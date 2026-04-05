# 検索とナビゲーション

Zed には、コードベース内をすばやく移動するためのさまざまな方法が用意されています。ここでは、主なナビゲーションツールの概要を説明します。

## コマンドパレット

コマンドパレット ({#kb command_palette::Toggle}) は、Zed のほぼあらゆる機能への入り口です。数文字入力してコマンドを絞り込み、Enter を押して実行します。

[コマンドパレットの詳細 →](./command-palette.md)

## ファイルファインダー

{#kb file_finder::Toggle} で、プロジェクト内の任意のファイルを開くことができます。ファイル名またはパスの一部を入力して結果を絞り込みます。

## プロジェクト検索

{#kb pane::DeploySearch} を使って、すべてのファイルを対象に検索します。検索フィールドへの入力を始めると検索が開始され、入力と同時に結果が表示されます。

結果は [multibuffer](./multibuffers.md) に表示され、その場でヒット箇所を編集できます。

## 定義へ移動

{#kb editor::GoToDefinition}（または `Cmd+Click` / `Ctrl+Click`）で、シンボルが定義されている場所へジャンプできます。複数の定義がある場合は、multibuffer で開かれます。

## シンボルへ移動

- **現在のファイル:** {#kb outline::Toggle} で、アクティブなファイル内のシンボルのアウトラインを開きます
- **プロジェクト全体:** {#kb project_symbols::Toggle} で、すべてのファイルを対象にシンボルを検索します

## アウトラインパネル

アウトラインパネル ({#kb outline_panel::ToggleFocus}) は、現在のファイル内のシンボルをツリービューで常に表示します。検索結果や診断をナビゲートする際には、[multibuffers](./multibuffers.md) と組み合わせると特に便利です。

[アウトラインパネルの詳細 →](./outline-panel.md)

## タブスイッチャー

{#kb tab_switcher::Toggle} で、開いているタブ間をすばやく切り替えられます。タブは最近使用した順に並びます。Ctrl を押したまま Tab を押すことで順番に切り替えられます。

[タブスイッチャーの詳細 →](./tab-switcher.md)

## クイックリファレンス

| Task              | Keybinding                       |
| ----------------- | -------------------------------- |
| コマンドパレット | {#kb command_palette::Toggle}    |
| ファイルを開く    | {#kb file_finder::Toggle}        |
| プロジェクト検索  | {#kb pane::DeploySearch}         |
| 定義へ移動        | {#kb editor::GoToDefinition}     |
| 参照を検索        | {#kb editor::FindAllReferences}  |
| ファイル内のシンボル | {#kb outline::Toggle}          |
| プロジェクト内のシンボル | {#kb project_symbols::Toggle} |
| アウトラインパネル | {#kb outline_panel::ToggleFocus} |
| タブスイッチャー  | {#kb tab_switcher::Toggle}       |
