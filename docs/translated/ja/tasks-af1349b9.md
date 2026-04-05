# タスク

Zed には、統合された [ターミナル](./terminal.md) を使ってコマンドを起動（および再実行）し、その結果を出力する機能があります。これらのコマンドは、編集中のファイルへのパスや選択中のテキストなど、Zed の状態の一部のみを参照できます。

```json [tasks]
[
  {
    "label": "Example task",
    "command": "for i in {1..5}; do echo \"Hello $i/5\"; sleep 1; done",
    //"args": [],
    // コマンド用の環境変数の上書き設定。設定からターミナルの環境に追加されます。
    "env": { "foo": "bar" },
    // コマンドを起動する作業ディレクトリ。指定しない場合は現在のプロジェクトルートが使われます。
    //"cwd": "/path/to/working/directory",
    // 新しいターミナルタブを使うか、既存のタブを再利用してプロセスを起動するか。デフォルトは `false` です。
    "use_new_terminal": false,
    // 同じタスクの複数インスタンスの実行を許可するか、既存のタスクが終了するまで待機するか。デフォルトは `false` です。
    "allow_concurrent_runs": false,
    // コマンド開始後の、ターミナルペインとタブの扱い:
    // * `always` — 常にタスクのペインを表示し、その中の対応するタブにフォーカスします（デフォルト）
    // * `no_focus` — 常にタスクのペインを表示し、その中にタスクのタブを追加しますが、フォーカスは移しません
    // * `never` — フォーカスは変更せず、それでもタスクのタブをそのペインに追加／再利用します
    "reveal": "always",
    // コマンド終了後の、ターミナルペインとタブの扱い:
    // * `never` — コマンドが終了しても何もしません（デフォルト）
    // * `always` — 常にターミナルタブを隠し、タブが最後の 1 つだった場合はペインも隠します
    // * `on_success` — タスクが成功した場合のみターミナルタブを隠し、それ以外は `always` と同様に振る舞います
    "hide": "never",
    // ターミナル内でタスクを実行するときに使用するシェル。
    // 3 つの値を取ることができます:
    // 1. （デフォルト）/etc/passwd に定義されたシステムのデフォルトターミナル設定を使用する
    //      "shell": "system"
    // 2. プログラムを指定する:
    //      "shell": {
    //        "program": "sh"
    //      }
    // 3. 引数付きのプログラムを指定する:
    //     "shell": {
    //         "with_arguments": {
    //           "program": "/bin/bash",
    //           "args": ["--login"]
    //         }
    //     }
    "shell": "system",
    // 起動されたタスクの出力内にタスク行を表示するかどうか。デフォルトは `true` です。
    "show_summary": true,
    // 起動されたタスクの出力内にコマンドラインを表示するかどうか。デフォルトは `true` です。
    "show_command": true,
    // タスクの実行前に保存する編集済みバッファー:
    // * `all` — すべての編集済みバッファーを保存する
    // * `current` — 現在アクティブなバッファーのみ保存する
    // * `none` — どのバッファーも保存しない
    "save": "none"
    // インラインで実行可能なインジケーター用、または複数タスクを一度に起動するためのタグを表します。
    // "tags": []
  }
]
```

タスクの利用ワークフローを駆動するアクションは 2 つあります: `task: spawn` と `task: rerun` です。  
`task: spawn` は、現在のファイルで利用可能なすべてのタスクを表示するモーダルを開きます。  
`task: rerun` は、直近に起動したタスクを再実行します。タスクモーダルからタスクを再実行することもできます。

デフォルトでは、タスクの再実行時には同じターミナルを再利用します（デフォルトの `"use_new_terminal": false` による）が、新しいタスクを開始する前に前回のタスクの終了を待ちます（デフォルトの `"allow_concurrent_runs": false` による）。

再実行時に前回のタスクをキャンセルできるようにするには、`"use_new_terminal": false` を維持したまま、`"allow_concurrent_runs": true` を設定してください。

## タスクテンプレート

タスクは次の場所で定義できます:

