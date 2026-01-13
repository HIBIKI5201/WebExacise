// src/html-css-js/main.js

let exports = null; // C#のexportsを保持する変数

// index.htmlから呼び出される初期化関数
function initializeMainJs(wasmExports) {
    exports = wasmExports;
    console.log("main.js: C# exports received.");
    document.getElementById('output').innerText += "main.js: C# exports received.\n";

    // UIイベントリスナーを設定
    document.getElementById('addBtn').addEventListener('click', callCSharpAdd);
}

// C#のProgram.Addメソッドを呼び出す関数
async function callCSharpAdd() {
    if (!exports || !exports.WasmLogic.Program) {
        console.error("main.js: C# Program exports not available.");
        document.getElementById('output').innerText += "main.js: C# Program exports not available.\n";
        return;
    }

    const numA = parseInt(document.getElementById('numA').value);
    const numB = parseInt(document.getElementById('numB').value);

    document.getElementById('output').innerText += `main.js: C# Add(${numA}, ${numB}) を呼び出します...\n`;

    // C#のProgram.Addメソッドを呼び出す
    // WasmLogicはプロジェクト名、Programはクラス名（partial Programで宣言しているため）
    const result = await exports.WasmLogic.Program.Add(numA, numB);

    document.getElementById('result').innerText = result;
    document.getElementById('output').innerText += `main.js: C#からの結果: ${result}\n`;
}

// initializeMainJs 関数をグローバルに公開
// index.htmlのscriptタグから呼び出せるようにする
window.initializeMainJs = initializeMainJs;
