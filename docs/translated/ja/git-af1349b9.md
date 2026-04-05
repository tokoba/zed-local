# Git

Zed には Git が組み込まれており、エディタから離れることなくバージョン管理を扱うことができます。Git Panel には、作業ツリーの状態、ステージングエリア、ブランチ情報が表示されます。コマンドラインで行った変更も、Zed に即座に反映されます。

Zed がネイティブにはサポートしていない操作については、統合ターミナルを使用できます。

## Git Panel

Git Panel には、作業ツリーと Git のステージングエリアの状態が表示されます。

Git Panel は {#action git_panel::ToggleFocus} を使用するか、ステータスバーの Git アイコンをクリックすると開けます。

このパネルでは、どのリポジトリとブランチがアクティブか、どのファイルが変更されているか、および各ファイルの現在のステージング状態をひと目で確認できます。

Zed はあなたのリポジトリを監視しており、コマンドラインで行った変更も即座に反映されます。

### Configuration

Settings Editor（macOS では `Cmd+,`、Linux/Windows では `Ctrl+,`）を開いて、Git の動作をカスタマイズします。設定は次の 2 つのページに分かれています。

- **Panels > Git Panel**: パネルの位置、ツリービューかフラットビューか、ステータス表示スタイル
- **Version Control**: ガターインジケータ、インライン blame、ハンクのスタイル

#### Moving the Git Panel

デフォルトでは、Git Panel は左側にドックされます。**Panels > Git Panel** に移動し、**Git Panel Dock** を変更して、右側または下部に移動します。

#### Switching to Tree View

Git Panel はデフォルトで変更されたファイルをフラットなリストで表示します。ファイルをフォルダー階層ごとに表示したい場合は、パネルのコンテキストメニューで **Tree View** を切り替えるか、**Panels > Git Panel** で有効にします。

#### Inline Blame

Zed は現在行に対して Git の blame 情報を表示します。これを無効にしたり、表示までの遅延を追加したりするには、**Version Control > Inline Git Blame** に移動します。

#### Hiding the Gutter Indicators

追加・変更・削除された行を示すガター内の色付きバーは非表示にできます。**Version Control > Git Gutter** に移動し、**Visibility** を "Hide" に設定します。

#### Commit Message Line Length

Zed はコミットメッセージを 72 文字で折り返します（Git の慣例です）。これを変更するには、Settings で "Git Commit" を検索し、**Preferred Line Length** を調整します。

## Project Diff

Zed では Project Diff ({#kb git::Diff}) を開くことで、Git によって取得されたすべての変更を確認できます。Project Diff は Command Palette または Git Panel 内の {#action git::Diff} アクションからアクセスできます。

Project Diff に表示されるすべての変更は、他の任意の multibuffer とまったく同じように振る舞います。すべてファイルの編集可能な抜粋です。

タブバー上のボタン、または対応するキーバインドを押すことで、各ハンク単位でもファイル全体でもステージ／アンステージできます。

### Word Diff Highlighting

デフォルトでは、Zed は変更された行の中で変更された単語をハイライトし、どこが変わったのかを把握しやすくします。これをグローバルに無効にするには、Settings Editor を開き、**Languages & Tools > Miscellaneous** に移動して **Word Diff Enabled** をオフにします。

特定の言語に対してのみ word diff を無効にするには、settings.json に次の設定を追加します。

```json
{
  "languages": {
    "Markdown": {
      "word_diff_enabled": false
    }
  }
}
```

### Diff View Styles

Zed は diff を 2 つのモードで表示します: **split**（並列比較）と **unified**（インラインの変更）。デフォルトは split ビューです。

#### Changing the diff view

Settings Editor ({#kb zed::OpenSettings}) を開き、"diff view style" を検索します。**Split** または **Unified** のいずれかを選択します。

デフォルトを変更するには、`settings.json` に次を追加します。

```json
{
  "diff_view_style": "unified"
}
```

Settings Editor の詳細については、[Configuring Zed](./configuring-zed.md) を参照してください。

#### Split vs unified

- **Split**: 元のバージョンと変更後のバージョンを並べて表示します。ファイル構造を比較したり、大きな変更をレビューしたりするのに便利です。
- **Unified**: 追加および削除を 1 つのビュー内でインラインに表示します。特定の行の変更に集中したい場合に便利です。

モードはいつでも切り替えることができます。あなたの設定は [Project Diff](#project-diff)、[File History](#file-history)、[Stash Diff View](#stash-diff-view) に適用されます。これらの diff ビューは [multibuffers](./multibuffers.md) として機能し、複数の抜粋を同時に編集できます。

## File History

File History では、個々のファイルのコミット履歴が表示されます。各エントリにはコミットの作者、タイムスタンプ、メッセージが表示されます。コミットを選択すると、そのコミットでそのファイルに対して行われた変更だけを表示する diff ビューが開きます。

To view File History:

- Project Panel のファイルを右クリックし、"View File History" を選択します
- Git Panel のファイルを右クリックし、"View File History" を選択します
- エディタタブを右クリックし、"View File History" を選択します
- Command Palette を使い、"file history" を検索します

## Fetch, Push, and Pull

Git リポジトリに対して fetch、push、pull を行うには、Git Panel にあるボタンを使うか、Command Palette でそれぞれのアクション {#action git::Fetch}、{#action git::Push}、{#action git::Pull} を実行します。

### Push Configuration

Zed は Git の push 設定を尊重します。push を行う際、Zed は次の順序で設定を確認します。

1. 現在のブランチに設定されている `pushRemote`
2. Git 設定内の `remote.pushDefault`
3. ブランチの追跡リモート

これは Git の標準的な挙動と一致しているため、`.gitconfig` や `git config` で `pushRemote` や `pushDefault` を設定していれば、Zed はそれらの設定を使用します。

## Remotes

リポジトリに複数のリモートがある場合、Zed は Git Panel にリモートセレクタを表示します。push/pull の横にあるリモートボタンをクリックして、その操作で使用するリモートを選択します。

## Staging Workflow

Zed には、Project Diff を使う方法とパネルを直接使う方法という 2 つの主なステージングワークフローがあります。

### Using the Project Diff

Project Diff ビューでは、各ハンクにフォーカスして、タブバーのボタンをクリックするか、{#action git::StageAndNext} ({#kb git::StageAndNext}) のキーバインドを使って個別にステージできます。

同様に、{#action git::StageAll} ({#kb git::StageAll}) のキーバインドで全ハンクを一度にステージし、そのまま {#action git::Commit} ({#kb git::Commit}) で即座にコミットできます。

### Using the Git Panel

パネルからは、コミットメッセージを入力してコミットボタン、もしくは {#action git::Commit} を押すだけです。これにより、すべての追跡済みファイル（エントリのチェックボックス内の `[·]` で示されます）が自動的にステージされ、コミットされます。

<!-- デフォルトでステージされた変更セットを表示 -->

各エントリのチェックボックスを使って、個々のエントリをステージできます。すべての変更は、パネル上部のボタン、または {#action git::StageAll} を使ってステージできます。

<!-- メディアを追加 -->

## Committing

Zed には 2 つのコミット用テキストエリアがあります。

1. 1 つ目は Git Panel の一番下にあります。{#kb git::Commit} を押すと、ステージされた変更がすべて即座にコミットされます。
2. 2 つ目は、アクション {#action git::ExpandCommitEditor} を使用するか、Git Panel のコミット用テキストエリアにフォーカスしている間に {#kb git::ExpandCommitEditor} を押すことで利用できます。

### Undoing a Commit

Zed でコミットするとすぐに、Git Panel のコミット用テキストエリア直下にバーが表示され、直近に送信したコミットが表示されます。
そこから "Uncommit" ボタンを使用でき、このボタンは `git reset HEADˆ--soft` コマンドを実行します。

### コミットメッセージの行長の設定

デフォルトでは、Zed はコミットメッセージの行長を `72` に設定しますが、ローカルの `settings.json` ファイルで変更できます。

`preferred-line-length` の設定について詳しくは、[Configuration](#configuration) セクションを参照してください。

## ブランチ管理

### ブランチの作成と切り替え

新しいブランチを作成するには {#action git::Branch} を使用し、既存のブランチに切り替えるには {#action git::Switch} または {#action git::CheckoutBranch} を使用します。

### ブランチの削除

ブランチを削除するには、{#action git::Switch} でブランチスイッチャーを開き、削除したいブランチを見つけて削除オプションを使用します。誤ってデータを失わないように、Zed は削除前に確認を行います。

> **注意:** 現在チェックアウトしているブランチは削除できません。先に別のブランチに切り替えてください。

## マージコンフリクト

マージ、リベース、または pull の後にマージコンフリクトが発生した場合、Zed はファイル内の競合している領域をハイライトし、各コンフリクトの上に解決用ボタンを表示します。

### コンフリクトの確認

コンフリクトが発生しているファイルは、Git パネルに警告アイコン付きで表示されます。Project Diff ビューでもコンフリクトを確認でき、その場合は各コンフリクト領域が次のようにハイライトされます。

- 現在のブランチからの変更は緑色でハイライトされます
- マージ元ブランチからの変更は青色でハイライトされます

### コンフリクトの解消

各コンフリクトには、次の 3 つのボタンが表示されます。

- **[branch-name] を使用**: 一方のブランチからの変更を保持します（実際には `"main"` のようにブランチ名が表示されます）
- **[other-branch] を使用**: もう一方のブランチからの変更を保持します（`"feature-branch"` など）
- **両方を使用**: 両方の変更を保持し、自分のブランチの変更を先に配置します

該当するボタンをクリックすると、そのコンフリクトが解消されます。コンフリクトマーカーは削除され、選択した内容に置き換えられます。ファイル内のすべてのコンフリクトを解消したら、そのファイルをステージしてコミットし、マージを完了します。

> **ヒント:** 手動での編集が必要な複雑なコンフリクトの場合は、ファイルを直接編集できます。コンフリクトマーカー（`<<<<<<<`、`=======`、`>>>>>>>`）を削除し、必要な内容だけを残してください。

## スタッシュ

Git の stash 機能を使用すると、コミットしていない変更を一時的に保存し、作業ディレクトリをクリーンな状態に戻すことができます。これは、未完成の作業をコミットせずに素早くブランチを切り替えたり、更新を pull したい場合に特に便利です。

### スタッシュの作成

現在のすべての変更をスタッシュするには、{#action git::StashAll} アクションを使用します。これにより、ステージ済みおよび未ステージの変更の両方が新しいスタッシュエントリに保存され、作業ディレクトリがクリーンな状態になります。

### スタッシュの管理

Zed は、{#action git::ViewStash} から、または Git パネルのオーバーフローメニューからアクセスできるスタッシュピッカーを提供しています。スタッシュピッカーからは次の操作が可能です。

- **スタッシュ一覧の表示**: 保存されているすべてのスタッシュを、その説明とタイムスタンプとともに閲覧します
- **Diff を開く**: 各スタッシュにどのような変更が保存されているかを正確に確認します
- **スタッシュの適用**: スタッシュエントリを残したまま、スタッシュされた変更を作業ディレクトリに適用します
- **スタッシュのポップ**: スタッシュされた変更を適用し、リストからそのスタッシュエントリを削除します
- **スタッシュの削除**: 適用せずに不要なスタッシュエントリを削除します

### クイックスタッシュ操作

ワークフローを高速化するために、Zed には最新のスタッシュを直接操作するアクションが用意されています。

- **最新のスタッシュを適用**: {#action git::StashApply} を使用して、最新のスタッシュを削除せずに適用します
- **最新のスタッシュをポップ**: {#action git::StashPop} を使用して、最新のスタッシュを適用しつつ削除します

### スタッシュ Diff ビュー

スタッシュの内容を表示するには、スタッシュピッカーで対象のスタッシュを選択し、{#kb stash_picker::ShowStashItem} を押します。Diff ビューでは、次のキーバインドを使用できます。

| Action                               | Keybinding                   |
| ------------------------------------ | ---------------------------- |
| スタッシュを適用                    | {#kb git::ApplyCurrentStash} |
| スタッシュをポップ（適用して削除）  | {#kb git::PopCurrentStash}   |
| スタッシュを削除（適用せずに削除）  | {#kb git::DropCurrentStash}  |

## Git における AI サポート

Zed は現在、LLM を利用したコミットメッセージの生成をサポートしています。
Git パネル内のメッセージエディタにフォーカスを当て、左下の鉛筆アイコンをクリックするか、{#action git::GenerateCommitMessage}（{#kb git::GenerateCommitMessage}）のキーバインドを使用して、AI にコミットメッセージの生成を依頼できます。

> LLM プロバイダーを利用するには、自分の API キーを用意して設定するか、Zed がホストする AI モデルを通じて設定しておく必要があります。  
> 設定方法の詳細は、[the AI configuration page](./ai/configuration.md) を参照してください。

使用したいモデルは、`commit_message_model` エージェント設定を指定することで選択できます。
詳しくは、[Feature-specific models](./ai/agent-settings.md#feature-specific-models) を参照してください。

```json [settings]
{
  "agent": {
    "commit_message_model": {
      "provider": "anthropic",
      "model": "claude-3-5-haiku"
    }
  }
}
```

生成されるコミットメッセージのフォーマットをカスタマイズするには、{#action agent::OpenRulesLibrary} を実行し、左側から "Commit message" ルールを選択します。
そこから、目的のフォーマットに合うようにプロンプトを編集できます。

<!-- メディアを追加 -->

コミットメッセージ用に [Rules ファイル](./ai/rules.md) に追加された特定の指示も、コミットメッセージを作成するモデルによって利用されます。

## Git 連携

Zed は一般的な Git ホスティングサービスと連携しており、Git のコミットハッシュや Issue、Pull Request、Merge Request への参照をクリック可能なリンクとして扱えるようにします。

Zed は現在、ホスティング版の次のサービスへのリンクをサポートしています
[GitHub](https://github.com),
[GitLab](https://gitlab.com),
[Bitbucket](https://bitbucket.org),
[SourceHut](https://sr.ht) および
[Codeberg](https://codeberg.org).

### セルフホスト環境

Zed は、Git のリモート URL に含まれるキーワードを確認することで、Git ホスティングプロバイダーを自動的に識別します。たとえば、セルフホスト環境の URL に `gitlab` や `gitea` などの既知のプロバイダー名が含まれている場合、追加の設定を行わなくても、そのホスティングプロバイダーが自動的に登録されます。

しかし、セルフホストの Git インスタンスの URL に識別用キーワードが含まれていない場合でも、`git_hosting_providers` 設定を追加することで、Zed を手動で設定してインスタンスへのクリック可能なリンクを作成できます。これにより、コミットハッシュやパーマリンクが自分のドメインに解決されるようになります。

```json [settings]
{
  "git_hosting_providers": [
    {
      "provider": "gitlab",
      "name": "Corp GitLab",
      "base_url": "https://git.example.corp"
    }
  ]
}
```

`provider` フィールドは、使用しているホスティングサービスの種類を指定します。サポートされている `provider` の値は `github`、`gitlab`、`bitbucket`、`gitea`、`forgejo`、`sourcehut` です。`name` は任意で、インスタンスの表示名として使用され、`base_url` はセルフホストサーバーのルート URL を指定します。

複数のセルフホストインスタンスを使用している場合は、複数のカスタムプロバイダーを設定できます。

### パーマリンク

Zed には、Git ホスティングサービス上のコードスニペットへの永続的なリンクを作成する Copy Permalink 機能もあります。
これらのリンクは、特定のコミットにおけるファイル内の特定の行または行範囲を共有するのに便利です。
このアクションは、[Command Palette](./getting-started.md#command-palette)（`permalink` を検索）から実行するか、
`editor::CopyPermalinkToLine` または `editor::OpenPermalinkToLine` アクションに対する
[カスタムキーバインド](key-bindings.md#custom-key-bindings) を作成するか、
エディタで行を選択した状態で右クリックし、`Copy Permalink` を選択することで実行できます。

## Diff ハンクのキーボードショートカット

変更のあるファイルを表示しているとき、Zed は詳細なレビューのために展開／折りたたみ可能な diff ハンクを表示します:

- **すべての diff ハンクを展開**: {#action editor::ExpandAllDiffHunks} ({#kb editor::ExpandAllDiffHunks})
- **すべての diff ハンクを折りたたむ**: `Escape` を押します（{#action editor::Cancel} にバインドされています）
- **選択した diff ハンクを切り替え**: {#action editor::ToggleSelectedDiffHunks} ({#kb editor::ToggleSelectedDiffHunks})
- **ハンク間を移動**: {#action editor::GoToHunk} および {#action editor::GoToPreviousHunk}

> **Tip:** `Escape` キーは、展開されているすべての diff ハンクをすばやく折りたたみ、変更内容の概要ビューに戻る最も簡単な方法です。

## アクションリファレンス

| Action                                    | Keybinding                            |
| ----------------------------------------- | ------------------------------------- |
| {#action git::Add}                        | {#kb git::Add}                        |
| {#action git::StageAll}                   | {#kb git::StageAll}                   |
| {#action git::UnstageAll}                 | {#kb git::UnstageAll}                 |
| {#action git::ToggleStaged}               | {#kb git::ToggleStaged}               |
| {#action git::StageAndNext}               | {#kb git::StageAndNext}               |
| {#action git::UnstageAndNext}             | {#kb git::UnstageAndNext}             |
| {#action git::Commit}                     | {#kb git::Commit}                     |
| {#action git::ExpandCommitEditor}         | {#kb git::ExpandCommitEditor}         |
| {#action git::Push}                       | {#kb git::Push}                       |
| {#action git::ForcePush}                  | {#kb git::ForcePush}                  |
| {#action git::Pull}                       | {#kb git::Pull}                       |
| {#action git::PullRebase}                 | {#kb git::PullRebase}                 |
| {#action git::Fetch}                      | {#kb git::Fetch}                      |
| {#action git::Diff}                       | {#kb git::Diff}                       |
| {#action git::Restore}                    | {#kb git::Restore}                    |
| {#action git::RestoreFile}                | {#kb git::RestoreFile}                |
| {#action git::Branch}                     | {#kb git::Branch}                     |
| {#action git::Switch}                     | {#kb git::Switch}                     |
| {#action git::CheckoutBranch}             | {#kb git::CheckoutBranch}             |
| {#action git::Blame}                      | {#kb git::Blame}                      |
| {#action git::StashAll}                   | {#kb git::StashAll}                   |
| {#action git::StashPop}                   | {#kb git::StashPop}                   |
| {#action git::StashApply}                 | {#kb git::StashApply}                 |
| {#action git::ViewStash}                  | {#kb git::ViewStash}                  |
| {#action editor::ToggleGitBlameInline}    | {#kb editor::ToggleGitBlameInline}    |
| {#action editor::ExpandAllDiffHunks}      | {#kb editor::ExpandAllDiffHunks}      |
| {#action editor::ToggleSelectedDiffHunks} | {#kb editor::ToggleSelectedDiffHunks} |

> すべてのアクションにデフォルトのキーバインドがあるわけではありませんが、[キーマップをカスタマイズ](./key-bindings.md#user-keymaps) することで割り当てることができます。

## Git CLI の設定

コマンドラインからコミットする際の [git コミットメッセージエディタ](https://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration#_core_editor) としても Zed を使いたい場合は、`zed --wait` を利用できます:

```sh
git config --global core.editor "zed --wait"
```

または、次の内容をシェル環境（`~/.zshrc` や `~/.bashrc` など）に追加します:

```sh
export GIT_EDITOR="zed --wait"
```
