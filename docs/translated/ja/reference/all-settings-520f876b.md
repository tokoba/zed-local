# すべての設定

これは、すべての Zed 設定に関する完全なリファレンスです。

あわせて、[テーマ](../themes.md)を変更したり、[キーバインド](../key-bindings.md)を設定したり、[タスク](../tasks.md)をセットアップしたり、[拡張機能](../extensions.md)をインストールしたりすることもできます。

# 設定

以下のセクションでは、サポートされている Zed の設定について説明します。

## Active Pane Modifiers

- 説明: アクティブなペインに適用されるスタイル設定です。
- 設定: `active_pane_modifiers`
- デフォルト:

```json [settings]
{
  "active_pane_modifiers": {
    "border_size": 0.0,
    "inactive_opacity": 1.0
  }
}
```

### Border size

- 説明: アクティブなペインを囲むボーダーのサイズです。0 に設定すると、アクティブペインにはボーダーが表示されません。ボーダーは内側に描画されます。
- 設定: `border_size`
- デフォルト: `0.0`

**オプション**

0 以上の `float` 値

### Inactive Opacity

- 説明: 非アクティブなペインの不透明度です。1.0 に設定すると、非アクティブペインはアクティブペインと同じ不透明度になります。0 に設定すると、非アクティブペインの内容は表示されません。値は [0.0, 1.0] の範囲に制限されます。
- 設定: `inactive_opacity`
- デフォルト: `1.0`

**オプション**

`float` 値

## Bottom Dock Layout

- 説明: 左右のドックに対するボトムドックのレイアウトを制御します。
- 設定: `bottom_dock_layout`
- デフォルト: `"contained"`

**オプション**

1. ボトムドックをコンテインし、ウィンドウの全高を左右のドックに割り当てます。

```json [settings]
{
  "bottom_dock_layout": "contained"
}
```

2. ボトムドックにウィンドウの全幅を割り当て、左右のドックを切り詰めます。

```json [settings]
{
  "bottom_dock_layout": "full"
}
```

3. ボトムドックを左寄せにし、左ドックを切り詰めて右ドックにウィンドウの全高を割り当てます。

```json [settings]
{
  "bottom_dock_layout": "left_aligned"
}
```

4. ボトムドックを右寄せにし、左ドックにウィンドウの全高を割り当てて右ドックを切り詰めます。

```json [settings]
{
  "bottom_dock_layout": "right_aligned"
}
```

## Agent Font Size

- 説明: エージェントパネル内のテキストのフォントサイズです。未設定の場合は UI のフォントサイズを継承します。
- 設定: `agent_font_size`
- デフォルト: `null`

**オプション**

`6` から `100` ピクセルまで（両端を含む）の `integer` 値

## Allow Rewrap

