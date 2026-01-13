# publish.ps1

# 既存のdocsフォルダを削除してクリーンな状態にする
if (Test-Path -Path "docs") {
    Write-Host "既存の docs フォルダを削除します..." -ForegroundColor Yellow
    Remove-Item -Path "docs" -Recurse -Force
}

Write-Host "Blazorアプリの公開を開始します..." -ForegroundColor Cyan

# dotnet publish コマンドを実行
# src/csharp/BlazorSample/BlazorSample.csproj はBlazorプロジェクトのパス
# -c Release はリリースビルドを行う
# -o docs は出力先フォルダをdocsに指定
# --nologo は dotnet のロゴ表示を抑制
dotnet publish src/csharp/BlazorSample/BlazorSample.csproj -c Release -o docs --nologo

if ($LASTEXITCODE -eq 0) {
    Write-Host "Blazorアプリの公開が成功しました！" -ForegroundColor Green
    Write-Host "docsフォルダにファイルが出力されました。" -ForegroundColor Green

    # index.htmlのベースパスをリポジトリ名に合わせて修正
    $repoName = "WebExacise" # ユーザーのリポジトリ名
    $indexPath = "docs/wwwroot/index.html"
    Write-Host "index.html の <base href> を '/$repoName/' に修正します..." -ForegroundColor Yellow
    (Get-Content $indexPath) -replace '<base href="/" />', "<base href='/$repoName/' />" | Set-Content $indexPath


    # wwwrootフォルダの中身をdocs直下に移動
    Write-Host "docs/wwwroot の内容を docs/ 直下に移動します..." -ForegroundColor Yellow
    # Get-ChildItem -Path "docs/wwwroot" -Force はディレクトリも取得してしまうため、ファイルのみを対象とします
    Get-ChildItem -Path "docs/wwwroot" -File -Force | Move-Item -Destination "docs/" -Force
    # docs/wwwroot 下のディレクトリも移動対象に含める場合（例：_frameworkなど）
    Get-ChildItem -Path "docs/wwwroot" -Directory -Force | Move-Item -Destination "docs/" -Force

    # 空になったwwwrootフォルダを削除
    Write-Host "空になった docs/wwwroot フォルダを削除します..." -ForegroundColor Yellow
    Remove-Item -Path "docs/wwwroot" -Recurse -Force

    Write-Host "GitHub Pages公開用のファイル配置が完了しました！" -ForegroundColor Green
} else {
    Write-Host "Blazorアプリの公開に失敗しました。" -ForegroundColor Red
    Write-Host "エラーコード: $LASTEXITCODE" -ForegroundColor Red
}

# 実行結果を確認できるように一時停止
Read-Host "続行するには何かキーを押してください..."
