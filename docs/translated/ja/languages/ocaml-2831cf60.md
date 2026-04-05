# OCaml

OCaml のサポートは、[OCaml extension](https://github.com/zed-extensions/ocaml) を通じて利用できます。

- Tree-sitter: [tree-sitter/tree-sitter-ocaml](https://github.com/tree-sitter/tree-sitter-ocaml)
- 言語サーバー: [ocaml/ocaml-lsp](https://github.com/ocaml/ocaml-lsp)

## セットアップ手順

すでに開発環境がセットアップ済みの場合は、[Launching Zed](#launching-zed) まで飛ばして構いません。

### Opam の使用

Opam は OCaml の公式パッケージマネージャーであり、OCaml を始める際には強く推奨されます。Opam を使い始めるには、[こちら](https://ocaml.org/install) に記載されている手順に従ってください。

指示に従って opam をインストールし、開発環境用のスイッチをセットアップしたら、次のステップに進めます。

### Zed の起動

この時点で `ocamllsp` がインストールされているはずです。次のコマンドを実行して確認してください。

```sh
ocamllsp --help
```

ターミナルで上記を実行し、ヘルプメッセージが表示されれば準備完了です。そうでない場合は `ocamllsp` のインストール手順を見直し、正しくインストールされていることを確認してください。

準備ができたら、Zed を起動できます。OCaml のパッケージマネージャーの動作上、Zed はターミナルから実行する必要があります。まだインストールしていない場合は、[Zed cli](https://zed.dev/features#cli) をインストールしてください。

cli をインストールしたら、ターミナルでプロジェクトのディレクトリに移動し、次のコマンドを実行するだけです。

```sh
zed .
```

これで追加のセットアップなしで、OCaml サポート付きの Zed が起動しているはずです。
