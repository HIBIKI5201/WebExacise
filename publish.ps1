# publish.ps1
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
} else {
    Write-Host "Blazorアプリの公開に失敗しました。" -ForegroundColor Red
    Write-Host "エラーコード: $LASTEXITCODE" -ForegroundColor Red
}

# 実行結果を確認できるように一時停止
Read-Host "続行するには何かキーを押してください..."