- グローバルな `tasks.json` ファイル内。このタスクは、あなたが作業するすべての Zed プロジェクトで利用可能です。このファイルは通常 `~/.config/zed/tasks.json` にあります。`zed: open tasks` アクションを使って編集できます。
- ワークツリー固有（ローカル）の `.zed/tasks.json` ファイル内。このタスクは、そのワークツリーを含むプロジェクトで作業している場合にのみ利用可能です。`zed: open project tasks` アクションを使って、ワークツリー固有のタスクを編集できます。
- [ワンショットタスク](#oneshot-tasks) を使って、その場で定義する。このタスクはプロジェクト固有であり、セッションをまたいで永続化はされません。
- 言語拡張によって定義する。

## 変数

Zed のタスクはシェルと同様に動作します。そのため、シェル風の `$VAR_NAME` 構文で環境変数を参照できます。加えて、いくつかの環境変数が利便性のために設定されています。  
これらの変数を使うことで、現在のエディターから情報を取得し、タスクの中で利用できます。利用可能な変数は次のとおりです:

- `ZED_COLUMN`: 現在の行のカラム
- `ZED_ROW`: 現在の行の行番号
- `ZED_FILE`: 現在開いているファイルの絶対パス（例: `/Users/my-user/path/to/project/src/main.rs`）
- `ZED_FILENAME`: 現在開いているファイルのファイル名（例: `main.rs`）
- `ZED_DIRNAME`: 現在開いているファイルの絶対パスからファイル名を取り除いたもの（例: `/Users/my-user/path/to/project/src`）
- `ZED_RELATIVE_FILE`: 現在開いているファイルのパスを `ZED_WORKTREE_ROOT` からの相対パスで表したもの（例: `src/main.rs`）
- `ZED_RELATIVE_DIR`: 現在開いているファイルのディレクトリのパスを `ZED_WORKTREE_ROOT` からの相対パスで表したもの（例: `src`）
- `ZED_STEM`: 現在開いているファイルのステム（拡張子を除いたファイル名）（例: `main`）
- `ZED_SYMBOL`: 現在選択されているシンボル。シンボルブレッドクラムに表示される最後のシンボルと一致するはずです（例: `mod tests > fn test_task_contexts`）
- `ZED_SELECTED_TEXT`: 現在選択されているテキスト
- `ZED_LANGUAGE`: 現在開いているバッファーの言語（例: `Rust`, `Python`, `Shell Script`）
- `ZED_WORKTREE_ROOT`: 現在のワークツリーのルートへの絶対パス（例: `/Users/my-user/path/to/project`）
- `ZED_CUSTOM_RUST_PACKAGE`: （Rust 固有）`$ZED_FILE` ソースファイルの親パッケージの名前。

タスクで変数を使用するには、ドル記号（`$`）を前に付けます:

```json [tasks]
{
  "label": "echo current file's path",
  "command": "echo $ZED_FILE"
}
```

また、指定した変数が利用できない場合にデフォルト値を指定できる冗長な構文 `${ZED_FILE:default_value}` も使用できます。

これらの環境変数は、タスクの `cwd`、`args`、`label` フィールドでも使用できます。

### 変数のクオート

スペースやその他の特殊文字を含むパスを扱う場合は、変数が適切にエスケープされていることを確認してください。

たとえば、次のようにすると（パスにスペースが含まれている場合は失敗します）:

```json [tasks]
{
  "label": "stat current file",
  "command": "stat $ZED_FILE"
}
```

代わりに次のようにします:

```json [tasks]
{
  "label": "stat current file",
  "command": "stat",
  "args": ["$ZED_FILE"]
}
```

あるいは、次のように明示的にクオートをエスケープして含めます:

```json [tasks]
{
  "label": "stat current file",
  "command": "stat \"$ZED_FILE\""
}
```

### 変数に基づくタスクのフィルタリング

タスクリストが決定される時点で存在しない変数を含むタスク定義はフィルタリングされます。  
たとえば、次のタスクはテキスト選択がある場合にのみ、spawn モーダルに表示されます:

```json [tasks]
{
  "label": "selected text",
  "command": "echo \"$ZED_SELECTED_TEXT\""
}
```

このような変数にデフォルト値を設定すると、そのようなタスクを常に表示させることができます:

```json [tasks]
{
  "label": "selected text with default",
  "command": "echo \"${ZED_SELECTED_TEXT:no text selected}\""
}
```

## ワンショットタスク

`task: spawn` から開かれる同じタスクモーダルは、任意の bash 風コマンドの実行をサポートします。モーダルのテキストフィールド内にコマンドを入力し、`opt-enter` を使って起動します。

タスクモーダルは、これらのアドホックなコマンドをセッションの間保持します。最後に起動されたタスクであれば、`task: rerun` によってそのようなタスクも再実行されます。

モーダル内で現在選択されているタスクを調整することもできます（デフォルトのキーバインドは `tab` です）。そうすると、そのタスクのコマンドがプロンプトに入り、編集してワンショットタスクとして起動できます。

### エフェメラルタスク

モーダル経由でタスクを起動する際に `cmd` 修飾キーを使うことができます。この方法で起動されたタスクは使用回数が増加しません（そのため `task: rerun` で再起動されず、タスクモーダル内で高い順位にはなりません）。
エフェメラルタスクは、継続的に `task: rerun` を使いながらフローを維持するために利用することを想定しています。

### タスク再実行のより細かい制御

デフォルトでは、タスクは変数を一度コンテキストに取り込み、この「解決済みタスク」が常に再実行されます。

これはタスクの `"reevaluate_context"` 引数で制御できます。`true` に設定すると、各実行前にタスクの再評価が強制されます。

```json [keymap]
{
  "context": "Workspace",
  "bindings": {
    "alt-t": ["task::Rerun", { "reevaluate_context": true }]
  }
}
```

## タスク用のカスタムキーバインド

`task::Spawn` に追加の引数を渡すことで、タスクに対する独自のキーバインドを定義できます。前述の `echo current file's path` タスクを `alt-g` に割り当てたい場合は、[`keymap.json`](./key-bindings.md) ファイルに次のスニペットを追加します。

```json [keymap]
{
  "context": "Workspace",
  "bindings": {
    "alt-g": ["task::Spawn", { "task_name": "echo current file's path" }]
  }
}
```

これらのタスクには、起動されたタスクをどこに表示するかを制御するための 'target' も指定できます。
これは、中央エリアで使いたいターミナルアプリケーションを起動する場合などに役立ちます。

```json [tasks]
// tasks.json 内
{
  "label": "start lazygit",
  "command": "lazygit -p $ZED_WORKTREE_ROOT"
}
```

```json [keymap]
// keymap.json 内
{
  "context": "Workspace",
  "bindings": {
    "alt-g": [
      "task::Spawn",
      { "task_name": "start lazygit", "reveal_target": "center" }
    ]
  }
}
```

## VS Code タスクフォーマット

`.vscode/tasks.json` から VS Code のタスクをインポートする場合、`label` フィールドは省略できます。Zed はタスクの種類に基づいて自動的にラベルを生成します。

- **npm タスク**: `npm: <script>`（例: `npm: start`）
- **gulp タスク**: `gulp: <task>`（例: `gulp: build`）
- **shell タスク**: `command` 文字列をそのまま使用します（例: `echo hello`）。コマンドが空の場合は `shell` を使用します
- **type を持たないタスク**: `Untitled Task`

自動生成されたラベルを持つタスクファイルの例:

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "type": "npm",
      "script": "start"
    },
    {
      "type": "shell",
      "command": "cargo build --release"
    }
  ]
}
```

これらのタスクはタスクピッカーでは「npm: start」と「cargo build --release」として表示されます。明示的な `label` フィールドを指定することで、自動生成されたラベルを上書きできます。

## runnable タグをタスクテンプレートにバインドする

Zed では、ワークスペースローカルおよびグローバルな `tasks.json` ファイルを通じて、インライン runnable インジケーターのデフォルトアクションを次の優先順位で上書きできます。

1. ワークスペースの `tasks.json`
2. グローバルな `tasks.json`
3. 言語が提供するタグバインディング（デフォルト）

タスクにタグを付けるには、タスクテンプレートの `tags` フィールドに runnable タグ名を追加します。

```json [tasks]
{
  "label": "echo current file's path",
  "command": "echo $ZED_FILE",
  "tags": ["rust-test"]
}
```

これにより、runnables インジケーターに表示されるタスクを変更できます。

## runnables にバインドされたタスクを実行するためのキーバインド

runnable にバインドされたタスク定義がある場合、それを素早く実行するには [Code Actions](https://zed.dev/docs/configuring-languages?#code-actions) を利用できます。Code Actions は `editor: Toggle Code Actions` コマンド、または `cmd-.`/`ctrl-.` ショートカットから起動できます。あなたのタスクはドロップダウンの先頭に表示されます。この行に追加の Code Action がなければ、そのタスクは即座に実行されます。

## Bash スクリプトの実行

Zed から直接 bash スクリプトを実行できます。`.sh` または `.bash` ファイルを開くと、Zed はスクリプトを自動的に runnable として検出し、タスクピッカーから選択できるようにします。

bash スクリプトを実行するには:

1. {#kb command_palette::Toggle} でコマンドパレットを開きます
2. "task" を検索し、**task: spawn** を選択します
3. リストからスクリプトを選択します

Bash スクリプトには `bash-script` タグが付与されており、タスク設定内でそれらをフィルタリングしたり参照したりできます。

引数を渡したり実行環境をカスタマイズしたりする必要がある場合は、`.zed/tasks.json` にタスク設定を追加します。

```json
[
  {
    "label": "run my-script.sh with args",
    "command": "./my-script.sh",
    "args": ["--verbose", "--output=results.txt"],
    "tags": ["bash-script"]
  }
]
```

## シェルの初期化

Zed がタスクを実行するとき、コマンドはログインシェル内で起動されます。これにより、タスクの実行前にシェルの初期化ファイル（`.bash_profile`、`.zshrc` など）が読み込まれることが保証されます。

この挙動により、タスクはシェルプロファイルで設定したものと同じ環境変数、エイリアス、PATH の変更にアクセスできます。タスクが、ターミナルでは動作するコマンドを見つけられない場合は、シェルの設定ファイルが正しく構成されているか確認してください。

タスクで使用されるシェルを上書きするには、`terminal.shell` 設定を構成します。

```json
{
  "terminal": {
    "shell": {
      "program": "/bin/zsh"
    }
  }
}
```

シェルオプションの詳細については [Terminal configuration](./terminal.md) を参照してください。
