# デバッガー拡張機能

[Debug Adapter Protocol](https://microsoft.github.io/debug-adapter-protocol) サーバーは、[デバッガー](../debugger.md) で利用できる拡張機能として公開できます。

## デバッガー拡張機能の定義

1 つの拡張機能は、1 つ以上の DAP サーバーを提供できます。
各 DAP サーバーは `extension.toml` 内で登録する必要があります。

```toml
[debug_adapters.my-debug-adapter]
# デバッグアダプター設定スキーマ用 JSON スキーマへの任意の相対パス。既定値は `debug_adapter_schemas/$DEBUG_ADAPTER_NAME_ID.json` です。
# このフィールドは任意ですが、スキーマ自体は必須であることに注意してください。
schema_path = "relative/path/to/schema.json"
```

次に、拡張機能の Rust コードで、拡張機能に対して `get_dap_binary` メソッドを実装します。

```rust
impl zed::Extension for MyExtension {
    fn get_dap_binary(
        &mut self,
        adapter_name: String,
        config: DebugTaskDefinition,
        user_provided_debug_adapter_path: Option<String>,
        worktree: &Worktree,
    ) -> Result<DebugAdapterBinary, String>;
}
```

このメソッドは、Debug Adapter Protocol サーバーを起動するコマンドと、その動作に必要な引数や環境変数を返す必要があります。

DAP サーバーを外部ソース（GitHub Releases、npm など）からダウンロードする必要がある場合は、この関数内でそれを行うこともできます。この関数はユーザーがあなたのデバッグアダプターで新しいデバッグセッションを開始するたびに呼び出されるため、更新の確認は定期的にのみ行うようにしてください。

また、`dap_request_kind` も実装する必要があります。この関数は、あるデバッグシナリオが新しいデバッグ対象を *起動* するのか、既存のものに *接続* するのかを判定するために使用されます。
また、特定のデバッグシナリオで *ロケーター* を実行する必要があるかどうかを判定するためにも使用されます。

```rust
impl zed::Extension for MyExtension {
    fn dap_request_kind(
        &mut self,
        _adapter_name: String,
        _config: Value,
    ) -> Result<StartDebuggingRequestArgumentsRequest, String>;
}
```

`debug.json` ベースのユーザーワークフローであなたのデバッグアダプターを利用可能にするには、これら 2 つの関数で十分ですが、`dap_config_to_scenario` も実装することを強く検討してください。

```rust
impl zed::Extension for MyExtension {
    fn dap_config_to_scenario(
        &mut self,
        _adapter_name: DebugConfig,
    ) -> Result<DebugScenario, String>;
}
```

`dap_config_to_scenario` は、ユーザーが新しいプロセスのモーダル UI 経由でセッションを開始するときに使用されます。大まかに言うと、これは（特定の
デバッグアダプターに依存しない）汎用的なデバッグ設定を受け取り、それをあなたのアダプター用の具体的なデバッグシナリオに変換しようとします。
言い換えると、「プログラム、引数のリスト、カレントワーキングディレクトリ、環境変数が与えられたとき、このデバッグアダプターを起動する設定はどのようなものになるか？」という問いに答えることを目的としています。

## デバッグロケーターの定義

Zed には、*デバッグロケーター* を使ってデバッグシナリオを自動的に作成する方法が用意されています。
ロケーターはデバッグターゲットを特定し、そのためのデバッグセッションをどのように起動するかを判断します。ロケーターのおかげで、既存のユーザータスク（例: `cargo run`）を、自動的にデバッグシナリオ（例: `cargo build` を実行し、その後 `target/debug/my_program` をデバッグ対象のプログラムとしてデバッガーを起動する）に変換できます。

> あなたの拡張機能は、デバッグアダプターを公開していない場合でも独自のデバッグロケーターを定義できます。拡張機能がすでに言語タスクを公開している場合は、デバッグアダプターを手動で設定しなくてもユーザーがデバッグセッションを開始できるようになるため、この方法を強く推奨します。

ロケーターは、使用されるデバッグアダプターに依存しない形（そうでなくても構いません）で実装できます。ロケーターはデバッグターゲットを特定し、そのためのデバッグセッションをどのように起動するかを判断する責任があります。これにより、拡張機能はロケーターのロジックをアダプター間で共有できます。

拡張機能は 1 つ以上のデバッグロケーターを定義できます。各デバッグロケーターは `extension.toml` に登録する必要があります。

```toml
[debug_locators.my-debug-locator]
```

ロケーターには 2 つのコンポーネントがあります。
まず、利用可能な各タスクに対して各ロケーターが実行され、そのタスクに対していずれかのロケーターがデバッグシナリオを提供できるかどうかを判定します。これは `dap_locator_create_scenario` を呼び出すことで行われます。

```rust
impl zed::Extension for MyExtension {
    fn dap_locator_create_scenario(
        &mut self,
        _locator_name: String,
        _build_task: TaskTemplate,
        _resolved_label: String,
        _debug_adapter_name: String,
    ) -> Option<DebugScenario>;
}
```

この関数は、特定のユーザータスクに対応するデバッグ用タスクを定義する場合に `Some` デバッグシナリオを返す必要があります。
`DebugScenario` には [ビルドタスク](../debugger.md#build-tasks) を含めることができます。ビルドタスクが含まれている場合は、ビルドタスクが正常に完了した後に `run_dap_locator` を実行します。

```rust
impl zed::Extension for MyExtension {
    fn run_dap_locator(
        &mut self,
        _locator_name: String,
        _build_task: TaskTemplate,
    ) -> Result<DebugRequest, String>;
}
```

ビルドターゲットを決定的に特定できない場合、`run_dap_locator` は有用です。ビルドシステムによっては、あらかじめ名前が分からない成果物を生成するものもあります。
ただし、2 段階の解決処理を行う必要は *ありません*。`dap_locator_create_scenario` だけで完全なデバッグ設定を決定できる場合は、返される `DebugScenario` の `build` プロパティを省略できます。 また、ロケーターは受け入れる可能性が低いタスクに対しても **呼び出されます**。そのため、コストの高い処理を実行する前に、できるだけ早く `None` を返すように努めるべきです。

## 利用可能な拡張機能

拡張機能として公開されている DAP サーバーについては、[Zed のサイト](https://zed.dev/extensions?filter=debug-adapters) を参照してください。

一般的な実装パターンや構造を確認するために、それらのリポジトリを参照してください。

## テスト

新しい Debug Adapter Protocol サーバー拡張機能をテストするには、[開発用拡張機能としてインストール](./developing-extensions.md#developing-an-extension-locally) できます。
