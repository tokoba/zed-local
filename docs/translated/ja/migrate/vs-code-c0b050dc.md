# VS Code から Zed に移行する方法

このガイドでは、既存のワークフローを作り直すことなく VS Code から Zed へ移行する方法を説明します。

どの設定が自動的にインポートされるか、どのショートカットがそのまま対応しているか、どの挙動が異なるかをカバーし、すばやく調整できるようにします。

## Zed のインストール

Zed は macOS、Windows、Linux で利用できます。

macOS では、zed.dev/download からダウンロードするか、Homebrew 経由でインストールできます:
`brew install zed-editor/zed/zed`

多くの Linux ユーザーにとって、Zed をインストールする最も簡単な方法は、インストールスクリプトを使用することです:
`curl -f https://zed.dev/install.sh | sh`

インストール後は、アプリケーションフォルダ（macOS）から、またはターミナル（Linux）から次のように直接 Zed を起動できます:
`zed .`
これはカレントディレクトリを Zed で開きます。

## VS Code から設定をインポートする

セットアップ中に、VS Code から主要な設定をインポートするオプションがあります。Zed は次の設定をインポートします:

### VS Code からインポートされる設定

**Import Settings from VS Code** を使用すると、次の VS Code の設定が自動的にインポートされます:

**エディター**

| VS Code の設定                             | Zed の設定                                    |
| ------------------------------------------ | --------------------------------------------- |
| `editor.fontFamily`                        | `buffer_font_family`                          |
| `editor.fontSize`                          | `buffer_font_size`                            |
| `editor.fontWeight`                        | `buffer_font_weight`                          |
| `editor.tabSize`                           | `tab_size`                                    |
| `editor.insertSpaces`                      | `hard_tabs` (inverted)                        |
| `editor.wordWrap`                          | `soft_wrap`                                   |
| `editor.wordWrapColumn`                    | `preferred_line_length`                       |
| `editor.cursorStyle`                       | `cursor_shape`                                |
| `editor.cursorBlinking`                    | `cursor_blink`                                |
| `editor.renderLineHighlight`               | `current_line_highlight`                      |
| `editor.lineNumbers`                       | `gutter.line_numbers`, `relative_line_numbers` |
| `editor.showFoldingControls`               | `gutter.folds`                                |
| `editor.minimap.enabled`                   | `minimap.show`                                |
| `editor.minimap.autohide`                  | `minimap.show`                                |
| `editor.minimap.showSlider`                | `minimap.thumb`                               |
| `editor.minimap.maxColumn`                 | `minimap.max_width_columns`                   |
| `editor.stickyScroll.enabled`              | `sticky_scroll.enabled`                       |
| `editor.scrollbar.horizontal`              | `scrollbar.axes.horizontal`                   |
| `editor.scrollbar.vertical`                | `scrollbar.axes.vertical`                     |
| `editor.mouseWheelScrollSensitivity`       | `scroll_sensitivity`                          |
| `editor.fastScrollSensitivity`             | `fast_scroll_sensitivity`                     |
| `editor.cursorSurroundingLines`            | `vertical_scroll_margin`                      |
| `editor.hover.enabled`                     | `hover_popover_enabled`                       |
| `editor.hover.delay`                       | `hover_popover_delay`                         |
| `editor.parameterHints.enabled`            | `auto_signature_help`                         |
| `editor.multiCursorModifier`               | `multi_cursor_modifier`                       |
| `editor.selectionHighlight`                | `selection_highlight`                         |
| `editor.roundedSelection`                  | `rounded_selection`                           |
| `editor.find.seedSearchStringFromSelection` | `seed_search_query_from_cursor`               |
| `editor.rulers`                            | `wrap_guides`                                 |
| `editor.renderWhitespace`                  | `show_whitespaces`                            |
| `editor.guides.indentation`                | `indent_guides.enabled`                       |
| `editor.linkedEditing`                     | `linked_edits`                                |
| `editor.autoSurround`                      | `use_auto_surround`                           |
| `editor.formatOnSave`                      | `format_on_save`                              |
| `editor.formatOnPaste`                     | `auto_indent_on_paste`                        |
| `editor.formatOnType`                      | `use_on_type_format`                          |
| `editor.trimAutoWhitespace`                | `remove_trailing_whitespace_on_save`          |
| `editor.suggestOnTriggerCharacters`        | `show_completions_on_input`                   |
| `editor.suggest.showWords`                 | `completions.words`                           |
| `editor.inlineSuggest.enabled`             | `show_edit_predictions`                       |

