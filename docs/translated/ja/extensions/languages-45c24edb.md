# 言語拡張

Zed における言語サポートはいくつかのコンポーネントから構成されます:

- 言語メタデータと設定
- 文法
- クエリ
- 言語サーバー

## 言語メタデータ

Zed がサポートするそれぞれの言語は、拡張機能の `languages` ディレクトリ内のサブディレクトリで定義されている必要があります。

このサブディレクトリには、次の構造を持つ `config.toml` という名前のファイルを含める必要があります:

```toml
name = "My Language"
grammar = "my-language"
path_suffixes = ["myl"]
line_comments = ["# "]
```

- `name`（必須）は、人間が読める名前であり、Select Language ドロップダウンに表示されます。
- `grammar`（必須）は grammar の名前です。grammar は下で説明するように別途登録されます。
- `path_suffixes` は、この言語に関連付けるファイルサフィックスの配列です。設定の `file_types` と違い、これは glob パターンをサポートしません。
- `line_comments` は、その言語における行コメントを識別するために使用される文字列の配列です。これは、コードの行をトグルするための `editor::ToggleComments` キーバインド {#kb editor::ToggleComments} に使用されます。
- `tab_size` は、この言語で使用されるインデント／タブ幅を定義します（デフォルトは `4`）。
- `hard_tabs` は、タブ（`true`）でインデントするか、スペース（`false`、デフォルト）でインデントするかを指定します。
- `first_line_pattern` は、`path_suffixes`（上記）や設定の `file_types` と組み合わせて使用できる正規表現であり、この言語を使用すべきファイルをマッチさせるために使われます。たとえば Zed では、スクリプトの先頭行の [shebang 行](https://github.com/zed-industries/zed/blob/main/crates/languages/src/bash/config.toml) にマッチさせることで、シェルスクリプトを識別するためにこれを使用します。
- `debuggers` は、その言語におけるデバッガーを識別するために使用される文字列の配列です。デバッガーの `New Process Modal` を起動する際、Zed はこの配列内のエントリの順序に従って、利用可能なデバッガーを並べ替えます。

<!--
TBD: `language_name/config.toml` のキーをドキュメント化する

- autoclose_before
- brackets (start, end, close, newline, not_in: ["comment", "string"])
- word_characters
- prettier_parser_name
- opt_into_language_servers
- code_fence_block_name
- scope_opt_in_language_servers
- increase_indent_pattern, decrease_indent_pattern
- collapsed_placeholder
- auto_indent_on_paste, auto_indent_using_last_non_empty_line
- overrides: `[overrides.element]`, `[overrides.string]`
-->

## 文法

Zed は、組み込みの言語固有の機能を提供するために、[Tree-sitter](https://tree-sitter.github.io) パーシングライブラリを使用します。多くの言語向けの grammar が利用可能であり、[独自の grammar を開発](https://tree-sitter.github.io/tree-sitter/creating-parsers/3-writing-the-grammar.html)することもできます。増え続ける Zed の機能の多くは、Tree-sitter クエリによる構文木上でのパターンマッチングを使って構築されています。前述のとおり、拡張機能で定義されるすべての言語は、パースに使用される Tree-sitter grammar の名前を指定しなければなりません。これらの grammar は、その後、拡張機能の `extension.toml` ファイル内で次のように別途登録されます:

```toml
[grammars.gleam]
repository = "https://github.com/gleam-lang/tree-sitter-gleam"
rev = "58b7cac8fc14c92b0677c542610d8738c373fa81"
```

`repository` フィールドには、Tree-sitter grammar を読み込むリポジトリを指定しなければならず、`rev` フィールドには、使用する Git リビジョン（Git コミットの SHA など）を含める必要があります。拡張機能をローカルで開発していて、ローカルファイルシステムから grammar を読み込みたい場合は、`repository` に `file://` URL を使用できます。拡張機能は、複数の Tree-sitter リポジトリを参照することで、複数の grammar を提供できます。

## Tree-sitter クエリ

Zed は、[Tree-sitter](https://tree-sitter.github.io) クエリ言語によって生成された構文木を使用して、
いくつかの機能を実装しています:

- シンタックスハイライト
- 括弧のマッチング
- コードのアウトライン／構造
- 自動インデント
- コードインジェクション
- 構文のオーバーライド
- テキストのマスキング
- 実行可能なコードの検出
- クラスや関数などの選択

以下のセクションでは、[Tree-sitter クエリ](https://tree-sitter.github.io/tree-sitter/using-parsers/queries/index.html) が Zed においてどのようにこれらの機能を実現しているかを、[JSON 構文](https://www.json.org/json-en.html) を例として詳しく説明します。

### シンタックスハイライト

Tree-sitter では、`highlights.scm` ファイルが特定の構文に対するシンタックスハイライトのルールを定義します。

次は、JSON 用の `highlights.scm` からの例です:

```scheme
(string) @string

(pair
  key: (string) @property.json_key)

(number) @number
```

このクエリは、文字列、オブジェクトキー、および数値をハイライト対象としてマークします。以下は、テーマでサポートされているキャプチャの完全な一覧です:

| Capture                  | Description                              |
| ------------------------ | ---------------------------------------- |
| @attribute               | 属性をキャプチャーします                 |
| @boolean                 | ブール値をキャプチャーします             |
| @comment                 | コメントをキャプチャーします             |
| @comment.doc             | ドキュメンテーションコメントをキャプチャーします |
| @constant                | 定数をキャプチャーします                 |
| @constant.builtin        | 組み込み定数をキャプチャーします         |
| @constructor             | コンストラクターをキャプチャーします     |
| @embedded                | 埋め込みコンテンツをキャプチャーします   |
| @emphasis                | 強調されたテキストをキャプチャーします   |
| @emphasis.strong         | 強く強調されたテキストをキャプチャーします |
| @enum                    | 列挙をキャプチャーします                 |
| @function                | 関数をキャプチャーします                 |
| @hint                    | ヒントをキャプチャーします               |
| @keyword                 | キーワードをキャプチャーします           |
| @label                   | ラベルをキャプチャーします               |
| @link_text               | リンクテキストをキャプチャーします       |
| @link_uri                | リンク URI をキャプチャーします          |
| @number                  | 数値をキャプチャーします                 |
| @operator                | 演算子をキャプチャーします               |
| @predictive              | 予測テキストをキャプチャーします         |
| @preproc                 | プリプロセッサーディレクティブをキャプチャーします |
| @primary                 | 主要な要素をキャプチャーします           |
| @property                | プロパティをキャプチャーします           |
| @punctuation             | 句読点をキャプチャーします               |
| @punctuation.bracket     | 角かっこをキャプチャーします             |
| @punctuation.delimiter   | デリミタをキャプチャーします             |
| @punctuation.list_marker | リストマーカーをキャプチャーします       |
| @punctuation.special     | 特殊な句読点をキャプチャーします         |
| @string                  | 文字列リテラルをキャプチャーします       |
| @string.escape           | 文字列内のエスケープされた文字をキャプチャーします |
| @string.regex            | 正規表現をキャプチャーします             |
| @string.special          | 特殊な文字列をキャプチャーします         |
| @string.special.symbol   | 特殊なシンボルをキャプチャーします       |
| @tag                     | タグをキャプチャーします                 |
| @tag.doctype             | doctype（例: HTML）の宣言をキャプチャーします |
| @text.literal            | リテラルテキストをキャプチャーします     |
| @title                   | タイトルをキャプチャーします             |
| @type                    | 型をキャプチャーします                   |
| @type.builtin            | 組み込み型をキャプチャーします           |
| @variable                | 変数をキャプチャーします                 |
| @variable.special        | 特殊な変数をキャプチャーします           |
| @variable.parameter      | 関数/メソッドのパラメーターをキャプチャーします |
| @variant                 | バリアントをキャプチャーします           |

#### Fallback captures

1 つの Tree-sitter パターンは、同じノードに対して複数のキャプチャーを指定して、フォールバック用のハイライトを定義できます。
Zed は右から左へとそれらを解決します。まず一番右のキャプチャーを試し、現在のテーマにそのスタイルがない場合は、左隣のキャプチャーへとフォールバックし、以下同様に続きます。

例えば次のようになります。

```scheme
(type_identifier) @type @variable
```

ここで Zed はまずテーマから `@variable` を解決しようとします。テーマが `@variable` に対してスタイルを定義している場合は、そのスタイルが使用されます。そうでなければ、Zed は `@type` にフォールバックします。

これは、ある言語が、すべてのテーマがサポートしているとは限らない優先されるハイライトを提供しつつ、ほとんどのテーマが定義しているより一般的なキャプチャーへとフォールバックしたい場合に有用です。

### Bracket matching

`brackets.scm` ファイルは対応する括弧を定義します。

以下は JSON 用の `brackets.scm` ファイルの例です。

```scheme
("[" @open "]" @close)
("{" @open "}" @close)
("\"" @open "\"" @close)
```

このクエリは開き括弧と閉じ括弧、中かっこ、引用符を識別します。

| Capture | Description                                         |
| ------- | --------------------------------------------------- |
| @open   | 開き括弧、中かっこ、引用符をキャプチャーします     |
| @close  | 閉じ括弧、中かっこ、引用符をキャプチャーします     |

Zed はこれらを使用して対応する括弧をハイライトします。各括弧のペアを異なる色（「レインボーブラケット」）で塗り分け、カーソルが括弧のペアの内側にある場合には括弧をハイライトします。

レインボーブラケットによる色付けを無効化するには、対応する `brackets.scm` エントリに次の内容を追加します。

```scheme
(("\"" @open "\"" @close) (#set! rainbow.exclude))
```

### Code outline/structure

`outline.scm` ファイルはコードアウトラインの構造を定義します。

以下は JSON 用の `outline.scm` ファイルの例です。

```scheme
(pair
  key: (string (string_content) @name)) @item
```

このクエリはアウトライン構造のためにオブジェクトのキーをキャプチャーします。

| Capture        | Description                                                                                 |
| -------------- | ------------------------------------------------------------------------------------------- |
| @name          | オブジェクトキーの内容をキャプチャーします                                                 |
| @item          | キーと値のペア全体をキャプチャーします                                                     |
| @context       | アウトライン項目にコンテキストを提供する要素をキャプチャーします                           |
| @context.extra | アウトライン項目の追加のコンテキスト情報をキャプチャーします                               |
| @annotation    | アウトライン項目に注釈を付けるノード（ドキュメントコメント、属性、デコレーター）をキャプチャーします[^1] |

[^1]: これらの注釈は、Assistant がコード変更ステップを生成する際に使用されます。

### Auto-indentation

`indents.scm` ファイルはインデントルールを定義します。

以下は JSON 用の `indents.scm` ファイルの例です。

```scheme
(array "]" @end) @indent
(object "}" @end) @indent
```

このクエリはインデントのために配列とオブジェクトの終端をマークします。

| Capture | Description                                        |
| ------- | -------------------------------------------------- |
| @end    | 閉じ括弧と中かっこをキャプチャーします            |
| @indent | インデントのために配列とオブジェクト全体をキャプチャーします |

### Code injections

`injections.scm` ファイルは、Markdown 内のコードブロックや Python の文字列内の SQL クエリのように、ある言語の中に別の言語を埋め込むためのルールを定義します。

以下は Markdown 用の `injections.scm` ファイルの例です。

```scheme
(fenced_code_block
  (info_string
    (language) @injection.language)
  (code_fence_content) @injection.content)

((inline) @content
 (#set! injection.language "markdown-inline"))
```

このクエリはフェンス付きコードブロックを識別し、info string で指定された言語とブロック内のコンテンツをキャプチャーします。また、インラインコンテンツをキャプチャーし、その言語を "Markdown-inline" に設定します。

```
| キャプチャ             | 説明                                                          |
| ------------------- | ------------------------------------------------------------- |
| @injection.language | コードブロックの言語識別子をキャプチャします                  |
| @injection.content  | 別の言語として扱われるコンテンツをキャプチャします            |

ここでは JSON は言語インジェクションをサポートしていないため、例として使用できませんでした。

### 構文オーバーライド

`overrides.scm` ファイルは、特定の言語構造内で特定のエディタ設定を上書きするために使用できる構文上の _スコープ_ を定義します。

例えば、言語固有の設定に `word_characters` というものがあり、変数をダブルクリックして選択するときなどに、どの非アルファベット文字を単語の一部と見なすかを制御します。JavaScript では、"$" と "#" が単語文字と見なされます。

また、`completion_query_characters` という言語固有の設定もあり、どの文字が自動補完候補をトリガーするかを制御します。JavaScript では、カーソルが _文字列_ の中にあるとき、`-` を補完クエリ文字として扱う必要があります。これを実現するために、JavaScript の `overrides.scm` ファイルには次のパターンが含まれています。

```scheme
[
  (string)
  (template_string)
] @string
```

そして JavaScript の `config.toml` には次の設定が含まれています。

```toml
word_characters = ["#", "$"]

[overrides.string]
completion_query_characters = ["-"]
```

また、特定のスコープ内で特定の自動クローズ括弧を無効化することもできます。例えば、文字列内での `'` の自動クローズを防ぐには、JavaScript の `config.toml` に次のように記述します。

```toml
brackets = [
  { start = "'", end = "'", close = true, newline = false, not_in = ["string"] },
  # 他のペア...
]
```

#### 範囲の包含性

デフォルトでは、`overrides.scm` で定義された範囲は *排他的* です。そのため上記の例では、カーソルが文字列を区切る引用符の *外側* にある場合、`string` スコープは適用されません。場合によっては、範囲を *包含的* にしたくなることがあります。その場合は、クエリ内のキャプチャ名に `.inclusive` サフィックスを追加します。

例えば JavaScript では、コメント内でのシングルクォートの自動クローズも無効化します。そしてコメントスコープは、行コメントの改行の後ろまで含めて延びている必要があります。これを実現するために、JavaScript の `overrides.scm` には次のパターンが含まれています。

```scheme
(comment) @comment.inclusive
```

### テキストオブジェクト

`textobjects.scm` ファイルは、テキストオブジェクトによるナビゲーションのルールを定義します。これは Zed v0.165 で追加され、現在は Vim モードでのみ使用されています。

Vim はファイル内を移動するために 2 つの粒度レベルを提供します。`[]` などによるセクション単位、および `]m` などによるメソッド単位です。関数やクラスをサポートしていない言語でも、同様の概念を定義することでうまく機能させることができます。例えば CSS では、ルールセットをメソッド、メディアクエリをクラスとして定義します。

クロージャを持つ言語に対しては、Zed では通常これらを関数として数えないようにするべきです。ただしこれはベストエフォートであり、JavaScript のように構文上クロージャとトップレベルの関数宣言を区別しない言語もあります。

C のように宣言を持つ言語では、`@class.around` や `@function.around` にマッチするクエリを用意してください。`inside` がない場合、`if` と `ic` のテキストオブジェクトはこれらをデフォルトとして使用します。

`textobjects.scm` に何を書けばよいかわからない場合は、[nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) と [Helix editor](https://github.com/helix-editor/helix) の両方が多くの言語向けのクエリを持っているので参考にできます。また、Zed の[組み込み言語](https://github.com/zed-industries/zed/tree/main/crates/languages/src)を参照して、それらをどのように適応させているかを見ることができます。

| キャプチャ          | 説明                                                                     | Vim モード                                        |
| ---------------- | ------------------------------------------------------------------------ | ------------------------------------------------ |
| @function.around | 関数定義全体、またはそれと同等の小さなファイルセクション                  | `[m`, `]m`, `[M`,`]M` モーション。`af` テキストオブジェクト  |
| @function.inside | 関数本体（波かっこ内の部分）                                              | `if` テキストオブジェクト                        |
| @class.around    | クラス定義全体、またはそれと同等の大きなファイルセクション                | `[[`, `]]`, `[]`, `][` モーション。`ac` テキストオブジェクト |
| @class.inside    | クラス定義の中身                                                          | `ic` テキストオブジェクト                        |
| @comment.around  | コメント全体（例: すべての隣接する行コメント、またはブロックコメント）    | `gc` テキストオブジェクト                        |
| @comment.inside  | コメントの中身                                                            | `igc` テキストオブジェクト（サポートされることは稀）        |

例えば次のようになります。

```scheme
; 関数にはメソッドの内容のみを含める
(method_definition
    body: (_
        "{"
        (_)* @function.inside
        "}")) @function.around

; 本体のない宣言に対して function.around をマッチさせる
(function_signature_item) @function.around

; すべての隣接するコメントを 1 つに結合する
(comment)+ @comment.around
```

### テキストのマスキング

`redactions.scm` ファイルはテキストマスキングのルールを定義します。コラボレーション中に画面共有を行う際、特定の構文ノードが漏洩しないように、それらをマスクされた状態で描画するようにします。

以下は JSON 向け `redactions.scm` ファイルの例です。

```scheme
(pair value: (number) @redact)
(pair value: (string) @redact)
(array (number) @redact)
(array (string) @redact)
```

このクエリは、キーと値のペアおよび配列内の数値と文字列の値をマスキング対象としてマークします。

| キャプチャ | 説明                           |
| -------- | ------------------------------ |
| @redact  | マスキング対象となる値をキャプチャします |

### 実行可能コードの検出

`runnables.scm` ファイルは、実行可能コードを検出するためのルールを定義します。

以下は JSON 向け `runnables.scm` ファイルの例です。

```scheme
(
    (document
        (object
            (pair
                key: (string
                    (string_content) @_name
                    (#eq? @_name "scripts")
                )
                value: (object
                    (pair
                        key: (string (string_content) @run @script)
                    )
                )
            )
        )
    )
    (#set! tag package-script)
    (#set! tag composer-script)
)
```

このクエリは、package.json と composer.json ファイル内の実行可能なスクリプトを検出します。

`@run` キャプチャは、エディタ内で実行ボタンを表示する位置を指定します。先頭にアンダースコアが付いているものを除く他のキャプチャは、コードを実行する際に `ZED_CUSTOM_$(capture_name)` というプレフィックスを付けた環境変数として公開されます。

| キャプチャ | 説明                                        |
| -------- | ------------------------------------------- |
| @\_name  | `"scripts"` キーをキャプチャします           |
| @run     | スクリプト名をキャプチャします               |
| @script  | 別の用途のためにスクリプト名もキャプチャします |
<!--
TBD: `#set! tag`
-->

## 言語サーバー

Zed は高度な言語サポートを提供するために [Language Server Protocol](https://microsoft.github.io/language-server-protocol/) を使用します。

拡張機能は任意の数の言語サーバーを提供できます。拡張機能から言語サーバーを提供するには、言語サーバーの名前と、それが適用される言語を指定したエントリを `extension.toml` に追加します。`languages` の一覧にあるエントリは、その言語の `config.toml` ファイル内の `name` フィールドと一致している必要があります。

```toml
[language_servers.my-language-server]
name = "My Language LSP"
languages = ["My Language"]
```

次に、拡張機能の Rust コードで、拡張機能に対して `language_server_command` メソッドを実装します。

```rust
impl zed::Extension for MyExtension {
    fn language_server_command(
        &mut self,
        language_server_id: &LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<zed::Command> {
        Ok(zed::Command {
            command: get_path_to_language_server_executable()?,
            args: get_args_for_language_server()?,
            env: get_env_for_language_server()?,
        })
    }
}
```

言語サーバーの扱いは、`Extension` トレイトのいくつかのオプションメソッドを使ってカスタマイズできます。たとえば、`label_for_completion` メソッドを使って補完のスタイルを制御できます。利用可能なメソッドの完全な一覧については、[Zed extension API の API ドキュメント](https://docs.rs/zed_extension_api) を参照してください。

### セマンティックトークンによる構文ハイライト

Zed は、接続された言語サーバーから提供されるセマンティックトークンを利用した構文ハイライトをサポートしています。これは現在デフォルトでは無効になっていますが、設定ファイルで有効化できます。

```json [settings]
{
  // 各言語の tree-sitter ハイライトを併用して、セマンティックトークンをグローバルに有効化する:
  "semantic_tokens": "combined",
  // あるいは、言語ごとに指定する:
  "languages": {
    "Rust": {
      // tree-sitter は使わず、LSP のセマンティックトークンのみを使用する:
      "semantic_tokens": "full"
    }
  }
}
```

`semantic_tokens` 設定には、次の値を指定できます:

- `"off"`（デフォルト）: 言語サーバーにセマンティックトークンを要求しません。
- `"combined"`: LSP のセマンティックトークンと tree-sitter のハイライトを併用します。
- `"full"`: tree-sitter のハイライトを置き換え、LSP のセマンティックトークンのみを使用します。

#### 拡張機能が提供するセマンティックトークンルール

言語拡張は、その言語サーバーのカスタムトークンタイプに対するデフォルトのセマンティックトークンルールを同梱できます。そのためには、`config.toml` と同じ言語ディレクトリに `semantic_token_rules.json` ファイルを配置します。

```
my-extension/
  languages/
    my-language/
      config.toml
      highlights.scm
      semantic_token_rules.json
```

このファイルの形式は、ユーザー設定内の `semantic_token_rules` 配列と同じで、ルールオブジェクトの JSON 配列です。

```json
[
  {
    "token_type": "lifetime",
    "style": ["lifetime"]
  },
  {
    "token_type": "builtinType",
    "style": ["type"]
  },
  {
    "token_type": "selfKeyword",
    "style": ["variable.special"]
  }
]
```

これは、言語サーバーが Zed の組み込みデフォルトルールでカバーされていないカスタム（非標準）のセマンティックトークンタイプを報告する場合に有用です。拡張機能が提供するルールは、その言語に対する適切なデフォルトとして機能します。ユーザーは設定ファイル内の `semantic_token_rules` でこれらをいつでも上書きでき、ユーザー設定と拡張機能のルールのいずれにも一致しない場合にのみ、組み込みのデフォルトルールが使用されます。

#### セマンティックトークンのスタイルをカスタマイズする

Zed はセマンティックトークンに使用されるスタイルのカスタマイズをサポートしています。設定ファイルにルールを定義することで、セマンティックトークンがテーマ内のスタイルにどのようにマッピングされるかをカスタマイズできます。

```json [settings]
{
  "global_lsp_settings": {
    "semantic_token_rules": [
      {
        // マクロをキーワードとしてハイライトします。
        "token_type": "macro",
        "style": ["syntax.keyword"]
      },
      {
        // 未解決の参照を太字の赤でハイライトします。
        "token_type": "unresolvedReference",
        "foreground_color": "#c93f3f",
        "font_weight": "bold"
      },
      {
        // すべてのミュータブルな変数や参照などに下線を引きます。
        "token_modifiers": ["mutable"],
        "underline": true
      }
    ]
  }
}
```

指定された `token_type` と `token_modifiers` に一致するすべてのルールが適用されます。先に記述されたルールが優先されます。一致するルールがない場合、そのトークンはハイライトされません。

ルールは次の優先順位（高い順）で適用されます。

1. **ユーザー設定** — 設定ファイル内の `semantic_token_rules` によるルール。
2. **拡張機能のルール** — 拡張機能の言語ディレクトリ内の `semantic_token_rules.json` のルール。
3. **デフォルトルール** — 標準的な LSP トークンタイプに対する Zed の組み込みルール。

`semantic_token_rules` 配列内の各ルールは次のように定義されます。

- `token_type`: [LSP specification](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_semanticTokens) で定義されているセマンティックトークンタイプ。省略された場合、そのルールはすべてのトークンタイプに一致します。
- `token_modifiers`: 一致させるセマンティックトークン修飾子のリスト。すべての修飾子が含まれている場合にのみ一致します。
- `style`: 使用する現在のシンタックステーマ内のスタイルのリスト。最初に見つかったスタイルが使用されます。以下の設定はそのスタイルを上書きします。
- `foreground_color`: トークンタイプに使用する前景色。16 進数形式（例: `"#ff0000"`）。
- `background_color`: トークンタイプに使用する背景色。16 進数形式（例: `"#ff0000"`）。
- `underline`: 下線を引くかどうか、または使用する下線色（16 進数形式）。`true` の場合、そのトークンは文字色で下線が引かれます。
- `strikethrough`: 取り消し線を引くかどうか、または使用する取り消し線の色（16 進数形式）。`true` の場合、そのトークンには文字色の取り消し線が引かれます。
- `font_weight`: `"normal"`、`"bold"` のいずれか。
- `font_style`: `"normal"`、`"italic"` のいずれか。

### 複数言語サポート

言語サーバーが複数の言語をサポートしている場合は、`language_ids` を使って、Zed の `languages` を目的の [LSP 固有の `languageId`](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocumentItem) 識別子にマッピングできます。

```toml

[language-servers.my-language-server]
name = "Whatever LSP"
languages = ["JavaScript", "HTML", "CSS"]

[language-servers.my-language-server.language_ids]
"JavaScript" = "javascript"
"TSX" = "typescriptreact"
"HTML" = "html"
"CSS" = "css"
```
