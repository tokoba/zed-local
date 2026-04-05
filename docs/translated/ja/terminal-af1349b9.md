# ターミナル

Zed には、複数のターミナルインスタンス、カスタムシェル、エディタとの深い統合をサポートする組み込みターミナルエミュレータが含まれています。

## ターミナルを開く

| 操作                     | macOS           | Linux/Windows   |
| ------------------------ | --------------- | --------------- |
| ターミナルパネルの表示切り替え | `` Ctrl+` ``    | `` Ctrl+` ``    |
| 新しいターミナルを開く       | `Ctrl+~`        | `Ctrl+~`        |
| センターペインにターミナルを開く | コマンドパレット | コマンドパレット |

また、コマンドパレットで `terminal panel: toggle` や `workspace: new terminal` を使用してターミナルを開くこともできます。

### ターミナルパネル vs センターターミナル

ターミナルは 2 つの位置に開くことができます。

- **ターミナルパネル** — ワークスペースの下部（デフォルト）、左側、または右側にドックされます。`` Ctrl+` `` で表示を切り替えます。
- **センターペイン** — ファイルと並んで通常のタブとして開きます。コマンドパレットから `workspace: new center terminal` を使用します。

## 複数のターミナルの操作

ターミナルパネルにフォーカスがある状態で、macOS では `Cmd+N`、Linux/Windows では `Ctrl+N` を押して、追加のターミナルを作成できます。各ターミナルはパネル内にタブとして表示されます。

ターミナルを水平方向に分割するには、macOS では `Cmd+D`、Linux/Windows では `Ctrl+Shift+5` を使用します。

## シェルの設定

デフォルトでは、Zed はシステムのデフォルトシェル（Unix システムでは `/etc/passwd` に定義されたもの）を使用します。別のシェルを使用するには次のようにします。

```json [settings]
{
  "terminal": {
    "shell": {
      "program": "/bin/zsh"
    }
  }
}
```

シェルに引数を渡すには次のようにします。

```json [settings]
{
  "terminal": {
    "shell": {
      "with_arguments": {
        "program": "/bin/bash",
        "args": ["--login"]
      }
    }
  }
}
```

## 作業ディレクトリ

新しいターミナルの開始場所を制御します。

| 値                                           | 動作                                                                                                                   |
| -------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| `"current_file_directory"`                   | 現在のファイルのディレクトリを使用し、それがなければプロジェクトディレクトリ、さらにそれもなければワークスペース内の最初のプロジェクトを使用します |
| `"current_project_directory"`                | 現在のファイルのプロジェクトディレクトリを使用します（デフォルト）                                                    |
| `"first_project_directory"`                  | ワークスペース内の最初のプロジェクトを使用します                                                                      |
| `"always_home"`                              | 常にホームディレクトリで開始します                                                                                    |
| `{ "always": { "directory": "~/projects" } }` | 常に特定のディレクトリで開始します                                                                                    |

```json [settings]
{
  "terminal": {
    "working_directory": "first_project_directory"
  }
}
```

## 環境変数

すべてのターミナルセッションに環境変数を追加します。

```json [settings]
{
  "terminal": {
    "env": {
      "EDITOR": "zed --wait",
      "MY_VAR": "value"
    }
  }
}
```

> **ヒント:** 1 つの変数の中で複数の値を区切るには `:` を使用します: `"PATH": "/custom/path:$PATH"`

### Python 仮想環境の検出

Zed は、ターミナルを開くときに Python 仮想環境を自動的に有効化できます。デフォルトでは、`.env`、`env`、`.venv`、`venv` ディレクトリを検索します。

```json [settings]
{
  "terminal": {
    "detect_venv": {
      "on": {
        "directories": [".venv", "venv"],
        "activate_script": "default"
      }
    }
  }
}
```

`activate_script` オプションは、`"default"`、`"csh"`、`"fish"`、`"nushell"` をサポートします。

仮想環境の検出を無効にするには次のようにします。

```json [settings]
{
  "terminal": {
    "detect_venv": "off"
  }
}
```

## フォントと外観

ターミナルでは、エディタとは異なるフォントを使用できます。

```json [settings]
{
  "terminal": {
    "font_family": "JetBrains Mono",
    "font_size": 14,
    "font_features": {
      "calt": false
    },
    "line_height": "comfortable"
  }
}
```

行の高さのオプション:

- `"comfortable"` — 比率 1.618。読みやすさに優れます（デフォルト）
- `"standard"` — 比率 1.3。罫線文字を使用する TUI アプリケーションに適しています
- `{ "custom": 1.5 }` — カスタム比率

### カーソル

カーソルの見た目を設定します。

```json [settings]
{
  "terminal": {
    "cursor_shape": "bar",
    "blinking": "on"
  }
}
```

カーソルの形状: `"block"`、`"bar"`、`"underline"`、`"hollow"`

点滅のオプション: `"off"`、`"terminal_controlled"`（デフォルト）、`"on"`

### 最小コントラスト

Zed は、可読性を維持するためにターミナルの色を調整します。デフォルト値の `45` により、テキストが読みやすく保たれます。コントラスト調整を無効にしてテーマの色をそのまま使用するには、`0` に設定します。

```json [settings]
{
  "terminal": {
    "minimum_contrast": 0
  }
}
```

## スクロール

次のキー割り当てでターミナルの履歴を移動します。

| 操作              | macOS                              | Linux/Windows    |
| ----------------- | ---------------------------------- | ---------------- |
| 1 ページ上にスクロール   | `Shift+PageUp` または `Cmd+Up`     | `Shift+PageUp`   |
| 1 ページ下にスクロール   | `Shift+PageDown` または `Cmd+Down` | `Shift+PageDown` |
| 1 行上にスクロール      | `Shift+Up`                        | `Shift+Up`       |
| 1 行下にスクロール      | `Shift+Down`                      | `Shift+Down`     |
| 先頭へスクロール        | `Shift+Home` または `Cmd+Home`    | `Shift+Home`     |
| 末尾へスクロール        | `Shift+End` または `Cmd+End`      | `Shift+End`      |

スクロール速度は次の設定で調整できます。

```json [settings]
{
  "terminal": {
    "scroll_multiplier": 3.0
  }
}
```

## コピーとペースト

| 操作   | macOS   | Linux/Windows  |
| ------ | ------- | -------------- |
| コピー | `Cmd+C` | `Ctrl+Shift+C` |
| ペースト | `Cmd+V` | `Ctrl+Shift+V` |

### 選択時にコピー

選択したテキストを自動的にクリップボードにコピーします。

```json [settings]
{
  "terminal": {
    "copy_on_select": true
  }
}
```

### コピー後も選択を維持

デフォルトでは、コピー後もテキストの選択状態は維持されます。コピー後に選択を解除するには次のようにします。

```json [settings]
{
  "terminal": {
    "keep_selection_on_copy": false
  }
}
```

## 検索

ターミナル内の内容を検索するには、macOS では `Cmd+F`、Linux/Windows では `Ctrl+Shift+F` を使用します。これはエディタと同じ検索バーを開きます。

## Vi モード

ターミナルでの vi スタイルのナビゲーションは、`Ctrl+Shift+Space` で切り替えられます。これにより、vi のキーバインドでテキストの移動や選択ができるようになります。

## ターミナルのクリア

ターミナル画面をクリアします。

- macOS: `Cmd+K`
- Linux/Windows: `Ctrl+Shift+L`

## Option キーを Meta として使用 (macOS)

Emacs ユーザーや Meta キーの組み合わせを使用するアプリケーション向けに、Option キーを Meta として有効にできます。

```json [settings]
{
  "terminal": {
    "option_as_meta": true
  }
}
```

これにより、Option キーが Meta として解釈されるようになり、`Alt+X` のようなキーシーケンスが正しく動作するようになります。

## 代替スクロールモード

有効にすると、`vim` や `less` のようなアプリケーションで、マウスのスクロールイベントが矢印キーの押下に変換されます。

```json [settings]
{
  "terminal": {
    "alternate_scroll": "on"
  }
}
```

## パスハイパーリンク

Zed はターミナル出力内のファイルパスを検出し、クリック可能にします。`Cmd+Click` (macOS) または `Ctrl+Click` (Linux/Windows) で Zed でファイルを開き、行番号が検出されている場合はその行にジャンプします。

認識される一般的な形式:

- `src/main.rs:42` — 42 行目で開きます
- `src/main.rs:42:10` — 42 行目、10 列目で開きます
- `File "script.py", line 10` — Python のトレースバック

## パネル設定

### ドックの位置

```json [settings]
{
  "terminal": {
    "dock": "bottom"
  }
}
```

オプション: `"bottom"` (デフォルト), `"left"`, `"right"`

### デフォルトサイズ

```json [settings]
{
  "terminal": {
    "default_width": 640,
    "default_height": 320
  }
}
```

### ターミナルボタン

ステータスバーのターミナルボタンを非表示にします:

```json [settings]
{
  "terminal": {
    "button": false
  }
}
```

### ツールバー

パンくずツールバーにターミナルタイトルを表示します:

```json [settings]
{
  "terminal": {
    "toolbar": {
      "breadcrumbs": true
    }
  }
}
```

タイトルは、エスケープシーケンス `\e]2;Title\007` を使用してシェルから設定できます。

## タスクとの統合

ターミナルは Zed の[タスクシステム](./tasks.md)と統合されています。タスクを実行すると、ターミナル内で実行されます。ターミナルから直前のタスクを再実行するには次のショートカットを使用します:

- macOS: `Cmd+Alt+R`
- Linux/Windows: `Ctrl+Shift+R` または `Alt+T`

## AI アシスタンス

[Inline Assistant](./ai/inline-assistant.md) を使用してターミナルコマンドのヘルプを得ることができます:

- macOS: `Ctrl+Enter`
- Linux/Windows: `Ctrl+Enter` または `Ctrl+I`

これにより Inline Assistant が開き、エラーの説明、コマンドの提案、問題のトラブルシューティングを支援します。[Agent Panel](./ai/agent-panel.md) の AI エージェントも、ワークフローの一部としてターミナルコマンドを実行できます。

## テキストとキーストロークの送信

高度なキーバインドのカスタマイズのために、生のテキストやキーストロークをターミナルに送信できます:

```json [keymap]
{
  "context": "Terminal",
  "bindings": {
    "alt-left": ["terminal::SendText", "\u001bb"],
    "ctrl-c": ["terminal::SendKeystroke", "ctrl-c"]
  }
}
```

## すべてのターミナル設定

ターミナル設定の完全な一覧については、[Terminal section in All Settings](./reference/all-settings.md#terminal) を参照してください。

## 次のステップ

- [Tasks](./tasks.md) — Zed からコマンドやスクリプトを実行します
- [REPL](./repl.md) — 対話的なコード実行
- [CLI Reference](./reference/cli.md) — Zed でファイルを開くためのコマンドラインインターフェイス