**ファイルとワークスペース**

| VS Code の設定            | Zed の設定                       |
| ------------------------- | -------------------------------- |
| `files.autoSave`          | `autosave`                       |
| `files.autoSaveDelay`     | `autosave.milliseconds`          |
| `files.insertFinalNewline` | `ensure_final_newline_on_save`  |
| `files.associations`      | `file_types`                     |
| `files.watcherExclude`    | `file_scan_exclusions`           |
| `files.watcherInclude`    | `file_scan_inclusions`           |
| `files.simpleDialog.enable` | `use_system_path_prompts`      |
| `search.smartCase`        | `use_smartcase_search`           |
| `search.useIgnoreFiles`   | `search.include_ignored`         |

**ターミナル**

| VS Code の設定                       | Zed の設定                          |
| ------------------------------------ | ----------------------------------- |
| `terminal.integrated.fontFamily`     | `terminal.font_family`             |
| `terminal.integrated.fontSize`       | `terminal.font_size`               |
| `terminal.integrated.lineHeight`     | `terminal.line_height`             |
| `terminal.integrated.cursorStyle`    | `terminal.cursor_shape`            |
| `terminal.integrated.cursorBlinking` | `terminal.blinking`                |
| `terminal.integrated.copyOnSelection` | `terminal.copy_on_select`         |
| `terminal.integrated.scrollback`     | `terminal.max_scroll_history_lines` |
| `terminal.integrated.macOptionIsMeta` | `terminal.option_as_meta`         |
| `terminal.integrated.{platform}Exec` | `terminal.shell`                   |
| `terminal.integrated.env.{platform}` | `terminal.env`                     |

**タブとパネル**

| VS Code 設定                                     | Zed 設定                                           |
| ------------------------------------------------ | -------------------------------------------------- |
| `workbench.editor.showTabs`                      | `tab_bar.show`                                     |
| `workbench.editor.showIcons`                     | `tabs.file_icons`                                  |
| `workbench.editor.tabActionLocation`             | `tabs.close_position`                              |
| `workbench.editor.tabActionCloseVisibility`      | `tabs.show_close_button`                           |
| `workbench.editor.focusRecentEditorAfterClose`   | `tabs.activate_on_close`                           |
| `workbench.editor.enablePreview`                 | `preview_tabs.enabled`                             |
| `workbench.editor.enablePreviewFromQuickOpen`    | `preview_tabs.enable_preview_from_file_finder`     |
| `workbench.editor.enablePreviewFromCodeNavigation` | `preview_tabs.enable_preview_from_code_navigation` |
| `workbench.editor.editorActionsLocation`         | `tab_bar.show_tab_bar_buttons`                     |
| `workbench.editor.limit.enabled` / `value`       | `max_tabs`                                         |
| `workbench.editor.restoreViewState`              | `restore_on_file_reopen`                           |
| `workbench.statusBar.visible`                    | `status_bar.show`                                  |

**Project Panel (File Explorer)**

| VS Code Setting                | Zed Setting                         |
| ------------------------------ | ----------------------------------- |
| `explorer.compactFolders`      | `project_panel.auto_fold_dirs`      |
| `explorer.autoReveal`          | `project_panel.auto_reveal_entries` |
| `explorer.excludeGitIgnore`    | `project_panel.hide_gitignore`      |
| `problems.decorations.enabled` | `project_panel.show_diagnostics`    |
| `explorer.decorations.badges`  | `project_panel.git_status`          |

**Git**

| VS Code Setting                      | Zed Setting                                    |
| ------------------------------------ | ---------------------------------------------- |
| `git.enabled`                        | `git_panel.button`                             |
| `git.defaultBranchName`              | `git_panel.fallback_branch_name`               |
| `git.decorations.enabled`            | `git.inline_blame`, `project_panel.git_status` |
| `git.blame.editorDecoration.enabled` | `git.inline_blame.enabled`                     |

**Window & Behavior**

