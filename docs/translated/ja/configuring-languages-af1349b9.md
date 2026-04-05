# サポート対象言語の設定

Zed の言語サポートは、次の 2 つの技術の上に成り立っています。

1. **Tree-sitter** は、構文ハイライトおよびアウトラインパネルのようなコード構造に基づく機能を扱います。
2. **Language Server Protocol (LSP)** は、コード補完、診断、定義へのジャンプ、リファクタリングといったセマンティックな機能を提供します。

このページでは、言語固有の設定、ファイルの関連付け、言語サーバーの設定、フォーマット、リンティング、シンタックスハイライトについて説明します。

サポートされている言語の一覧については [Supported Languages](./languages.md) を参照してください。新しい言語のサポートを追加する方法については [Language Extensions](./extensions/languages.md) を参照してください。

## 言語固有の設定

Zed では、個々の言語ごとにグローバル設定を上書きできます。これらのカスタム設定は、`settings.json` ファイルの `languages` キーの下で定義します。

言語固有設定の例は次のとおりです。

```json [settings]
"languages": {
  "Python": {
    "tab_size": 4,
    "formatter": "language_server",
    "format_on_save": "on"
  },
  "JavaScript": {
    "tab_size": 2,
    "formatter": {
      "external": {
        "command": "prettier",
        "arguments": ["--stdin-filepath", "{buffer_path}"]
      }
    }
  }
}
```

各言語ごとに、次のような幅広い設定をカスタマイズできます。

