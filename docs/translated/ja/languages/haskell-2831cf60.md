# Haskell

Haskell のサポートは、[Haskell extension](https://github.com/zed-extensions/haskell) を通じて利用できます。

- Tree-sitter: [tree-sitter-haskell](https://github.com/tree-sitter/tree-sitter-haskell)
- 言語サーバー: [haskell-language-server](https://github.com/haskell/haskell-language-server)

## HLS のインストール

[haskell-language-server](https://haskell-language-server.readthedocs.io/en/latest/installation.html)（HLS）の推奨インストール方法は、[ghcup](https://www.haskell.org/ghcup/install/)（`curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
`）を使用することです:

```sh
ghcup install hls
which haskell-language-server-wrapper
```

## HLS の設定

haskell-language-server（hls）を設定する必要がある場合は、Zed の settings.json に設定オプションを追加できます:

```json [settings]
{
  "lsp": {
    "hls": {
      "initialization_options": {
        "haskell": {
          "formattingProvider": "fourmolu"
        }
      }
    }
  }
}
```

より多くのオプションについては、公式ドキュメント [configuring haskell-language-server](https://haskell-language-server.readthedocs.io/en/latest/configuration.html) を参照してください。

特定の hls バイナリを使用したい場合、あるいは代わりに [static-ls](https://github.com/josephsumabat/static-ls) をドロップインの代替として使用したい場合は、バイナリのパスと引数を指定できます:

```json [settings]
{
  "lsp": {
    "hls": {
      "binary": {
        "path": "static-ls",
        "arguments": ["--experimentalFeatures"]
      }
    }
  }
}
```