| VS Code Setting                                  | Zed Setting                              |
| ------------------------------------------------ | ---------------------------------------- |
| `window.confirmBeforeClose`                      | `confirm_quit`                           |
| `window.nativeTabs`                              | `use_system_window_tabs`                 |
| `window.closeWhenEmpty`                          | `when_closing_with_no_tabs`              |
| `accessibility.dimUnfocused.enabled` / `opacity` | `active_pane_modifiers.inactive_opacity` |

**Other**

| VS Code Setting            | Zed Setting                                              |
| -------------------------- | -------------------------------------------------------- |
| `http.proxy`               | `proxy`                                                  |
| `npm.packageManager`       | `node.npm_path`                                          |
| `telemetry.telemetryLevel` | `telemetry.metrics`, `telemetry.diagnostics`             |
| `outline.icons`            | `outline_panel.file_icons`, `outline_panel.folder_icons` |
| `chat.agent.enabled`       | `agent.enabled`                                          |
| `mcp`                      | `context_servers`                                        |

Zed は拡張機能やキーバインドをインポートしませんが、このインポートによって、コアなエディターの挙動を VS Code のセットアップに近づけることができます。セットアップ中にこのステップをスキップした場合でも、後からコマンドパレット経由で手動で設定をインポートできます:

`Cmd+Shift+P → Zed: Import VS Code Settings`

## Set Up Editor Preferences

