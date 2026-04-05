# Agent Settings

Zed の Agent Panel の設定です。モデル選択、UI の設定、ツール権限などが含まれます。

## Model Settings {#model-settings}

### Default Model {#default-model}

[Zed's hosted LLM service](./subscription.md) を利用している場合、エージェントによる処理（Agent Panel、インラインアシスタント）用のデフォルトモデルとして `claude-sonnet-4-5` が、また「fast」モデル（スレッド要約、Git コミットメッセージ）として `gpt-5-nano` が設定されます。サブスクリプション未加入の場合や、これらのデフォルトを変更したい場合は、設定内の `default_model` オブジェクトを手動で編集できます:

```json [settings]
{
  "agent": {
    "default_model": {
      "provider": "openai",
      "model": "gpt-4o"
    }
  }
}
```

### Feature-specific Models {#feature-specific-models}

次の AI 搭載機能ごとに、個別かつ特定のモデルを割り当てることができます:

- Thread summary model: スレッド要約の生成に使用されます
- Inline assistant model: Inline Assistant 機能に使用されます
- Commit message model: Git のコミットメッセージ生成に使用されます

```json [settings]
{
  "agent": {
    "default_model": {
      "provider": "zed.dev",
      "model": "claude-sonnet-4-5"
    },
    "inline_assistant_model": {
      "provider": "anthropic",
      "model": "claude-3-5-sonnet"
    },
    "commit_message_model": {
      "provider": "openai",
      "model": "gpt-4o-mini"
    },
    "thread_summary_model": {
      "provider": "google",
      "model": "gemini-2.0-flash"
    }
  }
}
```

> これらの機能のいずれかにカスタムモデルが設定されていない場合、その機能は自動的に default model を使用します。

### Alternative Models for Inline Assists {#alternative-assists}

特に Inline Assistant では、同じプロンプトを一度に複数のモデルへ送信できます。

この機能を追加するには、設定ファイルを次のようにカスタマイズします（[編集方法](../configuring-zed.md#settings-files)）:

```json [settings]
{
  "agent": {
    "default_model": {
      "provider": "zed.dev",
      "model": "claude-sonnet-4-5"
    },
    "inline_alternatives": [
      {
        "provider": "zed.dev",
        "model": "gpt-5-mini"
      }
    ]
  }
}
```

複数のモデルが設定されている場合、Inline Assistant の UI に、各モデルが生成した出力を切り替えるためのボタンが表示されます。

ここで指定したモデルは、常に[default model](#default-model)に_追加_で使用されます。

たとえば、次の設定では、各 Assist ごとに 3 つの出力が生成されます。
1 つは Claude Sonnet 4.5（default model）、もう 1 つは GPT-5-mini、さらにもう 1 つは Gemini 3 Flash です。

```json [settings]
{
  "agent": {
    "default_model": {
      "provider": "zed.dev",
      "model": "claude-sonnet-4-5"
    },
    "inline_alternatives": [
      {
        "provider": "zed.dev",
        "model": "gpt-5-mini"
      },
      {
        "provider": "zed.dev",
        "model": "gemini-3-flash"
      }
    ]
  }
}
```

### Model Temperature

provider やモデルごとに、独自の temperature を指定できます:

```json [settings]
{
  "agent": {
    "model_parameters": [
      // すべての OpenAI モデルへのリクエストに対してパラメータを設定する:
      {
        "provider": "openai",
        "temperature": 0.5
      },
      // すべてのリクエストに対してパラメータを設定する:
      {
        "temperature": 0
      },
      // 特定の provider とモデルに対してパラメータを設定する:
      {
        "provider": "zed.dev",
        "model": "claude-sonnet-4-5",
        "temperature": 1.0
      }
    ]
  }
}
```

## Agent Panel Settings {#agent-panel-settings}

これらの設定の一部は Agent Panel の設定 UI にも表示されます。`agent: open settings` アクションから、またはパネル右上のドロップダウンメニューからアクセスできます。

### Font Size

`agent_ui_font_size` 設定を使用して、パネル内にレンダリングされるエージェントの応答のフォントサイズを変更できます。

```json [settings]
{
  "agent_ui_font_size": 18
}
```

> Agent Panel 内のエディタ（メインメッセージの textarea など）は等幅フォントを使用し、`agent_buffer_font_size` によって制御されます（未設定の場合は `buffer_font_size` がデフォルトとして使用されます）。

### Default Tool Permissions

> **Note:** Zed v0.224.0 以降では、ツールの承認には以下で説明する `agent.tool_permissions` 設定が使用されます。

`agent.tool_permissions.default` 設定は、Zed のネイティブエージェントに対するツール承認のベースライン動作を制御します:

- `"confirm"`（デフォルト） — いずれのツールアクションを実行する前にも承認を求めます
- `"allow"` — プロンプトなしでツールアクションを自動承認します
- `"deny"` — すべてのツールアクションをブロックします

```json [settings]
{
  "agent": {
    "tool_permissions": {
      "default": "confirm"
    }
  }
}
```

`"default": "allow"` の場合でも、ツールごとの `always_deny` および `always_confirm` パターンは依然として尊重されます。そのため、ほとんどのアクションは自動承認しつつ、危険または機密性の高いアクションにはガードレールを維持できます。

### Per-tool Permission Rules {#per-tool-permission-rules}

個々のツールアクションをきめ細かく制御するには、`tool_permissions` 内の `tools` キーを使用して、特定の入力に対して自動承認、自動拒否、常に確認を行う正規表現ベースのルールを設定します。

各ツールエントリは次のキーをサポートします:

- `default` — パターンにマッチしない場合のフォールバック: `"confirm"`, `"allow"`, `"deny"`
- `always_allow` — 一致したアクションを自動承認するパターンの配列
- `always_deny` — 一致したアクションを即座にブロックするパターンの配列
- `always_confirm` — 一致したアクションに必ず確認を求めるパターンの配列

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
            { "pattern": "^git\\s+(status|log|diff)" }
          ],
          "always_deny": [{ "pattern": "rm\\s+-rf\\s+(/|~)" }],
          "always_confirm": [{ "pattern": "sudo\\s" }]
        },
        "edit_file": {
          "always_deny": [
            { "pattern": "\\.env" },
            { "pattern": "\\.(pem|key)$" }
          ]
        }
      }
    }
  }
}
```

#### Pattern Precedence

ツールアクションを評価する際、ルールは次の順序でチェックされます（優先度の高い順）:

1. **Built-in security rules** — 上書きできないハードコードされた保護（例: `rm -rf /`）
2. **`always_deny`** — 一致したアクションを即座にブロックします
3. **`always_confirm`** — 一致したアクションに対して確認を要求します
4. **`always_allow`** — 一致したアクションを自動承認します。複数のコマンドを連結した terminal ツール（例: `echo hello && rm file`）では、**すべて**のサブコマンドが `always_allow` パターンにマッチしている必要があります
5. **Tool-specific `default`** — パターンにマッチしない場合のツール固有のフォールバック（例: `tools.terminal.default`）
6. **Global `default`** — `tool_permissions.default` にフォールバックします

#### Case Sensitivity

パターンはデフォルトでは**大文字／小文字を区別しません**。大文字／小文字を区別するパターンにするには、`case_sensitive` を `true` に設定します:

```
```json [settings]
{
  "agent": {
    "tool_permissions": {
      "tools": {
        "edit_file": {
          "always_deny": [
            {
              "pattern": "^Makefile$",
              "case_sensitive": true
            }
          ]
        }
      }
    }
  }
}
```

