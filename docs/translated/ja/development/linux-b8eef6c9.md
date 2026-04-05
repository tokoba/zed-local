# Linux 向け Zed のビルド

## リポジトリ

[Zed リポジトリ](https://github.com/zed-industries/zed) をクローンします。

## 依存関係

- [rustup](https://www.rust-lang.org/tools/install) をインストールします。

- 必要なシステムライブラリをインストールします:

  ```sh
  script/linux
  ```

  システムライブラリを手動でインストールしたい場合は、必要なパッケージの一覧を `script/linux` ファイル内で確認できます。

### リンカ {#linker}

Linux では、Rust のデフォルトリンカは [LLVM の `lld`](https://blog.rust-lang.org/2025/09/18/Rust-1.90.0/) です。代替のリンカ、特に [Wild](https://github.com/davidlattimore/wild) や [Mold](https://github.com/rui314/mold) を使用すると、クリーンビルドおよびインクリメンタルビルドの時間を短縮できます。

Zed は現在、より成熟しているため CI では Mold を使用しています。ローカル開発用には、通常 Mold より 5〜20% 高速であるため Wild を推奨します。

これらのリンカは `script/install-mold` および `script/install-wild` でインストールできます。

Wild をデフォルトとして使用するには、次の行を `~/.cargo/config.toml` に追加します:

```toml
[target.x86_64-unknown-linux-gnu]
linker = "clang"
rustflags = ["-C", "link-arg=--ld-path=wild"]

[target.aarch64-unknown-linux-gnu]
linker = "clang"
rustflags = ["-C", "link-arg=--ld-path=wild"]
```

Mold をデフォルトとして使用するには次のようにします:

```toml
[target.'cfg(target_os = "linux")']
rustflags = ["-C", "link-arg=-fuse-ld=mold"]
```

## ソースからのビルド

依存関係のインストールが完了したら、[Cargo](https://doc.rust-lang.org/cargo/) を使って Zed をビルドできます。

エディタのデバッグビルドを行うには:

```sh
cargo run
```

テストを実行するには次のようにします:

```sh
cargo test --workspace
```

リリースモードでは、主なユーザーインターフェイスは `cli` クレートです。開発用に実行するには次のようにします:

```sh
cargo run -p cli
```

## 開発ビルドのインストール

ローカルビルドをマシンにインストールするには次のコマンドを実行します:

```sh
./script/install-linux
```

これは `zed` と `cli` をリリースモードでビルドし、バイナリを `~/.local/bin/zed` にインストールし、`.desktop` ファイルを `~/.local/share` にインストールします。

> ***注意***: 次のようなリンカエラーが発生した場合:
>
> ```bash
> error: linking with `cc` failed: exit status: 1 ...
> = note: /usr/bin/ld: /tmp/rustcISMaod/libaws_lc_sys-79f08eb6d32e546e.rlib(f8e4fd781484bd36-bcm.o): in function `aws_lc_0_25_0_handle_cpu_env':
>           /aws-lc/crypto/fipsmodule/cpucap/cpu_intel.c:(.text.aws_lc_0_25_0_handle_cpu_env+0x63): undefined reference to `__isoc23_sscanf'
>           /usr/bin/ld: /tmp/rustcISMaod/libaws_lc_sys-79f08eb6d32e546e.rlib(f8e4fd781484bd36-bcm.o): in function `pkey_rsa_ctrl_str':
>           /aws-lc/crypto/fipsmodule/evp/p_rsa.c:741:(.text.pkey_rsa_ctrl_str+0x20d): undefined reference to `__isoc23_strtol'
>           /usr/bin/ld: /aws-lc/crypto/fipsmodule/evp/p_rsa.c:752:(.text.pkey_rsa_ctrl_str+0x258): undefined reference to `__isoc23_strtol'
>           collect2: error: ld returned 1 exit status
>   = note: some `extern` functions couldn't be found; some native libraries may need to be installed or have their path specified
>   = note: use the `-l` flag to specify native libraries to link
>   = note: use the `cargo:rustc-link-lib` directive to specify the native libraries to link with Cargo (see https://doc.rust-lang.org/cargo/reference/build-scripts.html#rustc-link-lib)
> error: could not compile `remote_server` (bin "remote_server") due to 1 previous error
> ```
>
> **原因**:
> これは aws-lc-rs の既知のバグ (GCC >= 14 非対応) によって発生します: [GCC >= 14 で FIPS のビルドに失敗する](https://github.com/aws/aws-lc-rs/issues/569)
> と [GCC-14 - FIPS モジュールのビルド失敗](https://github.com/aws/aws-lc/issues/2010)
>
> 詳細については、[linux: script/install-linux 使用時の remote_server のリンカエラー](https://github.com/zed-industries/zed/issues/24880) を参照してください。
>
> **回避策**:
> 次のようにリモートサーバーのターゲットを `x86_64-unknown-linux-gnu` に設定します: `export REMOTE_SERVER_TARGET=x86_64-unknown-linux-gnu; script/install-linux`

## Wayland と X11

Zed は X11 と Wayland の両方をサポートしています。デフォルトでは、実行時に利用可能な方を自動的に選択します。Wayland 上で動作している環境で X11 モードで実行したい場合は、環境変数 `WAYLAND_DISPLAY=''` を使用してください。

## Zed をパッケージングする際の注意事項

このセクションは Zed をパッケージングするディストリビューションメンテナ向けです。

### 技術的要件

Zed には 2 つのメインバイナリがあります:

- `crates/cli` をビルドし、そのバイナリを `zed` という名前で `$PATH` から参照できるようにする必要があります。
- `crates/zed` をビルドし、そのバイナリを `$PATH/to/cli/../../libexec/zed-editor` に配置する必要があります。たとえば、cli を `~/.local/bin/zed` に配置する場合は、zed を `~/.local/libexec/zed-editor` に配置してください。一部の Linux ディストリビューション (特に Arch) では `libexec` の使用が推奨されていないため、このバイナリを代わりに `$PATH/to/cli/../../lib/zed/zed-editor` (例: `~/.local/lib/zed/zed-editor`) に配置することもできます。
- `.desktop` ファイルを提供する場合は、`crates/zed/resources/zed.desktop.in` にテンプレートがあり、`envsubst` を使って必要な値を埋め込むことができます。このファイルは、[FreeDesktop の標準に従う](https://github.com/zed-industries/zed/issues/12707#issuecomment-2168742761) よう `$APP_ID.desktop` にリネームする必要があります。また、この desktop ファイルを実行可能 (`chmod 755`) にする必要があります。
- 必要なライブラリがインストールされていることを確認する必要があります。現在の一覧は、システム上で[ビルド済みバイナリを検査](https://github.com/zed-industries/zed/blob/935cf542aebf55122ce6ed1c91d0fe8711970c82/script/bundle-linux#L65-L67) することで取得できます。
- 完全なビルドスクリプトの例については、[script/bundle-linux](https://github.com/zed-industries/zed/blob/935cf542aebf55122ce6ed1c91d0fe8711970c82/script/bundle-linux) を参照してください。
- 環境変数 `ZED_UPDATE_EXPLANATION` を指定して Zed をビルド (または実行) することで、Zed の自動更新を無効にし、手動で Zed を更新しようとするユーザー向けの手順を提供できます。例: `ZED_UPDATE_EXPLANATION="Please use flatpak to update zed."`。
- `crates/zed/RELEASE_CHANNEL` ファイルの内容を、改行なしで 'nightly'、'preview'、または 'stable' のいずれかに更新してください。これにより、Zed は資格情報マネージャーを使用してユーザーのログイン情報を記憶するようになります。

### その他の注意点

Zed の開発サイクルは速く、ディストリビューションメンテナはしばしば異なる制約や優先順位を持っています。以下のポイントは、現在のトレードオフについて説明します。

- Zed は開発の進行が速いプロジェクトです。報告された問題への対応や大きな変更のリリースのために、通常は週に 2〜3 回ビルドを公開しています。
- Linux システム上には、他にもいくつかの `zed` バイナリが存在する場合があります（[1](https://openzfs.github.io/openzfs-docs/man/v2.2/8/zed.8.html)、[2](https://zed.brimdata.io/docs/commands/zed)）。これらとの問題を避けるために本 CLI バイナリの名前を変更したい場合は、`zedit`、`zeditor`、`zed-cli` などを推奨します。
- Zed は、rustup/rbenv/pyenv と同様に、一般的な開発ツールのバージョンを自動的にインストールします。この挙動については[こちら](https://github.com/zed-industries/zed/issues/12589)で議論されています。
- ユーザーはローカルおよび [zed-industries/extensions](https://github.com/zed-industries/extensions) から拡張機能をインストールできます。拡張機能は、言語サーバーなどの追加ツールをインストールする場合があります。予定されている安全性向上策は[こちら](https://github.com/zed-industries/zed/issues/12358)で追跡されています。
- Zed はデフォルトで複数のオンラインサービス（AI、テレメトリ、コラボレーション）に接続します。AI と当社のテレメトリは、ユーザーの zed 設定から、または当社の[既定設定ファイル](https://github.com/zed-industries/zed/blob/main/assets/settings/default.json)を修正することで無効にできます。
- 上記の理由により、現時点では Zed はサンドボックス環境と相性が良くありません。[このディスカッション](https://github.com/zed-industries/zed/pull/12006#issuecomment-2130421220)も参照してください。

## Flatpak

> 現在の Zed の Flatpak 統合は、起動時にサンドボックスから抜けます。Flatpak のサンドボックスに依存するワークフローは、期待どおりに動作しない可能性があります。

Flatpak パッケージをローカルでビルドしてインストールするには、以下の手順に従ってください:

1. お使いのディストリビューション向けに、[こちら](https://flathub.org/setup)の説明に従って Flatpak をインストールします。
2. 必要な依存関係をインストールするために `script/flatpak/deps` スクリプトを実行します。
3. `script/flatpak/bundle-flatpak` を実行します。
4. これでパッケージがインストールされ、`target/release/{app-id}.flatpak` にバンドルが利用可能になっています。

## Memory profiling

[`heaptrack`](https://github.com/KDE/heaptrack) はメモリリークの診断に非常に有用です。インストールするには次のコマンドを実行します:

```sh
sudo apt install heaptrack heaptrack-gui
cargo install cargo-heaptrack
```

次に、プロファイラをアタッチした状態で Zed をビルドして実行するには、次を実行します:

```sh
cargo heaptrack -b zed
```

この zed インスタンスを終了すると、ターミナル出力に `heaptrack_interpret` を実行するためのコマンドが含まれます。これにより `*.raw.zst` プロファイルが `*.zst` ファイルに変換され、そのファイルを `heaptrack_gui` に渡して表示できます。

## perf の記録

稼働中の Zed インスタンスから、シンボル解決済みのフレームグラフを取得する方法です。Zed が大量の CPU を使用している場合に使用してください。ハングしている場合には有用ではありません。

### 事象発生中

- 次のコマンドを使って PID（プロセス ID）を取得します:
  `ps -eo size,pid,comm | grep zed | sort | head -n 1 | cut -d ' ' -f 2`
  また、htop/btop/top などのツールで最も RAM 使用量が多い
  `zed-editor` の PID を特定してもかまいません。

- perf をインストールします:
  Ubuntu（およびその派生ディストリビューション）では `sudo apt install linux-tools` を実行します。

- perf で記録を行います:
  `sudo perf record -p <pid you just found>` を実行し、数秒間データを収集したら Ctrl+C を押します。これで `perf.data` ファイルが生成されているはずです。

- 出力ファイルの所有者を現在のユーザーに変更します:
  `sudo chown $USER:$USER perf.data` を実行します。

- ビルド情報を取得します:
  zed を再度実行し、コマンドパレットで `zed: about` と入力して、正確なコミットを取得します。

`perf.data` ファイルは、その正確なコミット情報と一緒に Zed に送付できます。

### 事後作業

これは Zed スタッフが実施できます。

- シンボル付きで Zed をビルドします:
  先ほど特定したコミットをチェックアウトし、`Cargo.toml` を修正します。
  次の diff を適用し、そのうえでリリースビルドを行います。

```diff
[profile.release]
-debug = "limited"
+debug = "full"
```

- perf のデータベースにシンボルを追加します:
  `perf buildid-cache -v -a <path to release zed binary>`

- データベースからシンボルを解決します:
  `perf inject -i perf.data -o perf_with_symbols.data`

- flamegraph をインストールします:
  `cargo install cargo-flamegraph`

- フレームグラフをレンダリングします:
  `flamegraph --perfdata perf_with_symbols.data`

## トラブルシューティング

### 依存関係が unstable な機能を使用しているとする Cargo エラー

`cargo clean` と `cargo build` を実行してみてください。
