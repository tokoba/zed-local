# macOS 向けに Zed をビルドする

## リポジトリ

[Zed リポジトリ](https://github.com/zed-industries/zed) をクローンします。

## 依存関係

- [rustup](https://www.rust-lang.org/tools/install) をインストールします。

- macOS App Store、または [Apple Developer](https://developer.apple.com/download/all/) のウェブサイトから [Xcode](https://apps.apple.com/us/app/xcode/id497799835?mt=12) をインストールします。Apple Developer からダウンロードする場合は、開発者アカウントが必要です。

> インストール後に Xcode を起動し、macOS コンポーネント（デフォルトのオプション）をインストールしてください。

- [Xcode command line tools](https://developer.apple.com/xcode/resources/) をインストールします。

  ```sh
  xcode-select --install
  ```

- Xcode command line tools が新しくインストールした Xcode を使用していることを確認します:

  ```sh
  sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
  sudo xcodebuild -license accept
  ```

- `cmake` をインストールします（[依存関係](https://docs.rs/wasmtime-c-api-impl/latest/wasmtime_c_api/) によって必要です）。

  ```sh
  brew install cmake
  ```

## ソースから Zed をビルドする

依存関係をインストールしたら、[Cargo](https://doc.rust-lang.org/cargo/) を使って Zed をビルドできます。

デバッグビルドの場合:

```sh
cargo run
```

リリースビルドの場合:

```sh
cargo run --release
```

テストを実行するには次のコマンドを使います:

```sh
cargo test --workspace
```

## ビジュアル回帰テスト

Zed には、実際の Zed ウィンドウのスクリーンショットを取得し、それらをベースライン画像と比較するビジュアル回帰テストが含まれています。これらのテストを実行するには、画面収録の権限が付与された macOS が必要です。

### 前提条件

ターミナルに画面収録の権限を付与する必要があります:

1. ビジュアルテストランナーを一度実行します — macOS から権限付与のダイアログが表示されます
2. または手動で: System Settings > Privacy & Security > Screen Recording
3. ターミナルアプリ（例: Terminal.app、iTerm2、Ghostty）を有効にします
4. 権限を付与したらターミナルを再起動します

### ビジュアルテストの実行

```sh
cargo run -p zed --bin zed_visual_test_runner --features visual-tests
```

### ベースライン画像

ベースライン画像は `crates/zed/test_fixtures/visual_tests/` に保存されますが、
リポジトリが肥大化しないよう **.gitignore によって管理対象外** になっています。
テストを実行する前にローカルで生成する必要があります。

#### 初期セットアップ

UI を変更する前に、既知の正常な状態からベースライン画像を生成します:

```sh
git checkout origin/main
UPDATE_BASELINE=1 cargo run -p zed --bin zed_visual_test_runner --features visual-tests
git checkout -
```

これにより、現在の期待される UI を反映したベースラインが作成されます。

#### ベースラインの更新

UI の変更が意図的なものである場合は、変更後にベースライン画像を更新します:

```sh
UPDATE_BASELINE=1 cargo run -p zed --bin zed_visual_test_runner --features visual-tests
```

> **注意:** 将来的にはベースライン画像が外部に保存される可能性があります。現在のところは、
> Git リポジトリを軽量に保つため、ローカルのみに保存されています。

## トラブルシューティング

### Metal シェーダーのコンパイルエラー

```sh
error: failed to run custom build command for gpui v0.1.0 (/Users/path/to/zed)`**

xcrun: error: unable to find utility "metal", not a developer tool or in PATH
```

`sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer` を試してください。

macOS 26 を使用している場合は、`xcodebuild -downloadComponent MetalToolchain` を試してください。
このコマンドが失敗する場合は、`xcodebuild -runFirstLaunch` を実行し、ツールチェーンのダウンロードを再度試してください。

### 依存関係が unstable な機能を使用しているとする Cargo エラー

`cargo clean` と `cargo build` を試してください。

### エラー: 'dispatch/dispatch.h' file not found

次のようなエラーが発生した場合:

```sh
src/platform/mac/dispatch.h:1:10: fatal error: 'dispatch/dispatch.h' file not found

Caused by:
  process didn't exit successfully

  --- stdout
  cargo:rustc-link-lib=framework=System
  cargo:rerun-if-changed=src/platform/mac/dispatch.h
  cargo:rerun-if-env-changed=TARGET
  cargo:rerun-if-env-changed=BINDGEN_EXTRA_CLANG_ARGS_aarch64-apple-darwin
  cargo:rerun-if-env-changed=BINDGEN_EXTRA_CLANG_ARGS_aarch64_apple_darwin
  cargo:rerun-if-env-changed=BINDGEN_EXTRA_CLANG_ARGS
```

このファイルは Xcode に含まれています。Xcode コマンドラインツールがインストールされており、パスが正しく設定されていることを確認してください:

```sh
xcode-select --install
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
```

さらに、`BINDGEN_EXTRA_CLANG_ARGS` 環境変数を設定します:

```sh
export BINDGEN_EXTRA_CLANG_ARGS="--sysroot=$(xcrun --show-sdk-path)"
```

その後、プロジェクトをクリーンし、再ビルドします:

```sh
cargo clean
cargo run
```

### `Too many open files (os error 24)` によってテストが失敗する

このエラーは、OS のリソース制限が原因で発生しているようです。`cargo-nextest` をインストールし、それを使ってテストを実行することで問題が解決するはずです。

- `cargo install cargo-nextest --locked`
- `cargo nextest run --workspace --no-fail-fast`

## ヒントとコツ

### 継続的な再ビルドを避ける

Zed がルートクレートを何度も再ビルドしてしまう場合、開発用ビルドで Zed 自身のコードベースを開いている可能性があります。

これは問題を引き起こします。というのも、`cargo run` が多くの環境変数をエクスポートし、
それを Zed の開発ビルドで動作している `rust-analyzer` が読み取ってしまうためです。
これらの環境変数は `cargo check` に渡され、その結果、依存しているいくつかのクレートのビルドキャッシュが無効になってしまいます。

これを避けるには、ビルド済みバイナリを別のプロジェクトに対して実行します。例えば、`cargo run ~/path/to/other/project` のように実行します。

### 検証の高速化

Zed を頻繁にビルドしている場合、macOS が新しいビルドを毎回検証しようとするため、反復ごとに数秒のオーバーヘッドが発生することがあります。

これを改善するには、次のようにします:

- `sudo spctl developer-mode enable-terminal` を実行して、システム設定に Developer Tools パネルを有効にします。
- システム設定で「Developer Tools」を検索し、「Allow applications to use developer tools」の一覧に使用しているターミナル（例: iTerm や Ghostty）を追加します。
- ターミナルを再起動します。

[nextest の開発者](https://nexte.st/docs/installation/macos/#gatekeeper) がこのドキュメントを公開してくれていることに感謝します。