#### `copy_path` と `move_path` のパターン

`copy_path` と `move_path` ツールでは、パターンはソースパスと宛先パスの両方に対して、それぞれ独立してマッチングされます。**どちらか一方の** パスが `deny` または `confirm` にマッチした場合、その設定が適用されます。`always_allow` の場合は、自動承認されるためには **両方の** パスがパターンにマッチしている必要があります。

#### MCP ツール権限

MCP ツールでは、`tools` 設定内で `mcp:<server_name>:<tool_name>` というキー形式を使用します。例えば次のようになります。

```json [settings]
{
  "agent": {
    "tool_permissions": {
      "tools": {
        "mcp:github:create_issue": {
          "default": "confirm"
        },
        "mcp:github:create_pull_request": {
          "default": "deny"
        }
      }
    }
  }
}
```

各 MCP ツールエントリの `default` キーが、MCP ツールの権限を制御する主な手段です。パターンベースのルール（`always_allow`、`always_deny`、`always_confirm`）は MCP ツールに対しては空文字列を対象にマッチングするため、ほとんどのパターンは一致しません。そのため、代わりにツールレベルの `default` を使用してください。

より多くの例と詳細については、[ツール権限](./tool-permissions.md) のドキュメントを参照してください。

> **注記:** Zed v0.224.0 より前は、ツールの承認は boolean 値 `agent.always_allow_tool_actions`（デフォルトは `false`）で制御されていました。ツールの操作を自動承認するにはこれを `true` に設定し、編集やツール呼び出しのたびに確認を求めるには `false` のままにしておきます。

