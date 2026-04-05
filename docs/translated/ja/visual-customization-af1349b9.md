# 表示のカスタマイズ

Zed のビジュアルレイアウトのさまざまな側面は、Settings Editor ({#kb zed::OpenSettings}) か、設定ファイル ({#kb zed::OpenSettingsFile}) で設定できます。

詳細情報やその他のビジュアル以外の設定については、[All Settings](./reference/all-settings.md) を参照してください。

## テーマ

コマンドパレットから {#action zed::Extensions} を実行することで、多くの [テーマ](./themes.md) および [アイコンテーマ](./icon-themes.md) を拡張機能としてインストールできます。

インストール済みのテーマおよびアイコンテーマは、{#action theme_selector::Toggle} ({#kb theme_selector::Toggle}) と {#action icon_theme_selector::Toggle} を使ってプレビュー／選択でき、これにより次の設定が変更されます。

```json [settings]
{
  "theme": "One Dark",
  "icon_theme": "Zed (Default)"
}
```

ライトモードとダークモードで別々のテーマを使用したい場合は、次のように設定できます。

```json [settings]
{
  "theme": {
    "dark": "One Dark",
    "light": "One Light",
    // 使用するモード（dark, light）または OS のライト／ダークモードに追従する "system"（デフォルト）
    "mode": "system"
  },
  "icon_theme": {
    "dark": "Zed (Default)",
    "light": "Zed (Default)",
    // 使用するモード（dark, light）または OS のライト／ダークモードに追従する "system"（デフォルト）
    "mode": "system"
  }
}
```

## フォント

```json [settings]
  // UI フォント。デフォルトのシステムフォント（macOS では SF Pro）を使うには ".SystemUIFont" を使用します
  // 同梱されているデフォルトフォント（現在は IBM Plex）を使うには ".ZedSans" を使用します
  "ui_font_family": ".SystemUIFont",
  "ui_font_weight": 400, // フォントウェイト。標準的な CSS の単位で 100 から 900 まで指定します。
  "ui_font_size": 16,

  // バッファフォント - エディターバッファで使用されます
  // 同梱されているデフォルトの等幅フォント（現在は Lilex）を使うには ".ZedMono" を使用します
  "buffer_font_family": "Berkeley Mono", // エディターバッファ用のフォント名
  "buffer_font_size": 15,                 // エディターバッファ用のフォントサイズ
  "buffer_font_weight": 400,              // フォントウェイト（CSS の単位 [100-900]）
  // 行の高さは "comfortable" (1.618)、"standard" (1.3)、または `{ "custom": 2 }` でカスタムを指定できます
  "buffer_line_height": "comfortable",

  // ターミナルフォントの設定
  "terminal": {
    "font_family": "",
    "font_size": 15,
    // ターミナルの行の高さ: comfortable (1.618)、standard (1.3) または `{ "custom": 2 }`
    "line_height": "standard",
  },

  // エージェントパネル内のエージェントの応答に使われるフォントサイズを制御します。
  // 指定しない場合は UI フォントサイズが使用されます。
  "agent_ui_font_size": 15,
  // エージェントパネルのメッセージエディター、ユーザーメッセージ、
  // その他のコードスニペットに対して使用するフォントサイズを制御します。
  "agent_buffer_font_size": 12
```

### フォント合字

デフォルトでは、Zed はフォント合字を有効にしており、特定の隣接した文字を視覚的に結合して表示します。

たとえば `=>` は `→`、`!=` は `≠` のように表示されます。
これは見た目だけのものであり、実際の文字自体は変更されません。

この動作を無効にするには、次のように設定します。

```json [settings]
{
  "buffer_font_features": {
    "calt": false // 合字を無効にする
  }
}
```

### ステータスバー

```json [settings]
{
  // 行インジケーターに完全なラベルを表示するか、省略表示するかを指定します
  //   - `short`: "2 s, 15 l, 32 c"
  //   - `long`: "2 selections, 15 lines, 32 characters"
  "line_indicator_format": "long"

  // ステータスバーの各アイコンは個別に非表示にできます:
  // "project_panel": {"button": false },
  // "outline_panel": {"button": false },
  // "collaboration_panel": {"button": false },
  // "git_panel": {"button": false },
  // "notification_panel": {"button": false },
  // "agent": {"button": false },
  // "debugger": {"button": false },
  // "diagnostics": {"button": false },
  // "search": {"button": false },
}
```

### タイトルバー

```json [settings]
  // タイトルバーに表示／非表示にする項目を制御します
  "title_bar": {
    "show_branch_icon": false,      // ブランチスイッチャーの横にあるブランチアイコンを表示／非表示にします
    "show_branch_name": true,       // ブランチ名を表示／非表示にします
    "show_project_items": true,     // プロジェクトのホスト名とプロジェクト名を表示／非表示にします
    "show_onboarding_banner": true, // オンボーディングバナーを表示／非表示にします
    "show_user_picture": true,      // ユーザーアバターを表示／非表示にします
    "show_user_menu": true,         // アプリのユーザーボタンを表示／非表示にします
    "show_sign_in": true,           // サインインボタンを表示／非表示にします
    "show_menus": false             // メニューを表示／非表示にします
  },
```

## ワークスペース

```json [settings]
{
  // Zed 組み込みのパスプロンプト（ファイル／ディレクトリピッカー）を強制的に使用します
  // OS ネイティブのピッカーの代わりに使用します（false）。
  "use_system_path_prompts": true,
  // Zed 組み込みの確認プロンプト（"Do you want to save?"）を強制的に使用します
  // OS ネイティブのプロンプトの代わりに使用します（false）。Linux ではこの設定は無視されます（常に false）。
  "use_system_prompts": true,

  // アクティブペインのスタイル設定です。
  "active_pane_modifiers": {
    // アクティブペインの内側のボーダーサイズ（ピクセル単位）
    "border_size": 0.0,
    // 非アクティブペインの不透明度。0 は透明、1 は不透明を意味します。
    "inactive_opacity": 1.0
  },

  // 下部ドックのレイアウトモード: contained, full, left_aligned, right_aligned
  "bottom_dock_layout": "contained",

  // ドックのサイズ変更時に、そのドック内のすべてのパネルを同時にリサイズするかどうか。
  // "left"、"right"、"bottom" の組み合わせを指定できます。
  "resize_all_panels_in_dock": ["left"]
}
```

<!--
TBD: 中央配置レイアウトに関連する設定
```json [settings]
    "centered_layout": {
    // 中央配置レイアウトを使用する場合の中央ペイン左側パディングの相対幅を
    // ワークスペース全体に対して指定します。
    "left_padding": 0.2,
    // 中央配置レイアウトを使用する場合の中央ペイン右側パディングの相対幅を
    // ワークスペース全体に対して指定します。
    "right_padding": 0.2
    },
```
-->

## エディター

```
```json [settings]
  // エディター内でカーソルを点滅させるかどうか。
  "cursor_blink": true,

  // デフォルトエディターのカーソル形状: bar, block, underline, hollow
  "cursor_shape": null,

  // エディターで現在行をハイライトするかどうか: none, gutter, line, all
  "current_line_highlight": "all",

  // マウスカーソルをいつ非表示にするか: never, on_typing, on_typing_and_movement
  "hide_mouse": "on_typing_and_movement",

  // エディター内で選択テキストの出現箇所をすべてハイライトするかどうか。
  "selection_highlight": true,

  // タブとスペースを視覚的に表示するかどうか (none, all, selection, boundary, trailing)
  "show_whitespaces": "selection",
  "whitespace_map": { // `show_whitespaces` が有効なときに表示する文字
    "space": "•",
    "tab": "⟶"       // より短い矢印にするには "→" を使用
  },

  "unnecessary_code_fade": 0.3, // 未使用コードをどの程度フェードアウトするか。

  // プライベートファイルで変数の値を画面表示から隠すかどうか
  "redact_private_values": false,

  // ソフトラップとルーラー
  "soft_wrap": "none",          // none, editor_width, preferred_line_length, bounded
  "preferred_line_length": 80,  // ソフトラップする列位置
  "show_wrap_guides": true,     // ラップガイド (縦のルーラー) を表示/非表示にする
  "wrap_guides": [],            // wrap_guides を配置する位置 (文字数)

  // ガターの設定
  "gutter": {
    "line_numbers": true,         // ガターに行番号を表示/非表示にする。
    "runnables": true,            // ガターに runnables ボタンを表示/非表示にする。
    "breakpoints": true,          // ガターにブレークポイントを表示/非表示にする。
    "folds": true,                // ガターに折りたたみボタンを表示/非表示にする。
    "min_line_number_digits": 4   // N 桁の行番号用にスペースを確保する
  },
  "relative_line_numbers": "enabled", // ガターに相対行番号を表示する

  // インデントガイド
  "indent_guides": {
    "enabled": true,
    "line_width": 1,                  // ガイドの幅 (ピクセル単位) [1-10]
    "active_line_width": 1,           // アクティブガイドの幅 (ピクセル単位) [1-10]
    "coloring": "fixed",              // disabled, fixed, indent_aware
    "background_coloring": "disabled" // disabled, indent_aware
  },

  "sticky_scroll": {
    "enabled": false // スコープをエディター上部に固定するかどうか。デフォルトでは無効。
  }
```

### Git Blame {#editor-blame}

```json [settings]
  "git": {
    "inline_blame": {
      "enabled": true,             // インラインの blame を表示/非表示にする
      "delay_ms": 0,               // 遅延後に表示する (ミリ秒)
      "min_column": 0,             // blame をインライン表示する最小カラム
      "padding": 7,                // コードとインライン blame の間の余白 (em)
      "show_commit_summary": false // コミットサマリーを表示/非表示にする
    },
    "hunk_style": "staged_hollow"  // staged_hollow, unstaged_hollow
  }
```

### エディターのツールバー

```json [settings]
  // エディターツールバー関連の設定
  "toolbar": {
    "breadcrumbs": true, // パンくずリストを表示するかどうか。
    "quick_actions": true, // クイックアクションボタンを表示するかどうか。
    "selections_menu": true, // Selections メニューを表示するかどうか
    "agent_review": true, // エージェントレビュー用ボタンを表示するかどうか
    "code_actions": false // コードアクションボタンを表示するかどうか
  }
```

### エディターのスクロールバーとミニマップ {#editor-scrollbar}

```json [settings]
  // スクロールバー関連の設定
  "scrollbar": {
    // エディターでスクロールバーを表示するタイミング (auto, system, always, never)
    "show": "auto",
    "cursors": true,          // スクロールバー内にカーソル位置を表示する。
    "git_diff": true,         // スクロールバー内に git diff のインジケーターを表示する。
    "search_results": true,   // スクロールバー内にバッファ検索結果を表示する。
    "selected_text": true,    // スクロールバー内に選択テキストの出現箇所を表示する。
    "selected_symbol": true,  // スクロールバー内に選択シンボルの出現箇所を表示する。
    "diagnostics": "all",     // 診断を表示する (none, error, warning, information, all)
    "axes": {
      "horizontal": true,     // 水平スクロールバーを表示/非表示にする
      "vertical": true        // 垂直スクロールバーを表示/非表示にする
    }
  },

  // ミニマップ関連の設定
  "minimap": {
    "show": "never",                // 表示タイミング (auto, always, never)
    "display_in": "active_editor",  // 表示場所 (active_editor, all_editor)
    "thumb": "always",              // サムを表示するタイミング (always, hover)
    "thumb_border": "left_open",    // サムの境界線 (left_open, right_open, full, none)
    "max_width_columns": 80,        // ミニマップの最大幅
    "current_line_highlight": null  // 現在行をハイライトする方法 (null, line, gutter)
  },

  // エディターを最終行の先までスクロールさせるか: off, one_page, vertical_scroll_margin
  "scroll_beyond_last_line": "one_page",
  // キーボードスクロール時にカーソルの上下に確保しておく行数
  "vertical_scroll_margin": 3,
  // マウススクロール時に左右に確保しておく文字数
  "horizontal_scroll_margin": 5,
  // スクロール感度の倍率
  "scroll_sensitivity": 1.0,
  // 高速スクロール用のスクロール感度倍率 (スクロール中に Alt を押下)
  "fast_scroll_sensitivity": 4.0,
```

### エディタータブ

```json [settings]
  // ペインごとのタブの最大数。未設定の場合は無制限。
  "max_tabs": null,

  // タブバーの見た目をカスタマイズする
  "tab_bar": {
    "show": true,                     // タブバーを表示/非表示にする
    "show_nav_history_buttons": true, // タブバー上の履歴ボタンを表示/非表示にする
    "show_tab_bar_buttons": true      // new、split、zoom ボタンを表示/非表示にする
  },
  "tabs": {
    "git_status": false,              // git status を示す色
    "close_position": "right",        // 閉じるボタンの位置 (left, right, hidden)
    "show_close_button": "hover",     // 閉じるボタンを表示するタイミング (hover, always, hidden)
    "file_icons": false,              // ファイルタイプを示すアイコン
    // ファイルアイコン内に診断を表示する (off, errors, all)。file_icons=true が必要
    "show_diagnostics": "off"
  }
```

### ステータスバー

```json [settings]
  "status_bar": {
    // アクティブなバッファの言語を表示するボタンを表示/非表示にする。
    // ボタンをクリックすると言語セレクターが開く。
    // 既定値は true。
    "active_language_button": true,
    // カーソル位置を表示するボタンを表示/非表示にする。
    // ボタンをクリックすると行・列へジャンプする入力欄が開く。
    // 既定値は true。
    "cursor_position_button": true,
    // バッファの改行モードを表示するボタンを表示/非表示にする。
    // ボタンをクリックすると改行コードセレクターが開く。
    // 既定値は false。
    "line_endings_button": false,
    // バッファの文字エンコーディングを表示するボタンを表示/非表示にする。
    // "non_utf8" に設定すると、BOM なしの UTF-8 の場合にのみボタンを非表示にする。
    // 既定値は "non_utf8"。
    "active_encoding_button": "non_utf8"
  },
  "global_lsp_settings": {
    // ステータスバーに LSP ボタンを表示/非表示にする。
    // LSP からのアクティビティは引き続き表示される。
    // "enable_language_server" が false の場合、ボタンは表示されない。
    "button": true
  },
```

### マルチバッファ

```json [settings]
{
  // multibuffer で抜粋を展開するときに使用するデフォルトの行数。
  "expand_excerpt_lines": 5,
  // multibuffer で抜粋に付与されるコンテキスト行数のデフォルト値。
  "excerpt_context_lines": 2
}
```

### エディタの補完、スニペット、アクション、診断 {#editor-lsp}

```json [settings]
  "snippet_sort_order": "inline",        // スニペット補完の表示順: top, inline, bottom, none
  "show_completions_on_input": true,     // 入力中に補完候補を表示する
  "show_completion_documentation": true, // 補完候補にドキュメントを表示する
  "auto_signature_help": false,          // かっこの内部にメソッドシグネチャを表示する

  // 補完の後、またはかっこが挿入された後にシグネチャヘルプを表示するかどうか。
  // `auto_signature_help` が有効な場合、この設定も有効として扱われます。
  "show_signature_help_after_edits": false,

  // バッファ行の先頭にコードアクションボタンを表示するかどうか。
  "inline_code_actions": true,

  // エディタに表示される診断メッセージをフィルタリングする際に使用するレベル:
  "diagnostics_max_severity": null,      // off, error, warning, info, hint, null (すべて)

  // エディタ内で LSP の `textDocument/documentColor` の色をどのようにレンダリングするか。
  "lsp_document_colors": "inlay",        // none, inlay, border, background
  // 補完メニューにスクロールバーを表示するタイミング。
  "completion_menu_scrollbar": "never", // auto, system, always, never
  // エディタでかっこのカラー化を有効にする (言語ごとに設定可能)
  "colorize_brackets": true,
```

### 編集予測 {#editor-ai}

```json [settings]
  "edit_predictions": {
    "mode": "eager"                  // 自動的に表示する (eager) か、hold-alt で表示する (subtle) か
  },
  "show_edit_predictions": true     // エディタ内で予測を表示/非表示にする
```

### エディタのインレイヒント

```json [settings]
{
  "inlay_hints": {
    "enabled": false,
    // 特定の種類のヒントをオン/オフ切り替える。デフォルトではすべてオン。
    "show_type_hints": true,
    "show_parameter_hints": true,
    "show_other_hints": true,

    // インレイヒントに背景を表示するかどうか (テーマ `hint.background`)
    "show_background": false, //

    // 編集後、ヒントを要求するまでの待ち時間 (0 でデバウンスを無効化)
    "edit_debounce_ms": 700,
    // スクロール後、ヒントを要求するまでの待ち時間 (0 でデバウンスを無効化)
    "scroll_debounce_ms": 50,

    // 押されたときにインレイヒントの表示/非表示を切り替える修飾キーのセット。
    "toggle_on_modifiers_press": {
      "control": false,
      "shift": false,
      "alt": false,
      "platform": false,
      "function": false
    }
  }
}
```

## ファイルファインダー

```json [settings]
  // File Finder の設定
  "file_finder": {
    "file_icons": true,         // ファイルアイコンの表示/非表示
    "modal_max_width": "small", // 横幅: small, medium, large, xlarge, full
    "include_ignored": null     // 結果に gitignore 対象ファイルを含めるか: true, false, null
  },
```

## Project パネル

Project パネルは {#action project_panel::ToggleFocus} ({#kb project_panel::ToggleFocus}) または {#action pane::RevealInProjectPanel} ({#kb pane::RevealInProjectPanel}) で表示/非表示を切り替えられます。

```json [settings]
  // Project パネルの設定
  "project_panel": {
    "button": true,                 // ステータスバーにボタンを表示/非表示
    "default_width": 240,           // パネルのデフォルト幅
    "dock": "left",                 // ドックの位置 (left, right)
    "entry_spacing": "comfortable", // 垂直方向の間隔 (comfortable, standard)
    "file_icons": true,             // ファイルアイコンの表示/非表示
    "folder_icons": true,           // フォルダーアイコンの表示/非表示
    "git_status": true,             // 新規/更新されたファイルを示す
    "indent_size": 20,              // 1 階層ごとのインデントのピクセル数
    "auto_reveal_entries": true,    // バッファをアクティブにしたときにパネル上でそのファイルを表示する
    "auto_fold_dirs": true,         // 単一のサブディレクトリしか持たないディレクトリを折りたたむ
    "bold_folder_labels": false,    // フォルダー名を太字で表示する
    "sticky_scroll": true,          // Project パネルの上部に親ディレクトリを固定する
    "drag_and_drop": true,          // ドラッグ＆ドロップを有効にするかどうか
    "scrollbar": {                  // Project パネルのスクロールバー設定
      "show": null                  // 表示/非表示: (auto, system, always, never)
    },
    "show_diagnostics": "all",      //
    // Project パネルのインデントガイドに関する設定。
    "indent_guides": {
      // Project パネルでインデントガイドを表示するタイミング。 (always, never)
      "show": "always"
    },
    // エントリのソート順 (directories_first, mixed, files_first)
    "sort_mode": "directories_first",
    // ウィンドウで 1 つのフォルダーのみ開かれている場合にルートエントリを非表示にするかどうか。
    // これは、ファイルファインダー履歴に表示されるファイルパスにも影響します。
    "hide_root": false,
    // Project パネルで隠しエントリを非表示にするかどうか。
    "hide_hidden": false
  }
```

## Agent パネル

```json [settings]
{
  "agent": {
    "enabled": true, // Agent の有効/無効を切り替える
    "button": true, // ステータスバーのアイコンの表示/非表示
    "dock": "right", // ドックする場所: left, right, bottom
    "default_width": 640, // デフォルト幅 (left/right にドックした場合)
    "default_height": 320 // デフォルト高さ (bottom にドックした場合)
  },
  // Agent パネル内の Agent の応答に使用されるフォントサイズを制御します。
  // 指定されていない場合は、UI フォントサイズが使用されます。
  "agent_ui_font_size": 15,
  // Agent パネルのメッセージエディタ、ユーザーメッセージ、
  // およびその他のコードスニペットに使用されるフォントサイズを制御します。
  "agent_buffer_font_size": 12
}
```

追加の非視覚的な AI 設定については、[Zed AI Documentation](./ai/overview.md) を参照してください。

## ターミナルパネル

```json [settings]
  // ターミナルパネルの設定
  "terminal": {
    "dock": "bottom",                   // ドックする場所: left, right, bottom
    "button": true,                     // ステータスバーアイコンの表示/非表示
    "default_width": 640,               // デフォルト幅 (left/right にドックした場合)
    "default_height": 320,              // デフォルト高さ (bottom にドックした場合)

    // ターミナル内のカーソル点滅の挙動 (on, off, terminal_controlled) を設定
    "blinking": "terminal_controlled",
    // ターミナルカーソルのデフォルト形状 (block, bar, underline, hollow)
    "cursor_shape": "block",

    // ターミナルのプロセス環境に追加する環境変数
    "env": {
      // "KEY": "value"
    },

    // ターミナルのスクロールバー
    "scrollbar": {
      "show": null                       // 表示/非表示: (auto, system, always, never)
    },
    // ターミナルフォントの設定
    "font_family": "Fira Code",
    "font_size": 15,
    "font_weight": 400,
    // ターミナルの行の高さ: comfortable (1.618), standard(1.3) または `{ "custom": 2 }`
    "line_height": "comfortable",

    "max_scroll_history_lines": 10000,   // スクロールバック履歴 (0=無効, 最大=100000)
  }
```

追加の非視覚的なカスタマイズオプションについては、[Terminal settings](./reference/all-settings.md#terminal) を参照してください。

### その他のパネル

```json [settings]
  // Git パネル
  "git_panel": {
    "button": true,               // ステータスバーアイコンの表示/非表示
    "dock": "left",               // ドッキング位置: left, right
    "default_width": 360,         // Git パネルのデフォルト幅。
    "status_style": "icon",       // label_color, icon
    "sort_by_path": false,        // パス (false) またはステータス (true) でソート
    "scrollbar": {
      "show": null                // スクロールバーの表示/非表示: (auto, system, always, never)
    }
  },

  // デバッガーパネル
  "debugger": {
    "dock": "bottom",             // ドッキング位置: left, right, bottom
    "button": true                // ステータスバーアイコンの表示/非表示
  },

  // アウトラインパネル
  "outline_panel": {
    "button": true,               // ステータスバーアイコンの表示/非表示
    "default_width": 300,         // Git パネルのデフォルト幅
    "dock": "left",               // ドッキング位置: left, right
    "file_icons": true,           // file_icons の表示/非表示
    "folder_icons": true,         // ディレクトリに対して file_icons (true) または chevrons (false) を表示
    "git_status": true,           // Git ステータスを表示
    "indent_size": 20,            // ネストされた項目のインデント量 (ピクセル)
    "indent_guides": {
      "show": "always"            // インデントガイドの表示: (always, never)
    },
    "auto_reveal_entries": true,  // バッファーをアクティブにしたときにパネルでファイルを表示
    "auto_fold_dirs": true,       // サブディレクトリが 1 つだけのディレクトリを折りたたむ
    "scrollbar": {                // プロジェクトパネルのスクロールバー設定
      "show": null                // スクロールバーの表示/非表示: (auto, system, always, never)
    }
  }
```

## コラボレーションパネル

```json [settings]
{
  // コラボレーションパネル
  "collaboration_panel": {
    "button": true, // ステータスバーアイコンの表示/非表示
    "dock": "left", // ドッキング位置: left, right
    "default_width": 240 // コラボレーションパネルのデフォルト幅。
  },
  "show_call_status_icon": true, // OS ステータスバーに通話ステータスを表示する。

  // 通知パネル
  "notification_panel": {
    // ステータスバーに通知パネルボタンを表示するかどうか。
    "button": true,
    // 通知パネルをドッキングする位置。'left' または 'right' を指定可能。
    "dock": "right",
    // 通知パネルのデフォルト幅。
    "default_width": 380
  }
}
```
