# マルチバッファー

Zed が提供する強力な機能の 1 つが、複数のファイルを同時に編集できることです。これを複数カーソルと組み合わせると、大規模なリファクタリングを大幅に高速化できます。

## マルチバッファーでの編集

<div class="video" style="position: relative; padding-top: 71.71314741035857%;">
  <iframe
    src="https://customer-snccc0j9v3kfzkif.cloudflarestream.com/bda0a6584c19f4b39e58a263c0ae4358/iframe?muted=true&preload=true&loop=true&autoplay=true&poster=https%3A%2F%2Fcustomer-snccc0j9v3kfzkif.cloudflarestream.com%2Fbda0a6584c19f4b39e58a263c0ae4358%2Fthumbnails%2Fthumbnail.jpg%3Ftime%3D%26height%3D600&controls=false"
    style="border: none; position: absolute; top: 0; left: 0; height: 100%; width: 100%;"
    allow="accelerometer; gyroscope; autoplay; encrypted-media; picture-in-picture;"
    allowfullscreen="true"
  ></iframe>
</div>

マルチバッファーでの編集は、通常のファイルを編集するのと同じです。行った変更は、エディタ内のそのファイルの他の開いているコピーにも反映されます。すべてのファイルは `editor: Save` コマンドで保存できます（macOS では `cmd-s`、Windows/Linux では `ctrl-s`、Vim モードでは `:w` に対応しています）。

マルチバッファー内では、複数カーソルを使ってすべてのファイルを同時に編集すると便利な場合がよくあります。いくつかのインスタンスだけを編集したい場合は、マウス（macOS では `option-click`、Window/Linux では `alt-click`）やキーボードでそれらを選択できます。macOS の `cmd-d`、Windows/Linux の `ctrl-d`、または Vim モードの `gl` は、カーソル下の単語の次の一致を選択します。

すべての一致箇所を編集したい場合は、`editor: Select All Matches` コマンドを実行して選択できます（macOS では `cmd-shift-l`、Windows/Linux では `ctrl-shift-l`、Vim モードでは `g a`）。

## ソースファイルへの移動

マルチバッファー内でファイルを簡単に編集できますが、ソースファイルに直接移動できると便利なことがよくあります。抜粋同士の区切り線のいずれかをクリックするか、抜粋内にカーソルを置いて `editor: open excerpts` コマンドを実行することで、これを行えます。複数カーソルを使用している場合、このコマンドはマルチバッファー内の各カーソル位置に対応するソースファイルを開くことに注意してください。

また、マウス操作を好み、抜粋をダブルクリックして開きたい場合は、`"double_click_in_multibuffer": "open"` という設定でこの機能を有効にできます。

## プロジェクト検索

検索を開始するには、`pane: Toggle Search` コマンドを実行します（macOS では `cmd-shift-f`、Windows/Linux では `ctrl-shift-f`、Vim モードでは `g/`）。検索が完了すると、結果は新しいマルチバッファーに表示されます。プロジェクト全体の一致する各行ごとに 1 つの抜粋が表示されます。

## 診断

言語サーバーがインストールされている場合、診断ペインでプロジェクト全体のすべてのエラーを表示できます。ステータスバーのアイコンをクリックするか、`diagnostics: Deploy` コマンド（macOS では `cmd-shift-m`、Windows/Linux では `ctrl-shift-m`、Vim モードでは `:clist`）を実行して開くことができます。

## 参照の検索

言語サーバーがインストールされている場合、`editor: Find References` コマンドを使って、カーソル下のシンボルへのすべての参照を検索できます（macOS では `cmd-click`、Windows/Linux では `ctrl-click`、Vim モードでは `g A`。

使用している言語サーバーによっては、`editor: Go To Definition` や `editor: Go To Type Definition` のようなコマンドも、定義が複数存在する場合にはマルチバッファーを開きます。
