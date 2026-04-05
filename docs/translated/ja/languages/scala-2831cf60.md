# Scala

Zed における Scala の言語サポートは、コミュニティによってメンテナンスされている [Scala extension](https://github.com/scalameta/metals-zed) によって提供されます。
問題の報告先: <https://github.com/scalameta/metals-zed/issues>

- Tree-sitter: [tree-sitter/tree-sitter-scala](https://github.com/tree-sitter/tree-sitter-scala)
- 言語サーバー: [scalameta/metals](https://github.com/scalameta/metals)

## セットアップ

- `cs setup` (Coursier) を使って Scala をインストールします: <https://www.scala-lang.org/download/>
  - `brew install coursier/formulas/coursier && cs setup`
- REPL (Almond) のセットアップ手順 <https://almond.sh/docs/quick-start-install>
  - `brew install --cask temurin` (Eclipse Foundation 公式の OpenJDK バイナリ)
  - `brew install coursier/formulas/coursier && cs setup`
  - `coursier launch --use-bootstrap almond -- --install`

## 設定

Metals 言語サーバーの動作は、次のファイルで制御できます:

- `.scalafix.conf` ファイル - [Scalafix Configuration](https://scalacenter.github.io/scalafix/docs/users/configuration.html) を参照してください
- `.scalafmt.conf` ファイル - [Scalafmt Configuration](https://scalameta.org/scalafmt/docs/configuration.html) を参照してください

これらのファイルはプロジェクトのルートに配置するか、Metals の設定で場所を指定できます。詳細は [Metals User Configuration](https://scalameta.org/metals/docs/editors/user-configuration) を参照してください。

<!--
TBD: Zed の settings.json における metals の LSP 設定例を提供すること。metals.{javaHome,excludedPackages,customProjectRoot} など。
-->