- [`tab_size`](./reference/all-settings.md#tab-size): 各インデントレベルに使用するスペースの数
- [`formatter`](./reference/all-settings.md#formatter): コードフォーマットに使用するツール
- [`format_on_save`](./reference/all-settings.md#format-on-save): 保存時にコードを自動フォーマットするかどうか
- [`enable_language_server`](./reference/all-settings.md#enable-language-server): 言語サーバーサポートの有効／無効を切り替える
- [`hard_tabs`](./reference/all-settings.md#hard-tabs): インデントにスペースではなくタブを使用する
- [`preferred_line_length`](./reference/all-settings.md#preferred-line-length): 推奨される行の最大長
- [`soft_wrap`](./reference/all-settings.md#soft-wrap): 長い行をどのように折り返すか
- [`show_completions_on_input`](./reference/all-settings.md#show-completions-on-input): 入力中に補完候補を表示するかどうか
- [`show_completion_documentation`](./reference/all-settings.md#show-completion-documentation): 補完メニュー内の項目について、インラインおよびサイドにドキュメントを表示するかどうか
- [`colorize_brackets`](./reference/all-settings.md#colorize-brackets): エディタ内の括弧を検出・色分けするために tree-sitter の bracket クエリを使用するかどうか（いわゆる「rainbow brackets」）

これらの設定により、異なる言語やプロジェクト間で特定のコーディングスタイルを維持できます。

## ファイルの関連付け

Zed は拡張子に基づいてファイルタイプを自動検出しますが、ワークフローに合わせてこれらの関連付けをカスタマイズできます。

カスタムのファイル関連付けを設定するには、`settings.json` 内の [`file_types`](./reference/all-settings.md#file-types) 設定を使用します。

```json [settings]
"file_types": {
  "C++": ["c"],
  "TOML": ["MyLockFile"],
  "Dockerfile": ["Dockerfile*"]
}
```

この設定により、Zed は次のように動作します。

- `.c` ファイルを C ではなく C++ として扱う
- "MyLockFile" という名前のファイルを TOML として認識する
- "Dockerfile" で始まる任意のファイルに Dockerfile の構文を適用する

より柔軟なマッチングのために glob パターンを使用できるため、プロジェクト内の複雑な命名規則にも対応できます。

## 言語サーバーの利用

言語サーバーは Zed のインテリジェントなコーディング機能の重要な要素であり、オートコンプリート、定義へのジャンプ、リアルタイムのエラーチェックなどの機能を提供します。

### 言語サーバーとは何か

言語サーバーは Language Server Protocol (LSP) を実装しており、エディタと各言語向けツールとの間の通信を標準化します。これにより Zed は、各機能を個別に実装することなく、複数のプログラミング言語に対して高度な機能を提供できます。

言語サーバーが提供する主な機能には次のようなものがあります。

- コード補完
- エラーチェックおよび診断
- コードナビゲーション（定義へ移動、参照の検索）
- コードアクション（リネーム、メソッド抽出）
- ホバー情報
- ワークスペースシンボル検索

### 言語サーバーの管理

Zed はユーザー向けに言語サーバーの管理を簡素化しています。

1. 自動ダウンロード: 対応するファイルタイプのファイルを開くと、Zed が適切な言語サーバーを自動的にダウンロードします。既知のファイルタイプの場合、Zed から拡張機能のインストールを促されることがあります。

2. 保存場所:

   - macOS: `~/Library/Application Support/Zed/languages`
   - Linux: `$XDG_DATA_HOME/zed/languages`, `$FLATPAK_XDG_DATA_HOME/zed/languages`, または `$HOME/.local/share/zed/languages`

3. 自動アップデート: Zed は言語サーバーを最新の状態に保ち、常に最新の機能と改善を利用できるようにします。

### 言語サーバーの選択

Zed では、言語によっては複数の言語サーバーオプションが提供されています。同じ言語を対象とする言語サーバーをバンドルした拡張機能を複数インストールしている場合、機能が重複することがあります。好みの機能を利用できるように、Zed では使用する言語サーバーとその順序を優先度付きで指定できます。

`language_servers` 設定を使用して、優先順位を指定できます。

```json [settings]
  "languages": {
    "PHP": {
      "language_servers": ["intelephense", "!phpactor", "!phptools", "..."]
    }
  }
```

この例では:

- `intelephense` がプライマリの言語サーバーとして設定されています。
- `phpactor` と `phptools` は無効化されています（`!` プレフィックスに注目してください）。
- `"..."` は、PHP 用に登録されている言語サーバーのうち、まだリストされていない残りすべてを展開して追加します。

`"..."` エントリはワイルドカードのように機能し、明示的に指定していない登録済み言語サーバーをすべて含めます。名前で列挙したサーバーはその位置を保持し、`"..."` がその位置に残りのサーバーを埋めます。`!` が付いたサーバーは完全に除外されます。つまり、新しい言語サーバー拡張機能をインストールしたり、ある言語に新しいサーバーが登録された場合でも、`"..."` によって自動的に含まれることになります。どのサーバーを有効にするかを完全に制御したい場合は、`"..."` を省略してください — 名前で列挙したサーバーだけが使用されます。

#### 例

Ruby を使っているとします。デフォルトの設定は次のとおりです。

```json [settings]
{
  "language_servers": [
    "solargraph",
    "!ruby-lsp",
    "!rubocop",
    "!sorbet",
    "!steep",
    "!kanayago",
    "..."
  ]
}
```

設定内で `language_servers` を上書きすると、そのリストはデフォルトを完全に**置き換え**ます。つまり、`kanayago` のようにデフォルトでは無効化されているサーバーも、明示的に再度無効化しない限り、`"..."` によって再び有効化されることになります。

| 構成                                               | 結果                                                                 |
| ------------------------------------------------- | ------------------------------------------------------------------ |
| `["..."]`                                         | `solargraph`, `ruby-lsp`, `rubocop`, `sorbet`, `steep`, `kanayago` |
| `["ruby-lsp", "..."]`                             | `ruby-lsp`, `solargraph`, `rubocop`, `sorbet`, `steep`, `kanayago` |
| `["ruby-lsp", "!solargraph", "!kanayago", "..."]` | `ruby-lsp`, `rubocop`, `sorbet`, `steep`                           |
| `["ruby-lsp", "solargraph"]`                      | `ruby-lsp`, `solargraph`                                           |

> 注意: 最初の例では、デフォルトで無効化されているにもかかわらず、`"..."` には `kanayago` が含まれます。これは上書きによってデフォルトのリストが置き換えられ、`"!kanayago"` エントリが存在しなくなったためです。引き続き無効のままにしておくには、構成内に `"!kanayago"` を含める必要があります。

### Toolchains

一部の言語サーバーは、現在の「toolchain」を設定する必要があります。これは特定バージョンのプログラミング言語コンパイラやインタープリタのインストールであり、場合によってはプロジェクトの依存関係一式を含むこともあります。
Zed がツールチェーンとみなすものの例としては、Python の仮想環境があります。
Zed のすべての言語がツールチェーンの検出と選択をサポートしているわけではありませんが、サポートしている言語については、ツールチェーンピッカー（{#action toolchain::Select}）からツールチェーンを指定できます。Zed におけるツールチェーンの詳細については、[`toolchains`](./toolchains.md) を参照してください。

### Configuring Language Servers

`settings.json` で言語サーバーを構成する際、オートコンプリート候補には、読み込まれている言語で現在アクティブなものだけでなく、Zed が認識している利用可能なすべての LSP アダプタが含まれます。これにより、それらを使用するファイルを開く前に、言語サーバーを見つけて設定することができます。

多くの言語サーバーはカスタム設定オプションを受け付けます。これらは `settings.json` の `lsp` セクションで設定できます:

```json [settings]
  "lsp": {
    "rust-analyzer": {
      "initialization_options": {
        "check": {
          "command": "clippy"
        }
      }
    }
  }
```

この例では、Rust Analyzer がファイル保存時に追加のリント用として Clippy を使用するように構成しています。

#### Nested objects

Zed で言語サーバーのオプションを構成する場合、ドット区切りの文字列ではなく、ネストされたオブジェクトを使用することが重要です。これは、より複雑な設定を扱うときに特に重要です。TypeScript 言語サーバーを使った実際の例を見てみましょう。

TypeScript に対して次の設定を行いたいとします:

- 厳密な null チェックを有効にする
- ECMAScript のターゲットバージョンを ES2020 に設定する

これらの設定を Zed の `settings.json` で構成すると、次のようになります:

```json [settings]
"lsp": {
  "typescript-language-server": {
    "initialization_options": {
      // これらはサポートされません（VSCode のドット区切りスタイル）:
      // "preferences.strictNullChecks": true,
      // "preferences.target": "ES2020"
      //
      // こちらが正しい記述です（ネスト構文）:
      "preferences": {
        "strictNullChecks": true,
        "target": "ES2020"
      },
    }
  }
}
```

#### Possible configuration options

個々の言語サーバーの実装方法によって、LSP で指定されている異なる設定オプションに依存する場合があります。

- [initializationOptions](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#version_3_17_0)

言語サーバーの起動時に一度だけ送信され、変更を再適用するにはサーバーの再起動が必要です。

たとえば、rust-analyzer と clangd は、この方法による設定のみに依存します。

```json [settings]
  "lsp": {
    "rust-analyzer": {
      "initialization_options": {
        "checkOnSave": false
      }
    }
  }
```

- [Configuration Request](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#workspace_configuration)

サーバーから複数回問い合わせられる可能性があります。
ほとんどのサーバーは、この方法による設定のみに依存します。

```json [settings]
"lsp": {
  "tailwindcss-language-server": {
    "settings": {
      "tailwindCSS": {
        "emmetCompletions": true,
      },
    }
  }
}
```

LSP 関連のサーバー設定オプションとは別に、Zed の一部のサーバーでは、Zed によるバイナリの起動方法を設定できます。

言語サーバーは、パス上で見つかった場合には自動的にダウンロードまたは起動されます。明示的に別のバイナリを指定したい場合は、それを settings で指定できます:

```json [settings]
  "lsp": {
    "rust-analyzer": {
      "binary": {
        // バイナリをインターネットから取得するか、ローカルから探すかを指定します。
        "ignore_system_version": false,
        "path": "/path/to/langserver/bin",
        "arguments": ["--option", "value"],
        "env": {
          "FOO": "BAR"
        }
      }
    }
  }
```

### Enabling or Disabling Language Servers

言語サーバーのサポートは、グローバルまたは言語ごとに切り替えることができます:

```json [settings]
  "languages": {
    "Markdown": {
      "enable_language_server": false
    }
  }
```

これは Markdown ファイルに対する言語サーバーを無効にします。大規模なドキュメントプロジェクトでは性能面で有用な場合があります。これは `~/.config/zed/settings.json` でグローバルに、またはプロジェクトディレクトリ内の `.zed/settings.json` で設定できます。

## Formatting and Linting

Zed は、コードスタイルの一貫性を保ち、潜在的な問題を早期に検出するためのコードフォーマットとリントをサポートしています。

### Configuring Formatters

Zed は、組み込みフォーマッタと外部フォーマッタの両方をサポートします。詳細は [`formatter`](./reference/all-settings.md#formatter) のドキュメントを参照してください。フォーマッタは `settings.json` でグローバルまたは言語ごとに設定できます:

```json [settings]
"languages": {
  "JavaScript": {
    "formatter": {
      "external": {
        "command": "prettier",
        "arguments": ["--stdin-filepath", "{buffer_path}"]
      }
    },
    "format_on_save": "on"
  },
  "Rust": {
    "formatter": "language_server",
    "format_on_save": "on"
  }
}
```

この例では、JavaScript には Prettier を、Rust には言語サーバーのフォーマッタを使用し、どちらも保存時にフォーマットするように設定しています。

特定の言語に対してフォーマットを無効にするには:

```json [settings]
"languages": {
  "Markdown": {
    "format_on_save": "off"
  }
}
```

### Setting Up Linters

Zed でのリントは、通常は言語サーバーによって処理されます。多くの言語サーバーは、リントルールの設定をサポートしています:

```json [settings]
"lsp": {
  "eslint": {
    "settings": {
      "codeActionOnSave": {
        "rules": ["import/order"]
      }
    }
  }
}
```

この設定では、JavaScript ファイルの保存時に ESLint が import の並び替えを行うように構成しています。

保存時にリンターの修正を自動的に実行するには:

```json [settings]
"languages": {
  "JavaScript": {
    "formatter": {
      "code_action": "source.fixAll.eslint"
    }
  }
}
```

### Formatting Selections

Zed は、`editor: format selections` ({#kb editor::FormatSelections}) を使って選択されたテキストのみをフォーマットできます。
この動作は、設定されているフォーマッタに依存します:

```
- **言語サーバー**: 各選択範囲に対して LSP の範囲フォーマット要求を送信します。これにより、最も精密な
  選択範囲のみのフォーマットが行われます。
- **Prettier**: すべての選択範囲を包含する範囲をフォーマットするために、Prettier の組み込みの範囲フォーマットを使用します。選択範囲外に対して行われた
  変更はすべて破棄されるため、選択したコードだけが変更されます。
- **外部コマンド**: 外部コマンドのフォーマッターは範囲フォーマットをサポートしていないため、
  選択範囲のフォーマット時にはスキップされます。

### フォーマットとリントの統合

Zed では、保存時にフォーマットとリントの両方を実行できます。以下は、JavaScript ファイルに対してフォーマットに Prettier を、リントに ESLint を使用する例です:

```json [settings]
"languages": {
  "JavaScript": {
    "formatter": [
      {
        "code_action": "source.fixAll.eslint"
      },
      {
        "external": {
          "command": "prettier",
          "arguments": ["--stdin-filepath", "{buffer_path}"]
        }
      }
    ],
    "format_on_save": "on"
  }
}
```

### トラブルシューティング

フォーマットやリントで問題が発生した場合は、次の点を確認してください:

1. エラーメッセージについて Zed のログファイルを確認します（コマンドパレットで `zed: open log` を使用）
2. 外部ツール（フォーマッター、リンター）が正しくインストールされ、PATH に含まれていることを確認します
3. Zed の設定と各言語用の設定ファイル（例: `.eslintrc`, `.prettierrc`）の両方で設定内容を確認します

## シンタックスハイライトとテーマ

Zed ではシンタックスハイライトとテーマをカスタマイズでき、コードの見た目を好みに合わせて調整できます。

### シンタックスハイライトのカスタマイズ

Zed はシンタックスハイライトに Tree-sitter の文法を使用します。`theme_overrides` 設定を使って、デフォルトのハイライトを上書きできます。

次の例では、コメントをイタリックにし、文字列の色を変更しています:

```json [settings]
"theme_overrides": {
  "One Dark": {
    "syntax": {
      "comment": {
        "font_style": "italic"
      },
      "string": {
        "color": "#00AA00"
      }
    }
  }
}
```

### テーマの選択とカスタマイズ

テーマを変更するには:

1. テーマセレクターを使用する（{#kb theme_selector::Toggle}）
2. または `settings.json` で設定します:

```json [settings]
"theme": {
  "mode": "dark",
  "dark": "One Dark",
  "light": "GitHub Light"
}
```

`~/.config/zed/themes/` に JSON ファイルを作成することでカスタムテーマを作成できます。Zed はこのディレクトリ内のテーマを自動的に検出し、利用可能にします。

### テーマ拡張機能の使用

Zed はテーマ拡張機能をサポートしています。Extensions パネル（{#kb zed::Extensions}）からテーマ拡張機能を閲覧およびインストールできます。

独自のテーマ拡張機能を作成するには、[テーマ拡張機能の開発](./extensions/themes.md) ガイドを参照してください。

## Language Server 機能の使用

### セマンティックトークン

セマンティックトークンは、言語サーバーからの型やスコープの情報を利用することで、よりリッチなシンタックスハイライトを提供します。`semantic_tokens` 設定で有効化できます:

```json [settings]
"semantic_tokens": "combined"
```

- `"off"` — Tree-sitter のハイライトのみ（デフォルト）
- `"combined"` — Tree-sitter の上に LSP のセマンティックトークンを重ねて表示
- `"full"` — LSP のセマンティックトークンで Tree-sitter を完全に置き換え

設定の `global_lsp_settings.semantic_token_rules` で、トークンの色やスタイルをカスタマイズできます。

→ [セマンティックトークンのドキュメント](./semantic-tokens.md)

### インレイヒント

インレイヒントは、パラメーター名や推論された型などの追加情報をコード内にインラインで表示します。`settings.json` でインレイヒントを設定できます:

```json [settings]
"inlay_hints": {
  "enabled": true,
  "show_type_hints": true,
  "show_parameter_hints": true,
  "show_other_hints": true
}
```

言語ごとのインレイヒント設定については、各言語のドキュメントを参照してください。

### コードアクション

コードアクションは、クイックフィックスやリファクタリングのオプションを提供します。`editor: Toggle Code Actions` コマンドを使用するか、アクションが利用可能なときにカーソルの横に表示される電球アイコンをクリックして、コードアクションにアクセスできます。

### 定義および参照へのジャンプ

次のコマンドを使ってコードベース内を移動できます:

- `editor: Go to Definition` (<kbd>f12|f12</kbd>)
- `editor: Go to Type Definition` (<kbd>cmd-f12|ctrl-f12</kbd>)
- `editor: Find All References` (<kbd>shift-f12|shift-f12</kbd>)

### シンボル名の変更

プロジェクト全体でシンボル名を変更するには:

1. 変更したいシンボル上にカーソルを置きます
2. `editor: Rename Symbol` コマンドを使用します（<kbd>f2|f2</kbd>）
3. 新しい名前を入力し、Enter キーを押します

これらの機能は、各言語の言語サーバーの機能に依存します。

複数のファイルにまたがるシンボル名を変更する場合、Zed はマルチバッファでプレビューを開きます。これにより、変更を適用する前にプロジェクト全体のすべての変更を確認できます。名前の変更を確定するには、マルチバッファを保存するだけです。名前の変更を行わない場合は、変更を元に戻すか、マルチバッファを保存せずに閉じることができます。

### ホバー情報

`editor: Hover` コマンドを使用して、カーソル下のシンボルに関する情報を表示できます。ここには、型情報、ドキュメント、関連リソースへのリンクなどが含まれることがよくあります。

### ワークスペースシンボル検索

{#action project_symbols::Toggle} コマンドを使用すると、プロジェクト全体を対象にシンボル（関数、クラス、変数）を検索できます。これは、大規模なコードベースを素早くナビゲートするのに役立ちます。

### コード補完

Zed は、入力中にインテリジェントなコード補完候補を提示します。`editor: Show Completions` コマンドで補完を手動でトリガーできます。候補を確定するには、<kbd>tab|tab</kbd> または <kbd>enter|enter</kbd> を使用します。

### 診断

言語サーバーは、コーディング中にリアルタイムの診断（エラー、警告、ヒント）を提供します。{#action diagnostics::Deploy} コマンドを使用して、プロジェクトのすべての診断を表示できます。
