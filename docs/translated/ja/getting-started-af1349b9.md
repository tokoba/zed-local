# はじめに

Zed は、コラボレーション機能と AI ツールを内蔵したオープンソースのコードエディタです。

このガイドでは、基本的なコマンド、環境設定、ナビゲーションの基礎について説明します。

## クイックスタート

### ウェルカムページ

フォルダを開かずに Zed を起動すると、メインエディタ領域にウェルカムページが表示されます。ウェルカムページでは、フォルダを開く、リポジトリをクローンする、ドキュメントを表示するといったクイックアクションが提供されます。フォルダまたはファイルを開くと、ウェルカムページは閉じられます。エディタを複数ペインに分割している場合、中央のペインが空のときにのみウェルカムページが表示され、その他のペインには通常の空の状態が表示されます。

ウェルカムページを再度表示するには、中央のペイン内の項目をすべて閉じるか、コマンドパレットで「Welcome」を検索します。

### 1. プロジェクトを開く

コマンドラインからフォルダを開きます:

```sh
zed ~/projects/my-app
```

または、Zed 内からフォルダを開くには、`Cmd+O` (macOS) / `Ctrl+O` (Linux/Windows) を使用します。

### 2. 主要なコマンドを覚える

| 操作             | macOS         | Linux/Windows  |
| ---------------- | ------------- | -------------- |
| コマンドパレット | `Cmd+Shift+P` | `Ctrl+Shift+P` |
| ファイルへ移動   | `Cmd+P`       | `Ctrl+P`       |
| シンボルへ移動   | `Cmd+Shift+O` | `Ctrl+Shift+O` |
| プロジェクト内を検索 | `Cmd+Shift+F` | `Ctrl+Shift+F` |
| ターミナルの表示切り替え | `` Ctrl+` ``  | `` Ctrl+` ``   |
| 設定を開く       | `Cmd+,`       | `Ctrl+,`       |

コマンドパレット（`Cmd+Shift+P`）は、Zed のあらゆる操作への入口です。ショートカットを忘れてしまった場合は、そこで検索してください。

### 3. エディタを設定する

設定エディタは、`Cmd+,` (macOS) または `Ctrl+,` (Linux/Windows) で開けます。任意の設定を検索して、その場で変更できます。

最初によく行われる変更:

- **テーマ**: `Cmd+K Cmd+T` (macOS) または `Ctrl+K Ctrl+T` (Linux/Windows) でテーマセレクタを開きます
- **フォント**: 設定で `buffer_font_family` を検索します
- **保存時にフォーマット**: `format_on_save` を検索し、値を `on` に設定します

### 4. 使用言語を設定する

Zed には多くの言語のサポートが組み込まれています。それ以外の言語については、拡張機能をインストールします:

1. `Cmd+Shift+X` (macOS) または `Ctrl+Shift+X` (Linux/Windows) で Extensions を開きます
2. 使用したい言語を検索します
3. Install をクリックします

言語ごとのセットアップ手順については、[言語](./languages.md) を参照してください。

### 5. AI 機能を試す

Zed には AI アシスタンス機能が組み込まれています。会話を開始するには、`Cmd+Shift+A` (macOS) または `Ctrl+Shift+A` (Linux/Windows) で Agent Panel を開くか、インラインでアシストを受けるには、`Cmd+Enter` (macOS) / `Ctrl+Enter` (Linux/Windows) を使用します。

プロバイダの設定方法や利用できる機能については、[AI Overview](./ai/overview.md) を参照してください。

## 別のエディタから移行する場合

他のエディタから移行するための専用ガイドを用意しています:

- [VS Code](./migrate/vs-code.md) — 設定のインポート、キーバインドのマッピング、同等機能の確認
- [IntelliJ IDEA](./migrate/intellij.md) — ナビゲーションとリファクタリングにおける Zed のアプローチに慣れる
- [PyCharm](./migrate/pycharm.md) — Zed での Python 開発をセットアップする
- [WebStorm](./migrate/webstorm.md) — JavaScript/TypeScript のワークフローを構成する
- [RustRover](./migrate/rustrover.md) — Zed での Rust 開発

おなじみのキーバインドを有効にすることもできます:

- **Vim**: 設定で `vim_mode` を有効にします。詳しくは [Vim Mode](./vim.md) を参照してください。
- **Helix**: 設定で `helix_mode` を有効にします。詳しくは [Helix Mode](./helix.md) を参照してください。

## コミュニティに参加する

Zed はオープンソースです。GitHub や Discord で私たちのコミュニティに参加し、コードのコントリビュート、バグ報告、機能提案などを行ってください。

- [Discord](https://discord.com/invite/zedindustries)
- [GitHub Discussions](https://github.com/zed-industries/zed/discussions)
- [Zed Reddit](https://www.reddit.com/r/ZedEditor)