- 説明: 現在の言語スコープ内で {#action editor::Rewrap} アクションを許可する範囲を制御します
- 設定: `allow_rewrap`
- デフォルト: `"in_comments"`

**オプション**

1. コメント内でのみ rewrap を許可します:

```json [settings]
{
  "allow_rewrap": "in_comments"
}
```

2. 選択範囲内でのみ rewrap を許可します:

```json [settings]
{
  "allow_rewrap": "in_selections"
}
```

3. 任意の場所で rewrap を許可します:

```json [settings]
{
  "allow_rewrap": "anywhere"
}
```

注: rewrap はすでにどこでも許可されているため、この設定は Vim モードでは効果がありません。

## Auto Indent

- 説明: 入力中にコンテキストに基づいてインデントを調整するかどうかを指定します。これは言語ごとに設定できます。
- 設定: `auto_indent`
- デフォルト: `true`

**オプション**

`boolean` 値

## Auto Indent On Paste

- 説明: 貼り付けた内容のインデントをコンテキストに基づいて調整するかどうかを指定します
- 設定: `auto_indent_on_paste`
- デフォルト: `true`

**オプション**

`boolean` 値

## Auto Install extensions

- 説明: 自動的にインストールする拡張機能、または決してインストールしない拡張機能を定義します。
- 設定: `auto_install_extensions`
- デフォルト: `{ "html": true }`

**オプション**

現在インストールされている拡張機能の名前は、[拡張機能のインストール場所](../extensions/installing-extensions.md#installation-location) 配下のサブフォルダを一覧表示することで確認できます。

macOS の場合:

```sh
ls ~/Library/Application\ Support/Zed/extensions/installed/
```

Linux の場合:

```sh
ls ~/.local/share/zed/extensions/installed
```

インストールすべき拡張機能（`true`）と、決してインストールしない拡張機能（`false`）を定義します。

```json [settings]
{
  "auto_install_extensions": {
    "html": true,
    "dockerfile": true,
    "docker-compose": false
  }
}
```

## Autosave

- 説明: 編集済みバッファを自動保存するタイミングです。
- 設定: `autosave`
- デフォルト: `off`

**オプション**

1. 自動保存を無効にするには、`off` を設定します:

```json [settings]
{
  "autosave": "off"
}
```

2. フォーカスが変化したときに自動保存するには、`on_focus_change` を使用します:

```json [settings]
{
  "autosave": "on_focus_change"
}
```

3. アクティブウィンドウが変化したときに自動保存するには、`on_window_change` を使用します:

```json [settings]
{
  "autosave": "on_window_change"
}
```

4. 一定時間操作が行われなかった後に自動保存するには、`after_delay` を使用します:

```json [settings]
{
  "autosave": {
    "after_delay": {
      "milliseconds": 1000
    }
  }
}
```

設定した非アクティブ期間より前であっても、未保存のタブを閉じたときには保存が実行されることに注意してください。

## Autoscroll on Clicks

- 説明: 表示されているテキスト領域の端付近をクリックしたときにスクロールするかどうかを指定します。
- 設定: `autoscroll_on_clicks`
- デフォルト: `false`

**オプション**

`boolean` 値

## Auto Signature Help

- 説明: 括弧内にいるときに、エディタ内にメソッドシグネチャを表示します。
- 設定: `auto_signature_help`
- デフォルト: `false`

**オプション**

`boolean` 値

### Show Signature Help After Edits

- 説明: 補完の後や括弧のペアを挿入した後にシグネチャヘルプを表示するかどうかを指定します。`auto_signature_help` が有効な場合、この設定も有効として扱われます。
- 設定: `show_signature_help_after_edits`
- デフォルト: `false`

**オプション**

`boolean` 値

## Auto Update

- 説明: アップデートを自動的にチェックするかどうかを指定します。
- 設定: `auto_update`
- デフォルト: `true`

**オプション**

`boolean` 値

## Base Keymap

- 説明: ベースとなるキーバインドのスキームです。ベースキーマップはユーザーキーマップで上書きできます。
- 設定: `base_keymap`
- デフォルト: `VSCode`

**オプション**

1. VS Code

```json [settings]
{
  "base_keymap": "VSCode"
}
```

2. Atom

```json [settings]
{
  "base_keymap": "Atom"
}
```

3. JetBrains

```json [settings]
{
  "base_keymap": "JetBrains"
}
```

4. None

```json [settings]
{
  "base_keymap": "None"
}
```

5. Sublime Text

```json [settings]
{
  "base_keymap": "SublimeText"
}
```

6. TextMate

```json [settings]
{
  "base_keymap": "TextMate"
}
```

## Buffer Font Family

- 説明: エディタ内のテキスト描画に使用するフォント名です。
- 設定: `buffer_font_family`
- デフォルト: `.ZedMono`。現在は [Lilex](https://lilex.myrt.co) へのエイリアスになっています。

**オプション**

ユーザーのシステムにインストールされている任意のフォントファミリー名、または `".ZedMono"` のいずれかです。

## Buffer Font Features

- 説明: エディタ内のテキストに対して有効にする OpenType 機能です。
- 設定: `buffer_font_features`
- デフォルト: `null`
- プラットフォーム: macOS および Windows。

**オプション**

Zed では、特定のバッファまたはターミナルフォントに対して有効化・無効化できるすべての OpenType 機能と、その機能に対する値の設定をサポートしています。

たとえば、フォントの合字を無効にするには、設定に次の項目を追加します:

```json [settings]
{
  "buffer_font_features": {
    "calt": false
  }
}
```

`cv01` を `7` に設定するなど、他の OpenType 機能も設定できます:

```json [settings]
{
  "buffer_font_features": {
    "cv01": 7
  }
}
```

## Buffer Font Fallbacks

- 説明: バッファ内テキスト用のフォントフォールバックを設定します。これはプラットフォームのデフォルトのフォールバックとマージされます。
- 設定: `buffer_font_fallbacks`
- デフォルト: `null`
- プラットフォーム: macOS および Windows

**Options**

例えば、`Nerd Font` をフォールバックとして使用するには、設定に次のように追加します:

```json [settings]
{
  "buffer_font_fallbacks": ["Nerd Font"]
}
```

## バッファフォントサイズ

- 説明: エディタ内テキストのデフォルトのフォントサイズ。
- 設定: `buffer_font_size`
- デフォルト: `15`

**Options**

`6` から `100` ピクセルまでのフォントサイズ（両端を含む）

## バッファフォントウェイト

- 説明: エディタ内テキストのデフォルトのフォントウェイト。
- 設定: `buffer_font_weight`
- デフォルト: `400`

**Options**

`100` から `900` までの `integer` 値

## バッファ行の高さ

- 説明: エディタ内テキストのデフォルトの行の高さ。
- 設定: `buffer_line_height`
- デフォルト: `"comfortable"`

**Options**

`"standard"`、`"comfortable"` または `{ "custom": float }`（`1` はコンパクト、`2` はルーズ）

## 中央レイアウト

- 説明: 中央レイアウトモードの設定。
- 設定: `centered_layout`
- デフォルト:

```json [settings]
{
  "centered_layout": {
    "left_padding": 0.2,
    "right_padding": 0.2
  }
}
```

**Options**

`left_padding` と `right_padding` オプションは、中央レイアウトモードが有効なときに、ワークスペースに対する中央ペインの左右のパディングの相対的な幅を定義します。有効な値の範囲は `0` から `0.4` です。

## ファイル削除時に閉じる

- 説明: 対応するファイルがディスクから削除されたときに、エディタのタブを自動的に閉じるかどうか。
- 設定: `close_on_file_delete`
- デフォルト: `false`

**Options**

`boolean` 値

有効にすると、この設定はファイルシステムから削除されたファイルのタブを自動的に閉じます。これは、一時ファイルやスクラッチファイルのように、頻繁に作成および削除されるファイルを扱うワークフローに特に便利です。無効（デフォルト）の場合、削除されたファイルはタブタイトルに取り消し線が付いた状態で開いたままになります。

注意: ダーティファイル（未保存の変更があるファイル）は、この設定が有効でも自動的には閉じられず、未保存の作業が失われないようになっています。

## 終了確認

- 説明: アプリケーションを閉じる前に確認を求めるかどうか。
- 設定: `confirm_quit`
- デフォルト: `false`

**Options**

`boolean` 値

## Diagnostics Max Severity

- 説明: エディタに表示される診断をフィルタリングする際に使用するレベル。
- 設定: `diagnostics_max_severity`
- デフォルト: `null`

**Options**

1. すべての診断を許可（デフォルト）:

```json [settings]
{
  "diagnostics_max_severity": "all"
}
```

2. エラーのみを表示:

```json [settings]
{
  "diagnostics_max_severity": "error"
}
```

3. エラーと警告を表示:

```json [settings]
{
  "diagnostics_max_severity": "warning"
}
```

4. エラー、警告、および情報を表示:

```json [settings]
{
  "diagnostics_max_severity": "info"
}
```

5. ヒントを含むすべてを表示:

```json [settings]
{
  "diagnostics_max_severity": "hint"
}
```

## Diff ビュースタイル

- 説明: エディタで diff をどのように表示するか。
- 設定: `diff_view_style`
- デフォルト: `"split"`

**Options**

- `"unified"`: 追加行と削除行を縦に積み重ねてインラインで変更を表示
- `"split"`: 旧バージョンと新バージョンを別々のペインで左右に並べて表示（デフォルト）

詳しくは [Git ドキュメント](../git.md#diff-view-styles) を参照してください。

## Disable AI

- 説明: Zed のすべての AI 機能を無効にするかどうか。
- 設定: `disable_ai`
- デフォルト: `false`

**Options**

`boolean` 値

## Direnv Integration

- 説明: [direnv](https://direnv.net/) 統合の設定。`direnv` がインストールされている必要があります。
  `direnv` 統合により、`direnv` の設定で定義された環境変数を使用して、言語サーバーの一部をインストールする代わりに `$PATH` から検出できるようになります。
  また、これらの環境変数をタスク内で使用できるようにします。
- 設定: `load_direnv`
- デフォルト: `"direct"`

**Options**

選択できるオプションは 3 つあります:

1. `shell_hook`: シェルフックを使用して direnv を読み込みます。これは、ディレクトリに入ったときに direnv が有効になることに依存します。POSIX シェルと fish をサポートします。
2. `direct`: `direnv export json` を使用して direnv を読み込みます。これはシェルフックに依存せずに direnv を直接読み込むため、一部の不整合を引き起こす可能性があります。このオプションにより、direnv を任意のシェルで動作させることができます。
3. `disabled`: シェル環境は自動的には読み込まれません。direnv を使用するには、（`direnv exec` のように）手動で起動する必要があります。

## Double Click In Multibuffer

- 説明: multibuffer の一部の抜粋（単一バッファの一部）上でダブルクリックされたときにどう動作するか。
- 設定: `double_click_in_multibuffer`
- デフォルト: `"select"`

**Options**

1. 通常のバッファと同様に動作し、単語全体を選択する（デフォルト）:

```json [settings]
{
  "double_click_in_multibuffer": "select"
}
```

2. クリックした抜粋を新しいタブで新しいバッファとして開く:

```json [settings]
{
  "double_click_in_multibuffer": "open"
}
```

「open」の場合でも、ダブルクリック時に `alt` を押し続けることで通常の選択動作を行えます。

## ドロップターゲットサイズ

- 説明: エディタ内のドロップターゲットの相対的なサイズ（0〜0.5）。このドロップターゲットにファイルをドロップすると分割ペインとして開かれます。例えば 0.25 の場合、ペインの上部/下部 1/4 にドロップすると新しい垂直分割が使用され、左側/右側 1/4 にドロップすると新しい水平分割が使用されます。
- 設定: `drop_target_size`
- デフォルト: `0.2`

**Options**

`0` から `0.5` までの `float` 値

## Edit Predictions

- 説明: 編集予測の設定。
- 設定: `edit_predictions`
- デフォルト:

```json [settings]
  "edit_predictions": {
    "disabled_globs": [
      "**/.env*",
      "**/*.pem",
      "**/*.key",
      "**/*.cert",
      "**/*.crt",
      "**/.dev.vars",
      "**/secrets.yml"
    ]
  }
```

**Options**

### Disabled Globs

- 説明: 編集予測を無効にすべきグロブのリスト。このリストは、あらかじめ存在する妥当なデフォルトのグロブセットに追加されます。追加したものはそれらと結合されます。
- 設定: `disabled_globs`
- デフォルト: `["**/.env*", "**/*.pem", "**/*.key", "**/*.cert", "**/*.crt", "**/.dev.vars", "**/secrets.yml"]`

**Options**

`string` 値のリスト。

## Edit Predictions Disabled in

- 説明: 編集予測を無効にする言語スコープのリスト。
- 設定: `edit_predictions_disabled_in`
- デフォルト: `[]`

**Options**

`string` 値のリスト

1. コメント内では編集予測を表示しない:

```json [settings]
{
  "edit_predictions_disabled_in": ["comment"]
}
```

2. 文字列とコメント内では編集予測を表示しない:

```json [settings]
{
  "edit_predictions_disabled_in": ["comment", "string"]
}
```

3. Go のみについて、文字列とコメント内では編集予測を表示しない:

```json [settings]
{
  "languages": {
    "Go": {
      "edit_predictions_disabled_in": ["comment", "string"]
    }
  }
}
```

## 現在行のハイライト

- 説明: エディタで現在行をどのようにハイライトするか。
- 設定: `current_line_highlight`
- デフォルト: `all`

**Options**

1. 現在行をハイライトしない:

```json [settings]
{
  "current_line_highlight": "none"
}
```

2. ガター領域をハイライトする:

```json [settings]
{
  "current_line_highlight": "gutter"
}
```

3. エディター領域をハイライトする:

```json [settings]
{
  "current_line_highlight": "line"
}
```

4. 行全体をハイライトする:

```json [settings]
{
  "current_line_highlight": "all"
}
```

## 選択範囲のハイライト

- Description: エディター内で選択されたテキストのすべての出現箇所をハイライトするかどうか。
- Setting: `selection_highlight`
- Default: `true`

## 角丸の選択範囲

- Description: テキスト選択範囲の角を丸くするかどうか。
- Setting: `rounded_selection`
- Default: `true`

## カーソル点滅

- Description: カーソルを点滅させるかどうか。
- Setting: `cursor_blink`
- Default: `true`

**Options**

`boolean` 値

## カーソル形状

- Description: デフォルトエディターのカーソル形状。
- Setting: `cursor_shape`
- Default: `bar`

**Options**

1. 縦棒:

```json [settings]
{
  "cursor_shape": "bar"
}
```

2. 次の文字を囲むブロック:

```json [settings]
{
  "cursor_shape": "block"
}
```

3. 次の文字に沿って表示される下線（アンダースコア）:

```json [settings]
{
  "cursor_shape": "underline"
}
```

4. 次の文字の周囲に描かれるボックス:

```json [settings]
{
  "cursor_shape": "hollow"
}
```

## ガター

- Description: エディターのガターに関する設定。
- Setting: `gutter`
- Default:

```json [settings]
{
  "gutter": {
    "line_numbers": true,
    "runnables": true,
    "breakpoints": true,
    "folds": true,
    "min_line_number_digits": 4
  }
}
```

**Options**

- `line_numbers`: ガターに行番号を表示するかどうか
- `runnables`: ガターに実行ボタンを表示するかどうか
- `breakpoints`: ガターにブレークポイントを表示するかどうか
- `folds`: ガターに折りたたみボタンを表示するかどうか
- `min_line_number_digits`: ガターに確保する行番号の最小桁数

## マウスの非表示

- Description: エディターや入力ボックスでマウスカーソルをいつ非表示にするかを決定します。
- Setting: `hide_mouse`
- Default: `on_typing_and_movement`

**Options**

1. マウスカーソルを非表示にしない:

```json [settings]
{
  "hide_mouse": "never"
}
```

2. 入力中のみ非表示にする:

```json [settings]
{
  "hide_mouse": "on_typing"
}
```

3. 入力中およびカーソル移動時に非表示にする:

```json [settings]
{
  "hide_mouse": "on_typing_and_movement"
}
```

## スニペットの並び順

- Description: 他の補完候補と比較して、スニペットをどのように並べ替えるかを決定します。
- Setting: `snippet_sort_order`
- Default: `inline`

**Options**

1. スニペットを補完リストの先頭に配置する:

```json [settings]
{
  "snippet_sort_order": "top"
}
```

2. 優先順位を付けず、通常どおりスニペットを配置する:

```json [settings]
{
  "snippet_sort_order": "inline"
}
```

3. スニペットを補完リストの末尾に配置する:

```json [settings]
{
  "snippet_sort_order": "bottom"
}
```

4. 補完リストにスニペットを一切表示しない:

```json [settings]
{
  "snippet_sort_order": "none"
}
```

## エディタースクロールバー

- Description: エディターのスクロールバーおよびその中の各種要素を表示するかどうか。
- Setting: `scrollbar`
- Default:

```json [settings]
{
  "scrollbar": {
    "show": "auto",
    "cursors": true,
    "git_diff": true,
    "search_results": true,
    "selected_text": true,
    "selected_symbol": true,
    "diagnostics": "all",
    "axes": {
      "horizontal": true,
      "vertical": true
    }
  }
}
```

### 表示モード

- Description: エディターのスクロールバーをいつ表示するか。
- Setting: `show`
- Default: `auto`

**Options**

1. 重要な情報がある場合にスクロールバーを表示するか、システムで設定された動作に従う:

```json [settings]
{
  "scrollbar": {
    "show": "auto"
  }
}
```

2. システムで設定された動作に合わせる:

```json [settings]
{
  "scrollbar": {
    "show": "system"
  }
}
```

3. 常にスクロールバーを表示する:

```json [settings]
{
  "scrollbar": {
    "show": "always"
  }
}
```

4. スクロールバーを表示しない:

```json [settings]
{
  "scrollbar": {
    "show": "never"
  }
}
```

### カーソルインジケーター

- Description: スクロールバー上にカーソル位置を表示するかどうか。
- Setting: `cursors`
- Default: `true`

カーソルインジケーターは、スクロールバー上の小さなマークとして表示され、他の共同編集者のカーソルがファイル内のどこにあるかを示します。

**Options**

`boolean` 値

### Git Diff インジケーター

- Description: スクロールバーに git diff インジケーターを表示するかどうか。
- Setting: `git_diff`
- Default: `true`

git diff インジケーターは、git の HEAD と比較して追加・変更・削除された行を示す、色付きのマークとして表示されます。

**Options**

`boolean` 値

### 検索結果インジケーター

- Description: スクロールバーにバッファー内の検索結果を表示するかどうか。
- Setting: `search_results`
- Default: `true`

検索結果インジケーターは、現在の検索クエリが一致するファイル内のすべての位置を示すマークとして表示されます。

**Options**

`boolean` 値

### 選択テキストインジケーター

- Description: スクロールバーに選択テキストの出現箇所を表示するかどうか。
- Setting: `selected_text`
- Default: `true`

選択テキストインジケーターは、現在選択されているテキストがファイル全体のどこに出現しているかを示すマークとして表示されます。

**Options**

`boolean` 値

### 選択シンボルインジケーター

- Description: スクロールバーに選択したシンボルの出現箇所を表示するかどうか。
- Setting: `selected_symbol`
- Default: `true`

選択シンボルインジケーターは、現在選択されているシンボル（関数名や変数名など）がファイル全体のどこに出現しているかを示すマークとして表示されます。

**Options**

`boolean` 値

### 診断

- Description: スクロールバーにどの診断インジケーターを表示するか。
- Setting: `diagnostics`
- Default: `all`

診断インジケーターは、エラー、警告、その他の Language Server の診断結果を、ファイル内の該当する行位置に対応した色付きのマークとして表示します。

**Options**

1. すべての診断を表示する:

```json [settings]
{
  "scrollbar": {
    "diagnostics": "all"
  }
}
```

2. 診断を一切表示しない:

```json [settings]
{
  "scrollbar": {
    "diagnostics": "none"
  }
}
```

3. エラーのみ表示する:

```json [settings]
{
  "scrollbar": {
    "diagnostics": "error"
  }
}
```

4. エラーと警告のみ表示する:

```json [settings]
{
  "scrollbar": {
    "diagnostics": "warning"
  }
}
```

5. エラー、警告、および情報のみ表示する:

```json [settings]
{
  "scrollbar": {
    "diagnostics": "information"
  }
}
```

### 軸

- Description: 各軸ごとにスクロールバーを強制的に有効化または無効化します。
- Setting: `axes`
- Default:

```json [settings]
{
  "scrollbar": {
    "axes": {
      "horizontal": true,
      "vertical": true
    }
  }
}
```

#### 水平

- Description: `false` の場合、水平方向のスクロールバーを強制的に無効化します。それ以外の場合は、他の設定に従います。
- Setting: `horizontal`
- Default: `true`

**Options**

`boolean` 値

#### 垂直

- Description: `false` の場合、垂直方向のスクロールバーを強制的に無効化します。それ以外の場合は、他の設定に従います。
- Setting: `vertical`
- Default: `true`

**Options**

`boolean` 値

## ミニマップ

- 説明: ドキュメント全体の概要を表示するエディターのミニマップに関する設定です。
- 設定: `minimap`
- デフォルト:

```json [settings]
{
  "minimap": {
    "show": "never",
    "thumb": "always",
    "thumb_border": "left_open",
    "current_line_highlight": null
  }
}
```

### 表示モード

- 説明: エディターでミニマップを表示するタイミングを指定します。
- 設定: `show`
- デフォルト: `never`

**オプション**

1. 常にミニマップを表示します:

```json [settings]
{
  "minimap": {
    "show": "always"
  }
}
```

2. エディターのスクロールバーが表示されているときにミニマップを表示します:

```json [settings]
{
  "minimap": {
    "show": "auto"
  }
}
```

3. ミニマップを表示しません:

```json [settings]
{
  "minimap": {
    "show": "never"
  }
}
```

### サムの表示

- 説明: ミニマップ内にサム（表示中のエディター領域）をいつ表示するかを指定します。
- 設定: `thumb`
- デフォルト: `always`

**オプション**

1. ミニマップにホバーしたときにサムを表示します:

```json [settings]
{
  "minimap": {
    "thumb": "hover"
  }
}
```

2. 常にサムを表示します:

```json [settings]
{
  "minimap": {
    "thumb": "always"
  }
}
```

### サムの境界線

- 説明: ミニマップのサムの境界線の表示方法を指定します。
- 設定: `thumb_border`
- デフォルト: `left_open`

**オプション**

1. サムの四辺すべてに境界線を表示します:

```json [settings]
{
  "minimap": {
    "thumb_border": "full"
  }
}
```

2. 左側以外のすべての辺に境界線を表示します:

```json [settings]
{
  "minimap": {
    "thumb_border": "left_open"
  }
}
```

3. 右側以外のすべての辺に境界線を表示します:

```json [settings]
{
  "minimap": {
    "thumb_border": "right_open"
  }
}
```

4. 左側のみに境界線を表示します:

```json [settings]
{
  "minimap": {
    "thumb_border": "left_only"
  }
}
```

5. サムを境界線なしで表示します:

```json [settings]
{
  "minimap": {
    "thumb_border": "none"
  }
}
```

### 現在行のハイライト

- 説明: ミニマップ内で現在行をどのようにハイライトするかを指定します。
- 設定: `current_line_highlight`
- デフォルト: `null`

**オプション**

1. エディターの現在行ハイライト設定を継承します:

```json [settings]
{
  "minimap": {
    "current_line_highlight": null
  }
}
```

2. ミニマップで現在行をハイライトします:

```json [settings]
{
  "minimap": {
    "current_line_highlight": "line"
  }
}
```

または

```json [settings]
{
  "minimap": {
    "current_line_highlight": "all"
  }
}
```

3. ミニマップで現在行をハイライトしません:

```json [settings]
{
  "minimap": {
    "current_line_highlight": "gutter"
  }
}
```

または

```json [settings]
{
  "minimap": {
    "current_line_highlight": "none"
  }
}
```

## エディターのタブバー

- 説明: エディターのタブバーに関する設定です。
- 設定: `tab_bar`
- デフォルト:

```json [settings]
{
  "tab_bar": {
    "show": true,
    "show_nav_history_buttons": true,
    "show_tab_bar_buttons": true
  }
}
```

### 表示

- 説明: エディターにタブバーを表示するかどうかを指定します。
- 設定: `show`
- デフォルト: `true`

**オプション**

`boolean` 値

### ナビゲーション履歴ボタン

- 説明: ナビゲーション履歴ボタンを表示するかどうかを指定します。
- 設定: `show_nav_history_buttons`
- デフォルト: `true`

**オプション**

`boolean` 値

### タブバーボタン

- 説明: タブバーボタンを表示するかどうかを指定します。
- 設定: `show_tab_bar_buttons`
- デフォルト: `true`

**オプション**

`boolean` 値

## エディタータブ

- 説明: エディタータブの設定です。
- 設定: `tabs`
- デフォルト:

```json [settings]
{
  "tabs": {
    "close_position": "right",
    "file_icons": false,
    "git_status": false,
    "activate_on_close": "history",
    "show_close_button": "hover",
    "show_diagnostics": "off"
  }
}
```

### クローズボタンの位置

- 説明: タブ内のどこにクローズボタンを表示するかを指定します。
- 設定: `close_position`
- デフォルト: `right`

**オプション**

1. クローズボタンを右側に表示します:

```json [settings]
{
  "tabs": {
    "close_position": "right"
  }
}
```

2. クローズボタンを左側に表示します:

```json [settings]
{
  "tabs": {
    "close_position": "left"
  }
}
```

### ファイルアイコン

- 説明: タブにファイルアイコンを表示するかどうかを指定します。
- 設定: `file_icons`
- デフォルト: `false`

### Git ステータス

- 説明: タブに Git のファイルステータスを表示するかどうかを指定します。
- 設定: `git_status`
- デフォルト: `false`

### クローズ時のアクティブ化

- 説明: 現在のタブを閉じたあとにどのタブをアクティブにするかを指定します。
- 設定: `activate_on_close`
- デフォルト: `history`

**オプション**

1. 直前に開いていたタブをアクティブにします:

```json [settings]
{
  "tabs": {
    "activate_on_close": "history"
  }
}
```

2. 右隣のタブがあればそれをアクティブにします:

```json [settings]
{
  "tabs": {
    "activate_on_close": "neighbour"
  }
}
```

3. 左隣のタブがあればそれをアクティブにします:

```json [settings]
{
  "tabs": {
    "activate_on_close": "left_neighbour"
  }
}
```

### クローズボタンの表示

- 説明: タブのクローズボタンの表示タイミングを制御します。
- 設定: `show_close_button`
- デフォルト: `hover`

**オプション**

1. タブにホバーしたときだけ表示します:

```json [settings]
{
  "tabs": {
    "show_close_button": "hover"
  }
}
```

2. 常に表示します:

```json [settings]
{
  "tabs": {
    "show_close_button": "always"
  }
}
```

3. ホバーしても表示しません:

```json [settings]
{
  "tabs": {
    "show_close_button": "hidden"
  }
}
```

### 診断の表示

- 説明: タブに診断インジケーターを表示するかどうかを指定します。この設定はファイルアイコンが有効な場合にのみ機能し、診断上の問題があるどのファイルをマークするかを制御します。
- 設定: `show_diagnostics`
- デフォルト: `off`

**オプション**

1. どのファイルもマークしません:

```json [settings]
{
  "tabs": {
    "show_diagnostics": "off"
  }
}
```

2. エラーのあるファイルのみマークします:

```json [settings]
{
  "tabs": {
    "show_diagnostics": "errors"
  }
}
```

3. エラーおよび警告のあるファイルをマークします:

```json [settings]
{
  "tabs": {
    "show_diagnostics": "all"
  }
}
```

### インラインコードアクションの表示

- 説明: バッファー行の先頭にコードアクションボタンを表示するかどうかを指定します。
- 設定: `inline_code_actions`
- デフォルト: `true`

**オプション**

`boolean` 値

### セッション

- 説明: Zed のライフサイクル関連の挙動を制御します。
- 設定: `session`
- デフォルト:

```json
{
  "session": {
    "restore_unsaved_buffers": true,
    "trust_all_worktrees": false
  }
}
```

**オプション**

1. 再起動時に未保存のバッファーを復元するかどうか:

```json [settings]
{
  "session": {
    "restore_unsaved_buffers": true
  }
}
```

この値が `true` の場合、アプリケーションを閉じるときに変更済みファイルを保存するか破棄するかの確認は表示されません。

2. ワークツリーおよびワークスペースの信頼チェックを省略するかどうか:

```json [settings]
{
  "session": {
    "trust_all_worktrees": false
  }
}
```

信頼されている場合、プロジェクト設定は自動的に同期され、言語サーバーと MCP サーバーが自動的にダウンロードされて起動されます。

### ドラッグアンドドロップ選択

- 説明: バッファー内でドラッグアンドドロップによるテキスト選択を許可するかどうかを指定します。`delay` はドラッグアンドドロップが許可されるまでに経過する必要があるミリ秒数です。条件を満たさない場合は新しいテキスト選択が作成されます。
- 設定: `drag_and_drop_selection`
- デフォルト:

```
```json [settings]
{
  "drag_and_drop_selection": {
    "enabled": true,
    "delay": 300
  }
}
```

## エディターのツールバー

- 説明: エディターのツールバーにさまざまな要素を表示するかどうか。
- 設定: `toolbar`
- デフォルト:

```json [settings]
{
  "toolbar": {
    "breadcrumbs": true,
    "quick_actions": true,
    "selections_menu": true,
    "agent_review": true,
    "code_actions": false
  }
}
```

**オプション**

各オプションは特定のツールバー要素の表示を制御します。すべての要素を非表示にすると、エディターのツールバー自体が表示されなくなります。

## システムタブを使用する

- 説明: ユーザーのタブ設定に基づいてウィンドウをタブとしてまとめることを許可するかどうか (macOS のみ)。
- 設定: `use_system_window_tabs`
- デフォルト: `false`

**オプション**

この設定を有効にすると、macOS ネイティブのウィンドウのタブ機能と統合されます。`true` に設定すると、ユーザーがシステム全体のタブ設定 (「Always」「In Full Screen」「Never」など) で指定した動作に従って、Zed のウィンドウを 1 つの macOS ウィンドウ内のタブとしてまとめることができます。この設定は macOS でのみ利用できます。

## Language Server を有効にする

- 説明: コードインテリジェンスを提供するために Language Server を使用するかどうか。
- 設定: `enable_language_server`
- デフォルト: `true`

**オプション**

`boolean` 値

## 保存時に末尾の改行を保証する

- 説明: ファイル末尾の空白文字だけを含む行をすべて削除し、末尾に改行が 1 行だけ存在するようにします。
- 設定: `ensure_final_newline_on_save`
- デフォルト: `true`

**オプション**

`boolean` 値

## 抜粋の行を展開する

- 説明: マルチバッファ内で抜粋を展開するときのデフォルトの行数。
- 設定: `expand_excerpt_lines`
- デフォルト: `5`

**オプション**

正の `integer` 値

## 抜粋のコンテキスト行

- 説明: マルチバッファに抜粋を表示する際に提供するコンテキストの行数。
- 設定: `excerpt_context_lines`
- デフォルト: `2`

**オプション**

1 から 32 の範囲の正の `integer` 値。範囲外の値はこの範囲にクランプされます。

## 改行時にコメントを延長する

- 説明: 直前の行もコメントである場合に、新しい行をコメントで開始するかどうか。
- 設定: `extend_comment_on_newline`
- デフォルト: `true`

**オプション**

`boolean` 値

## ステータスバー

- 説明: ステータスバー内のさまざまな要素を制御します。ステータスバー内の一部の項目には、別の場所に個別の設定がある点に注意してください。
- 設定: `status_bar`
- デフォルト:

```json [settings]
{
  "status_bar": {
    "active_language_button": true,
    "cursor_position_button": true,
    "line_endings_button": false
  }
}
```

ステータスバーを完全に非表示にする実験的な設定があります。これにより大きな使い勝手の問題が発生し (Zed の多くの機能を使用できなくなります) ますが、それでも画面領域を何より重視する人向けに提供されています。

```json
"status_bar": {
  "experimental.show": false
}
```

## LSP

- 説明: Language Server 用の設定。
- 設定: `lsp`
- デフォルト: `null`

**オプション**

特定の Language Server ごとに、以下の設定を上書きできます。

- `initialization_options`
- `settings`

Language Server の設定を上書きするには、`lsp` の値にその Language Server 名のエントリを追加します。

一部のオプションは `initialization_options` を介して Language Server に渡されます。これらは Language Server の起動時に指定する必要があるオプションであり、値を変更した場合は Language Server の再起動が必要になります。

たとえば `rust-analyzer` に `check` オプションを渡すには、次の設定を使用します。

```json [settings]
{
  "lsp": {
    "rust-analyzer": {
      "initialization_options": {
        "check": {
          "command": "clippy" // rust-analyzer.check.command (デフォルト: "check")
        }
      }
    }
  }
}
```

一方、実行時に変更可能なその他のオプションは `settings` の下に配置する必要があります。

```json [settings]
{
  "lsp": {
    "yaml-language-server": {
      "settings": {
        "yaml": {
          "keyOrdering": true // マップ内のキーをアルファベット順に並べることを強制する
        }
      }
    }
  }
}
```

## グローバル LSP 設定

- 説明: すべての Language Server に適用されるグローバルな LSP 設定。
- 設定: `global_lsp_settings`
- デフォルト:

```json [settings]
{
  "global_lsp_settings": {
    "button": true,
    "request_timeout": 120,
    "notifications": {
      // Language Server の通知を自動的に閉じるまでのタイムアウト時間 (ミリ秒)。
      // 自動的に閉じないようにするには 0 に設定します。
      "dismiss_timeout_ms": 5000
    }
  }
}
```

**オプション**

- `button`: ステータスバーに LSP ステータスボタンを表示するかどうか
- `request_timeout`: Language Server からの応答を待機する最大時間 (秒)。`0` を指定するとタイムアウトを適用しません (すべての LSP 応答が完了するまで無期限に待機することになります)。デフォルト: `120`
- `notifications`: 通知に関する設定。
  - `dismiss_timeout_ms`: Language Server の通知を自動的に閉じるまでのタイムアウト時間 (ミリ秒)。自動的に閉じないようにするには 0 に設定します。

## LSP ハイライトのデバウンス

- 説明: 現在のカーソル位置に基づいて Language Server にハイライトを問い合わせる前に待機するデバウンス遅延時間 (ミリ秒)。
- 設定: `lsp_highlight_debounce`
- デフォルト: `75`

**オプション**

ミリ秒を表す `integer` 値

## 機能

- 説明: グローバルに有効化 / 無効化できる機能
- 設定: `features`
- デフォルト:

```json [settings]
{
  "edit_predictions": {
    "provider": "zed"
  }
}
```

### 編集予測プロバイダー

- 説明: どの編集予測プロバイダーを使用するか
- 設定: `edit_prediction_provider`
- デフォルト: `"zed"`

**オプション**

1. 編集予測プロバイダーとして Zeta を使用する:

```json [settings]
{
  "edit_predictions": {
    "provider": "zed"
  }
}
```

2. 編集予測プロバイダーとして Copilot を使用する:

```json [settings]
{
  "edit_predictions": {
    "provider": "copilot"
  }
}
```

3. すべてのプロバイダーで編集予測を無効にする

```json [settings]
{
  "edit_predictions": {
    "provider": "none"
  }
}
```

## 保存時にフォーマット

- 説明: 保存前にバッファのフォーマットを実行するかどうか。
- 設定: `format_on_save`
- デフォルト: `on`

**オプション**

1. `on`。`formatter` 設定に従って保存時のフォーマットを有効にします:

```json [settings]
{
  "format_on_save": "on"
}
```

2. `off`。保存時のフォーマットを無効にします:

```json [settings]
{
  "format_on_save": "off"
}
```

## フォーマッター

- 説明: バッファのフォーマット方法。
- 設定: `formatter`
- デフォルト: `auto`

**オプション**

1. 現在の Language Server を使用するには `"language_server"` を指定します:

```json [settings]
{
  "formatter": "language_server"
}
```

2. 外部コマンドを使用する場合は `"external"` を指定します。実行するフォーマットプログラムの名前と、そのプログラムに渡す引数の配列を指定します。バッファのテキストは標準入力 (stdin) でプログラムに渡され、フォーマット済みの出力は標準出力 (stdout) に書き出す必要があります。たとえば、次のコマンドは [`sed(1)`](https://linux.die.net/man/1/sed) を使って末尾の空白を削除します:

```json [settings]
{
  "formatter": {
    "external": {
      "command": "sed",
      "arguments": ["-e", "s/ *$//"]
    }
  }
}
```

3. 外部フォーマッタは任意で `{buffer_path}` プレースホルダーを含めることができ、実行時にはフォーマットされているバッファのパスがそこに含まれます。フォーマッタは標準入力経由でファイル内容を受け取り、それを再フォーマットして標準出力に出力することで動作するため、通常は何というファイル名をフォーマットしているのかを知りません。Prettier のようなツールはコマンドライン引数としてファイルパスを受け取ることをサポートしており、それを使用してフォーマットの判断に影響を与えることができます。

WARNING: `{buffer_path}` を使用して、フォーマッタにファイル名から読み込ませるようにしてはいけません。フォーマッタは標準入力からのみ読み取り、ファイルを直接読み書きすべきではありません。

```json [settings]
  "formatter": {
    "external": {
      "command": "prettier",
      "arguments": ["--stdin-filepath", "{buffer_path}"]
    }
  }
```

4. 接続されている言語サーバーが提供するコードアクションを使用するには、`"code_actions"` を使用します:

```json [settings]
{
  "formatter": [
    // ESLint の --fix を使う:
    { "code_action": "source.fixAll.eslint" },
    // 保存時に import を整理する:
    { "code_action": "source.organizeImports" }
  ]
}
```

5. 複数のフォーマッタを連続して使用するには、フォーマッタの配列を使用します:

```json [settings]
{
  "formatter": [
    { "language_server": { "name": "rust-analyzer" } },
    {
      "external": {
        "command": "sed",
        "arguments": ["-e", "s/ *$//"]
      }
    }
  ]
}
```

ここでは、まず `rust-analyzer` がコードのフォーマットに使用され、その後に sed の呼び出しが続きます。
いずれかのフォーマッタが失敗した場合でも、後続のフォーマッタは引き続き実行されます。

6. フォーマッタを無効にするには `"none"` を使用します。この設定は構成されたフォーマッタを無効にしますが、`code_actions_on_format` 内のアクションは引き続き実行されます:

```json [settings]
{
  "formatter": "none"
}
```

## Auto close

- Description: 開きかっこ、角かっこ、中かっこ、シングルクォートまたはダブルクォート文字を入力したときに、対応する閉じ文字を自動的に追加するかどうか。
- Setting: `use_autoclose`
- Default: `true`

**Options**

`boolean` 値

## Always Treat Brackets As Autoclosed

- Description: エディタが自動クローズされた文字をどのように扱うかを制御します。
- Setting: `always_treat_brackets_as_autoclosed`
- Default: `false`

**Options**

`boolean` 値

**Example**

この設定が `true` に設定されている場合:

1. エディタに入力: `)))`
2. カーソルを先頭に移動: `^)))`
3. 再度入力: `)))`

結果はデフォルトの場合の `))))))` ではなく、引き続き `)))` のままです。

## File Scan Exclusions

- Setting: `file_scan_exclusions`
- Description: Zed によって完全に除外されるファイルまたはファイルのグロブ。ファイルスキャンやファイル検索の際にスキップされ、プロジェクトファイルツリーにも表示されません。`file_scan_inclusions` を上書きします。
- Default:

```json [settings]
{
  "file_scan_exclusions": [
    "**/.git",
    "**/.svn",
    "**/.hg",
    "**/.jj",
    "**/CVS",
    "**/.DS_Store",
    "**/Thumbs.db",
    "**/.classpath",
    "**/.settings"
  ]
}
```

settings.json で `file_scan_exclusions` を指定すると、（上記に示した）デフォルトが上書きされます。追加の項目を除外したい場合は、デフォルトの値をすべて settings に含める必要があります。

## File Scan Inclusions

- Setting: `file_scan_inclusions`
- Description: git によって無視されている場合でも、Zed によってインクルードされるファイルまたはファイルのグロブ。git では追跡されていないが、プロジェクトにとって重要なファイルに役立ちます。グロブが広すぎると、Zed のファイルスキャンが遅くなる可能性があります。`file_scan_exclusions` はこれらの inclusion より優先されます。
- Default:

```json [settings]
{
  "file_scan_inclusions": [".env*"]
}
```

## File Types

- Setting: `file_types`
- Description: Zed がファイル名や拡張子に基づいてファイルの言語をどのように選択するかを構成します。グロブのエントリをサポートします。
- Default:

```json [settings]
{
  "file_types": {
    "JSONC": [
      "**/.zed/**/*.json",
      "**/zed/**/*.json",
      "**/Zed/**/*.json",
      "**/.vscode/**/*.json"
    ],
    "Shell Script": [".env.*"]
  }
}
```

**Examples**

すべての `.c` ファイルを C++ として、`MyLockFile` という名前のファイルを TOML として、`Dockerfile` で始まるファイルを Dockerfile として解釈するには:

```json [settings]
{
  "file_types": {
    "C++": ["c"],
    "TOML": ["MyLockFile"],
    "Dockerfile": ["Dockerfile*"]
  }
}
```

## Diagnostics

- Description: Diagnostics 関連機能の構成。
- Setting: `diagnostics`
- Default:

```json [settings]
{
  "diagnostics": {
    "include_warnings": true,
    "inline": {
      "enabled": false
    }
  }
}
```

### Inline Diagnostics

- Description: Diagnostics 情報をインラインで表示するかどうか。
- Setting: `inline`
- Default:

```json [settings]
{
  "diagnostics": {
    "inline": {
      "enabled": false,
      "update_debounce_ms": 150,
      "padding": 4,
      "min_column": 0,
      "max_severity": null
    }
  }
}
```

**Options**

1. インライン diagnostics を有効にする。

```json [settings]
{
  "diagnostics": {
    "inline": {
      "enabled": true
    }
  }
}
```

2. 最後の diagnostics 更新から一定時間経過するまで diagnostics の更新を遅延させる。

```json [settings]
{
  "diagnostics": {
    "inline": {
      "enabled": true,
      "update_debounce_ms": 150
    }
  }
}
```

3. ソース行の末尾と diagnostics の開始位置との間のパディングを設定する。

```json [settings]
{
  "diagnostics": {
    "inline": {
      "enabled": true,
      "padding": 4
    }
  }
}
```

4. インライン diagnostics を指定した桁位置で水平に揃える。

```json [settings]
{
  "diagnostics": {
    "inline": {
      "enabled": true,
      "min_column": 80
    }
  }
}
```

5. warning と error の diagnostics のみを表示する。

```json [settings]
{
  "diagnostics": {
    "inline": {
      "enabled": true,
      "max_severity": "warning"
    }
  }
}
```

## Git

- Description: git 関連機能の構成。
- Setting: `git`
- Default:

```json [settings]
{
  "git": {
    "git_gutter": "tracked_files",
    "inline_blame": {
      "enabled": true
    },
    "branch_picker": {
      "show_author_name": true
    },
    "hunk_style": "staged_hollow"
  }
}
```

### Git Gutter

- Description: git gutter を表示するかどうか。
- Setting: `git_gutter`
- Default: `tracked_files`

**Options**

1. トラッキングされているファイルで git gutter を表示する

```json [settings]
{
  "git": {
    "git_gutter": "tracked_files"
  }
}
```

2. git gutter を非表示にする

```json [settings]
{
  "git": {
    "git_gutter": "hide"
  }
}
```

### Gutter Debounce

- Description: 変更が git gutter に反映されるまでのデバウンスしきい値（ミリ秒）を設定します。
- Setting: `gutter_debounce`
- Default: `null`

**Options**

ミリ秒を表す `integer` 値

例:

```json [settings]
{
  "git": {
    "gutter_debounce": 100
  }
}
```

### Inline Git Blame

- Description: 現在フォーカスされている行に対して、git blame 情報をインラインで表示するかどうか。
- Setting: `inline_blame`
- Default:

```json [settings]
{
  "git": {
    "inline_blame": {
      "enabled": true
    }
  }
}
```

**Options**

1. インライン git blame を無効にする:

```json [settings]
{
  "git": {
    "inline_blame": {
      "enabled": false
    }
  }
}
```

2. カーソルの移動が停止した後に開始される遅延の後でのみ、インライン git blame を表示します:

```json [settings]
{
  "git": {
    "inline_blame": {
      "delay_ms": 500
    }
  }
}
```

3. コミット日時と作者名の横にコミットサマリーを表示します:

```json [settings]
{
  "git": {
    "inline_blame": {
      "show_commit_summary": true
    }
  }
}
```

4. インライン blame 情報を表示する最小カラムとしてこの値を使用します:

```json [settings]
{
  "git": {
    "inline_blame": {
      "min_column": 80
    }
  }
}
```

5. 行末とインライン blame ヒントの間のパディングを em 単位で設定します:

```json [settings]
{
  "git": {
    "inline_blame": {
      "padding": 10
    }
  }
}
```

### ブランチピッカー

- Description: branch picker に関連する設定です。
- Setting: `branch_picker`
- Default:

```json [settings]
{
  "git": {
    "branch_picker": {
      "show_author_name": false
    }
  }
}
```

**オプション**

1. branch picker に作者名を表示します:

```json [settings]
{
  "git": {
    "branch_picker": {
      "show_author_name": true
    }
  }
}
```

### Hunk スタイル

- Description: diff hunk に使用するスタイルを指定します。
- Setting: `hunk_style`
- Default:

```json [settings]
{
  "git": {
    "hunk_style": "staged_hollow"
  }
}
```

**オプション**

1. ステージ済みの hunk をフェードさせて枠線を付けて表示します:

```json [settings]
{
  "git": {
    "hunk_style": "staged_hollow"
  }
}
```

2. ステージされていない hunk をフェードさせて枠線を付けて表示します:

```json [settings]
{
  "git": {
    "hunk_style": "unstaged_hollow"
  }
}
```

## Go to Definition Fallback

- Description: {#action editor::GoToDefinition} アクションが定義を見つけられなかった場合に何を行うかを指定します
- Setting: `go_to_definition_fallback`
- Default: `"find_all_references"`

**オプション**

1. 何もしません:

```json [settings]
{
  "go_to_definition_fallback": "none"
}
```

2. 同じシンボルの参照を検索します (デフォルト):

```json [settings]
{
  "go_to_definition_fallback": "find_all_references"
}
```

## Hard Tabs

- Description: 行のインデントにタブ文字を使用するか、複数のスペースを使用するかを指定します。
- Setting: `hard_tabs`
- Default: `false`

**オプション**

`boolean` 値

## Helix Mode

- Description: Helix モードを有効にするかどうか。`helix_mode` を有効にすると `vim_mode` も有効になります。詳細については [Helix ドキュメント](../helix.md) を参照してください。
- Setting: `helix_mode`
- Default: `false`

**オプション**

`boolean` 値

## インデントガイド

- Description: インデントガイドに関連する設定です。インデントガイドは言語ごとに個別に設定できます。
- Setting: `indent_guides`
- Default:

```json [settings]
{
  "indent_guides": {
    "enabled": true,
    "line_width": 1,
    "active_line_width": 1,
    "coloring": "fixed",
    "background_coloring": "disabled"
  }
}
```

**オプション**

1. インデントガイドを無効にします

```json [settings]
{
  "indent_guides": {
    "enabled": false
  }
}
```

2. 特定の言語に対してインデントガイドを有効にします。

```json [settings]
{
  "languages": {
    "Python": {
      "indent_guides": {
        "enabled": true
      }
    }
  }
}
```

3. インデント認識の色付け（「レインボーインデント」）を有効にします。
   異なるインデントレベルに使用される色はテーマで定義されています（テーマキー: `accents`）。これらはテーマのオーバーライドを使用してカスタマイズできます。

```json [settings]
{
  "indent_guides": {
    "enabled": true,
    "coloring": "indent_aware"
  }
}
```

4. インデント認識の背景色付け（「レインボーインデント」）を有効にします。
   異なるインデントレベルに使用される色はテーマで定義されています（テーマキー: `accents`）。これらはテーマのオーバーライドを使用してカスタマイズできます。

```json [settings]
{
  "indent_guides": {
    "enabled": true,
    "coloring": "indent_aware",
    "background_coloring": "indent_aware"
  }
}
```

## Hover Popover Enabled

- Description: エディタ内のシンボル上にマウスカーソルを移動したときに情報ボックスを表示するかどうかを指定します。
- Setting: `hover_popover_enabled`
- Default: `true`

**オプション**

`boolean` 値

## Hover Popover Delay

- Description: 情報ボックスを表示するまでに待機する時間（ミリ秒）。この遅延は、`auto_signature_help` が有効な場合の自動シグネチャヘルプにも適用されます。
- Setting: `hover_popover_delay`
- Default: `300`

**オプション**

ミリ秒を表す `integer` 値

## アイコンテーマ

- Description: アイコンテーマ設定は 2 つの形式で指定できます。アイコンテーマ名そのもの、または Zed 内のファイル/フォルダ用の `mode`、`dark`、`light` アイコンテーマを含むオブジェクトです。
- Setting: `icon_theme`
- Default: `Zed (Default)`

### アイコンテーマオブジェクト

- Description: `mode`、`dark`、`light` を含むオブジェクトを使ってアイコンテーマを指定します。
- Setting: `icon_theme`
- Default:

```json [settings]
{
  "icon_theme": {
    "mode": "system",
    "dark": "Zed (Default)",
    "light": "Zed (Default)"
  }
}
```

### Mode

- Description: アイコンテーマのモードを指定します。
- Setting: `mode`
- Default: `system`

**オプション**

1. アイコンテーマをダークモードに設定します

```json [settings]
{
  "icon_theme": {
    "mode": "dark",
    "dark": "Zed (Default)",
    "light": "Zed (Default)"
  }
}
```

2. アイコンテーマをライトモードに設定します

```json [settings]
{
  "icon_theme": {
    "mode": "light",
    "dark": "Zed (Default)",
    "light": "Zed (Default)"
  }
}
```

3. アイコンテーマをシステムモードに設定します

```json [settings]
{
  "icon_theme": {
    "mode": "system",
    "dark": "Zed (Default)",
    "light": "Zed (Default)"
  }
}
```

### Dark

- Description: ダークアイコンテーマの名前。
- Setting: `dark`
- Default: `Zed (Default)`

**オプション**

有効なアイコンテーマ名の最新一覧を表示するには、コマンドパレットで {#action icon_theme_selector::Toggle} アクションを実行します。

### Light

- Description: ライトアイコンテーマの名前。
- Setting: `light`
- Default: `Zed (Default)`

**オプション**

有効なアイコンテーマ名の最新一覧を表示するには、コマンドパレットで {#action icon_theme_selector::Toggle} アクションを実行します。

## 画像ビューア

- Description: 画像ビューア機能の設定
- Setting: `image_viewer`
- Default:

```json [settings]
{
  "image_viewer": {
    "unit": "binary"
  }
}
```

**オプション**

### Unit

- Description: 画像ファイルサイズの単位
- Setting: `unit`
- Default: `"binary"`

**オプション**

1. バイナリ単位（KiB, MiB）を使用します:

```json [settings]
{
  "image_viewer": {
    "unit": "binary"
  }
}
```

2. 10 進単位（KB, MB）を使用します:

```json [settings]
{
  "image_viewer": {
    "unit": "decimal"
  }
}
```

## インレイヒント

- Description: エディタ内にヒントとして追加のテキストを表示するための設定です。
- Setting: `inlay_hints`
- Default:

```json [settings]
{
  "inlay_hints": {
    "enabled": false,
    "show_type_hints": true,
    "show_parameter_hints": true,
    "show_other_hints": true,
    "show_background": false,
    "edit_debounce_ms": 700,
    "scroll_debounce_ms": 50,
    "toggle_on_modifiers_press": null
  }
}
```

**オプション**
Inlay hints のクエリは、エディター（クライアント）と LSP サーバーの 2 つの部分で構成されます。
上記の inlay 設定を変更してヒントを有効にすると、エディターは特定種類のヒントのクエリを開始し、サーバーからの LSP ヒントリフレッシュ要求に応答します。
この時点で、サーバーはその実装によってヒントを返す場合と返さない場合があり、追加の設定が必要なことがあります。詳細は対応する LSP サーバーのドキュメントを参照してください。

次の言語は、Zed によって inlay hints があらかじめ設定されています:

- [Go](https://docs.zed.dev/languages/go)
- [Rust](https://docs.zed.dev/languages/rust)
- [Svelte](https://docs.zed.dev/languages/svelte)
- [TypeScript](https://docs.zed.dev/languages/typescript)

サーバーの設定には `lsp` セクションを使用します。例は対応する言語のドキュメントに記載されています。

Zed ではヒントは即座にはクエリされず、2 種類のデバウンスが使用されます。どちらも 0 に設定すると無効化できます。
設定に関連するヒントの更新はデバウンスされません。

`toggle_on_modifiers_press` に指定可能な設定値はすべて次のとおりです:

```json [settings]
{
  "inlay_hints": {
    "toggle_on_modifiers_press": {
      "control": true,
      "shift": true,
      "alt": true,
      "platform": true,
      "function": true
    }
  }
}
```

指定されていない値は `false` となります。すべての修飾キーが `false` である場合、または修飾キーがすべて押されていない場合、ヒントはトグルされません。

## Journal

- Description: ジャーナルの設定。
- Setting: `journal`
- Default:

```json [settings]
{
  "journal": {
    "path": "~",
    "hour_format": "hour12"
  }
}
```

### Path

- Description: ジャーナルのエントリが保存されるディレクトリのパス。無効なパスが指定された場合、ジャーナルは `~`（ホームディレクトリ）を使用するようフォールバックします。
- Setting: `path`
- Default: `~`

**Options**

`string` 値

### Hour Format

- Description: ジャーナルで時間を表示する際に使用するフォーマット。
- Setting: `hour_format`
- Default: `hour12`

**Options**

1. 12 時間制:

```json [settings]
{
  "journal": {
    "hour_format": "hour12"
  }
}
```

2. 24 時間制:

```json [settings]
{
  "journal": {
    "hour_format": "hour24"
  }
}
```

## JSX Tag Auto Close

- Description: JSX タグを自動的に閉じるかどうか
- Setting: `jsx_tag_auto_close`
- Default:

```json [settings]
{
  "jsx_tag_auto_close": {
    "enabled": true
  }
}
```

**Options**

- `enabled`: JSX タグの自動クローズを有効にするかどうか

## Languages

- Description: 特定の言語に対する設定。
- Setting: `languages`
- Default: `null`

**Options**

ある言語の設定を上書きするには、その言語名のエントリを `languages` の値に追加します。例:

```json [settings]
{
  "languages": {
    "C": {
      "format_on_save": "off",
      "preferred_line_length": 64,
      "soft_wrap": "preferred_line_length"
    },
    "JSON": {
      "tab_size": 4
    }
  }
}
```

次の設定は、各特定言語ごとに上書き可能です:

- [`enable_language_server`](#enable-language-server)
- [`ensure_final_newline_on_save`](#ensure-final-newline-on-save)
- [`format_on_save`](#format-on-save)
- [`formatter`](#formatter)
- [`hard_tabs`](#hard-tabs)
- [`preferred_line_length`](#preferred-line-length)
- [`remove_trailing_whitespace_on_save`](#remove-trailing-whitespace-on-save)
- [`semantic_tokens`](#semantic-tokens)
- [`show_edit_predictions`](#show-edit-predictions)
- [`show_whitespaces`](#show-whitespaces)
- [`whitespace_map`](#whitespace-map)
- [`soft_wrap`](#soft-wrap)
- [`tab_size`](#tab-size)
- [`use_autoclose`](#use-autoclose)
- [`always_treat_brackets_as_autoclosed`](#always-treat-brackets-as-autoclosed)

これらの値は、同じ名前のルートレベル設定と同じオプションを受け取ります。

### Document Symbols

- Description: アウトラインやパンくずリストに使用されるドキュメントシンボルのソースを制御します。
- Setting: `document_symbols`
- Default: `off`

**Options**

- `"off"`: tree-sitter クエリを使用してドキュメントシンボルを計算します（デフォルト）
- `"on"`: 言語サーバーの `textDocument/documentSymbol` LSP レスポンスを使用します。有効にすると、ドキュメントシンボルに tree-sitter は使用されません

LSP ドキュメントシンボルは、tree-sitter ではうまく扱えない可能性のある複雑な言語機能（例: ジェネリック型、マクロ、デコレーター）に対して、より正確なシンボルを提供できる場合があります。言語サーバーが tree-sitter の文法より優れたシンボル情報を提供する場合は、これを使用してください。

例:

```json [settings]
{
  "languages": {
    "TypeScript": {
      "document_symbols": "on"
    }
  }
}
```

## Language Models

- Description: Language model プロバイダーの設定
- Setting: `language_models`
- Default:

```json [settings]
{
  "language_models": {
    "anthropic": {
      "api_url": "https://api.anthropic.com"
    },
    "google": {
      "api_url": "https://generativelanguage.googleapis.com"
    },
    "ollama": {
      "api_url": "http://localhost:11434"
    },
    "openai": {
      "api_url": "https://api.openai.com/v1"
    }
  }
}
```

**Options**

API URL や認証設定を含む、さまざまな AI モデルプロバイダーの設定。

## Line Indicator Format

- Description: ステータスバーの行インジケーターのフォーマット
- Setting: `line_indicator_format`
- Default: `"short"`

**Options**

1. 短いフォーマット:

```json [settings]
{
  "line_indicator_format": "short"
}
```

2. 長いフォーマット:

```json [settings]
{
  "line_indicator_format": "long"
}
```

## Linked Edits

- Description: 言語サーバーがサポートしている場合、関連する範囲のリンク編集を行うかどうか。たとえば、開きの `<html>` タグを編集したときに、閉じの `</html>` タグの内容も同様に編集されます。
- Setting: `linked_edits`
- Default: `true`

**Options**

`boolean` 値

## LSP Document Colors

- Description: エディター内で LSP `textDocument/documentColor` の色をどのように描画するか
- Setting: `lsp_document_colors`
- Default: `inlay`

**Options**

1. `inlay`: カラーのテキスト付近に inlay hints としてドキュメントカラーを描画します。
2. `background`: カラーのテキストの背後に背景を描画します。
3. `border`: カラーのテキストの周囲に枠線を描画します。
4. `none`: ドキュメントカラーをクエリおよび描画しません。

## Max Tabs

- Description: タブバーに表示するタブの最大数
- Setting: `max_tabs`
- Default: `null`

**Options**

正の `integer` 値、またはタブ数無制限を表す `null`

## Middle Click Paste (Linux のみ)

- Description: Linux での中クリック貼り付けを有効にする
- Setting: `middle_click_paste`
- Default: `true`

**Options**

`boolean` 値

## Multi Cursor Modifier

- Description: マウスで複数カーソルを追加する際に使用する修飾キーを決定します。ホバーリンクを開くためのマウスジェスチャーは、マルチカーソルの修飾キーと競合しないように調整されます。
- Setting: `multi_cursor_modifier`
- Default: `alt`

**Options**

1. Linux と Windows では `Alt`、macOS では `Option` にマッピングされます:

```json [settings]
{
  "multi_cursor_modifier": "alt"
}
```

2. Linux と Windows では `Control`、macOS では `Command` にマッピングされます:

```json [settings]
{
  "multi_cursor_modifier": "cmd_or_ctrl" // alias: "cmd", "ctrl"
}
```

## Node

- Description: Node.js 連携の設定
- Setting: `node`
- Default:

```
```json [settings]
{
  "node": {
    "ignore_system_version": false,
    "path": null,
    "npm_path": null
  }
}
```

