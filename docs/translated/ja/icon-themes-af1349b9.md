# アイコンテーマ

Zed にはビルトインのアイコンテーマが同梱されており、さらに拡張機能として利用できるアイコンテーマもあります。

## アイコンテーマの選択

インストール済みのアイコンテーマを確認し、Icon Theme Selector を使ってプレビューできます。Icon Theme Selector はコマンドパレットから `icon theme selector: toggle` で開けます。

アイコンテーマ一覧を上下に移動してナビゲートすると、リアルタイムにアイコンテーマが切り替わり、Enter キーを押すとそのテーマが設定ファイルに保存されます。

## アイコンテーマの追加インストール

その他のアイコンテーマは Extensions ページから利用できます。Extensions ページには、コマンドパレットから `zed: extensions` を実行するか、[Zed website](https://zed.dev/extensions?filter=icon-themes) からアクセスできます。

## アイコンテーマの設定

選択したアイコンテーマは設定ファイルに保存されます。
設定ファイルは、コマンドパレットから {#action zed::OpenSettingsFile}（{#kb zed::OpenSettingsFile} に割り当て）で開くことができます。

テーマと同様に、Zed ではライトモードとダークモードで異なるアイコンテーマを設定できます。
現在のシステムモードを無視するには、モードを `"light"` または `"dark"` に設定します。

```json [settings]
{
  "icon_theme": {
    "mode": "system",
    "light": "Light Icon Theme",
    "dark": "Dark Icon Theme"
  }
}
```

## アイコンテーマの開発

参照: [Zed アイコンテーマの開発](./extensions/icon-themes.md)
