# ツールの権限

どの [Agent Panel](./agent-panel.md) のツールを自動実行し、どのツールにあなたの承認を必要とさせるかを設定します。
利用可能なツールの一覧については、[Tools ページ](./tools.md) を参照してください。

> **注:** Zed v0.224.0 以降では、ツールの承認は `agent.tool_permissions.default` で制御されます。
> それより前のバージョンでは、`agent.always_allow_tool_actions` ブール値（デフォルトは `false`）で制御されていました。

## クイックスタート

Zed の Settings Editor を使って [ツール権限を設定](zed://settings/agent.tool_permissions) するか、設定ファイルに直接ルールを追加します:

```json [settings]
{
  "agent": {
    "tool_permissions": {
      "default": "allow",
      "tools": {
        "terminal": {
          "default": "confirm",
          "always_allow": [
            { "pattern": "^cargo\\s+(build|test|check)" },
            { "pattern": "^npm\\s+(install|test|run)" }
          ],
          "always_confirm": [{ "pattern": "sudo\\s+/" }]
        }
      }
    }
  }
}
```

この例では、terminal ツール内の `cargo` と `npm` コマンドは自動的に承認されますが、`sudo` コマンドについては個別に手動での確認が必要になります。
ターミナル以外のコマンドはグローバルな `"default": "allow"` 設定に従いますが、ツール固有の default 設定や `always_confirm` ルールによって、引き続き確認が求められる場合があります。

## 仕組み

`tool_permissions` 設定を使うと、次のような正規表現パターンを指定してツールの権限をカスタマイズできます:

- 信頼できるアクションを**自動承認**する
- 危険なアクションを**自動拒否**する（`tool_permissions.default` が `"allow"` に設定されている場合でもブロックされます）
- 他の設定に関係なく、機密性の高いアクションを**常に確認**する

## 対応ツール

| ツール                   | 照合対象の入力               |
| ------------------------ | ---------------------------- |
| `terminal`               | シェルコマンド文字列         |
| `edit_file`              | ファイルパス                 |
| `delete_path`            | 削除対象のパス               |
| `move_path`              | 元と先のパス                 |
| `copy_path`              | 元と先のパス                 |
| `create_directory`       | ディレクトリパス             |
| `restore_file_from_disk` | ファイルパス                 |
| `save_file`              | ファイルパス                 |
| `fetch`                  | URL                          |
| `web_search`             | 検索クエリ                   |

MCP ツールの場合は、`mcp:<server>:<tool_name>` の形式を使用します。
例えば、`github` というサーバー上の `create_issue` というツールは `mcp:github:create_issue` となります。

## 設定

```json [settings]
{
  "agent": {
    "tool_permissions": {
      "default": "confirm",
      "tools": {
        "<tool_name>": {
          "default": "confirm",
          "always_allow": [{ "pattern": "...", "case_sensitive": false }],
          "always_deny": [{ "pattern": "...", "case_sensitive": false }],
          "always_confirm": [{ "pattern": "...", "case_sensitive": false }]
        }
      }
    }
  }
}
```

### オプション

| オプション        | 説明                                                                               |
| ----------------- | ---------------------------------------------------------------------------------- |
| `default`         | どのパターンにもマッチしなかった場合のフォールバック: `"confirm"`（デフォルト）、`"allow"`、`"deny"` |
| `always_allow`    | 自動承認するパターン（deny または confirm にもマッチした場合を除く）             |
| `always_deny`     | 即座にブロックするパターン — 最優先で、上書きできません                           |
| `always_confirm`  | `tool_permissions.default` が `"allow"` の場合でも、常に確認を求めるパターン      |

### パターンの書式

```json [settings]
{
  "agent": {
    "tool_permissions": {
      "tools": {
        "edit_file": {
          "always_allow": [
            {
              "pattern": "your-regex-here",
              "case_sensitive": false
            }
          ]
        }
      }
    }
  }
}
```

パターンには Rust の正規表現構文が使われます。
マッチングはデフォルトで大文字小文字を区別しません。

## ルールの優先順位

優先度が高いものから低いものへ:

1. **組み込みのセキュリティルール**: ハードコードされた保護（例: `rm -rf /`）。上書きできません。
2. **`always_deny`**: マッチしたアクションをブロックします
3. **`always_confirm`**: マッチしたアクションに対して確認を要求します
4. **`always_allow`**: マッチしたアクションを自動承認します
5. **ツール固有の `default`**: パターンにマッチしなかった場合のツール単位のフォールバック（例: `tools.terminal.default`）
6. **グローバル `default`**: ツール固有の default が設定されていない場合に `tool_permissions.default` にフォールバックします

## グローバル自動承認

すべてのツールアクションを自動承認するには:

```json [settings]
{
  "agent": {
    "tool_permissions": {
      "default": "allow"
    }
  }
}
```

これによりほとんどのツールで確認プロンプトがスキップされますが、`always_deny`、`always_confirm`、組み込みのセキュリティルール、そして Zed の設定ディレクトリ内のパスについては、引き続き確認が求められたりブロックされたりします。

## シェル互換性

`terminal` ツールでは、Zed は連結されたコマンド（例: `echo hello && rm file`）をパースし、各サブコマンドをあなたのパターンに照らしてチェックします。

サポートされているすべてのシェルでツール権限パターンが動作します。対象には sh、bash、zsh、dash、fish、PowerShell 7+、pwsh、cmd、xonsh、csh、tcsh、Nushell、Elvish、rc（Plan 9）が含まれます。

## パターンの書き方

- 単語の境界には `\b` を使います: `\brm\b` は "rm" にマッチしますが "storm" にはマッチしません
- 入力の先頭/末尾に固定するには `^` と `$` でパターンをアンカーします
- 特殊文字はエスケープします: ドットのリテラルは `\.`、バックスラッシュは `\\`

<div class="warning">

deny パターンのタイプミスは正当なアクションもブロックしてしまうため、十分にテストしてください。
各ツールのページに用意されている "Test Your Rules" チェッカーを使うと、パターンが意図した条件に正しく分類されているか確認できます。

</div>

## 組み込みセキュリティルール

Zed には、どの設定でも**上書きできない**少数のハードコードされたセキュリティルールが含まれています。
これらは **terminal** ツールにのみ適用され、重要なディレクトリの再帰的削除をブロックします:

- `rm -rf /` および `rm -rf /*` — ファイルシステムのルート
- `rm -rf ~` および `rm -rf ~/*` — ホームディレクトリ
- `rm -rf $HOME` / `rm -rf ${HOME}`（および `$HOME/*`）— 環境変数経由のホームディレクトリ
- `rm -rf .` および `rm -rf ./*` — カレントディレクトリ
- `rm -rf ..` および `rm -rf ../*` — 親ディレクトリ

これらのパターンは、あらゆるフラグの組み合わせ（例: `-fr`、`-rfv`、`-r -f`、`--recursive --force`）を検出し、大文字小文字を区別しません。
また、生のコマンドと、連結されたコマンド内の各サブコマンド（例: `ls && rm -rf /`）の両方に対してチェックされます。

これ以外に組み込みルールはありません。
デフォルトの設定ファイル ({#action zed::OpenDefaultSettings}) には、`.env` ファイル、秘密情報のディレクトリ、秘密鍵を保護するためのコメントアウトされたサンプルが含まれており、これらを必要に応じてアンコメントしたり調整したりできます。

## UI における権限リクエスト

エージェントが権限を要求すると、スレッドビューにメニュー付きのツールカードが表示され、次のオプションが含まれます:

- **Allow once** / **Deny once** — 1 回限りの判断
- **Always for <tool>** — ツールごとのデフォルトを allow または deny に設定します
- **Always for <pattern>** — 安全なパターンを抽出できる場合に `always_allow` または `always_deny` パターンを追加します
"Always for <tool>" を選択すると、`tools.<tool>.default` が許可または拒否に設定されます。
パターンを安全に抽出できる場合、"Always for <pattern>" を選択すると、その入力に対する `always_allow` または `always_deny` ルールが追加されます。
MCP ツールでは、ツールレベルのオプションのみがサポートされます。

## 例

### Terminal: ビルドコマンドの自動承認

```json [settings]
{
  "agent": {
    "tool_permissions": {
      "tools": {
        "terminal": {
          "default": "confirm",
          "always_allow": [
            { "pattern": "^cargo\\s+(build|test|check|clippy|fmt)" },
            { "pattern": "^npm\\s+(install|test|run|build)" },
            { "pattern": "^git\\s+(status|log|diff|branch)" },
            { "pattern": "^ls\\b" },
            { "pattern": "^cat\\s" }
          ],
          "always_deny": [
            { "pattern": "rm\\s+-rf\\s+(/|~)" },
            { "pattern": "sudo\\s+rm" }
          ],
          "always_confirm": [
            { "pattern": "sudo\\s" },
            { "pattern": "git\\s+push" }
          ]
        }
      }
    }
  }
}
```

### ファイル編集: 機密ファイルを保護する

```json [settings]
{
  "agent": {
    "tool_permissions": {
      "tools": {
        "edit_file": {
          "default": "confirm",
          "always_allow": [
            { "pattern": "\\.(md|txt|json)$" },
            { "pattern": "^src/" }
          ],
          "always_deny": [
            { "pattern": "\\.env" },
            { "pattern": "secrets?/" },
            { "pattern": "\\.(pem|key)$" }
          ]
        }
      }
    }
  }
}
```

### Path Deletion: 重要なディレクトリの削除をブロックする

```json [settings]
{
  "agent": {
    "tool_permissions": {
      "tools": {
        "delete_path": {
          "default": "confirm",
          "always_deny": [
            { "pattern": "^/etc" },
            { "pattern": "^/usr" },
            { "pattern": "\\.git/?$" },
            { "pattern": "node_modules/?$" }
          ]
        }
      }
    }
  }
}
```

### URL フェッチ: 外部アクセスを制御する

```json [settings]
{
  "agent": {
    "tool_permissions": {
      "tools": {
        "fetch": {
          "default": "confirm",
          "always_allow": [
            { "pattern": "docs\\.rs" },
            { "pattern": "github\\.com" }
          ],
          "always_deny": [{ "pattern": "internal\\.company\\.com" }]
        }
      }
    }
  }
}
```

### MCP ツール

```json [settings]
{
  "agent": {
    "tool_permissions": {
      "tools": {
        "mcp:github:create_issue": {
          "default": "confirm"
        },
        "mcp:github:create_pull_request": {
          "default": "confirm"
        }
      }
    }
  }
}
```