**オプション**

- `ignore_system_version`: システムの Node.js バージョンを無視するかどうか
- `path`: Node.js バイナリへのカスタムパス
- `npm_path`: npm バイナリへのカスタムパス

## Network Proxy

- Description: Zed 用のネットワークプロキシを設定します。
- Setting: `proxy`
- Default: `null`

**オプション**

proxy 設定には、プロキシの URL を指定する必要があります。

次の URI スキームがサポートされています:

- `http`
- `https`
- `socks4` - ローカル DNS を使用する SOCKS4 プロキシ
- `socks4a` - リモート DNS を使用する SOCKS4 プロキシ
- `socks5` - ローカル DNS を使用する SOCKS5 プロキシ
- `socks5h` - リモート DNS を使用する SOCKS5 プロキシ

スキームが指定されていない場合は `http` が使用されます。

デフォルトではプロキシは使用されないか、Zed は `http_proxy`, `HTTP_PROXY`, `https_proxy`, `HTTPS_PROXY`, `all_proxy`, `ALL_PROXY`, `no_proxy`, `NO_PROXY` などの環境変数からプロキシ設定を取得しようとします。

例として、`http` プロキシを設定するには、設定に次を追加します:

```json [settings]
{
  "proxy": "http://127.0.0.1:10809"
}
```

