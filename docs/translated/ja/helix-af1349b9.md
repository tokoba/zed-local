# Helix Mode

*作業中です。すべての Helix キーバインドがまだ実装されているわけではありません。*

Zed の Helix モードは、Helix 風のキーバインドとモーダル編集を Zed にもたらすエミュレーションレイヤーです。これは Zed の [Vim モード](./vim.md) の上に構築されているため、多くのコア機能を共有しています。`helix_mode` を有効にすると、`vim_mode` も有効になります。

Helix モードでも利用可能な Vim 関連機能のガイドについては、[Vim モードのドキュメント](./vim.md) を参照してください。

Helix モードの現在のステータスを確認したり、未実装の Helix 機能をリクエストしたりするには、["Are we Helix yet?" ディスカッション](https://github.com/zed-industries/zed/discussions/33580) を参照してください。

Helix のデフォルトキーバインドの詳細な一覧については、[公式 Helix ドキュメント](https://docs.helix-editor.com/keymap.html) を参照してください。

## 主要な相違点

`m i` または `m a` で動作する任意のテキストオブジェクトは、`]` および `[` でも同様に動作します。たとえば `] (` は、カーソルの後にある次の丸括弧のペアを選択します。
