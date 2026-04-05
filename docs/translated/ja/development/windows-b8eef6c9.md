# Windows での Zed のビルド

> 以下のコマンドは任意のシェルで実行できます。

## リポジトリ

[Zed リポジトリ](https://github.com/zed-industries/zed) をクローンします。

## 依存関係

- [rustup](https://www.rust-lang.org/tools/install) をインストールします。

- オプションコンポーネント `MSVC v*** - VS YYYY C++ x64/x86 build tools` と `MSVC v*** - VS YYYY C++ x64/x86 Spectre-mitigated libs (latest)` を含めて [Visual Studio](https://visualstudio.microsoft.com/downloads/) をインストールします（`v***` は使用している VS のバージョン、`YYYY` はリリース年です。必要に応じてアーキテクチャを調整してください）。
- もしくは、より軽量なインストールを望む場合は、[Build Tools](https://visualstudio.microsoft.com/visual-cpp-build-tools/) のみ（上記のライブラリに加えて）と "Desktop development with C++" ワークロードをインストールします。
  このセットアップは rustup によって自動的には検出されません。コンパイルする前に、スタートメニューまたは Windows Terminal からインストールされた開発者シェル（cmd/PowerShell）を起動して、環境変数を初期化してください。
- 使用しているシステム用の Windows 11 または 10 SDK をインストールし、少なくとも `Windows 10 SDK version 2104 (10.0.20348.0)` がインストールされていることを確認してください。[Windows SDK Archive](https://developer.microsoft.com/windows/downloads/windows-sdk/) からダウンロードできます。
- [CMake](https://cmake.org/download) をインストールします（[依存関係](https://docs.rs/wasmtime-c-api-impl/latest/wasmtime_c_api/) によって必要とされます）。あるいは Visual Studio Installer を通じてインストールしてから、`bin` ディレクトリを手動で `PATH` に追加します。例: `C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin`。

Zed をコンパイルできない場合は、Visual Studio のインストールに少なくとも次のコンポーネントが含まれていることを確認してください。

```json
{
  "version": "1.0",
  "components": [
    "Microsoft.VisualStudio.Component.CoreEditor",
    "Microsoft.VisualStudio.Workload.CoreEditor",
    "Microsoft.VisualStudio.Component.VC.Tools.x86.x64",
    "Microsoft.VisualStudio.ComponentGroup.WebToolsExtensions.CMake",
    "Microsoft.VisualStudio.Component.VC.CMake.Project",
    "Microsoft.VisualStudio.Component.Windows11SDK.26100",
    "Microsoft.VisualStudio.Component.VC.Runtimes.x86.x64.Spectre"
  ],
  "extensions": []
}
```

Build Tools のみを使用している場合は、次のコンポーネントがインストールされていることを確認してください。

```json
{
  "version": "1.0",
  "components": [
    "Microsoft.VisualStudio.Component.Roslyn.Compiler",
    "Microsoft.Component.MSBuild",
    "Microsoft.VisualStudio.Component.CoreBuildTools",
    "Microsoft.VisualStudio.Workload.MSBuildTools",
    "Microsoft.VisualStudio.Component.Windows10SDK",
    "Microsoft.VisualStudio.Component.VC.CoreBuildTools",
    "Microsoft.VisualStudio.Component.VC.Tools.x86.x64",
    "Microsoft.VisualStudio.Component.VC.Redist.14.Latest",
    "Microsoft.VisualStudio.Component.Windows11SDK.26100",
    "Microsoft.VisualStudio.Component.VC.CMake.Project",
    "Microsoft.VisualStudio.Component.TextTemplating",
    "Microsoft.VisualStudio.Component.VC.CoreIde",
    "Microsoft.VisualStudio.ComponentGroup.NativeDesktop.Core",
    "Microsoft.VisualStudio.Workload.VCTools",
    "Microsoft.VisualStudio.Component.VC.Runtimes.x86.x64.Spectre"
  ],
  "extensions": []
}
```

コンポーネント一覧は次の手順でエクスポートできます。

- Visual Studio Installer を開きます。
- `Installed` タブで `More` をクリックします。
- `Export configuration` をクリックします。

### 注意点

`data` ディレクトリ内の `pg_hba.conf` を更新し、`host` メソッドについて `scram-sha-256` の代わりに `trust` を使用するようにします。そうしないと、接続は `password authentication failed` というエラーで失敗します。ファイルは通常、`C:\Program Files\PostgreSQL\17\data\pg_hba.conf` にあります。変更後は次のようになっているはずです。

```conf
# IPv4 ローカル接続:
host    all             all             127.0.0.1/32            trust
# IPv6 ローカル接続:
host    all             all             ::1/128                 trust
```

ラテン文字以外を使用する Windows ロケールを使用している場合は、`data` ディレクトリ内の `postgresql.conf` の `lc_messages` パラメーターを `English_United States.1252`（もしくはシステムで利用可能な UTF-8 互換の別のエンコーディング）に設定してください。そうしないと、データベースがパニックを起こす可能性があります。ファイルは次のようになっているはずです。

```conf
# lc_messages = 'Chinese (Simplified)_China.936' # システムエラーメッセージ文字列のロケール
lc_messages = 'English_United States.1252'
```

その後、`postgresql` サービスを再起動します。`Win`+`R` を押して「ファイル名を指定して実行」ダイアログを開き、`services.msc` と入力して **OK** を選択します。サービスマネージャーで `postgresql-x64-XX` を探し、右クリックして **Restart** を選択します。

## ソースからビルドする

依存関係をインストールしたら、[Cargo](https://doc.rust-lang.org/cargo/) を使って Zed をビルドできます。

デバッグビルドの場合:

```sh
cargo run
```

リリースビルドの場合:

```sh
cargo run --release
```

テストを実行するには次のとおりです。

```sh
cargo test --workspace
```

> **注意:** ビジュアル回帰テストは現在 macOS のみ対応で、Screen Recording 権限が必要です。詳細は [macOS での Zed のビルド](./macos.md#visual-regression-tests) を参照してください。

## msys2 からのインストール

Zed は、Mingw-w64 向けにビルドされた非公式の MSYS2 Zed パッケージをサポートしていません。[mingw-w64-zed](https://packages.msys2.org/base/mingw-w64-zed) に関する問題がある場合は、[msys2/MINGW-packages/issues](https://github.com/msys2/MINGW-packages/issues?q=is%3Aissue+is%3Aopen+zed) へ報告してください。

まず [MSYS2 ドキュメント](https://www.msys2.org/docs/ides-editors/#zed) を参照してください。

## トラブルシューティング

### `RUSTFLAGS` 環境変数の設定によってビルドが壊れる

`RUSTFLAGS` 環境変数を設定すると、Zed を正しくビルドするために必要な `.cargo/config.toml` 内の `rustflags` 設定が上書きされてしまいます。

これらの設定は時間とともに変更されるため、発生するビルドエラーはリンカエラーから、原因の特定が難しいその他のエラーまでさまざまです。

追加の Rust フラグが必要な場合は、`.cargo/config.toml` で次のいずれかの方法を使用してください。

`build` セクションにフラグを追加します。

```toml
[build]
rustflags = ["-C", "symbol-mangling-version=v0", "--cfg", "tokio_unstable"]
```

Windows ターゲットセクションにフラグを追加します。

```toml
[target.'cfg(target_os = "windows")']
rustflags = [
    "--cfg",
    "windows_slim_errors",
    "-C",
    "target-feature=+crt-static",
]
```

または、Zed リポジトリの親ディレクトリに新しい `.cargo/config.toml` を作成します（下記参照）。この方法は、リポジトリの元の `.cargo/config.toml` を編集する必要がないため、CI で便利です。

```
upper_dir
├── .cargo          // <-- このフォルダーを作成します
│   └── config.toml // <-- このファイルを作成します
└── zed
    ├── .cargo
    │   └── config.toml
    └── crates
        ├── assistant
        └── ...
```

新しく作成した（上記の） `.cargo/config.toml` で `rustflags` に `--cfg gles` を追加する場合、次のようになります。

```toml
[target.'cfg(all())']
rustflags = ["--cfg", "gles"]
```

### 依存関係が unstable 機能を使用しているとする Cargo エラー

`cargo clean` と `cargo build` を試してください。

### `STATUS_ACCESS_VIOLATION`

このエラーは、"rust-lld.exe" リンカを使用している場合に発生することがあります。別のリンカを試すことを検討してください。
グローバル設定を使用している場合は、Zed リポジトリをサブディレクトリに移動し、親ディレクトリにカスタムリンカー設定を記述した `.cargo/config.toml` を追加することを検討してください。

詳しくは、この issue [#12041](https://github.com/zed-industries/zed/issues/12041) を参照してください。

### 無効な RC パスが選択される

ラップトップに適用されているセキュリティポリシーによっては、Zed をコンパイル中に次のようなエラーが発生する場合があります。

```
error: failed to run custom build command for `zed(C:\Users\USER\src\zed\crates\zed)`

Caused by:
  process didn't exit successfully: `C:\Users\USER\src\zed\target\debug\build\zed-b24f1e9300107efc\build-script-build` (exit code: 1)
  --- stdout
  cargo:rerun-if-changed=../../.git/logs/HEAD
  cargo:rustc-env=ZED_COMMIT_SHA=25e2e9c6727ba9b77415588cfa11fd969612adb7
  cargo:rustc-link-arg=/stack:8388608
  cargo:rerun-if-changed=resources/windows/app-icon.ico
  package.metadata.winresource does not exist
  Selected RC path: 'bin\x64\rc.exe'

  --- stderr
  The system cannot find the path specified. (os error 3)
warning: build failed, waiting for other jobs to finish...
```

この問題を解決するには、`ZED_RC_TOOLKIT_PATH` 環境変数に RC ツールキットのパスを手動で設定してください。通常は次のようになります:
`C:\Program Files (x86)\Windows Kits\10\bin\<SDK_version>\x64`.

詳しくは、この [issue](https://github.com/zed-industries/zed/issues/18393) を参照してください。

### ビルドが失敗する: パスが長すぎる

ビルド時に次のようなエラーが発生することがあります。

```
error: failed to get `pet` as a dependency of package `languages v0.1.0 (D:\a\zed-windows-builds\zed-windows-builds\crates\languages)`

Caused by:
  failed to load source for dependency `pet`

Caused by:
  Unable to update https://github.com/microsoft/python-environment-tools.git?rev=ffcbf3f28c46633abd5448a52b1f396c322e0d6c#ffcbf3f2

Caused by:
  path too long: 'C:/Users/runneradmin/.cargo/git/checkouts/python-environment-tools-903993894b37a7d2/ffcbf3f/crates/pet-conda/tests/unix/conda_env_without_manager_but_found_in_history/some_other_location/conda_install/conda-meta/python-fastjsonschema-2.16.2-py310hca03da5_0.json'; class=Filesystem (30)
```

これを解決するには、Git と Windows の両方で長いパスのサポートを有効にしてください。

Git の場合: `git config --system core.longpaths true`

Windows では、次の PS コマンドを実行します:

```powershell
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "LongPathsEnabled" -Value 1 -PropertyType DWORD -Force
```

これについての詳細は、[win32 docs](https://learn.microsoft.com/en-us/windows/win32/fileio/maximum-file-path-limitation?tabs=powershell) を参照してください。

（長いパスのサポートを有効にした後は、システムを再起動する必要があります。）

### グラフィックスの問題

#### Zed が起動しない

Zed は現在、Windows ではグラフィックス API として Vulkan を使用しています。Zed が起動しない場合、原因としてよくあるのが Vulkan です。

Zed のログは次の場所で確認できます:
`C:\Users\YOU\AppData\Local\Zed\logs\Zed.log`

次のようなメッセージが表示されている場合は、

- `Zed failed to open a window: NoSupportedDeviceFound`
- `ERROR_INITIALIZATION_FAILED`
- `GPU Crashed`
- `ERROR_SURFACE_LOST_KHR`

お使いのシステムで Vulkan が正しく動作していない可能性があります。GPU ドライバーを更新することで解決する場合がよくあります。

ログに Vulkan 関連の内容が何もなく、お使いの環境に Bandicam がインストールされている場合は、アンインストールしてみてください。Zed は現在 Bandicam と互換性がありません。
