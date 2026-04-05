# デバッガーの使用

> このページは [Zed のデバッガーを設定する](../debugger.md) ことについてのものではありません。
> ここでは、Zed 自体の開発中にデバッガーをどう使うかを説明します。

## Zed の組み込みデバッガーを使う

Zed プロジェクトを開いている状態で、`New Process Modal` を開き、`Debug` タブを選択できます。そこには Zed をデバッグするための 2 つのデバッグ設定があり、1 つは GDB 用、もう 1 つは LLDB 用です。使用したい設定を選択すると、Zed がバイナリをビルドして起動します。

GDB は Apple Silicon 搭載の Mac ではサポートされていません。

## リリースビルドプロファイルに関する注意点

デフォルトでは、リリースプロファイル (nightly、preview、stable で使用されるプロファイル) を使ったビルドには、制限されたデバッグ情報のみが含まれます。

これは、ルートの `Cargo.toml` の `profile.(release).debug` フィールドを `"limited"` に設定することで行われます。

`debug` フィールドの公式ドキュメントは[こちら](https://doc.rust-lang.org/cargo/reference/profiles.html#debug)にあります。
要するに、`"limited"` は型レベルおよび変数レベルのデバッグ情報を取り除きます。

リリースビルドでは、これによりバイナリサイズが小さくなります。実用的なスタックトレースには、型レベルおよび変数レベルのデバッグ情報は必須ではありません。

しかし、実際にデバッグしているときには、この情報が重要になります。これがないと、デバッガーはローカル変数を解決したり、値を検査したり、プリティプリンタで出力を整形したりできません。

リリースビルドでデバッガーの機能をフルに利用するには、完全なデバッグ情報付きで Zed バイナリをコンパイルしてください。

最も簡単な方法は、`cargo run` または `cargo build` を実行するときに `--config` を使って、ルートの `Cargo.toml` 内の `debug` フィールドを上書きすることです:

```sh
cargo run --config 'profile.release.debug="full"'
cargo build --config 'profile.release.debug="full"'
```

> 毎回の `cargo` コマンドで `--config` を渡したくない場合は、[ルートの `Cargo.toml`](https://github.com/zed-industries/zed/blob/main/Cargo.toml) 内のセクションを変更することもできます
>
> 次の設定から
>
> ```toml
> [profile.release]
> debug = "limited"
> ```
>
> 次の設定へ変更します
>
> ```toml
> [profile.release]
> debug = "full"
> ```
>
> これにより、`cargo run --release` や `cargo build --release` のすべての呼び出しが、完全なデバッグ情報付きでコンパイルされるようになります。
>
> **Warning:** これらの変更をコミットしないでください。

## シェルデバッガー GDB/LLDB を使って Zed を実行する

### 背景

rustup を通して Rust をインストールすると (Zed 開発に推奨されるセットアップです。プラットフォームごとのガイドは[こちら](../development.md)を参照してください)、rustup は Rust バイナリをデバッグするためのヘルパースクリプトもインストールします。

これらのスクリプトが `rust-gdb` と `rust-lldb` です。

これらのスクリプトの詳細については[こちら](https://michaelwoerister.github.io/2015/03/27/rust-xxdb.html)を参照してください。

これらは `gdb` や `lldb` のラッパースクリプトであり、プリティプリンタや型情報など、Rust 固有の機能のためのコマンドやフラグを注入します。

`rust-gdb` または `rust-lldb` を使用するには、システムに `gdb` または `lldb` をインストールしてください。

[リンク先の記事](https://michaelwoerister.github.io/2015/03/27/rust-xxdb.html)では、サポートされる最小バージョンは GDB 7.7 と LLDB 310 であると述べられています。実際には、より新しいバージョンを使用する方が一般的に望ましいです。

> **注意**: Windows では `gdb` のサポートが不安定なため、`rust-gdb` はデフォルトではインストールされません。代わりに `rust-lldb` を使用してください。

これらのツールに慣れていない場合は、`gdb` のドキュメントは[こちら](https://www.gnu.org/software/gdb/)、`lldb` のドキュメントは[こちら](https://lldb.llvm.org/)を参照してください。

### Zed での使用方法

完全なデバッグ情報を有効にして `cargo build` でビルドしたら、コンパイル済みの Zed バイナリに対して `rust-gdb` または `rust-lldb` を実行します:

```
rust-gdb target/debug/zed
rust-lldb target/debug/zed
```

`cargo run` で起動したものなど、実行中の Zed プロセスにアタッチすることもできます:

```
rust-gdb -p <pid>
rust-lldb -p <pid>
```

`<pid>` は、アタッチしたい Zed インスタンスのプロセス ID です。

PID を取得するには、Windows なら Task Manager、macOS なら Activity Monitor など、システムのプロセスツールを使用してください。

また、macOS や Linux では `ps aux | grep zed` を、Windows の PowerShell では `Get-Process | Select-Object Id, ProcessName` を実行することもできます。

#### パニックとクラッシュのデバッグ

デバッガーは、Zed を含むパニックやクラッシュの原因を突き止めるのに有用です。

デフォルトでは、`gdb` や `lldb` にアタッチされたプロセスがパニックなどの例外に到達すると、デバッガーはその時点で停止し、プログラム状態を検査できるようにします。

最初に停止する場所は、多くの場合 Rust 標準ライブラリのパニックや例外処理コード内なので、通常はスタックをさかのぼって原因を特定する必要があります。

`lldb` では、`frame select` と併せて `backtrace` を使用します。`gdb` にも同等のコマンドがあります。

プログラムが例外で停止した後は、通常どおりの実行を続行することはできません。それでもスタックフレーム間を移動したり、変数や式を検査したりすることはでき、多くの場合それでクラッシュの原因を特定するには十分です。

Zed のクラッシュのデバッグに関する追加情報は[こちら](./debugging-crashes.md)で確認できます。