あるいは、`socks5` プロキシを設定するには:

```json [settings]
{
  "proxy": "socks5h://localhost:10808"
}
```

特定のホストをプロキシの対象外にしたい場合は、`NO_PROXY` 環境変数を設定します。これは、プロキシを使用しないホスト名、ホストサフィックス、IPv4/IPv6 アドレスまたはブロックをカンマ区切りで指定したリストを受け取ります。たとえば環境変数に `NO_PROXY="google.com, 192.168.1.0/24"` が含まれている場合、`192.168.1.*` 内のすべてのホストと、`google.com`, `*.google.com` はプロキシをバイパスします。詳細については [reqwest NoProxy docs](https://docs.rs/reqwest/latest/reqwest/struct.NoProxy.html#method.from_string) を参照してください。

## On Last Window Closed

- Description: 最後のウィンドウが閉じられたときに実行する動作
- Setting: `on_last_window_closed`
- Default: `"platform_default"`

**オプション**

1. プラットフォームのデフォルトの動作を使用する:

```json [settings]
{
  "on_last_window_closed": "platform_default"
}
```

2. 常にアプリケーションを終了する:

```json [settings]
{
  "on_last_window_closed": "quit_app"
}
```

## Profiles

- Description: 既存の設定または Zed のデフォルト設定の上に一時的に適用できる構成プロファイル。
- Setting: `profiles`
- Default: `{}`

**オプション**

各プロファイルは、次のオプションフィールドを持つオブジェクトです:

- `base`: プロファイルの上書きを適用する前に、どの設定を基準として使用するか。
  - `"user"` (デフォルト): 現在のユーザー設定の上に適用します。
  - `"default"`: ユーザーによるカスタマイズを無視して、Zed のデフォルト設定の上に適用します。
- `settings`: このプロファイルの設定上書き。

例:

```json [settings]
{
  "profiles": {
    "Presentation": {
      "settings": {
        "buffer_font_size": 20,
        "ui_font_size": 18,
        "theme": "One Light"
      }
    },
    "Clean Slate": {
      "base": "default",
      "settings": {
        "theme": "Ayu Dark"
      }
    }
  }
}
```

## Preview tabs

- Description:
  プレビュータブを使用すると、ファイルをプレビューモードで開くことができます。このモードでは、タブを明示的にピン留めしない限り、別のファイルに切り替えたときに自動的に閉じられます。これは、ワークスペースを散らかさずにファイルを素早く確認するのに便利です。プレビュータブでは、ファイル名がイタリック体で表示されます。 \
   プレビュータブを通常のタブに変換する方法はいくつかあります:

  - ファイルをダブルクリックする
  - タブヘッダーをダブルクリックする
  - {#action project_panel::OpenPermanent} アクションを使用する
  - ファイルを編集する
  - ファイルを別のペインにドラッグする

- Setting: `preview_tabs`
- Default:

```json [settings]
{
  "preview_tabs": {
    "enabled": true,
    "enable_preview_from_project_panel": true,
    "enable_preview_from_file_finder": false,
    "enable_preview_from_multibuffer": true,
    "enable_preview_multibuffer_from_code_navigation": false,
    "enable_preview_file_from_code_navigation": true,
    "enable_keep_preview_on_code_navigation": false
  }
}
```

### Enable preview from project panel

- Description: プロジェクトパネルからシングルクリックでファイルを開いたときに、プレビューモードで開くかどうかを決定します。
- Setting: `enable_preview_from_project_panel`
- Default: `true`

**オプション**

`boolean` 値

### Enable preview from file finder

- Description: ファイルファインダーからファイルを選択したときに、プレビューモードで開くかどうかを決定します。
- Setting: `enable_preview_from_file_finder`
- Default: `false`

**オプション**

`boolean` 値

### Enable preview from multibuffer

- Description: マルチバッファーからファイルを開いたときに、プレビューモードで開くかどうかを決定します。
- Setting: `enable_preview_from_multibuffer`
- Default: `true`

**オプション**

`boolean` 値

### Enable preview multibuffer from code navigation

- Description: コードナビゲーションを使用してマルチバッファーを開いたときに、タブをプレビューモードで開くかどうかを決定します。
- Setting: `enable_preview_multibuffer_from_code_navigation`
- Default: `false`

**オプション**

`boolean` 値

### Enable preview file from code navigation

- Description: コードナビゲーションを使用して単一ファイルを開いたときに、タブをプレビューモードで開くかどうかを決定します。
- Setting: `enable_preview_file_from_code_navigation`
- Default: `true`

**オプション**

`boolean` 値

### Enable keep preview on code navigation

- Description: コードナビゲーションを使用して別の場所へ移動したときに、タブをプレビューモードのまま維持するかどうかを決定します。`enable_preview_file_from_code_navigation` または `enable_preview_multibuffer_from_code_navigation` も `true` の場合、新しいタブが既存のタブを置き換えることがあります。
- Setting: `enable_keep_preview_on_code_navigation`
- Default: `false`

**オプション**

`boolean` 値

## File Finder

### File Icons

- Description: ファイルファインダーでファイルアイコンを表示するかどうか。
- Setting: `file_icons`
- Default: `true`

### Modal Max Width

- Description: ファイルファインダーのモーダルの最大幅。`small`, `medium`, `large`, `xlarge`, `full` のいずれかの値を取ります。
- Setting: `modal_max_width`
- Default: `small`

### Skip Focus For Active In Search

- Description: ファイルファインダーが、検索結果内でアクティブなファイルへのフォーカスをスキップするかどうかを決定します。
- Setting: `skip_focus_for_active_in_search`
- Default: `true`

## Pane Split Direction Horizontal

- Description: ペインを水平方向に分割するときの方向
- Setting: `pane_split_direction_horizontal`
- Default: `"up"`

**オプション**

1. 上方向に分割:

```json [settings]
{
  "pane_split_direction_horizontal": "up"
}
```

2. 下方向に分割:

```json [settings]
{
  "pane_split_direction_horizontal": "down"
}
```

## Pane Split Direction Vertical

- Description: ペインを垂直方向に分割するときの方向
- Setting: `pane_split_direction_vertical`
- Default: `"left"`

**オプション**

1. 左方向に分割:

```json [settings]
{
  "pane_split_direction_vertical": "left"
}
```

2. 右方向に分割:

```json [settings]
{
  "pane_split_direction_vertical": "right"
}
```

## Preferred Line Length

- Description: ソフトラップが有効なバッファーにおいて、行をソフトラップする桁位置。
- Setting: `preferred_line_length`
- Default: `80`

**オプション**

`integer` 値

## Private Files

- 説明: ファイルがプライベートかどうかを判定するためにファイルパスにマッチさせる glob パターン
- 設定: `private_files`
- デフォルト: `["**/.env*", "**/*.pem", "**/*.key", "**/*.cert", "**/*.crt", "**/secrets.yml"]`

**オプション**

`string` の glob パターンのリスト

## プロジェクトをデフォルトでオンライン表示

- 説明: デフォルトでオンラインプロジェクトビューを表示するかどうか。
- 設定: `projects_online_by_default`
- デフォルト: `true`

**オプション**

`boolean` 値

## SSH 設定ファイルの読み込み

- 説明: SSH 設定ファイルを読み込むかどうか
- 設定: `read_ssh_config`
- デフォルト: `true`

**オプション**

`boolean` 値

## プライベートな値のマスク

- 説明: プライベートファイル内で変数の値を表示から隠します
- 設定: `redact_private_values`
- デフォルト: `false`

**オプション**

`boolean` 値

## 相対行番号

- 説明: ガターに相対行番号を表示するかどうか
- 設定: `relative_line_numbers`
- デフォルト: `"disabled"`

**オプション**

1. 折り返された行を 1 行として数えつつ、ガターに相対行番号を表示します:

```json [settings]
{
  "relative_line_numbers": "enabled"
}
```

2. 折り返された行も行数に含めて、ガターに相対行番号を表示します:

```json [settings]
{
  "relative_line_numbers": "wrapped"
}
```

2. 相対行番号を使用しません:

```json [settings]
{
  "relative_line_numbers": "disabled"
}
```

## 保存時に末尾の空白を削除

- 説明: 保存前に、バッファ内の行末にある空白を削除するかどうか。
- 設定: `remove_trailing_whitespace_on_save`
- デフォルト: `true`

**オプション**

`boolean` 値

## Dock 内のすべてのパネルをリサイズ

- 説明: Dock をリサイズするときに、その Dock 内のすべてのパネルもリサイズするかどうか。「left」「right」「bottom」の組み合わせを指定できます。
- 設定: `resize_all_panels_in_dock`
- デフォルト: `["left"]`

**オプション**

任意の組み合わせを含む文字列のリスト:

- `"left"`: 左側 Dock のパネルをまとめてリサイズ
- `"right"`: 右側 Dock のパネルをまとめてリサイズ
- `"bottom"`: 下部 Dock のパネルをまとめてリサイズ

## ファイル再オープン時に復元

- 説明: ファイルを再度開くときに、以前のファイルの状態を復元しようとするかどうか。状態はペインごとに保存されます。
- 設定: `restore_on_file_reopen`
- デフォルト: `true`

**オプション**

`boolean` 値

## 起動時の復元

- 説明: 起動時のセッション復元を制御します。
- 設定: `restore_on_startup`
- デフォルト: `last_session`

**オプション**

1. Zed を終了したときに開いていたすべてのワークスペースを復元します:

```json [settings]
{
  "restore_on_startup": "last_session"
}
```

2. 最後に閉じたワークスペースを復元します:

```json [settings]
{
  "restore_on_startup": "last_workspace"
}
```

3. 常に空のエディターで起動します:

```json [settings]
{
  "restore_on_startup": "empty_tab"
}
```

4. 常に Welcome Launchpad で起動します:

```json [settings]
{
  "restore_on_startup": "launchpad"
}
```

## 最終行より先までスクロール

- 説明: エディターが最終行の先までスクロールするかどうか
- 設定: `scroll_beyond_last_line`
- デフォルト: `"one_page"`

**オプション**

1. 最終行より先を 1 ページ分スクロールします:

```json [settings]
{
  "scroll_beyond_last_line": "one_page"
}
```

2. エディターは `vertical_scroll_margin` と同じ行数だけ最終行の先までスクロールします:

```json [settings]
{
  "scroll_beyond_last_line": "vertical_scroll_margin"
}
```

3. エディターは最終行の先までスクロールしません:

```json [settings]
{
  "scroll_beyond_last_line": "off"
}
```

**オプション**

`boolean` 値

## スクロール感度

- 説明: スクロール感度の乗数。この乗数はスクロール中の水平方向と垂直方向の差分値の両方に適用されます。
- 設定: `scroll_sensitivity`
- デフォルト: `1.0`

**オプション**

正の `float` 値

### 高速スクロール感度

- 説明: 高速スクロール用のスクロール感度の乗数。この乗数はスクロール中の水平方向と垂直方向の差分値の両方に適用されます。高速スクロールは、ユーザーがスクロールしながら alt または option キーを押し続けているときに発生します。
- 設定: `fast_scroll_sensitivity`
- デフォルト: `4.0`

**オプション**

正の `float` 値

### 水平スクロールマージン

- 説明: マウスでスクロールするときに、左右それぞれに確保しておく文字数
- 設定: `horizontal_scroll_margin`
- デフォルト: `5`

**オプション**

非負の `integer` 値

### 垂直スクロールマージン

- 説明: キーボードでスクロールするときに、カーソルの上下に確保しておく行数
- 設定: `vertical_scroll_margin`
- デフォルト: `3`

**オプション**

非負の `integer` 値

## 検索

- 説明: 新しいプロジェクト検索およびバッファ検索を開くときに、デフォルトで有効にする検索オプション。
- 設定: `search`
- デフォルト:

```json [settings]
{
  "search": {
    "button": true,
    "whole_word": false,
    "case_sensitive": false,
    "include_ignored": false,
    "regex": false,
    "center_on_match": false
  }
}
```

### Button

- 説明: ステータスバーにプロジェクト検索ボタンを表示するかどうか。
- 設定: `button`
- デフォルト: `true`

### Whole Word

- 説明: 単語全体にのみマッチさせるかどうか。
- 設定: `whole_word`
- デフォルト: `false`

### Case Sensitive

- 説明: 大文字と小文字を区別してマッチさせるかどうか。この設定は、検索だけでなく、「Select Next Occurrence」「Select Previous Occurrence」「Select All Occurrences」のようなエディターアクションにも影響します。
- 設定: `case_sensitive`
- デフォルト: `false`

### Include Ignore

- 説明: gitignore 対象のファイルを検索結果に含めるかどうか。
- 設定: `include_ignored`
- デフォルト: `false`

### Regex

- 説明: 検索クエリを正規表現として解釈するかどうか。
- 設定: `regex`
- デフォルト: `false`

### Center On Match

- 説明: 検索結果を移動するときに、各一致箇所でカーソルを中央に配置するかどうか。
- 設定: `center_on_match`
- デフォルト: `false`

## 検索の折り返し

- 説明: `search_wrap` が無効な場合、検索結果はファイルの末尾を超えて折り返されません
- 設定: `search_wrap`
- デフォルト: `true`

## カーソルから検索クエリを引き継ぐ

- 説明: カーソル位置のテキストを基に新しい検索クエリを自動入力するタイミング。
- 設定: `seed_search_query_from_cursor`
- デフォルト: `always`

**オプション**

1. `always` 常にカーソル下の単語で検索クエリを自動入力する
2. `selection` テキストが選択されているときだけ検索クエリを自動入力する
3. `never` 検索クエリを自動入力しない

## セマンティックトークン

- 説明: Language Server からのセマンティックトークンを構文ハイライトにどのように使用するかを制御します。
- 設定: `semantic_tokens`
- デフォルト: `off`

**オプション**

1. `off`: Language Server にセマンティックトークンを要求しません。
2. `combined`: LSP のセマンティックトークンを tree-sitter のハイライトと組み合わせて使用します。
3. `full`: LSP のセマンティックトークンのみを使用し、tree-sitter のハイライトを置き換えます。

セマンティックトークンをグローバルに有効化するには:

```json [settings]
{
  "semantic_tokens": "combined"
}
```

特定の言語に対してセマンティックトークンを有効化するには:

```json [settings]
{
  "languages": {
    "Rust": {
      "semantic_tokens": "full"
    }
  }
}
```

適用を反映するには Language Server の再起動が必要な場合があります。

## LSP の折りたたみ範囲

- 説明: tree-sitter とインデントベースの折りたたみの代わりに、言語サーバーからの折りたたみ範囲を使用するかどうかを制御します。tree-sitter とインデントベースの折りたたみがデフォルトであり、LSP の折りたたみデータが返されない場合や、この設定がオフになっている場合のフォールバックとして使用されます。
- 設定: `document_folding_ranges`
- デフォルト: `off`

**オプション**

1. `off`: tree-sitter とインデントベースの折りたたみを使用します。
2. `on`: 可能な限り LSP の折りたたみを使用し、サーバーから結果が返されなかった場合は tree-sitter とインデントベースの折りたたみにフォールバックします。

LSP の折りたたみ範囲をグローバルに有効にするには:

```json [settings]
{
  "document_folding_ranges": "on"
}
```

特定の言語に対して LSP の折りたたみ範囲を有効にするには:

```json [settings]
{
  "languages": {
    "Rust": {
      "document_folding_ranges": "on"
    }
  }
}
```

## LSP ドキュメントシンボル

- 説明: アウトラインやパンくずリストで使用されるドキュメントシンボルのソースを制御します。これは LSP の機能であり、有効にするとドキュメントシンボルに tree-sitter は使用されず、代わりに言語サーバーの `textDocument/documentSymbol` レスポンスが使用されます。
- 設定: `document_symbols`
- デフォルト: `off`

**オプション**

1. `off`: ドキュメントシンボルの計算に tree-sitter クエリを使用します。
2. `on`: 言語サーバーの `textDocument/documentSymbol` LSP レスポンスを使用します。有効な場合、ドキュメントシンボルに tree-sitter は使用されません。

LSP ドキュメントシンボルをグローバルに有効にするには:

```json [settings]
{
  "document_symbols": "on"
}
```

特定の言語に対して LSP ドキュメントシンボルを有効にするには:

```json [settings]
{
  "languages": {
    "Rust": {
      "document_symbols": "on"
    }
  }
}
```

## Smartcase 検索を使用

- 説明: 有効にすると、検索クエリに基づいて検索の大文字小文字の区別を自動的に調整します。検索クエリに大文字が含まれている場合、検索は大文字小文字を区別するようになり、小文字のみで構成されている場合は大文字小文字を区別しない検索になります。\
  これはファイル内検索とプロジェクト全体の検索の両方に適用されます。
- 設定: `use_smartcase_search`
- デフォルト: `false`

**オプション**

`boolean` 値

例:

- "function" を検索すると "function"、"Function"、"FUNCTION" などにマッチします。
- "Function" を検索すると "Function" のみにマッチし、"function" や "FUNCTION" にはマッチしません。

## 呼び出しステータスアイコンを表示

- 説明: ステータスバーに呼び出しステータスアイコンを表示するかどうか。
- 設定: `show_call_status_icon`
- デフォルト: `true`

**オプション**

`boolean` 値

## 補完

- 説明: この言語の補完をどのように処理するかを制御します。
- 設定: `completions`
- デフォルト:

```json [settings]
{
  "completions": {
    "words": "fallback",
    "words_min_length": 3,
    "lsp": true,
    "lsp_fetch_timeout_ms": 0,
    "lsp_insert_mode": "replace_suffix"
  }
}
```

### Words

- 説明: 単語補完をどのように行うかを制御します。大きなドキュメントでは、補完用にすべての単語を取得できない場合があります。
- 設定: `words`
- デフォルト: `fallback`

**オプション**

1. `enabled` - LSP 補完と合わせて、常にドキュメント内の単語を補完のために取得します
2. `fallback` - LSP レスポンスがエラーになった場合、またはタイムアウトした場合にのみ、ドキュメントの単語を使用して補完を表示します
3. `disabled` - 補完のためにドキュメントの単語を取得したり補完したりしません（単語ベースの補完は、別のアクション経由で問い合わせることは可能です）

### 単語クエリの最小長

- 説明: 単語ベースの補完を自動的にトリガーするために必要な、最小の文字数です。
  この値に達する前でも、対応するエディタコマンドを使用して単語ベースの補完を手動でトリガーすることは可能です。
- 設定: `words_min_length`
- デフォルト: `3`

**オプション**

正の整数値

### LSP

- 説明: LSP 補完を取得するかどうか。
- 設定: `lsp`
- デフォルト: `true`

**オプション**

`boolean` 値

### LSP フェッチのタイムアウト (ms)

- 説明: LSP 補完を取得する際に、特定のサーバーのレスポンスをどれくらい待つかを決定します。0 に設定すると無期限に待機します。
- 設定: `lsp_fetch_timeout_ms`
- デフォルト: `0`

**オプション**

ミリ秒を表す `integer` 値

### LSP 挿入モード

- 説明: LSP 補完を確定したときに、どの範囲を置換するかを制御します。
- 設定: `lsp_insert_mode`
- デフォルト: `replace_suffix`

**オプション**

1. `insert` - LSP 仕様で定義されている `insert` 範囲を使用して、カーソルより前のテキストを置換します
2. `replace` - LSP 仕様で定義されている `replace` 範囲を使用して、カーソルの前後のテキストを置換します
3. `replace_subsequence` - 置換されるテキストが補完テキストの部分列である場合は `"replace"` と同様に動作し、それ以外の場合は `"insert"` と同様に動作します
4. `replace_suffix` - カーソルより後ろのテキストが補完テキストのサフィックスである場合は `"replace"` と同様に動作し、それ以外の場合は `"insert"` と同様に動作します

## 入力時に補完を表示

- 説明: 入力中に補完を表示するかどうか。
- 設定: `show_completions_on_input`
- デフォルト: `true`

**オプション**

`boolean` 値

## 補完のドキュメントを表示

- 説明: 補完メニュー内の項目について、インラインおよび横にドキュメントを表示するかどうか。
- 設定: `show_completion_documentation`
- デフォルト: `true`

**オプション**

`boolean` 値

## 編集予測を表示

- 説明: 入力中、または `editor::ShowEditPrediction` をトリガーして手動で、編集予測を表示するかどうか。
- 設定: `show_edit_predictions`
- デフォルト: `true`

**オプション**

`boolean` 値

## 空白を表示

- 説明: エディタ内で空白文字を描画するかどうか。
- 設定: `show_whitespaces`
- デフォルト: `selection`

**オプション**

1. `all`
2. `selection`
3. `none`
4. `boundary`

## 空白マップ

- 説明: `show_whitespaces` が有効なときに、空白を描画するために使用される文字を指定します。
- 設定: `whitespace_map`
- デフォルト:

```json [settings]
{
  "whitespace_map": {
    "space": "•",
    "tab": "→"
  }
}
```

## ソフトラップ

- 説明: エディタ／優先幅に収まるように行を自動で折り返すかどうか。
- 設定: `soft_wrap`
- デフォルト: `none`

**オプション**

1. `none` 一般的に折り返しを行いませんが、行が長すぎる場合は例外です
2. `prefer_line`（非推奨、`none` と同じ）
3. `editor_width` エディタの幅を超える行を折り返します
4. `preferred_line_length` `preferred_line_length` 設定値を超える行を折り返します
5. `bounded` `editor_width` と `preferred_line_length` のうち小さい方で行を折り返します

## ラップガイドを表示

- 説明: エディタにラップガイド（縦のルーラー）を表示するかどうか。これを true に設定すると、`soft_wrap` が `preferred_line_length` に設定されている場合は `preferred_line_length` の値の位置にガイドが表示され、`wrap_guides` 設定で指定された追加のガイドも表示されます。
- 設定: `show_wrap_guides`
- デフォルト: `true`

**オプション**

`boolean` 値

## タイプ時フォーマットを使用

- 説明: LSP サーバーの機能で定義された「トリガー」記号が入力されるたびに、コードをフォーマット（および修正）するための追加の LSP クエリを使用するかどうか。
- 設定: `use_on_type_format`
- デフォルト: `true`

**オプション**

`boolean` 値

## Use Auto Surround

- 説明: 開き丸かっこ、角かっこ、中かっこ、シングルクォートまたはダブルクォートの文字を入力したときに、選択したテキストを自動的に囲むかどうか。たとえば、テキストを選択して '(' を入力すると、Zed はそのテキストを () で囲みます。
- 設定: `use_auto_surround`
- デフォルト: `true`

**オプション**

`boolean` 値

## システムパスプロンプトを使用

- 説明: 「Open」や「Save As」のために、システムが提供するダイアログを使用するかどうか。`false` に設定した場合、Zed は組み込みのキーボード優先のピッカーを使用します。
- 設定: `use_system_path_prompts`
- デフォルト: `true`

**オプション**

`boolean` 値

## システムプロンプトを使用

- 説明: 確認プロンプトなどのプロンプトに対して、システムが提供するダイアログを使用するかどうか。`false` に設定した場合、Zed は組み込みのプロンプトを使用します。Linux ではこのオプションは無視され、Zed は常に組み込みのプロンプトを使用することに注意してください。
- 設定: `use_system_prompts`
- デフォルト: `true`

**オプション**

`boolean` 値

## 折り返しガイド（縦ルーラー）

- 説明: 折り返しガイドとして縦ルーラーをどこに表示するか。無効にするには、`show_wrap_guides` を `false` に設定します。
- 設定: `wrap_guides`
- デフォルト: []

**オプション**

`integer` の列番号のリスト

## タブサイズ

- 説明: 各タブ文字に使用するスペースの数。
- 設定: `tab_size`
- デフォルト: `4`

**オプション**

`integer` 値

## タスク

- 説明: Zed 内で実行できるタスクの設定
- 設定: `tasks`
- デフォルト:

```json [settings]
{
  "tasks": {
    "variables": {},
    "enabled": true,
    "prefer_lsp": false
  }
}
```

**オプション**

- `variables`: タスク設定用のカスタム変数
- `enabled`: タスクを有効にするかどうか
- `prefer_lsp`: Zed の言語拡張が提供するタスクよりも、LSP が提供するタスクを優先するかどうか

## テレメトリー

- 説明: Zed が収集する情報を制御します。
- 設定: `telemetry`
- デフォルト:

```json [settings]
{
  "telemetry": {
    "diagnostics": true,
    "metrics": true
  }
}
```

**オプション**

### 診断

- 説明: クラッシュレポートなどのデバッグ関連データを送信するための設定。
- 設定: `diagnostics`
- デフォルト: `true`

**オプション**

`boolean` 値

### メトリクス

- 説明: Zed をどの言語と一緒に使用しているかといった、匿名化された使用状況データを送信するための設定。
- 設定: `metrics`
- デフォルト: `true`

**オプション**

`boolean` 値

## ターミナル

- 説明: ターミナルの設定。
- 設定: `terminal`
- デフォルト:

```json [settings]
{
  "terminal": {
    "alternate_scroll": "off",
    "blinking": "terminal_controlled",
    "copy_on_select": false,
    "keep_selection_on_copy": true,
    "dock": "bottom",
    "default_width": 640,
    "default_height": 320,
    "detect_venv": {
      "on": {
        "directories": [".env", "env", ".venv", "venv"],
        "activate_script": "default"
      }
    },
    "env": {},
    "font_family": null,
    "font_features": null,
    "font_size": null,
    "line_height": "comfortable",
    "minimum_contrast": 45,
    "option_as_meta": false,
    "button": true,
    "shell": "system",
    "scroll_multiplier": 3.0,
    "toolbar": {
      "breadcrumbs": false
    },
    "working_directory": "current_project_directory",
    "scrollbar": {
      "show": null
    }
  }
}
```

### ターミナル: Dock

- 説明: Dock の位置を制御します
- 設定: `dock`
- デフォルト: `bottom`

**オプション**

`"bottom"`, `"left"` または `"right"` 

### ターミナル: Alternate Scroll

- 説明: Alternate Scroll モード（DECSET コード: `?1007`）をデフォルトで有効にするかどうかを設定します。Alternate Scroll モードは、代替画面（vim や less のようなアプリケーションを実行しているときなど）ではマウススクロールイベントを上下キー押下に変換します。このモードは、ANSI エスケープコードによってターミナル側から有効化および無効化することもできます。
- 設定: `alternate_scroll`
- デフォルト: `off`

**オプション**

1. Alternate Scroll モードをデフォルトでオフにする

```json [settings]
{
  "terminal": {
    "alternate_scroll": "off"
  }
}
```

2. Alternate Scroll モードをデフォルトでオンにする

```json [settings]
{
  "terminal": {
    "alternate_scroll": "on"
  }
}
```

### ターミナル: Blinking

- 説明: ターミナル内でのカーソルの点滅動作を設定します
- 設定: `blinking`
- デフォルト: `terminal_controlled`

**オプション**

1. カーソルを一切点滅させず、ターミナルモードを無視する

```json [settings]
{
  "terminal": {
    "blinking": "off"
  }
}
```

2. カーソルの点滅をデフォルトでオフにするが、ターミナルが点滅をオンに切り替えることは許可する

```json [settings]
{
  "terminal": {
    "blinking": "terminal_controlled"
  }
}
```

3. 常にカーソルを点滅させ、ターミナルモードを無視する

```json [settings]
{
  "terminal": {
    "blinking": "on"
  }
}
```

### ターミナル: Copy On Select

- 説明: ターミナル内でテキストを選択したときに、自動的にシステムクリップボードへコピーするかどうか。
- 設定: `copy_on_select`
- デフォルト: `false`

**オプション**

`boolean` 値

**例**

```json [settings]
{
  "terminal": {
    "copy_on_select": true
  }
}
```

### ターミナル: Cursor Shape

- 説明: ターミナル内のカーソルの見た目の形状を制御します。明示的に設定されていない場合、デフォルトでブロック形状になります。
- 設定: `cursor_shape`
- デフォルト: `null`（デフォルトはブロック）

**オプション**

1. 次の文字を囲むブロック

```json [settings]
{
  "terminal": {
    "cursor_shape": "block"
  }
}
```

2. 垂直のバー

```json [settings]
{
  "terminal": {
    "cursor_shape": "bar"
  }
}
```

3. 次の文字に沿って引かれる下線（アンダースコア）

```json [settings]
{
  "terminal": {
    "cursor_shape": "underline"
  }
}
```

4. 次の文字を囲む枠

```json [settings]
{
  "terminal": {
    "cursor_shape": "hollow"
  }
}
```

### ターミナル: Keep Selection On Copy

- 説明: テキストをコピーした後も、ターミナル内の選択範囲を保持するかどうか。
- 設定: `keep_selection_on_copy`
- デフォルト: `true`

**オプション**

`boolean` 値

**例**

```json [settings]
{
  "terminal": {
    "keep_selection_on_copy": false
  }
}
```

### ターミナル: Env

- 説明: このオブジェクトに追加された任意のキーと値のペアは、ターミナルの環境変数に追加されます。キーは一意でなければならず、1 つの変数内で複数の値を指定するには `:` で区切ります。
- 設定: `env`
- デフォルト: `{}`

**例**

```json [settings]
{
  "terminal": {
    "env": {
      "ZED": "1",
      "KEY": "value1:value2"
    }
  }
}
```

### ターミナル: Font Size

- 説明: ターミナルで使用するフォントサイズ。設定されていない場合は、エディターのフォントサイズに合わせるのがデフォルトです。
- 設定: `font_size`
- デフォルト: `null`

**オプション**

`integer` 値

```json [settings]
{
  "terminal": {
    "font_size": 15
  }
}
```

### ターミナル: Font Family

- 説明: ターミナルで使用するフォント。設定されていない場合は、エディターのフォントに合わせるのがデフォルトです。
- 設定: `font_family`
- デフォルト: `null`

**オプション**

ユーザーのシステムにインストールされている任意のフォントファミリー名

```json [settings]
{
  "terminal": {
    "font_family": "Berkeley Mono"
  }
}
```

### ターミナル: Font Features

- 説明: ターミナルで使用するフォント機能。設定されていない場合は、エディターのフォント機能に合わせるのがデフォルトです。
- 設定: `font_features`
- デフォルト: `null`
- 対応プラットフォーム: macOS と Windows。

**オプション**

Buffer Font Features を参照してください

```json [settings]
{
  "terminal": {
    "font_features": {
      "calt": false
      // さらに多くの機能については Buffer Font Features を参照してください
    }
  }
}
```

### ターミナル: 行の高さ

- Description: ターミナルの行の高さを設定します。
- Setting: `line_height`
- Default: `standard`

**Options**

1. 読みやすさのために `comfortable` な行の高さ 1.618 を使用します。

```json [settings]
{
  "terminal": {
    "line_height": "comfortable"
  }
}
```

2. `standard` な行の高さ 1.3 を使用します。特に、罫線文字を使用する TUI で有用です。（デフォルト）

```json [settings]
{
  "terminal": {
    "line_height": "standard"
  }
}
```

3. カスタムの行の高さを使用します。

```json [settings]
{
  "terminal": {
    "line_height": {
      "custom": 2
    }
  }
}
```

### ターミナル: 最低コントラスト

- Description: ターミナル内の前景色と背景色の最小コントラストを制御します。色の調整には APCA (Accessible Perceptual Contrast Algorithm) を使用します。この機能を無効にするには 0 に設定します。
- Setting: `minimum_contrast`
- Default: `45`

**Options**

`0` から `106` までの `integer` 値。一般的に推奨される値は以下の通りです:

- `0`: コントラスト調整なし
- `45`: 大きなフルエントテキストのための最小値（デフォルト）
- `60`: その他のコンテンツテキストのための最小値
- `75`: 本文テキストのための最小値
- `90`: 本文テキストに推奨される値

```json [settings]
{
  "terminal": {
    "minimum_contrast": 45
  }
}
```

### ターミナル: Option を Meta として扱う

- Description: option キーを再解釈して、Emacs のような 'meta' キーとして動作させます。
- Setting: `option_as_meta`
- Default: `false`

**Options**

`boolean` 値

```json [settings]
{
  "terminal": {
    "option_as_meta": true
  }
}
```

### ターミナル: シェル

- Description: ターミナル起動時に使用するシェル。
- Setting: `shell`
- Default: `system`

**Options**

1. システムのデフォルトのターミナル設定（通常は `/etc/passwd` ファイル）を使用します。

```json [settings]
{
  "terminal": {
    "shell": "system"
  }
}
```

2. 起動するプログラム:

```json [settings]
{
  "terminal": {
    "shell": {
      "program": "sh"
    }
  }
}
```

3. 引数付きのプログラム:

```json [settings]
{
  "terminal": {
    "shell": {
      "with_arguments": {
        "program": "/bin/bash",
        "args": ["--login"]
      }
    }
  }
}
```

## ターミナル: 仮想環境の検出 {#terminal-detect_venv}

- Description: ターミナルの作業ディレクトリ（`working_directory` によって解決されます）で [Python Virtual Environment](https://docs.python.org/3/library/venv.html) が見つかった場合、それを有効化し、自動的に仮想環境をアクティブ化します。
- Setting: `detect_venv`
- Default:

```json [settings]
{
  "terminal": {
    "detect_venv": {
      "on": {
        // 現在の作業ディレクトリからの相対パスとして、
        // 仮想環境を検索するデフォルトのディレクトリです。
        // この設定はグローバルではなく、プロジェクトの設定で
        // 上書きすることを推奨します。
        "directories": [".env", "env", ".venv", "venv"],
        // `csh`、`fish`、`nushell` も指定できます
        "activate_script": "default"
      }
    }
  }
}
```

無効化するには:

```json [settings]
{
  "terminal": {
    "detect_venv": "off"
  }
}
```

### ターミナル: スクロール倍率

- Description: マウスホイールやトラックパッドを使用した際の、ターミナルでのスクロール速度の倍率。
- Setting: `scroll_multiplier`
- Default: `1.0`

**Options**

正の浮動小数点数。0 以下の値は、最小値 0.01 にクランプされます。

**Example**

```json
{
  "terminal": {
    "scroll_multiplier": 5.0
  }
}
```

## ターミナル: ツールバー

- Description: ターミナルのツールバーにさまざまな要素を表示するかどうか。
- Setting: `toolbar`
- Default:

```json [settings]
{
  "terminal": {
    "toolbar": {
      "breadcrumbs": false
    }
  }
}
```

**Options**

現時点では `breadcrumbs` オプションのみ利用可能で、`PROMPT_COMMAND` を通じて変更可能なターミナルタイトルの表示を制御します。

ターミナルタイトルが空の場合、breadcrumbs は表示されません。

ターミナル内で動作しているシェルは、タイトルを出力するように設定されている必要があります。

タイトルを設定するためのコマンド例: `echo -e "\e]2;New Title\007";`

### ターミナル: ボタン

- Description: ステータスバーにターミナルボタンを表示するか非表示にするかを制御します。
- Setting: `button`
- Default: `true`

**Options**

`boolean` 値

```json [settings]
{
  "terminal": {
    "button": false
  }
}
```

### ターミナル: 作業ディレクトリ

- Description: ターミナル起動時に使用する作業ディレクトリ。
- Setting: `working_directory`
- Default: `"current_project_directory"`

**Options**

1. 現在のファイルのディレクトリを使用し、見つからない場合はプロジェクトディレクトリ、さらにその後はワークスペース内の最初のプロジェクトにフォールバックします。

```json [settings]
{
  "terminal": {
    "working_directory": "current_file_directory"
  }
}
```

2. 現在のファイルのプロジェクトディレクトリを使用します。失敗した場合は、最初のプロジェクトディレクトリ戦略にフォールバックします。

```json [settings]
{
  "terminal": {
    "working_directory": "current_project_directory"
  }
}
```

3. このワークスペース内の最初のプロジェクトのディレクトリを使用します。さらにフォールバックとして、このプラットフォームのホームディレクトリを使用します。

```json [settings]
{
  "terminal": {
    "working_directory": "first_project_directory"
  }
}
```

4. 見つかる場合は、常にこのプラットフォームのホームディレクトリを使用します。

```json [settings]
{
  "terminal": {
    "working_directory": "always_home"
  }
}
```

5. 常に特定のディレクトリを使用します。この値はシェル展開されます。このパスが有効なディレクトリでない場合、ターミナルはこのプラットフォームのホームディレクトリをデフォルトとして使用します。

```json [settings]
{
  "terminal": {
    "working_directory": {
      "always": {
        "directory": "~/zed/projects/"
      }
    }
  }
}
```

### ターミナル: パスハイパーリンクの正規表現

- Description: パスのハイパーリンクを識別するために使用される正規表現。正規表現は 2 つの形式で指定できます。1 つの正規表現文字列、または文字列の配列（これは 1 つの複数行の正規表現文字列にまとめられます）。
- Setting: `path_hyperlink_regexes`
- Default:

```
```json [settings]
{
  "terminal": {
    "path_hyperlink_regexes": [
      // Python スタイルの診断
      "File \"(?<path>[^\"]+)\", line (?<line>[0-9]+)",
      // 行、列、説明、末尾の句読点、または囲み記号や引用符を任意で含む
      // 一般的なパス構文
      [
        "(?x)",
        "# optionally starts with 0-2 opening prefix symbols",
        "[({\\[<]{0,2}",
        "# which may be followed by an opening quote",
        "(?<quote>[\"'`])?",
        "# `path` is the shortest sequence of any non-space character",
        "(?<link>(?<path>[^ ]+?",
        "    # which may end with a line and optionally a column,",
        "    (?<line_column>:+[0-9]+(:[0-9]+)?|:?\\([0-9]+([,:][0-9]+)?\\))?",
        "))",
        "# which must be followed by a matching quote",
        "(?(<quote>)\\k<quote>)",
        "# and optionally a single closing symbol",
        "[)}\\]>]?",
        "# if line/column matched, may be followed by a description",
        "(?(<line_column>):[^ 0-9][^ ]*)?",
        "# which may be followed by trailing punctuation",
        "[.,:)}\\]>]*",
        "# and always includes trailing whitespace or end of line",
        "([ ]+|$)"
      ]
    ]
  }
}
```

### Terminal: Path Hyperlink Timeout (ms)

- Description: パスハイパーリンクを検索する最大時間。0 に設定すると、パスハイパーリンクは無効になります。
- Setting: `path_hyperlink_timeout_ms`
- Default: `1`

## REPL

- Description: REPL の設定。
- Setting: `repl`
- Default:

```json [settings]
{
  "repl": {
    // REPL のスクロールバックバッファーに保持する列数の最大値。
    // 範囲 [20, 512] に制限されます。
    "max_columns": 128,
    // REPL のスクロールバックバッファーに保持する行数の最大値。
    // 範囲 [4, 256] に制限されます。
    "max_lines": 32
  }
}
```

## Theme

- Description: テーマ設定は 2 通りの形式で指定できます。テーマ名として指定するか、Zed UI 用の `mode`、`dark`、`light` テーマを含むオブジェクトとして指定します。
- Setting: `theme`
- Default: `One Dark`

### Theme Object

- Description: `mode`、`dark`、`light` テーマを含むオブジェクトを使用してテーマを指定します。
- Setting: `theme`
- Default:

```json [settings]
{
  "theme": {
    "mode": "system",
    "dark": "One Dark",
    "light": "One Light"
  }
}
```

### Mode

- Description: テーマモードを指定します。
- Setting: `mode`
- Default: `system`

**Options**

1. テーマをダークモードに設定する

```json [settings]
{
  "theme": {
    "mode": "dark",
    "dark": "One Dark",
    "light": "One Light"
  }
}
```

2. テーマをライトモードに設定する

```json [settings]
{
  "theme": {
    "mode": "light",
    "dark": "One Dark",
    "light": "One Light"
  }
}
```

3. テーマをシステムモードに設定する

```json [settings]
{
  "theme": {
    "mode": "system",
    "dark": "One Dark",
    "light": "One Light"
  }
}
```

### Dark

- Description: UI に使用するダーク Zed テーマの名前。
- Setting: `dark`
- Default: `One Dark`

**Options**

有効なテーマ名の最新の一覧を確認するには、コマンドパレットで {#action theme_selector::Toggle} アクションを実行してください。

### Light

- Description: UI に使用するライト Zed テーマの名前。
- Setting: `light`
- Default: `One Light`

**Options**

有効なテーマ名の最新の一覧を確認するには、コマンドパレットで {#action theme_selector::Toggle} アクションを実行してください。

## Title Bar

- Description: タイトルバーにさまざまな要素を表示するかどうか。
- Setting: `title_bar`
- Default:

```json [settings]
{
  "title_bar": {
    "show_branch_icon": false,
    "show_branch_name": true,
    "show_project_items": true,
    "show_onboarding_banner": true,
    "show_user_picture": true,
    "show_user_menu": true,
    "show_sign_in": true,
    "show_menus": false,
    "button_layout": "platform_default"
  }
}
```

**Options**

- `show_branch_icon`: タイトルバーのブランチスイッチャーの横にブランチアイコンを表示するかどうか。
- `show_branch_name`: タイトルバーにブランチ名ボタンを表示するかどうか。
- `show_project_items`: タイトルバーにプロジェクトのホスト名と名前を表示するかどうか。
- `show_onboarding_banner`: タイトルバーにオンボーディングバナーを表示するかどうか。
- `show_user_picture`: タイトルバーにユーザーの画像を表示するかどうか。
- `show_user_menu`: タイトルバーにユーザーメニューボタンを表示するかどうか (デフォルトであなたのアバターを表示し、Settings、Keymap、Themes などのオプションを含みます)。
- `show_sign_in`: タイトルバーにサインインボタンを表示するかどうか。
- `show_menus`: タイトルバーにメニューを表示するかどうか。
- `button_layout`: タイトルバー内のウィンドウ操作ボタンのレイアウト (Linux のみ)。システム設定に従う `"platform_default"`、Zed の組み込みレイアウトを使用する `"standard"`、または `"close:minimize,maximize"` のようなカスタム形式を指定できます。

## Vim

- Description: Vim モードを有効にするかどうか。
- Setting: `vim_mode`
- Default: `false`

## When Closing With No Tabs

- Description: タブがないウィンドウで「close active item」を使用したときに、そのウィンドウを閉じるかどうか。
- Setting: `when_closing_with_no_tabs`
- Default: `"platform_default"`

**Options**

1. プラットフォームのデフォルトの挙動を使用する:

```json [settings]
{
  "when_closing_with_no_tabs": "platform_default"
}
```

2. 常にウィンドウを閉じる:

```json [settings]
{
  "when_closing_with_no_tabs": "close_window"
}
```

3. ウィンドウを閉じない:

```json [settings]
{
  "when_closing_with_no_tabs": "keep_window_open"
}
```

## Project Panel

- Description: プロジェクトパネルをカスタマイズします。
- Setting: `project_panel`
- Default:

```json [settings]
{
  "project_panel": {
    "button": true,
    "default_width": 240,
    "dock": "left",
    "entry_spacing": "comfortable",
    "file_icons": true,
    "folder_icons": true,
    "git_status": true,
    "indent_size": 20,
    "auto_reveal_entries": true,
    "auto_fold_dirs": true,
    "bold_folder_labels": false,
    "drag_and_drop": true,
    "scrollbar": {
      "show": null,
      "horizontal_scroll": true
    },
    "sticky_scroll": true,
    "show_diagnostics": "all",
    "indent_guides": {
      "show": "always"
    },
    "sort_mode": "directories_first",
    "hide_root": false,
    "hide_hidden": false,
    "starts_open": true,
    "auto_open": {
      "on_create": true,
      "on_paste": true,
      "on_drop": true
    }
  }
}
```

### Dock

- Description: ドックの位置を制御します。
- Setting: `dock`
- Default: `left`

**Options**

1. デフォルトのドック位置を左にする

```json [settings]
{
  "project_panel": {
    "dock": "left"
  }
}
```

2. デフォルトのドック位置を右にする

```json [settings]
{
  "project_panel": {
    "dock": "right"
  }
}
```

### Entry Spacing

- Description: ワークツリーエントリ間の間隔。
- Setting: `entry_spacing`
- Default: `comfortable`

**Options**

1. 快適なエントリ間隔

```json [settings]
{
  "project_panel": {
    "entry_spacing": "comfortable"
  }
}
```

2. 標準的なエントリ間隔

```json [settings]
{
  "project_panel": {
    "entry_spacing": "standard"
  }
}
```

### Git Status

- Description: 新しく作成されたファイルや更新されたファイルを示します。
- Setting: `git_status`
- Default: `true`

**Options**

1. デフォルトで git status を有効にする

```
```json [settings]
{
  "project_panel": {
    "git_status": true
  }
}
```

2. git status をデフォルトで無効にする

```json [settings]
{
  "project_panel": {
    "git_status": false
  }
}
```

### デフォルト幅

- 説明: プロジェクトパネルが占有するデフォルトの幅をカスタマイズします
- 設定: `default_width`
- デフォルト: `240`

**オプション**

`float` 値

### エントリの自動表示

- 説明: 対応するプロジェクトエントリがアクティブになったときに、それをプロジェクトパネルで自動的に表示するかどうかを指定します。Gitignore 対象のエントリが自動表示されることはありません。
- 設定: `auto_reveal_entries`
- デフォルト: `true`

**オプション**

1. エントリの自動表示を有効にする

```json [settings]
{
  "project_panel": {
    "auto_reveal_entries": true
  }
}
```

2. エントリの自動表示を無効にする

```json [settings]
{
  "project_panel": {
    "auto_reveal_entries": false
  }
}
```

### ディレクトリの自動折りたたみ

- 説明: ディレクトリ内に 1 つのディレクトリしか含まれていない場合に、自動的にディレクトリを折りたたむかどうか。
- 設定: `auto_fold_dirs`
- デフォルト: `true`

**オプション**

1. ディレクトリの自動折りたたみを有効にする

```json [settings]
{
  "project_panel": {
    "auto_fold_dirs": true
  }
}
```

2. ディレクトリの自動折りたたみを無効にする

```json [settings]
{
  "project_panel": {
    "auto_fold_dirs": false
  }
}
```

### フォルダラベルの太字表示

- 説明: プロジェクトパネルでフォルダ名を太字で表示するかどうか。
- 設定: `bold_folder_labels`
- デフォルト: `false`

**オプション**

1. フォルダラベルの太字表示を有効にする

```json [settings]
{
  "project_panel": {
    "bold_folder_labels": true
  }
}
```

2. フォルダラベルの太字表示を無効にする

```json [settings]
{
  "project_panel": {
    "bold_folder_labels": false
  }
}
```

### インデントサイズ

- 説明: 入れ子になった項目に対するインデント量 (ピクセル単位)。
- 設定: `indent_size`
- デフォルト: `20`

### インデントガイド: 表示

- 説明: プロジェクトパネルでインデントガイドを表示するかどうか。
- 設定: `indent_guides`
- デフォルト:

```json [settings]
{
  "project_panel": {
    "indent_guides": {
      "show": "always"
    }
  }
}
```

**オプション**

1. プロジェクトパネルでインデントガイドを表示する

```json [settings]
{
  "project_panel": {
    "indent_guides": {
      "show": "always"
    }
  }
}
```

2. プロジェクトパネルでインデントガイドを非表示にする

```json [settings]
{
  "project_panel": {
    "indent_guides": {
      "show": "never"
    }
  }
}
```

### スクロールバー

- 説明: プロジェクトパネルのスクロールバーに関する設定。
- 設定: `scrollbar`
- デフォルト:

```json [settings]
{
  "project_panel": {
    "scrollbar": {
      "show": null,
      "horizontal_scroll": true
    }
  }
}
```

**オプション**

- `show`: プロジェクトパネルにスクロールバーを表示するかどうか。指定可能な値: null, "auto", "system", "always", "never"。指定されていない場合はエディタの設定を継承します。詳細については、エディタ設定の説明を参照してください。
- `horizontal_scroll`: プロジェクトパネルで水平スクロールを許可するかどうか。`false` の場合、ビューは最も左側の位置に固定され、長いファイル名は切り詰められます。

### ソートモード

- 説明: プロジェクトパネル内のエントリのソート順
- 設定: `sort_mode`
- デフォルト: `directories_first`

**オプション**

1. 先にディレクトリ、その後にファイルを表示する

```json [settings]
{
  "project_panel": {
    "sort_mode": "directories_first"
  }
}
```

2. ディレクトリとファイルを混在させて表示する

```json [settings]
{
  "project_panel": {
    "sort_mode": "mixed"
  }
}
```

3. 先にファイル、その後にディレクトリを表示する

```json [settings]
{
  "project_panel": {
    "sort_mode": "files_first"
  }
}
```

### 自動オープン

- 説明: プロジェクトパネル内のさまざまな作成フローの後に、ファイルを自動的に開くかどうかを制御します。
- 設定: `auto_open`
- デフォルト:

```json [settings]
{
  "project_panel": {
    "auto_open": {
      "on_create": true,
      "on_paste": true,
      "on_drop": true
    }
  }
}
```

**オプション**

- `on_create`: 新しく作成されたファイルをエディタで自動的に開くかどうか。
- `on_paste`: 貼り付けまたは複製後にファイルを自動的に開くかどうか。
- `on_drop`: 外部ソースからドロップされたファイルを自動的に開くかどうか。

## エージェント

エージェント関連のすべての設定については、AI セクションにある [Configuration ページ](../ai/configuration.md) を参照してください。

## コラボレーションパネル

- 説明: コラボレーションパネルのカスタマイズ。
- 設定: `collaboration_panel`
- デフォルト:

```json [settings]
{
  "collaboration_panel": {
    "button": true,
    "dock": "left",
    "default_width": 240
  }
}
```

**オプション**

- `button`: ステータスバーにコラボレーションパネルボタンを表示するかどうか
- `dock`: コラボレーションパネルをドックする位置。`left` または `right` を指定できます
- `default_width`: コラボレーションパネルのデフォルト幅

## デバッガー

- 説明: デバッガーパネルおよび設定の構成
- 設定: `debugger`
- デフォルト:

```json [settings]
{
  "debugger": {
    "stepping_granularity": "line",
    "save_breakpoints": true,
    "dock": "bottom",
    "button": true
  }
}
```

Zed 内のデバッグサポートの詳細については、[debugger ページ](../debugger.md) を参照してください。

## Git パネル

- 説明: Git パネルの動作をカスタマイズするための設定。
- 設定: `git_panel`
- デフォルト:

```json [settings]
{
  "git_panel": {
    "button": true,
    "dock": "left",
    "default_width": 360,
    "status_style": "icon",
    "fallback_branch_name": "main",
    "sort_by_path": false,
    "collapse_untracked_diff": false,
    "scrollbar": {
      "show": null
    },
    "starts_open": false
  }
}
```

**オプション**

- `button`: ステータスバーに Git パネルボタンを表示するかどうか
- `dock`: Git パネルをドックする位置。`left` または `right` を指定できます
- `default_width`: Git パネルのデフォルト幅
- `status_style`: Git ステータスの表示方法。`label_color` または `icon` を指定できます
- `fallback_branch_name`: `init.defaultBranch` が設定されていない場合に使用するブランチ名
- `sort_by_path`: パネル内のエントリをステータス (デフォルト) ではなくパスでソートするかどうか
- `collapse_untracked_diff`: diff パネル内の未追跡ファイルを折りたたむかどうか
- `scrollbar`: Git パネルのスクロールバーをいつ表示するか
- `starts_open`: 起動時に Git パネルを開いた状態にするかどうか

## Git Worktree ディレクトリ

- 説明: リポジトリの作業ディレクトリからの相対パスで指定される、git worktree が作成されるディレクトリ。
- 設定: `git.worktree_directory`
- デフォルト: `"../worktrees"`

解決されたディレクトリがプロジェクトルートの外側になる場合、同じ階層のリポジトリ同士が衝突しないように、プロジェクトのディレクトリ名が自動的に末尾に追加されます。例えば、デフォルトの `"../worktrees"` を使用し、プロジェクトが `~/code/zed` にある場合、worktree は `~/code/worktrees/zed/` 配下に作成されます。

解決されたディレクトリがプロジェクトルート内にある場合は、すでにプロジェクト単位でスコープされているため、追加のコンポーネントは付加されません。

**例**:

- `"../worktrees"` — `~/code/worktrees/<project>/` (デフォルト)
- `".git/zed-worktrees"` — `<project>/.git/zed-worktrees/`
- `"my-worktrees"` — `<project>/my-worktrees/`

末尾のスラッシュは無視されます。

```json [settings]
{
  "git": {
    "worktree_directory": "../worktrees"
  }
}
```

## Git ホスティングプロバイダー

- 説明: コミットハッシュ、課題参照、パーマリンクが正しいホストに解決されるように、セルフホストの GitHub、GitLab、Bitbucket インスタンスを登録します。
- 設定: `git_hosting_providers`
- デフォルト: `[]`

**オプション**

各エントリで指定できる値:

- `provider`: `github`、`gitlab`、`bitbucket` のいずれか
- `name`: インスタンスの表示名
- `base_url`: ベース URL（例: `https://git.example.corp`）

これらはユーザー設定またはプロジェクト設定で定義できます。プロジェクト設定はユーザー設定の上にマージされます。

```json [settings]
{
  "git_hosting_providers": [
    {
      "provider": "github",
      "name": "BigCorp GitHub",
      "base_url": "https://git.example.corp"
    }
  ]
}
```

## Outline パネル

- 説明: Outline パネルをカスタマイズします
- 設定: `outline_panel`
- デフォルト:

```json [settings]
{
  "outline_panel": {
    "button": true,
    "default_width": 300,
    "dock": "left",
    "file_icons": true,
    "folder_icons": true,
    "git_status": true,
    "indent_size": 20,
    "auto_reveal_entries": true,
    "auto_fold_dirs": true,
    "indent_guides": {
      "show": "always"
    },
    "scrollbar": {
      "show": null
    }
  }
}
```

## 通話

- 説明: 通話に参加しているときの動作をカスタマイズします
- 設定: `calls`
- デフォルト:

```json [settings]
{
  "calls": {
    // デフォルトでマイクをオンにした状態で通話に参加します
    "mute_on_join": false,
    // チャンネルに最初に参加したときにプロジェクトを共有します
    "share_on_join": false
  }
}
```

## 括弧のカラーリング

- 説明: エディタ内の括弧を検出して色分けするために tree-sitter の bracket クエリを使用するかどうか（「レインボーブラケット」とも呼ばれます）。
- 設定: `colorize_brackets`
- デフォルト: `false`

**オプション**

`boolean` 値

インデントレベルごとに使用される色は、テーマ（テーマキー: `accents`）で定義されています。テーマのオーバーライドを使ってカスタマイズできます。

## 未使用コードのフェード

- 説明: 未使用コードをどの程度フェードアウトするか。
- 設定: `unnecessary_code_fade`
- デフォルト: `0.3`

**オプション**

`0.0` から `0.9` の範囲の浮動小数点値で、次のような意味を持ちます:

- `0.0` はフェードなし（未使用コードが使用中のコードと同じ見た目）
- `0.9` は最大のフェード（未使用コードは非常に薄いが、まだ見える状態）

**例**

```json [settings]
{
  "unnecessary_code_fade": 0.5
}
```

## UI フォントファミリ

- 説明: UI のテキストに使用するフォント名。
- 設定: `ui_font_family`
- デフォルト: `.ZedSans`。これは現在 [IBM Plex](https://www.ibm.com/plex/) へのエイリアスです。

**オプション**

システムにインストールされている任意のフォントファミリ名、Zed が提供するデフォルトを使用する場合は `".ZedSans"`、システムのデフォルト UI フォント（macOS と Windows）を使用する場合は `".SystemUIFont"`。

## UI フォント機能

- 説明: UI のテキストに対して有効にする OpenType 機能。
- 設定: `ui_font_features`
- デフォルト:

```json [settings]
{
  "ui_font_features": {
    "calt": false
  }
}
```

- プラットフォーム: macOS と Windows

**オプション**

Zed は、指定した UI フォントで有効・無効を切り替えられるすべての OpenType 機能およびフォント機能の値設定をサポートします。

例えば、合字を無効にするには、設定に次を追加します:

```json [settings]
{
  "ui_font_features": {
    "calt": false
  }
}
```

また、`cv01` を `7` に設定するなど、他の OpenType 機能も設定できます:

```json [settings]
{
  "ui_font_features": {
    "cv01": 7
  }
}
```

## UI フォントフォールバック

- 説明: UI のテキストに対して使用するフォントフォールバック。
- 設定: `ui_font_fallbacks`
- デフォルト: `null`
- プラットフォーム: macOS と Windows

**オプション**

例えば、フォールバックとして `Nerd Font` を使用するには、設定に次を追加します:

```json [settings]
{
  "ui_font_fallbacks": ["Nerd Font"]
}
```

## UI フォントサイズ

- 説明: UI のテキストのデフォルトフォントサイズ。
- 設定: `ui_font_size`
- デフォルト: `16`

**オプション**

`6` から `100` ピクセル（両端を含む）の `integer` 値

## UI フォントウェイト

- 説明: UI のテキストのデフォルトフォントウェイト。
- 設定: `ui_font_weight`
- デフォルト: `400`

**オプション**

`100` から `900` の `integer` 値

## 設定プロファイル

- 説明: `settings profile selector: toggle` から選択したときに一時的に適用される設定プロファイルを、任意の数だけ構成します。
- 設定: `profiles`
- デフォルト: `{}`

`settings.json` ファイルに `profiles` オブジェクトを追加します。
このオブジェクト内の各キーが設定プロファイルの名前です。各プロファイルにはオプションの `base` フィールド（`"user"` または `"default"`）と、任意の Zed の設定を含む `settings` オブジェクトがあります。

例:

```json [settings]
{
  "profiles": {
    "Presenting (Dark)": {
      "settings": {
        "agent_buffer_font_size": 18.0,
        "buffer_font_size": 18.0,
        "theme": "One Dark",
        "ui_font_size": 18.0
      }
    },
    "Presenting (Light)": {
      "settings": {
        "agent_buffer_font_size": 18.0,
        "buffer_font_size": 18.0,
        "theme": "One Light",
        "ui_font_size": 18.0
      }
    },
    "Writing": {
      "settings": {
        "agent_buffer_font_size": 15.0,
        "buffer_font_size": 15.0,
        "theme": "Catppuccin Frappé - No Italics",
        "ui_font_size": 15.0,
        "tab_bar": { "show": false },
        "toolbar": { "breadcrumbs": false }
      }
    }
  }
}
```

設定プロファイルをプレビューして有効にするには、{#kb command_palette::Toggle} でコマンドパレットを開き、`settings profile selector: toggle` を検索します。

## 設定例

```json [settings]
// ~/.config/zed/settings.json
{
  "theme": "cave-light",
  "tab_size": 2,
  "preferred_line_length": 80,
  "soft_wrap": "none",

  "buffer_font_size": 18,
  "buffer_font_family": ".ZedMono",

  "autosave": "on_focus_change",
  "format_on_save": "off",
  "vim_mode": false,
  "terminal": {
    "font_family": "FiraCode Nerd Font Mono",
    "blinking": "off"
  },
  "languages": {
    "C": {
      "format_on_save": "on",
      "formatter": "language_server",
      "preferred_line_length": 64,
      "soft_wrap": "preferred_line_length"
    }
  }
}
```
