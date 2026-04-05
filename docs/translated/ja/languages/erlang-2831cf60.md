# Erlang

Erlang のサポートは [Erlang extension](https://github.com/zed-extensions/erlang) を通じて利用できます。

- Tree-sitter: [WhatsApp/tree-sitter-erlang](https://github.com/WhatsApp/tree-sitter-erlang)
- 言語サーバー:
  - [erlang-ls/erlang_ls](https://github.com/erlang-ls/erlang_ls)
  - [WhatsApp/erlang-language-platform](https://github.com/WhatsApp/erlang-language-platform)

## 言語サーバーの選択

Erlang extension は `erlang_ls` と `erlang-language-platform` の言語サーバーをサポートします。

デフォルトでは `erlang_ls` が有効になっています。

Settings ({#kb zed::OpenSettings}) の Languages > Erlang で言語サーバーを設定するか、設定ファイルに次を追加します:

```json [settings]
{
  "languages": {
    "Erlang": {
      "language_servers": ["elp", "!erlang-ls", "..."]
    }
  }
}
```

## 関連項目

- [Elixir](./elixir.md)
- [Gleam](./gleam.md)
