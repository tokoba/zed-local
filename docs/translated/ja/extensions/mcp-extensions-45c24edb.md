# MCP サーバー拡張機能

[Model Context Protocol サーバー](../ai/mcp.md)は、Agent Panel で利用するための拡張機能として公開できます。

## MCP 拡張機能の定義

ある拡張機能は、1 つ以上の MCP サーバーを提供できます。
各 MCP サーバーは `extension.toml` に登録する必要があります:

```toml
[context_servers.my-context-server]
```

次に、拡張機能用の Rust コードで、拡張機能に対して `context_server_command` メソッドを実装します:

```rust
impl zed::Extension for MyExtension {
    fn context_server_command(
        &mut self,
        context_server_id: &ContextServerId,
        project: &zed::Project,
    ) -> Result<zed::Command> {
        Ok(zed::Command {
            command: get_path_to_context_server_executable()?,
            args: get_args_for_context_server()?,
            env: get_env_for_context_server()?,
        })
    }
}
```

このメソッドは、MCP サーバーを起動するためのコマンドと、その動作に必要な引数や環境変数を返す必要があります。

MCP サーバーを外部ソース（GitHub Releases、npm など）からダウンロードする必要がある場合は、その処理もこの関数内で行うことができます。

## 利用可能な拡張機能

拡張機能として公開されている MCP サーバーは、[Zed のサイト](https://zed.dev/extensions?filter=context-servers) を参照してください。

一般的な実装パターンや構造を確認するには、それらのリポジトリを参照してください。

## テスト

新しい MCP サーバー拡張機能をテストするには、[dev extension としてインストール](./developing-extensions.md#developing-an-extension-locally) できます。
