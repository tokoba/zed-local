# スニペット

{#action snippets::ConfigureSnippets} アクションを使用して、指定した[スコープ](#scopes)の新しいスニペットファイルを作成するか、既存のスニペットファイルを編集します。

スニペットは `~/.config/zed/snippets` ディレクトリに配置されており、{#action snippets::OpenFolder} アクションでそのディレクトリに移動できます。

## 設定例

```json
{
  // 各スニペットには name と body が必須ですが、prefix と description は省略可能です。
  // prefix はスニペットをトリガーするために使用されますが、省略された場合は name が使用されます。
  // $1、$2、${1:defaultValue} のようなプレースホルダーを使用して、タブストップを定義します。
  // $0 は最終的なカーソル位置を決定します。
  // 同じ値を持つプレースホルダーはリンクされます。
  // スニペットにプレースホルダーの外側で $ 記号が含まれる場合は、バックスラッシュ 2 つでエスケープする必要があります（例: \\$var）。
  "Log to console": {
    "prefix": "log",
    "body": ["console.info(\"Hello, ${1:World}!\")", "$0"],
    "description": "Logs to console"
  }
}
```

## スコープ

スコープは小文字の言語名によって決定されます。たとえば、Python には `python.json`、Shell Script には `shell script.json` を使用します。ただし、このルールにはいくつかの例外があります。

| Scope      | Filename        |
| ---------- | --------------- |
| Global     | snippets.json   |
| JSX        | JavaScript.json |
| Plain Text | plaintext.json  |

JSX のスニペットを作成するには、`jsx.json` ではなく `javascript.json` のスニペットファイルを使用する必要があります。ただし、TSX と TypeScript にはこの制限はなく、上記のルールに従います。

## 既知の制限事項

- プレフィックスのリストが渡された場合、最初のプレフィックスのみが使用されます。
- 現在サポートされているスニペットファイル形式は `json` のみです。
