# Model Context Protocol

Zed はコンテキストサーバーとやり取りするために [Model Context Protocol](https://modelcontextprotocol.io/) を使用します。

> Model Context Protocol (MCP) は、標準インターフェースを通じて LLM アプリケーションを外部ツールやデータソースに接続するためのオープンなプロトコルです。

## Supported Features

Zed は現在、MCP の [Tools](https://modelcontextprotocol.io/specification/2025-11-25/server/tools) 機能と [Prompts](https://modelcontextprotocol.io/specification/2025-11-25/server/prompts) 機能をサポートしています。
Zed における MCP 機能の対応範囲（Discovery、Sampling、Elicitation など）を拡張するためのコントリビューションを歓迎します。

Zed は MCP サーバーからの `notifications/tools/list_changed` 通知も処理します。サーバーが実行時に利用可能なツールを追加・削除・変更した場合でも、サーバーの再起動を行わずに、Zed が自動的にツール一覧を再読み込みします。

## Installing MCP Servers

### As Extensions

Zed で MCP サーバーを利用する方法の 1 つは、それらを拡張機能として公開することです。
独自の MCP サーバー拡張機能を作成する方法については、[MCP Server Extensions](../extensions/mcp-extensions.md) のページを参照してください。

多くの MCP サーバーは拡張機能として提供されています。以下の方法で見つけることができます:

1. [Zed の Web サイト](https://zed.dev/extensions?filter=context-servers)
2. アプリ内で Command Palette を開き、`zed: extensions` アクションを実行する
3. アプリ内で Agent Panel の右上メニューを開き、"View Server Extensions" メニュー項目を探す

拡張機能として利用可能な代表的なサーバーには次のようなものがあります:

- [Context7](https://zed.dev/extensions/context7-mcp-server)
- [GitHub](https://zed.dev/extensions/github-mcp-server)
- [Puppeteer](https://zed.dev/extensions/puppeteer-mcp-server)
- [Gem](https://zed.dev/extensions/gem)
- [Brave Search](https://zed.dev/extensions/brave-search-mcp-server)
- [Prisma](https://github.com/aqrln/prisma-mcp-zed)
- [Framelink Figma](https://zed.dev/extensions/framelink-figma-mcp-server)
- [Resend](https://zed.dev/extensions/resend-mcp-server)

### As Custom Servers

拡張機能を作成することだけが、Zed で MCP サーバーを利用する唯一の方法ではありません。
設定ファイルにコマンドを直接追加することでも接続できます（[編集方法](../configuring-zed.md#settings-files) を参照）。次のように設定します:

```json [settings]
{
  "context_servers": {
    "local-mcp-server": {
      "command": "some-command",
      "args": ["arg-1", "arg-2"],
      "env": {}
    },
    "remote-mcp-server": {
      "url": "custom",
      "headers": { "Authorization": "Bearer <token>" }
    },
    "remote-mcp-server-with-oauth": {
      "url": "https://mcp.example.com/mcp"
    }
  }
}
```

また、Agent Panel の Settings ビュー（`agent: open settings` アクションからも開けます）にアクセスしてカスタムサーバーを追加することもできます。
そこから、"Add Custom Server" ボタンをクリックすると表示されるモーダルを通じて追加できます。

> 注意: リモート MCP サーバーで `"Authorization"` ヘッダーが設定されていない場合、Zed は標準的な MCP の OAuth フローを使用して MCP サーバーに対して認証を行うよう、ユーザーにプロンプトを表示します。

## Using MCP Servers

### Configuration Check

ほとんどの MCP サーバーは、インストール後に追加の設定が必要です。

拡張機能の場合、インストール後に Zed がモーダルを表示し、適切にセットアップするために何が必要かを案内します。
たとえば GitHub MCP 拡張機能では、[Personal Access Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens) を追加する必要があります。

カスタムサーバーの場合は、プロバイダーのドキュメントを確認し、どのようなコマンド、引数、環境変数を JSON に追加する必要があるかを把握してください。

MCP サーバーが正しく設定されているか確認するには、Agent Panel の Settings ビューを開き、サーバー名の横にあるインジケータドットを確認してください。
正常に動作している場合、インジケータは緑色になり、ツールチップには "Server is active" と表示されます。
そうでない場合は、別の色やツールチップメッセージによって状況が示されます。

### Agent Panel Usage

インストールが完了したら、Agent Panel に戻ってプロンプトの送信を開始できます。

MCP ツールがどの程度確実に呼び出されるかは、モデルによって異なります。
MCP サーバー名を明示的に言及すると、そのサーバーのツールをモデルが選択しやすくなります。

ただし、特定の MCP サーバーが *必ず* 使用されるようにしたい場合は、すべての組み込みツール（またはサーバーのツールと競合する可能性のあるツール）を無効にし、その MCP サーバー由来のツールだけを有効にした [カスタムプロファイル](./agent-panel.md#custom-profiles) を作成できます。

例えば、[Dagger チームは](https://container-use.com/agent-integrations#zed)、自分たちの [Container Use MCP server](https://zed.dev/extensions/mcp-server-container-use) に対してそのように設定することを推奨しています:

```json [settings]
"agent": {
  "profiles": {
    "container-use": {
      "name": "Container Use",
      "tools": {
        "fetch": true,
        "thinking": true,
        "copy_path": false,
        "find_path": false,
        "delete_path": false,
        "create_directory": false,
        "list_directory": false,
        "diagnostics": false,
        "read_file": false,
        "open": false,
        "move_path": false,
        "grep": false,
        "edit_file": false,
        "terminal": false
      },
      "enable_all_context_servers": false,
      "context_servers": {
        "container-use": {
          "tools": {
            "environment_create": true,
            "environment_add_service": true,
            "environment_update": true,
            "environment_run_cmd": true,
            "environment_open": true,
            "environment_file_write": true,
            "environment_file_read": true,
            "environment_file_list": true,
            "environment_file_delete": true,
            "environment_checkpoint": true
          }
        }
      }
    }
  }
}
```

### Tool Permissions

> **注意:** Zed v0.224.0 以降では、ツールの承認は `agent.tool_permissions.default` によって制御されます。
> それ以前のバージョンでは、`agent.always_allow_tool_actions` ブール値（デフォルト `false`）によって制御されていました。

Zed の Agent Panel では、ネイティブの Zed エージェントに対するツール承認の挙動を制御するために `agent.tool_permissions.default` 設定が用意されています:

- `"confirm"`（デフォルト） — MCP ツールの呼び出しを含む、あらゆるツールアクションを実行する前に承認を求めます
- `"allow"` — 確認ダイアログなしでツールアクションを自動承認します
- `"deny"` — すべてのツールアクションをブロックします

特定の MCP ツールに対してきめ細かく制御したい場合は、ツールごとの権限ルールを設定できます。
MCP ツールでは、`mcp:<server>:<tool_name>` というキー形式を使用します（例: `mcp:github:create_issue`）。
MCP ツールの場合、パターンベースのルールは空文字列に対して評価されるため、ほとんどのパターンは一致しません。そのため、ツールごとのエントリにおける `default` キーが MCP ツールの主な制御手段となります。

ツール権限の仕組みや、さらに詳細なカスタマイズ方法については、[ツール権限の仕組み](./tool-permissions.md) を参照してください。

### External Agents

なお、[Agent Client Protocol](https://agentclientprotocol.com/) 経由で接続された [external agents](./external-agents.md) では、Zed からインストールした MCP サーバーへのアクセス可否や挙動は ACP エージェントの実装によって異なる場合があります。

組み込みのエージェントについては、Claude Agent と Codex はどちらも MCP サーバーをサポートしていますが、Gemini CLI はまだサポートしていません。
その間は、[Gemini CLI のドキュメント](https://github.com/google-gemini/gemini-cli?tab=readme-ov-file#using-mcp-servers) を参照して、Gemini CLI に MCP サーバーサポートを追加する方法を確認してください。

### Error Handling

MCP サーバーがツール呼び出しの処理中にエラーに遭遇した場合、エージェントはエラーメッセージを直接受け取り、その操作は失敗します。
一般的なエラーシナリオには次のようなものがあります:

- ツールに無効なパラメーターが渡された場合
- サーバー側の障害（データベース接続の問題、レートリミットなど）
- 未対応の操作や不足しているリソース

コンテキストサーバーからのエラーメッセージはエージェントの応答内に表示されるため、それを基に問題を診断・修正できます。
特定のエラーコードの詳細については、コンテキストサーバーのログやドキュメントを確認してください。
