# アイコンテーマ

拡張機能では、Zed がフォルダーやファイルに使用するアイコンを変更するアイコンテーマを提供できます。

## 拡張機能の例

[Material Icon Theme](https://github.com/zed-extensions/material-icon-theme) は、アイコンテーマを含む拡張機能の構造の例となります。

## ディレクトリ構造

アイコンテーマ拡張機能には、次の 2 つの重要なディレクトリがあります:

- `icon_themes`: アイコンテーマ定義を含む 1 つ以上の JSON ファイルを格納するディレクトリです。
- `icons`: 拡張機能と一緒に配布されるアイコンアセットを格納するディレクトリです。必要に応じて、このディレクトリ内にサブディレクトリを作成できます。

各アイコンテーマファイルは、[`https://zed.dev/schema/icon_themes/v0.3.0.json`](https://zed.dev/schema/icon_themes/v0.3.0.json) で指定されている JSON スキーマに従う必要があります。

以下はアイコンテーマ構造の例です:

```json [icon-theme]
{
  "$schema": "https://zed.dev/schema/icon_themes/v0.3.0.json",
  "name": "My Icon Theme",
  "author": "Your Name",
  "themes": [
    {
      "name": "My Icon Theme",
      "appearance": "dark",
      "directory_icons": {
        "collapsed": "./icons/folder.svg",
        "expanded": "./icons/folder-open.svg"
      },
      "named_directory_icons": {
        "stylesheets": {
          "collapsed": "./icons/folder-stylesheets.svg",
          "expanded": "./icons/folder-stylesheets-open.svg"
        }
      },
      "chevron_icons": {
        "collapsed": "./icons/chevron-right.svg",
        "expanded": "./icons/chevron-down.svg"
      },
      "file_stems": {
        "Makefile": "make"
      },
      "file_suffixes": {
        "mp3": "audio",
        "rs": "rust"
      },
      "file_icons": {
        "audio": { "path": "./icons/audio.svg" },
        "default": { "path": "./icons/file.svg" },
        "make": { "path": "./icons/make.svg" },
        "rust": { "path": "./icons/rust.svg" }
        // ...
      }
    }
  ]
}
```

各アイコンパスは、拡張機能ディレクトリのルートからの相対パスとして解決されます。

この例では、拡張機能は次のような構造になります:

```
extension.toml
icon_themes/
  my-icon-theme.json
icons/
  audio.svg
  chevron-down.svg
  chevron-right.svg
  file.svg
  folder-open.svg
  folder.svg
  rust.svg
```