### 編集表示モード

エージェントによる編集が完了した後、単一バッファ内にレビューアクション（承認 / 却下）を表示するかどうかを制御します。
デフォルト値は `false` です。

```json [settings]
{
  "agent": {
    "single_file_review": false
  }
}
```

### サウンド通知

エージェントが変更の生成を完了したとき、またはユーザーからの入力が必要になったときに通知音を鳴らすかどうかを制御します。デフォルト値は `never` です。

- `"never"` (default) — サウンドを一切再生しません。
- `"when_hidden"` — Agent パネルが表示されていないときにのみサウンドを再生します。
- `"always"` — 完了時には常にサウンドを再生します。

```json [settings]
{
  "agent": {
    "play_sound_when_agent_done": "never"
  }
}
```

### メッセージエディターのサイズ

`message_editor_min_lines` 設定を使用して、エージェントのメッセージエディターの高さ（行数）の最小値を制御します。
デフォルトでは `4` に設定されており、最大行数は常に最小値の 2 倍になります。

```json [settings]
{
  "agent": {
    "message_editor_min_lines": 4
  }
}
```

### 送信のモディファイアキー

メッセージを送信する際にモディファイアキー（macOS では `cmd`、Linux では `ctrl`）を必須にします。これにより、編集中の誤送信を防ぐことができます。デフォルト値は `false` です。

```json [settings]
{
  "agent": {
    "use_modifier_to_send": true
  }
}
```

### 編集カード

`expand_edit_card` 設定を使用して、編集カードが Agent パネル内で差分をすべて表示するかどうかを制御します。
デフォルトでは `true` に設定されていますが、`false` にするとカードの高さは一定の行数までに制限され、全体を表示するにはクリックして展開する必要があります。

```json [settings]
{
  "agent": {
    "expand_edit_card": false
  }
}
```

### ターミナルカード

`expand_terminal_card` 設定を使用して、ターミナルカードが Agent パネル内でコマンドの出力を表示するかどうかを制御します。
デフォルトでは `true` に設定されていますが、`false` にするとコマンド実行中であってもカードは完全に折りたたまれたままとなり、内容を表示するにはクリックして展開する必要があります。

```json [settings]
{
  "agent": {
    "expand_terminal_card": false
  }
}
```

### フィードバックコントロール

各エージェント応答の下部にサムズアップ / サムズダウンボタンを表示するかどうかを制御し、エージェントの動作に関するフィードバックを Zed に送れるようにします。
デフォルト値は `true` です。

```json [settings]
{
  "agent": {
    "enable_feedback": false
  }
}
```
