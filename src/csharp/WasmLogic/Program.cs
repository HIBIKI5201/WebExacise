using Microsoft.JSInterop;

Console.WriteLine("WasmLogic C# is initializing...");

public partial class Program
{
    [JSInvokable("Add")]
    internal static int Add(int a, int b)
    {
        Console.WriteLine($"C# Add method called with {a} and {b}");
        return a + b;
    }

    public static void Main()
    {
        // このWasmアプリケーションがすぐにアンロードされないようにする
        // JavaScriptからメソッドが呼び出される限り、WASMランタイムはアクティブに保たれる
        Console.WriteLine("WasmLogic C# Main method finished initialization.");
    }
}