ほとんどの設定は Settings Editor ({#kb zed::OpenSettings}) で構成できます。高度な設定については、コマンドパレットから `zed: open settings file` を実行して、設定ファイルを直接編集します。

よく使われる VS Code の設定がどのように対応しているかは次のとおりです:

| VS Code | Zed | Notes |
| --- | --- | --- |
| editor.fontFamily | buffer_font_family | Zed はデフォルトで Zed Mono を使用します |
| editor.fontSize | buffer_font_size | 単位はピクセルです |
| editor.tabSize | tab_size | 言語ごとに上書きできます |
| editor.insertSpaces | insert_spaces | ブール値です |
| editor.formatOnSave | format_on_save | フォーマッターが有効な場合に動作します |
| editor.wordWrap | soft_wrap | 任意の折り返し桁をサポートします |

Zed はプロジェクトごとの設定もサポートしています。これらも Settings Editor から確認できます。

## Open or Create a Project

セットアップ後、`Cmd+O`（Linux では `Ctrl+O`）を押してフォルダーを開きます。これが Zed でのワークスペースになります。VS Code のようなマルチルートワークスペースや `.code-workspace` ファイルには対応していません。Zed はシンプルに、「1 フォルダー = 1 ワークスペース」です。

新しいプロジェクトを開始するには、ターミナルやファイルマネージャーでディレクトリを作成し、それを Zed で開きます。エディターはそのフォルダーをプロジェクトのルートとして扱います。

任意のフォルダー内のターミナルから次のようにして Zed を起動することもできます:
`zed .`

プロジェクト内に入ったら、`Cmd+P` でファイル間を素早く移動できます。`Cmd+Shift+P`（Linux では `Ctrl+Shift+P`）は、アクションやタスクの実行、設定の切り替え、コラボレーションセッションの開始などのために、コマンドパレットを開きます。

開いているバッファは上部にタブとして表示されます。Project Panel にはファイルツリーと Git ステータスが表示されます。`Cmd+B` で折りたたむと、集中しやすいビューになります。

## Differences in Keybindings

オンボーディング時に VS Code のキーマップを選択していれば、ほとんどのショートカットはすでに馴染みのあるものになっているはずです。
どのキーバインドが一致していて、どこが異なるかを素早く確認するための簡単なリファレンスは次のとおりです。

### Common Shared Keybindings (Zed <> VS Code)

| アクション                    | ショートカット          |
| ----------------------------- | ---------------------- |
| ファイルを検索                | `Cmd + P`              |
| コマンドを実行               | `Cmd + Shift + P`      |
| テキストを検索（プロジェクト全体） | `Cmd + Shift + F`      |
| シンボルを検索（プロジェクト全体） | `Cmd + T`              |
| シンボルを検索（ファイル内）       | `Cmd + Shift + O`      |
| 左ドックの表示切り替え        | `Cmd + B`              |
| 下部ドックの表示切り替え      | `Cmd + J`              |
| ターミナルを開く              | `Ctrl + ~`             |
| ファイルツリーエクスプローラーを開く | `Cmd + Shift + E`   |
| 現在のバッファを閉じる        | `Cmd + W`              |
| プロジェクト全体を閉じる      | `Cmd + Shift + W`      |
| リファクタリング：シンボル名の変更 | `F2`                 |
| テーマを変更                  | `Cmd + K, Cmd + T`     |
| テキストの折り返し            | `Opt + Z`              |
| 開いているタブ間を移動        | `Cmd + Opt + Arrow`    |
| 構文単位での折りたたみ / 展開 | `Cmd + Opt + {` or `}` |

### キーバインドの違い（Zed <> VS Code）

| アクション              | VS Code               | Zed                    |
| ----------------------- | --------------------- | ---------------------- |
| 最近のプロジェクトを開く | `Ctrl + R`            | `Cmd + Opt + O`        |
| 行を上下に移動          | `Opt + Up/Down`       | `Cmd + Ctrl + Up/Down` |
| ペインを分割            | `Cmd + \`             | `Cmd + K, Arrow Keys`  |
| 選択範囲を拡大          | `Shift + Alt + Right` | `Opt + Up`             |

### Zed に固有の機能

| アクション              | ショートカット               | 備考                                                 |
| ----------------------- | ---------------------------- | ---------------------------------------------------- |
| 右ドックの表示切り替え  | `Cmd + R` or `Cmd + Alt + B` |                                                      |
| 構文単位での選択        | `Opt + Up/Down`              | コードを構造単位で選択します（例: 波括弧の内側など）。 |

### キーバインドをカスタマイズする方法

キーバインドを編集するには:

- コマンドパレットを開きます（`Cmd+Shift+P`）
- `Zed: Open Keymap Editor` を実行します

これにより、利用可能なすべてのバインドの一覧が開きます。個々のショートカットを上書きしたり、競合を解消したり、自分の環境により適したレイアウトを作成したりできます。

Zed は VS Code と同様に、`Cmd+K Cmd+C` のような chords（複数キーのシーケンス）にも対応しています。

## ユーザーインターフェースの違い

### ワークスペースなし

VS Code には専用の Workspace という概念があり、マルチルートフォルダーや `.code-workspace` ファイル、「ウィンドウ」と「ワークスペース」の明確な区別などが存在します。
Zed はこのモデルを簡素化しています。

Zed では次のようになります:

- ワークスペース用のファイル形式は存在しません。フォルダーを開くこと自体がプロジェクトコンテキストになります。

- Zed はマルチルートワークスペースをサポートしていません。1つのウィンドウで同時に開けるフォルダーは 1 つだけです。

- ほとんどのプロジェクトレベルの挙動は、開いているフォルダーをスコープとして扱います。検索、Git 連携、タスク、環境検出はすべて、開いたディレクトリをプロジェクトルートとして扱います。

- プロジェクトごとの設定は任意です。グローバル設定を上書きするために、プロジェクト内に `.zed/settings.json` ファイルを追加することはできますが、Zed は `.code-workspace` ファイルを使用せず、インポートもしません。

- 単一ファイルや空のウィンドウから作業を始めることもできます。Zed では編集を開始するためにフォルダーを開く必要はありません。

結果として、よりシンプルなモデルになります:  
フォルダーを開く → そのフォルダー内で作業する → 追加のワークスペースレイヤーは存在しない。

### プロジェクト内でのナビゲーション

VS Code では、標準的な入り口はフォルダーを開くことです。そこから、左側のパネルがナビゲーションの中心となります。  
Zed は別のアプローチを取っています:

- フォルダーを開くこともできますが、必須ではありません。単一ファイルを開いたり、空のワークスペースから始めたりしても問題ありません。
- コマンドパレット（`Cmd+Shift+P`）と File Finder（`Cmd+P`）が主なナビゲーション手段です。File Finder は、ワークスペース全体のファイル、シンボル、コマンドを検索します。
- 常に表示されたパネルを使う代わりに、Zed は次のような操作を推奨しています:
  - ファイル名でファジー検索する（`Cmd+P`）
  - シンボルに直接ジャンプする（`Cmd+Shift+O`）
  - 大きなファイルツリーを常に開いておくのではなく、スプリットペインやタブをコンテキストとして利用する（必要であれば Project Panel で同様のこともできます）。

この UI は補助パネルを邪魔にならないようにし、ナビゲーションを常にコード中心に保つよう設計されています。

### 拡張機能とマーケットプレイス

Zed の拡張機能は VS Code ほど多くはありません。提供されている拡張機能は、言語サポート、テーマ、シンタックスハイライト、その他のコアな編集機能の拡張に重点が置かれています。

VS Code では通常拡張機能が必要となるいくつかの機能は、Zed では標準で組み込まれています:

- 音声とカーソル共有によるリアルタイムコラボレーション（Live Share は不要）
- AI コーディング支援（Copilot 拡張機能は不要）
- 組み込みのターミナルパネル
- プロジェクト全体を対象としたファジー検索
- JSON で構成するタスクランナー
- LSP 経由のインライン診断とコードアクション

すべての VS Code 拡張機能に対して 1 対 1 の代替が用意されているわけではありません。特に、DevOps、コンテナー、テストランナー向けのツールに依存している場合はそうです。Zed の拡張カタログは依然として成長途中であり、規模も小さいままです。

### Zed と VS Code におけるコラボレーション

VS Code と異なり、Zed ではコラボレーションのために拡張機能は必要ありません。コアの体験として組み込まれています。

- 左ドックで Collab Panel を開きます。
- チャンネルを作成し、[共同編集者を招待](https://zed.dev/docs/collaboration#inviting-a-collaborator)して参加してもらいます。
- [画面またはコードベースを直接共有](https://zed.dev/docs/collaboration#share-a-project)します。

接続されると、互いのカーソル、選択範囲、編集内容をリアルタイムに確認できます。音声チャットも含まれているので、作業しながら会話できます。別のツールやサードパーティのログインは不要です。

[Zed がどのように Zed を使って](https://zed.dev/blog/zed-is-our-office)作業計画やコラボレーションを行っているかについても参照してみてください。

### Zed での AI 利用

VS Code で GitHub Copilot を使い慣れている場合は、Zed でも同様のことができます。Zed Pro を通じて別のエージェントを試したり、自分の API キーを持ち込んで認証なしで接続したりすることもできます。必要であれば、AI 機能を完全に無効化することも可能です。

#### GitHub Copilot の設定

1. `Cmd+,`（macOS）または `Ctrl+,`（Linux/Windows）で Settings を開きます
2. **AI → Edit Predictions** に移動します
3. "Configure Providers" の横にある **Configure** をクリックします
4. **GitHub Copilot** の項目で **Sign in to GitHub** をクリックします

サインインが完了したら、そのまま入力を始めてください。Zed がインラインで候補を提示するので、必要に応じて受け入れることができます。

#### 追加の AI オプション

Zed で他の AI モデルを利用するには、いくつかの選択肢があります:

- より高いレート制限で利用できる、Zed ホスティングのモデルを使う（[認証](https://zed.dev/docs/authentication)と [Zed Pro](https://zed.dev/docs/ai/subscription.html) のサブスクリプションが必要）
- 自分の [API keys](https://zed.dev/docs/ai/llm-providers.html) を持ち込んで利用する（認証は不要）
- [Claude Agent などの外部エージェント](https://zed.dev/docs/ai/external-agents.html)を使用する

### 上級設定と生産性向上のための調整

Zed には、環境を細かくチューニングしたいパワーユーザー向けの高度な設定が用意されています。

便利ないくつかの調整例を挙げます:

**保存時にフォーマットする:**

```json
"format_on_save": "on"
```

**direnv サポートを有効化:**

```json
"load_direnv": "shell_hook"
```

**カスタムタスク**: `tasks.json` にビルドまたは実行コマンドを定義します（コマンドパレット `zed: open tasks` からアクセスできます）:

```json
[
  {
    "label": "build",
    "command": "cargo build"
  }
]
```

**カスタムスニペットを引き継ぐ**
VS Code のスニペット JSON をそのまま Zed のスニペットフォルダ（`zed: configure snippets`）にコピーします。
