# publish.ps1

# 既存のdocsフォルダを削除してクリーンな状態にする
if (Test-Path -Path "docs") {
    Write-Host "既存の docs フォルダを削除します..." -ForegroundColor Yellow
    Remove-Item -Path "docs" -Recurse -Force
}

Write-Host "WasmLogicアプリの公開を開始します..." -ForegroundColor Cyan

# クリーンビルドを実行
Write-Host "プロジェクトのクリーンアップを実行します..." -ForegroundColor Yellow
dotnet clean src/csharp/WasmLogic/WasmLogic.csproj -c Release --nologo

# dotnet publish コマンドを実行 (WasmLogicプロジェクト用)
# EmitWebAssemblyAssetsToSeparatePath=false のため、Wasm関連ファイルはdocs直下に出力される
dotnet publish src/csharp/WasmLogic/WasmLogic.csproj -c Release -o docs --nologo

if ($LASTEXITCODE -eq 0) {
    Write-Host "WasmLogicアプリの公開が成功しました！" -ForegroundColor Green
    Write-Host "docsフォルダにWebAssemblyファイルが出力されました。" -ForegroundColor Green

    # dotnet publish が wwwroot を作成してしまった場合、その中身を docs 直下に移動
    $wwwRootPath = "docs/wwwroot"
    if (Test-Path -Path $wwwRootPath) {
        Write-Host "$wwwRootPath の内容を docs/ に移動します..." -ForegroundColor Yellow
        Get-ChildItem -Path $wwwRootPath | ForEach-Object {
            Move-Item -Path $_.FullName -Destination "docs/" -Force
        }
        Remove-Item -Path $wwwRootPath -Recurse -Force
    }

    # src/html-css-js の内容を docs フォルダにコピー
    Write-Host "静的コンテンツ (HTML/CSS/JS) を docs フォルダにコピーします..." -ForegroundColor Yellow
    Copy-Item -Path "src/html-css-js/*" -Destination "docs/" -Recurse -Force

    # docs/index.htmlのベースパスをリポジトリ名に合わせて修正
    $repoName = "WebExacise" # ユーザーのリポジトリ名
    $indexPath = "docs/index.html" # docs直下にあるindex.htmlを修正
    Write-Host "$indexPath の <base href> を '/$repoName/' に修正します..." -ForegroundColor Yellow
    (Get-Content $indexPath) -replace '<base href="/" />', "<base href='/$repoName/' />" | Set-Content $indexPath

    # GitHub Pagesのルーティング設定のため、docs/index.htmlをdocs/404.htmlとしてコピー
    Write-Host "GitHub Pagesルーティング設定のため、$indexPathをdocs/404.htmlとしてコピーします..." -ForegroundColor Yellow
    Copy-Item -Path $indexPath -Destination "docs/404.html" -Force

    # WasmLogicプロジェクトではwwwrootは生成されないため、wwwrootフォルダの移動/削除は不要

    # GitHub Pagesでは不要なweb.configを削除 (dotnet publishが生成する可能性があるので念のため)
    Write-Host "不要な web.config ファイルを削除します..." -ForegroundColor Yellow
    if (Test-Path -Path "docs/web.config") {
        Remove-Item -Path "docs/web.config" -Force
    }

    # Jekyllを無効にするため、.nojekyllファイルを作成
    Write-Host "Jekyllを無効にするため、.nojekyllファイルを作成します..." -ForegroundColor Yellow
    New-Item -Path "docs/.nojekyll" -ItemType File -Force

    Write-Host "GitHub Pages公開用のファイル配置が完了しました！" -ForegroundColor Green
} else {
    Write-Host "WasmLogicアプリの公開に失敗しました。" -ForegroundColor Red
    Write-Host "エラーコード: $LASTEXITCODE" -ForegroundColor Red
    Read-Host "続行するには何かキーを押してください..."
}