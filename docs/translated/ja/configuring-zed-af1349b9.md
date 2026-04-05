# Zed の設定

このガイドでは、Zed の設定システムの仕組みについて、設定エディタ、JSON 設定ファイル、プロジェクト固有の設定を含めて説明します。

テーマ、フォント、アイコンなどの見た目のカスタマイズについては、[外観](./appearance.md) を参照してください。

## 設定エディタ

**設定エディタ** ({#kb zed::OpenSettings}) は、Zed を設定するための主な手段です。利用可能な設定を閲覧し、現在の値を確認し、変更を行うことができる検索機能付きのインターフェイスを提供します。

開くには次のいずれかを実行します:

- {#kb zed::OpenSettings} を押します
- または、コマンドパレットから `zed: open settings` を実行します

検索ボックスに入力すると、一致する設定がその説明と変更用のコントロールとともに表示されます。変更内容は自動的に設定ファイルに保存されます。

> **注意:** 設定エディタではまだすべての設定が利用できるわけではありません。言語フォーマッタなど一部の高度なオプションは、JSON ファイルを直接編集する必要があります。

## 設定ファイル

### ユーザー設定

ユーザー設定はすべてのプロジェクトに対してグローバルに適用されます。{#kb zed::OpenSettingsFile} でこのファイルを開くか、コマンドパレットから `zed: open settings file` を実行します。

このファイルの場所は次のとおりです:

- macOS: `~/.config/zed/settings.json`
- Linux: `~/.config/zed/settings.json` (または `$XDG_CONFIG_HOME/zed/settings.json`)
- Windows: `%APPDATA%\Zed\settings.json`

構文は JSON で、`//` コメントをサポートしています。

### デフォルト設定

利用可能なすべての設定とそのデフォルト値を確認するには、コマンドパレットから {#action zed::OpenDefaultSettings} を実行します。これにより、自分の設定を編集する際に参照できる読み取り専用のリファレンスが開きます。

### プロジェクト設定

特定のプロジェクトでユーザー設定を上書きするには、プロジェクトルートに `.zed/settings.json` ファイルを作成します。このファイルを作成するには {#action zed::OpenProjectSettings} を実行します。

プロジェクト設定は、そのプロジェクトに限りユーザー設定より優先されます。

```json [settings]
// .zed/settings.json
{
  "tab_size": 2,
  "formatter": "prettier",
  "format_on_save": "on"
}
```

より細かく制御したい場合は、サブディレクトリに設定ファイルを追加することもできます。

**制限事項:** すべての設定をプロジェクトレベルで指定できるわけではありません。エディタ全体に影響する設定（`theme` や `vim_mode` など）はユーザー設定でのみ機能します。プロジェクト設定で指定できるのは、`tab_size`、`formatter`、`format_on_save` のようなエディタの挙動や言語ツールに関するオプションに限られます。

## 設定のマージ方法

設定は次のレイヤー順に適用されます:

1. **デフォルト設定** — Zed に組み込まれているデフォルト値
2. **ユーザー設定** — あなたのグローバルな好み
3. **プロジェクト設定** — プロジェクトごとの上書き設定

後のレイヤーほど、前のレイヤーの設定を上書きします。`terminal` のようなオブジェクト型の設定では、プロパティは完全に置き換えられるのではなく、マージされます。

## ファイル単位の設定

Zed は Emacs および Vim の [modelines](./modelines.md) にある程度対応しているため、ファイルごとに一部の設定を指定できます。

## リリースチャネルごとのオーバーライド

トップレベルにチャネル用のキーを追加することで、Stable、Preview、Nightly 各ビルドで異なる設定を使用できます:

```json [settings]
{
  "theme": "One Dark",
  "vim_mode": false,
  "nightly": {
    "theme": "Rosé Pine",
    "vim_mode": true
  },
  "preview": {
    "theme": "Catppuccin Mocha"
  }
}
```

この設定では、次のように動作します:

- **Stable** は One Dark を使用し、vim モードはオフになります
- **Preview** は Catppuccin Mocha を使用し、vim モードはオフになります
- **Nightly** は Rosé Pine を使用し、vim モードはオンになります

設定エディタで行った変更は、すべてのチャネルに共通して適用されます。

## 設定へのディープリンク

Zed では、特定の設定を直接開くディープリンクをサポートしています:

```
zed://settings/theme
zed://settings/vim_mode
zed://settings/buffer_font_size
```

これらは、設定のヒントを共有したり、ドキュメントからリンクしたりする場合に便利です。

## 設定例

```json [settings]
{
  "theme": {
    "mode": "system",
    "light": "One Light",
    "dark": "One Dark"
  },
  "buffer_font_family": "JetBrains Mono",
  "buffer_font_size": 14,
  "tab_size": 2,
  "format_on_save": "on",
  "autosave": "on_focus_change",
  "vim_mode": false,
  "terminal": {
    "font_family": "JetBrains Mono",
    "font_size": 14
  },
  "languages": {
    "Python": {
      "tab_size": 4
    }
  }
}
```

## 次のステップ

- [外観](./appearance.md) — テーマ、フォント、見た目のカスタマイズ
- [キーバインド](./key-bindings.md) — キーボードショートカットをカスタマイズする
- [AI 設定](./ai/configuration.md) — AI プロバイダー、モデル、エージェント設定をセットアップする
- [すべての設定](./reference/all-settings.md) — 設定の完全なリファレンス
