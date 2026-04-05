# テーマ

Zed には多数の組み込みテーマが同梱されており、拡張機能として利用できる追加のテーマも用意されています。

## テーマの選択

インストールされているテーマの確認やプレビューは、Theme Selector から行えます。Theme Selector は、コマンドパレットで `theme selector: toggle`（{#kb theme_selector::Toggle} に割り当て）アクションを実行して開きます。

上下に移動してテーマ一覧をナビゲートすると、その場でリアルタイムにテーマが切り替わり、Enter キーを押すと選択したテーマが設定ファイルに保存されます。

## 新しいテーマのインストール

Zed の拡張機能ストアには何百種類ものテーマがあります。コマンドパレットで `zed: extensions` を実行するか、[Zed の Web サイト](https://zed.dev/extensions?filter=themes) からアクセスできます。

多くの人気テーマが Zed にポートされています。どのテーマにするか迷う場合は、[zed-themes.com](https://zed-themes.com) を参照してください。これは、多くのテーマのプレビューを確認できるサードパーティのギャラリーです。

## 自分のテーマを作成する

既存のテーマを基に、自分だけのカスタムテーマをデザインするには、[Zed の Theme Builder](https://zed.dev/theme-builder) を使用できます。

このツールを使うと、Zed アプリ内のあらゆる画面要素の見た目を細かく調整し、プレビューできます。
その後、JSON を [ローカルでの使用](./themes.md#local-themes) や [Zed の拡張機能ストアでの公開](./extensions/themes.md) 用にエクスポートできます。

## テーマの設定

選択したテーマは設定ファイルに保存されます。
設定ファイルは、コマンドパレットから {#action zed::OpenSettingsFile}（{#kb zed::OpenSettingsFile} に割り当て）で開けます。

デフォルトでは、Zed はライトモード用とダークモード用の 2 つのテーマを保持します。
システムの現在のモードを無視したい場合は、`"dark"` または `"light"` に mode を設定できます。

```json [settings]
{
  "theme": {
    "mode": "system",
    "light": "One Light",
    "dark": "One Dark"
  }
}
```

### キーボードからテーマモードを切り替える

{#kb theme::ToggleMode} を使うと、現在のテーマモードをライトとダークの間で切り替えられます。

現在の設定で次のように静的な theme 値を使用している場合:

```json [settings]
{
  "theme": "Any Theme"
}
```

最初に切り替えを行うと、デフォルトのテーマを用いた動的なテーマ選択に変換されます:

```json [settings]
{
  "theme": {
    "mode": "system",
    "light": "One Light",
    "dark": "One Dark"
  }
}
```

最初の切り替えの後は、`light` と `dark` の両方のテーマを手動で設定する必要があります。

それ以降、トグル操作で更新されるのは `theme.mode` のみです。
`light` と `dark` が同じテーマになっている場合、`light` と `dark` に異なる値を設定するまで、最初の切り替えでは UI に見える変化が起こらないことがあります。

## テーマのオーバーライド

テーマの特定の属性を上書きするには、`theme_overrides` 設定を使用します。
この設定を使って、テーマ固有のオーバーライドを構成できます。

たとえば、エディタの背景色を上書きし、コメントおよびドキュメントコメントをイタリック表示にしたい場合は、次の内容を `settings.json` に追加します:

```json [settings]
{
  "theme_overrides": {
    "One Dark": {
      "editor.background": "#333",
      "syntax": {
        "comment": {
          "font_style": "italic"
        },
        "comment.doc": {
          "font_style": "italic"
        }
      },
      "accents": [
        "#ff0000",
        "#ff7f00",
        "#ffff00",
        "#00ff00",
        "#0000ff",
        "#8b00ff"
      ]
    }
  }
}
```

`comment` や `comment.doc` のような capture の包括的な一覧については、[Language Extensions: Syntax highlighting](./extensions/languages.md#syntax-highlighting) を参照してください。

利用可能なテーマ属性の一覧を確認するには、使用しているテーマの JSON ファイルを参照してください。
たとえば、デフォルトの One Dark と One Light テーマの場合は [assets/themes/one/one.json](https://github.com/zed-industries/zed/blob/main/assets/themes/one/one.json) です。

## ローカルテーマ {#local-themes}

新しいテーマをローカルに保存するには、`~/.config/zed/themes` ディレクトリ（macOS および Linux）または `%USERPROFILE%\AppData\Roaming\Zed\themes\`（Windows）に配置します。

たとえば、`my-cool-theme` という新しいテーマを作成する場合は、そのディレクトリに `my-cool-theme.json` というファイルを作成します。
次回 Zed を起動すると、そのテーマはテーマセレクターから選択できるようになります。
