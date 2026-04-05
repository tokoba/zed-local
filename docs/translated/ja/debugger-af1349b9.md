# デバッガー

Zed は [Debug Adapter Protocol (DAP)](https://microsoft.github.io/debug-adapter-protocol/) を使用して、複数のプログラミング言語にわたるデバッグ機能を提供します。
DAP は、デバッガー、エディター、IDE が互いにどのように通信するかを定義する標準化されたプロトコルです。
これにより、Zed は言語ごとのデバッグロジックを実装することなく、さまざまなデバッガーをサポートできます。
Zed はプロトコルのクライアント側を実装しており、さまざまな *debug adapters* がサーバー側を実装しています。

このプロトコルにより、ブレークポイントの設定、コードのステップ実行、変数の検査など、
さまざまなプログラミング言語やランタイム環境にわたって一貫した方法で機能を利用できるようになります。

## 対応言語

特定の言語で書かれたコードをデバッグするには、Zed がその言語用のデバッグアダプターを見つける必要があります。いくつかのデバッグアダプターは追加のセットアップなしに Zed によって提供され、他はいくつかの [language extensions](./extensions/debugger-extensions.md) によって提供されます。現在、次の言語についてデバッグアダプターが利用可能です。

<!-- 並び順を保つこと -->

- [C](./languages/c.md#debugging) (組み込み)
- [C++](./languages/cpp.md#debugging) (組み込み)
- [Go](./languages/go.md#debugging) (組み込み)
- [Java](./languages/java.md#debugging) (拡張機能によって提供)
- [JavaScript](./languages/javascript.md#debugging) (組み込み)
- [PHP](./languages/php.md#debugging) (組み込み)
- [Python](./languages/python.md#debugging) (組み込み)
- [Ruby](./languages/ruby.md#debugging) (拡張機能によって提供)
- [Rust](./languages/rust.md#debugging) (組み込み)
- [Swift](./languages/swift.md#debugging) (拡張機能によって提供)
- [TypeScript](./languages/typescript.md#debugging) (組み込み)

> 利用している言語がこの一覧にない場合は、その言語用のデバッグアダプターを追加することで貢献できます。詳しくは [debugger extensions](./extensions/debugger-extensions.md) のドキュメントを参照してください。

言語やアダプター固有の情報やサンプルについてはこれらのリンク先を参照するか、すべてのアダプターに適用される Zed の一般的なデバッグ機能について知りたい場合は、この先を読み進めてください。

## はじめに

ほとんどの言語では、最も手っ取り早く始める方法は {#action debugger::Start} ({#kb debugger::Start}) を実行することです。これにより *new process modal* が開き、現在のプロジェクト向けに事前設定されたデバッグタスクの、コンテキストに応じた一覧が表示されます。デバッグタスクはテスト、エントリポイント（`main` 関数など）、その他の情報源から作成されます。サポート内容の詳細については、各言語のドキュメントを参照してください。

同じモーダルは、デバッグパネル右上の「プラス」ボタンをクリックして開くこともできます。

事前設定済みのデバッグタスクを提供しない言語（C、C++、および一部の拡張機能がサポートする言語など）の場合は、プロジェクトルートにある `.zed/debug.json` ファイル内にデバッグ構成を定義できます。このファイルは構成オブジェクトの配列である必要があります。

```json [debug]
[
  {
    "adapter": "CodeLLDB",
    "label": "First configuration"
    // ...
  },
  {
    "adapter": "Debugpy",
    "label": "Second configuration"
    // ...
  }
]
```

代表的なユースケースをカバーする構成例については、各言語のドキュメントを確認してください。`.zed/debug.json` に構成を追加すると、それらは new process モーダルの一覧に表示されます。

Zed は `.vscode/launch.json` からデバッグ構成も読み込み、`.zed/debug.json` に構成が見つからない場合は、それらを new process モーダルに表示します。

#### グローバルなデバッグ構成

複数のプロジェクトで同じ起動プロファイルを使用する場合は、それらをユーザー設定に一度だけ保存できます。コマンドパレットから {#action zed::OpenDebugTasks} を実行してグローバルな `debug.json` ファイルを開きます。このファイルは、ユーザーの `settings.json` の隣に Zed が作成し、デバッガー UI と同期された状態に保ちます。ファイルの場所は次のとおりです。

- **macOS:** `~/Library/Application Support/Zed/debug.json`
- **Linux/BSD:** `$XDG_CONFIG_HOME/zed/debug.json` (falls back to `~/.config/zed/debug.json`)
- **Windows:** `%APPDATA%\Zed\debug.json`

このファイルには、`.zed/debug.json` に記述するものと同じオブジェクト配列を記述します。ここで定義したシナリオはすべてのワークスペースにマージされるため、お気に入りの起動プリセットが "New Debug Session" ダイアログに自動的に表示されます。

### 起動とアタッチ

Zed のデバッガーにはプログラムをデバッグする方法が 2 つあります。プログラムの新しいインスタンスを *起動* するか、既存のプロセスに *アタッチ* するかです。
どちらを選ぶかは、達成したい目的によって異なります。

新しいインスタンスを起動する場合、Zed（およびその基盤となるデバッグアダプター）はプログラム全体のライフタイムを制御できるため、既存のプロセスにアタッチする場合と比べてデバッグ情報を取得しやすいことが多くなります。
ユニットテストの実行やアプリケーションのデバッグビルドの実行は、起動を用いるのに適したユースケースです。

起動と比べると、既存のプロセスへのアタッチは劣っているように見えるかもしれませんが、実際にはそうではありません。たとえば、バグが本番環境以外では再現しないなどの理由でプログラムを再起動できない場合があります。

## 設定

Zed では、すべてのデバッグタスクに対して `adapter` フィールドと `label` フィールドが必須です。さらに、Zed はデバッガーを開始する前に必要なセットアップ手順を実行するために `build` フィールドを使用し（[下記参照](#build-tasks)）、既存のプロセスに接続するための `tcp_connection` フィールドも受け付けます。

その他のフィールドはデバッグアダプターによって提供され、[タスク変数](./tasks.md#variables) を含めることができます。ほとんどのアダプターは `request`、`program`、`cwd` をサポートしています。

```json [debug]
[
  {
    // デバッグ構成のラベルであり、デバッグパネルおよび new process モーダル内でデバッグセッションを識別するために使用されます
    "label": "Example Start debugger config",
    // Zed がプログラムをデバッグする際に使用するデバッグアダプター
    "adapter": "Example adapter name",
    // request の種類:
    //  - launch: 指定されていれば Zed がプログラムを起動するか、適切な設定でデバッグターミナルを表示します
    //  - attach: Zed が実行中のプログラムにアタッチしてデバッグするか、process_id が指定されていない場合はプロセスピッカーを表示します（現在は node のみサポート）
    "request": "launch",
    // デバッグ対象のプログラム。このフィールドでは ~ や . 記号を用いたパス解決がサポートされています。
    "program": "path_to_program",
    // cwd: デフォルトはプロジェクトのカレント作業ディレクトリ（$ZED_WORKTREE_ROOT）です
    "cwd": "$ZED_WORKTREE_ROOT"
  }
]
```

サポートされているフィールドの詳細については、使用しているデバッグアダプターのドキュメントを参照してください。

### ビルドタスク

Zed では、デバッガーの開始前に実行される Zed タスクを `build` フィールドに埋め込むことができます。これは、デバッガーを開始する前に環境を構築したり、必要なセットアップ手順を実行したりするのに役立ちます。

```json [debug]
[
  {
    "label": "バイナリのビルド",
    "adapter": "CodeLLDB",
    "program": "path_to_program",
    "request": "launch",
    "build": {
      "command": "make",
      "args": ["build", "-j8"]
    }
  }
]
```

ビルドタスクは、置換されていないラベルを使って既存のタスクを参照することもできます:

```json [debug]
[
  {
    "label": "Build Binary",
    "adapter": "CodeLLDB",
    "program": "path_to_program",
    "request": "launch",
    "build": "my build task" // または "my build task for $ZED_FILE"
  }
]
```

### シナリオの自動作成

Zed タスクが与えられると、Zed はシナリオを自動的に作成できます。シナリオの自動作成は、ガターからのシナリオ作成機能の基盤にもなっています。
現在、シナリオの自動作成は Rust、Go、Python、JavaScript、TypeScript でサポートされています。

## ブレークポイント

ブレークポイントを設定するには、エディターのガターで行番号の横をクリックするだけです。
ブレークポイントはニーズに応じて調整できます。特定のブレークポイントの追加オプションにアクセスするには、ガター内のブレークポイントアイコンを右クリックし、目的のオプションを選択します。
現在、次のことができます。

- ブレークポイントにログを追加し、そのブレークポイントに到達するたびにログメッセージを出力する。
- ブレークポイントに条件を設定し、その条件が満たされた場合にのみそのブレークポイントで停止するようにする。条件式の構文はアダプターごとに異なります。
- ブレークポイントにヒットカウントを設定し、指定回数ヒットした後にのみブレークポイントで停止するようにする。
- ブレークポイントを無効化し、ガターには表示したままヒットしないようにする。

一部のデバッグアダプター（例: CodeLLDB や JavaScript）では、ブレークポイントに実際に到達可能かどうかを *検証* します。到達不能なブレークポイントは、UI 上でより目立つ形で示されます。

特定のプロジェクトで有効になっているすべてのブレークポイントは、デバッグセッションの UI にある "Breakpoints" 項目にも一覧表示されます。UI の "Breakpoints" 項目からは、例外ブレークポイントも管理できます。
その後、デバッグアダプターは指定した種類の例外が発生したときに停止します。サポートされる例外の種類はデバッグアダプターによって異なります。

## 分割ペインでの操作

複数の分割ペインを開いた状態でデバッグする場合、Zed はいずれか 1 つのペインにアクティブなデバッグ行を表示し、他のペインのレイアウトはそのまま保持します。同じファイルを複数のペインで開いている場合、デバッガーはそのファイルがすでにアクティブタブになっているペインを選択し、ファイルが非アクティブなペインのタブを切り替えることはありません。

デバッガーが一度ペインを選択すると、そのセッション中の以降のブレークポイントでも同じペインを使い続けます。アクティブなデバッグ行を含むタブを別の分割へドラッグした場合、デバッガーはその移動を追跡し、新しいペインを使用します。

これにより、異なるファイル間でステップ実行するときでも、デバッガーがワークフローを妨げないようになっています。

## 設定

デバッガーに関する設定は、`settings.json` の `debugger` キーの下にまとめられています。

- `dock`: デバッグパネルの UI 上での位置を指定します。
- `stepping_granularity`: ステップ実行の粒度を指定します。
- `save_breakpoints`: ブレークポイントを Zed のセッション間で再利用するかどうかを指定します。
- `button`: ステータスバーにデバッグボタンを表示するかどうかを指定します。
- `timeout`: TCP デバッグアダプターに接続するときのタイムアウトエラーまでの時間（ミリ秒）を指定します。
- `log_dap_communications`: アクティブなデバッグアダプターと Zed 間のメッセージをログに記録するかどうかを指定します。
- `format_dap_log_messages`: デバッグアダプターロガーに追加する際に DAP メッセージを整形するかどうかを指定します。

### Dock

- 説明: デバッグパネルの UI 上での位置。
- 既定値: `bottom`
- 設定: debugger.dock

**オプション**

1. `left` - デバッグパネルが UI の左側にドックされます。
2. `right` - デバッグパネルが UI の右側にドックされます。
3. `bottom` - デバッグパネルが UI の下部にドックされます。

```json [settings]
"debugger": {
  "dock": "bottom"
},
```

### Stepping granularity

- 説明: デバッガーが使用するステップ実行の粒度。
- 既定値: `line`
- 設定: `debugger.stepping_granularity`

**オプション**

1. Statement - ステップ実行では、現在のステートメントの実行が完了するまでプログラムを実行します。
   ステートメントの意味はアダプターによって決定され、行と同等とみなされる場合もあります。
   例えば `for(int i = 0; i < 10; i++)` は、`int i = 0`、`i < 10`、`i++` という 3 つのステートメントを持つとみなされることがあります。

```json [settings]
{
  "debugger": {
    "stepping_granularity": "statement"
  }
}
```

2. Line - ステップ実行では、現在のソース行の実行が完了するまでプログラムを実行します。

```json [settings]
{
  "debugger": {
    "stepping_granularity": "line"
  }
}
```

3. Instruction - ステップ実行では、1 命令（例: 1 つの x86 命令）の実行を許可します。

```json [settings]
{
  "debugger": {
    "stepping_granularity": "instruction"
  }
}
```

### Save Breakpoints

- 説明: ブレークポイントを Zed のセッション間で保存するかどうか。
- 既定値: `true`
- 設定: `debugger.save_breakpoints`

**オプション**

`boolean` 値

```json [settings]
{
  "debugger": {
    "save_breakpoints": true
  }
}
```

### Button

- 説明: ボタンをデバッガーツールバーに表示するかどうか。
- 既定値: `true`
- 設定: `debugger.button`

**オプション**

`boolean` 値

```json [settings]
{
  "debugger": {
    "button": true
  }
}
```

### Timeout

- 説明: TCP デバッグアダプターへの接続時にタイムアウトエラーとなるまでの時間（ミリ秒）。
- 既定値: `2000`
- 設定: `debugger.timeout`

**オプション**

`integer` 値

```json [settings]
{
  "debugger": {
    "timeout": 3000
  }
}
```

### Inline Values

- 説明: デバッグセッション中に、コード内の変数の値を表示するエディターのインレイヒントを有効にするかどうか。
- 既定値: `true`
- 設定: `inlay_hints.show_value_hints`

**オプション**

```json [settings]
{
  "inlay_hints": {
    "show_value_hints": false
  }
}
```

インライン値ヒントは、エディターツールバーの Editor Controls メニューからも切り替えできます。

### Log Dap Communications

- 説明: アクティブなデバッグアダプターと Zed 間のメッセージをログに記録するかどうか。（DAP の開発時に使用）
- 既定値: false
- 設定: debugger.log_dap_communications

**オプション**

`boolean` 値

```json [settings]
{
  "debugger": {
    "log_dap_communications": true
  }
}
```

### Format Dap Log Messages

- 説明: DAP メッセージをデバッグアダプターロガーに追加する際に整形するかどうか。（DAP の開発時に使用）
- 既定値: false
- 設定: debugger.format_dap_log_messages

**オプション**

`boolean` 値

```json [settings]
{
  "debugger": {
    "format_dap_log_messages": true
  }
}
```

### Customizing Debug Adapters

- 説明: 特定のデバッグアダプターを Zed が起動する方法を上書きするための、カスタムのプログラムパスと引数。
- 既定値: アダプターごとに異なる
- 設定: `dap.$ADAPTER.binary` と `dap.$ADAPTER.args`

`binary`、`args`、またはその両方を指定できます。`binary` には、*デバッガー*（`lldb` など）ではなく、*デバッグアダプター*（`lldb-dap` など）へのパスを指定する必要があります。`args` 設定は、通常 Zed がアダプターに渡す引数をすべて上書きします。

```json [settings]
{
  "dap": {
    "CodeLLDB": {
      "binary": "/Users/name/bin/lldb-dap",
      "args": ["--wait-for-debugger"]
    }
  }
}
```

## Theme

デバッガーは次のテーマオプションをサポートしています。

- `debugger.accent`: ブレークポイントおよびブレークポイント関連のシンボルを強調表示するために使用される色
- `editor.debugger_active_line.background`: アクティブなデバッグ行の背景色

## トラブルシューティング

If you're running into problems with the debugger, please [open a GitHub issue](https://github.com/zed-industries/zed/issues/new?template=04_bug_debugger.yml), providing as much context as possible. There are also some features you can use to gather more information about the problem:

- デバッグパネルでセッションが実行中の場合、{#action dev::CopyDebugAdapterArguments} アクションを実行すると、Zed がセッションをどのように初期化したかを記述した JSON ブロブをクリップボードにコピーできます。これはセッションの起動に失敗した場合に特に有用で、GitHub の issue を作成する際に添付するコンテキストとして最適です。
- また、{#action dev::OpenDebugAdapterLogs} アクションを使用して、直近のデバッグセッション中に行われた Zed とデバッグアダプターとのすべての通信のトレースを確認することもできます。
