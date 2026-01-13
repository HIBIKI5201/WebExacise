// DOMが完全に読み込まれたら実行
document.addEventListener('DOMContentLoaded', () => {

    console.log('ウェブページが読み込まれ、main.jsが実行されました。');

    const alertButton = document.getElementById('alertButton');

    if (alertButton) {
        alertButton.addEventListener('click', () => {
            alert('こんにちは！ボタンがクリックされました。');
        });
    }

});
