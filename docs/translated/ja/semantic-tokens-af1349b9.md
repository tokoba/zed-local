# セマンティックトークン

セマンティックトークンは、言語サーバーからの情報を利用することで、より豊かな構文ハイライトを提供します。純粋に構文だけに基づく tree-sitter のハイライトとは異なり、セマンティックトークンはコードの意味を理解し、ローカル変数とパラメーター、クラス定義とクラス参照といった違いを区別できます。

## セマンティックトークンを有効化する

セマンティックトークンは `semantic_tokens` 設定によって制御されます。デフォルトでは、セマンティックトークンは無効になっています。

```json [settings]
{
  "semantic_tokens": "combined"
}
```

この設定には次の 3 つの値を指定できます:

| Value        | Description                                                                                                                                                 |
| ------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `"off"`      | 言語サーバーにセマンティックトークンを要求しません。tree-sitter のハイライトのみを使用します。（デフォルト）                                                 |
| `"combined"` | tree-sitter のハイライトと併せて LSP のセマンティックトークンを使用します。tree-sitter がベースのハイライトを提供し、その上にセマンティックトークンが追加情報を重ねます。 |
| `"full"`     | LSP のセマンティックトークンのみを使用します。セマンティックトークンをサポートするバッファーでは、tree-sitter のハイライトは完全に無効化されます。                     |

この設定はグローバル、または言語ごとに構成できます:

```json [settings]
{
  "semantic_tokens": "off",
  "languages": {
    "Rust": {
      "semantic_tokens": "combined"
    },
    "TypeScript": {
      "semantic_tokens": "full"
    }
  }
}
```

> **注意:** `semantic_tokens` モードを変更した場合、反映させるには言語サーバーの再起動が必要になることがあります。ハイライトがすぐに更新されない場合は、コマンドパレットから `lsp: restart language servers` コマンドを使用してください。

## トークンカラーのカスタマイズ

セマンティックトークンは、LSP のトークン種別や修飾子をテーマのスタイルやカスタムカラーにマッピングするルールによってスタイル付けされます。Zed は妥当なデフォルトを提供していますが、`settings.json` でカスタマイズできます。`global_lsp_settings.semantic_token_rules` キーの下にルールを追加してください。

ルールは上から順にマッチされ、最初に一致したルールが採用されます。ユーザー定義のルールが最も優先され、その次に拡張機能が提供する言語ルール、最後に Zed のデフォルトが適用されます。

### ルールの構造

各ルールでは、次の項目を指定できます:

| Property           | Description                                                                                                        |
| ------------------ | ------------------------------------------------------------------------------------------------------------------ |
| `token_type`       | 一致させたい LSP セマンティックトークンの種別（例: `"variable"`, `"function"`, `"class"`）。省略した場合は、すべての種別に一致します。 |
| `token_modifiers`  | すべてが含まれていなければならない修飾子のリスト（例: `["declaration"]`, `["readonly", "static"]`）。                 |
| `style`            | 試行するテーマスタイル名のリスト。現在のテーマで最初に見つかったものが使用されます。                                     |
| `foreground_color` | 16 進数形式で前景色を上書きします（例: `"#ff0000"`）。                                                               |
| `background_color` | 16 進数形式で背景色を上書きします。                                                                                 |
| `underline`        | 真偽値または 16 進数カラー。`true` の場合、テキストカラーで下線を引きます。                                           |
| `strikethrough`    | 真偽値または 16 進数カラー。`true` の場合、テキストカラーで取り消し線を引きます。                                     |
| `font_weight`      | `"normal"` または `"bold"`。                                                                                       |
| `font_style`       | `"normal"` または `"italic"`。                                                                                     |

### 例: 解決されていない参照のハイライト

解決されていない参照を目立たせるには次のようにします:

```json [settings]
{
  "global_lsp_settings": {
    "semantic_token_rules": [
      {
        "token_type": "unresolvedReference",
        "foreground_color": "#c93f3f",
        "font_weight": "bold"
      }
    ]
  }
}
```

### 例: unsafe コードのハイライト

Rust の unsafe な操作をハイライトするには次のようにします:

```json [settings]
{
  "global_lsp_settings": {
    "semantic_token_rules": [
      {
        "token_type": "punctuation",
        "token_modifiers": ["unsafe"],
        "foreground_color": "#AA1111",
        "font_weight": "bold"
      }
    ]
  }
}
```

