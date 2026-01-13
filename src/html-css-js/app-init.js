(async function() {
    try {
        // blazor.web.jsのautostart="false"設定により、手動でWasmランタイムをロード
        await Blazor.start(); // ランタイムを起動し、グローバルAPI (DotNet) を準備させる

        // Blazor.start()完了後、グローバルのDotNetオブジェクトが利用可能になる
        // DotNet.getConfig() は存在しないため、アセンブリ名を直接指定する
        const assemblyName = 'WasmLogic';
        const exports = await DotNet.getAssemblyExports(assemblyName);

        // C#からJavaScriptの関数を呼び出せるように公開することも可能（今回は使用しないが参考として）
        // window.CallMeFromCsharp = (message) => {
        //     console.log("Called from C#:", message);
        // };

        // main.jsの初期化関数を呼び出す（もし定義されていれば）
        if (typeof initializeMainJs === 'function') {
            initializeMainJs(exports);
        }
        
        console.log("Wasmランタイムが初期化されました。");
        document.getElementById('output').innerText += "Wasmランタイムが初期化されました。\n";

    } catch (error) {
        console.error("Wasmランタイムの初期化中にエラーが発生しました (詳細):", error);
        let errorMessage = "Wasmランタイムの初期化中にエラーが発生しました (詳細情報):\n";
        errorMessage += "========================================\n";
        errorMessage += "エラーメッセージ: " + (error.message || "N/A") + "\n\n";
        errorMessage += "スタックトレース:\n" + (error.stack || "N/A") + "\n\n";
        errorMessage += "エラーオブジェクト (JSON):\n" + JSON.stringify(error, null, 2) + "\n";
        errorMessage += "========================================\n";
        document.getElementById('output').innerText += errorMessage;
    }
})();
