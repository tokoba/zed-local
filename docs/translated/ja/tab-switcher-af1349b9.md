# Tab Switcher

Tab Switcher は、Zed で開いているタブ間をすばやく移動するための手段を提供します。
最近の使用状況順に並べた開いているタブの一覧を表示し、直前に作業していたものへ簡単に戻れるようにします。

![複数のペインでの Tab Switcher](https://zed.dev/img/features/tab-switcher.png)

## クイック切り替え

Tab Switcher をコマンドパレットから {#action tab_switcher::Toggle} を実行するのではなく、
{#kb tab_switcher::Toggle} を使って開いた場合、<kbd class="keybinding">ctrl</kbd> キーを押し続けている間は
アクティブな状態のままになります。

<kbd class="keybinding">ctrl</kbd> を押し続けている間は、その後に押す <kbd class="keybinding">tab</kbd> キーごとに
次の項目へ移動します（逆方向に移動するには <kbd class="keybinding">shift</kbd>）。
そして <kbd class="keybinding">ctrl</kbd> を離すと、選択されている項目が確定され、スイッチャーが閉じられます。

## Tab Switcher を開く

Tab Switcher は、{#action tab_switcher::Toggle} ({#kb tab_switcher::Toggle}) または
{#action tab_switcher::ToggleAll} でも開くことができます。

Tab Switcher が開いている間は、次の操作ができます:

- {#kb menu::SelectNext} を押して、一覧内の次のタブに移動する
- {#kb menu::SelectPrevious} を押して、一覧内の前のタブに移動する
- <kbd class="keybinding">enter</kbd> を押して、選択中のタブを確定しスイッチャーを閉じる
- <kbd class="keybinding">escape</kbd> を押して、スイッチャーを閉じてスイッチャーを開いた元のタブに戻る
- {#kb tab_switcher::CloseSelectedItem} を押して、現在選択されているタブを閉じる

一覧を移動すると、それに合わせて Zed はペインのアクティブな項目を選択中のタブに更新します。

## アクションリファレンス

| Action                                    | Description                                         |
| ----------------------------------------- | --------------------------------------------------- |
| {#action tab_switcher::Toggle}            | 現在のペインの Tab Switcher を開く                 |
| {#action tab_switcher::ToggleAll}         | すべてのペインのタブを表示する Tab Switcher を開く |
| {#action tab_switcher::CloseSelectedItem} | Tab Switcher で選択中のタブを閉じる                |