### 例: テーマスタイルの使用

色をハードコードする代わりに、テーマからスタイルを参照します:

```json [settings]
{
  "global_lsp_settings": {
    "semantic_token_rules": [
      {
        "token_type": "variable",
        "token_modifiers": ["mutable"],
        "style": ["variable.mutable", "variable"]
      }
    ]
  }
}
```

現在のテーマで最初に見つかったスタイルが使用され、フォールバックとして機能します。

### 例: 特定のトークン種別を無効化する

特定のトークン種別のハイライトを無効化するには、それに一致する空のルールを追加します:

```json [settings]
{
  "global_lsp_settings": {
    "semantic_token_rules": [
      {
        "token_type": "comment"
      }
    ]
  }
}
```

ユーザーのルールが最も優先され、最初にマッチしたルールが採用されるため、この空のルールによってコメントトークンには一切スタイリングが適用されなくなります。

## デフォルトのルール

Zed のデフォルトのセマンティックトークンルールは、標準的な LSP のトークン種別を一般的なテーマスタイルにマッピングします。例えば次のようになります:

- `function` → `function` スタイル
- `variable` に `constant` 修飾子が付いたもの → `constant` スタイル
- `class` → `type.class`、`class`、または `type` スタイル（最初に見つかったもの）
- `comment` に `documentation` 修飾子が付いたもの → `comment.documentation` または `comment.doc` スタイル

完全なデフォルト設定は、Zed で `zed: show default semantic token rules` コマンドを実行することで表示できます。

## 標準的なトークン種別

言語サーバーは、標準化された種別を使用してトークンを報告します。一般的な種別には次のようなものがあります:

| 種類           | 説明                                 |
| --------------- | ---------------------------------- |
| `namespace`     | 名前空間またはモジュール名          |
| `type`          | 型名                               |
| `class`         | クラス名                           |
| `enum`          | 列挙型名                           |
| `interface`     | インターフェース名                 |
| `struct`        | 構造体名                           |
| `typeParameter` | ジェネリック型パラメーター         |
| `parameter`     | 関数/メソッドのパラメーター        |
| `variable`      | 変数名                             |
| `property`      | オブジェクトのプロパティまたは構造体のフィールド |
| `enumMember`    | 列挙型のバリアント                 |
| `function`      | 関数名                             |
| `method`        | メソッド名                         |
| `macro`         | マクロ名                           |
| `keyword`       | 言語キーワード                     |
| `comment`       | コメント                           |
| `string`        | 文字列リテラル                     |
| `number`        | 数値リテラル                       |
| `operator`      | 演算子                             |

一般的な修飾子には、`declaration`、`definition`、`readonly`、`static`、`deprecated`、`async`、`documentation`、`defaultLibrary` などがあり、Rust の `unsafe` や TypeScript の `abstract` のような言語固有の修飾子も含まれます。

完全な仕様については、[LSP Semantic Tokens documentation](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#semanticTokenTypes) を参照してください。

## Inspecting Semantic Tokens

セマンティックトークンがコードにどのように適用されているかをリアルタイムで確認するには、コマンドパレットから `dev: open highlights tree view` コマンドを使用します。これにより、現在のバッファに対するすべてのハイライト（セマンティックトークンを含む）を表示するパネルが開き、どのトークンが適用されているかの理解やカスタムルールのデバッグが容易になります。

## Troubleshooting

### セマンティックハイライトが表示されない

1. 対象の言語に対して `semantic_tokens` が `"combined"` または `"full"` に設定されていることを確認する
2. 言語サーバーがセマンティックトークンをサポートしていることを確認する（すべてのサーバーがサポートしているわけではありません）
3. `lsp: restart language servers` で言語サーバーの再起動を試す
4. エラーがないか LSP ログ（`workspace: open lsp log`）を確認する

### 設定変更後に色が更新されない

`semantic_tokens` モードの変更には言語サーバーの再起動が必要な場合があります。コマンドパレットから `lsp: restart language servers` を使用してください。

### テーマのスタイルが適用されない

ルール内で指定しているスタイル名が、テーマで定義されているスタイルと一致していることを確認してください。`style` 配列はフォールバックの選択肢を提供します。最初のスタイルが見つからない場合、Zed は次のスタイルを試行します。
