# publish.ps1

# 既存のdocsフォルダを削除してクリーンな状態にする
if (Test-Path -Path "docs") {
    Write-Host "既存の docs フォルダを削除します..." -ForegroundColor Yellow
    Remove-Item -Path "docs" -Recurse -Force
}

Write-Host "Blazorアプリの公開を開始します..." -ForegroundColor Cyan

# クリーンビルドを実行
Write-Host "プロジェクトのクリーンアップを実行します..." -ForegroundColor Yellow
dotnet clean src/csharp/BlazorSample/BlazorSample.csproj -c Release --nologo

# dotnet publish コマンドを実行
dotnet publish src/csharp/BlazorSample/BlazorSample.csproj -c Release -o docs --nologo

if ($LASTEXITCODE -eq 0) {
    Write-Host "Blazorアプリの公開が成功しました！" -ForegroundColor Green
    Write-Host "docsフォルダにファイルが出力されました。" -ForegroundColor Green

    # index.htmlのベースパスをリポジトリ名に合わせて修正
    $repoName = "WebExacise" # ユーザーのリポジトリ名
    $indexPath = "docs/wwwroot/index.html"
    Write-Host "index.html の <base href> を '/$repoName/' に修正します..." -ForegroundColor Yellow
    (Get-Content $indexPath) -replace '<base href="/" />', "<base href='/$repoName/' />" | Set-Content $indexPath

    # GitHub Pagesのルーティング設定のため、index.htmlを404.htmlとしてコピー
    Write-Host "GitHub Pagesルーティング設定のため、index.htmlを404.htmlとしてコピーします..." -ForegroundColor Yellow
    Copy-Item -Path "docs/wwwroot/index.html" -Destination "docs/wwwroot/404.html" -Force

    # wwwrootフォルダの中身をdocs直下に移動
    Write-Host "docs/wwwroot の内容を docs/ 直下に移動します..." -ForegroundColor Yellow
    Get-ChildItem -Path "docs/wwwroot" -File -Force | Move-Item -Destination "docs/" -Force
    Get-ChildItem -Path "docs/wwwroot" -Directory -Force | Move-Item -Destination "docs/" -Force

    # 空になったwwwrootフォルダを削除
    Write-Host "空になった docs/wwwroot フォルダを削除します..." -ForegroundColor Yellow
    Remove-Item -Path "docs/wwwroot" -Recurse -Force
    
    # GitHub Pagesでは不要なweb.configを削除
    Write-Host "不要な web.config ファイルを削除します..." -ForegroundColor Yellow
    if (Test-Path -Path "docs/web.config") {
        Remove-Item -Path "docs/web.config" -Force
    }

    # Jekyllを無効にするため、.nojekyllファイルを作成
    Write-Host "Jekyllを無効にするため、.nojekyllファイルを作成します..." -ForegroundColor Yellow
    New-Item -Path "docs/.nojekyll" -ItemType File -Force

    Write-Host "GitHub Pages公開用のファイル配置が完了しました！" -ForegroundColor Green
} else {
    Write-Host "Blazorアプリの公開に失敗しました。" -ForegroundColor Red
    Write-Host "エラーコード: $LASTEXITCODE" -ForegroundColor Red
}

# 実行結果を確認できるように一時停止
Read-Host "続行するには何かキーを押してください..."
