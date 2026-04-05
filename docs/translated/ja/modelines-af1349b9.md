# モードライン

モードラインは、特定のファイルに対するエディタ設定を構成するために、ファイルの先頭または末尾に記述する特別なコメントです。Zed は Vim と Emacs の両方のモードライン形式をサポートしており、タブ幅、インデントスタイル、ファイルタイプなどの設定をファイル内から直接指定できます。

## 設定

Zed がモードラインを検索する行数は、[`modeline_lines`](./reference/all-settings.md#modeline-lines) 設定で制御できます。

```json [settings]
{
  "modeline_lines": 5
}
```

モードラインの解析を完全に無効にするには、`0` に設定します。

## Emacs

Zed は [Emacs ファイル変数](https://www.gnu.org/software/emacs/manual/html_node/emacs/Specifying-File-Variables.html) に対して、いくつかの互換性サポートを提供しています。

例:

```python
# -*- mode: python; tab-width: 4; indent-tabs-mode: nil; -*-
```

### サポートされている Emacs 変数

| Variable                   | Description                          | Zed Setting                                                                                |
| -------------------------- | ------------------------------------ | ------------------------------------------------------------------------------------------ |
| `mode`                     | メジャーモード / 言語               | Language detection                                                                         |
| `tab-width`                | タブの表示幅                        | [`tab_size`](./reference/all-settings.md#tab-size)                                         |
| `fill-column`              | 行折り返し位置                      | [`preferred_line_length`](./reference/all-settings.md#preferred-line-length)               |
| `indent-tabs-mode`         | スペースには `nil`、タブには `t`    | [`hard_tabs`](./reference/all-settings.md#hard-tabs)                                       |
| `electric-indent-mode`     | 自動インデント                      | [`auto_indent`](./reference/all-settings.md#auto-indent)                                   |
| `require-final-newline`    | ファイル末尾の改行を保証            | [`ensure_final_newline_on_save`](./reference/all-settings.md#ensure-final-newline-on-save) |
| `show-trailing-whitespace` | 行末の空白を表示                    | [`show_whitespaces`](./reference/all-settings.md#show-whitespaces)                         |

## Vim

Zed は [Vim モードライン](https://vimhelp.org/options.txt.html#modeline) に対してもいくつかの互換性サポートを提供しています。

例:

```python
# vim: set ft=python ts=4 sw=4 et:
```

### サポートされている Vim のオプション

| Option         | Aliases | Description                                  | Zed Setting                                                                                |
| -------------- | ------- | -------------------------------------------- | ------------------------------------------------------------------------------------------ |
| `filetype`     | `ft`    | ファイルタイプ / 言語                       | Language detection                                                                         |
| `tabstop`      | `ts`    | タブ 1 つ分として数えられるスペースの数     | [`tab_size`](./reference/all-settings.md#tab-size)                                         |
| `textwidth`    | `tw`    | 最大行幅                                    | [`preferred_line_length`](./reference/all-settings.md#preferred-line-length)               |
| `expandtab`    | `et`    | タブの代わりにスペースを使用                | [`hard_tabs`](./reference/all-settings.md#hard-tabs)                                       |
| `noexpandtab`  | `noet`  | スペースの代わりにタブを使用                | [`hard_tabs`](./reference/all-settings.md#hard-tabs)                                       |
| `autoindent`   | `ai`    | 自動インデントを有効にする                  | [`auto_indent`](./reference/all-settings.md#auto-indent)                                   |
| `noautoindent` | `noai`  | 自動インデントを無効にする                  | [`auto_indent`](./reference/all-settings.md#auto-indent)                                   |
| `endofline`    | `eol`   | ファイル末尾の改行を保証                    | [`ensure_final_newline_on_save`](./reference/all-settings.md#ensure-final-newline-on-save) |
| `noendofline`  | `noeol` | ファイル末尾の改行を無効にする              | [`ensure_final_newline_on_save`](./reference/all-settings.md#ensure-final-newline-on-save) |

## 注意事項

- ファイルの先頭 1 キロバイトがモードラインの検索対象になります。
- Emacs のモードラインと Vim のモードラインが両方存在する場合は、Emacs のモードラインが優先されます。
- ファイル先頭付近の行にあるモードラインは、ファイル末尾にあるモードラインよりも優先されます。
