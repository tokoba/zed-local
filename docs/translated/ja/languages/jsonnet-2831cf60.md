# Jsonnet

Zed における Jsonnet 言語サポートは、コミュニティによってメンテナンスされている [Jsonnet extension](https://github.com/narqo/zed-jsonnet) によって提供されています。

- Tree-sitter: [sourcegraph/tree-sitter-jsonnet](https://github.com/sourcegraph/tree-sitter-jsonnet)
- 言語サーバー: [grafana/jsonnet-language-server](https://github.com/grafana/jsonnet-language-server)

## 設定

ワークスペースの設定オプションは、`settings.json` の `lsp` 設定を通じて言語サーバーに渡すことができます。

次の例では、`jsonnet-language-server` が [tanka](https://tanka.dev) のインポートパスを解決するように設定しています。

```json [settings]
{
  "lsp": {
    "jsonnet-language-server": {
      "settings": {
        "resolve_paths_with_tanka": true
      }
    }
  }
}
```
