# FreeBSD 向けの Zed のビルド

FreeBSD は現在サポート対象のプラットフォームではないため、このガイドは作業中です。

## リポジトリ

[Zed リポジトリ](https://github.com/zed-industries/zed)をクローンしてください。

## 依存関係

- 必要なシステムパッケージと rustup をインストールします:

  ```sh
  script/freebsd
  ```

  必要であれば、[`script/freebsd`](https://github.com/zed-industries/zed/blob/main/script/freebsd) を参照して手順を手動で実行することもできます。

## ソースからのビルド

依存関係のインストールが完了したら、[Cargo](https://doc.rust-lang.org/cargo/) を使って Zed をビルドできます。

エディタのデバッグビルドを行うには:

```sh
cargo run
```

テストを実行するには:

```sh
cargo test --workspace
```

リリースモードでは、主なユーザーインターフェイスは `cli` クレートです。開発用に実行するには次のコマンドを使用します:

```sh
cargo run -p cli
```

### WebRTC に関する注意

FreeBSD 上での `webrtc-sys` のビルドは、上流でのサポートがなく、事前ビルド済みバイナリも利用できないため、現在は失敗します。この結果、WebRTC に依存するコラボレーション機能（音声通話や画面共有）は一時的に無効化されています。

詳しくは [Issue #15309: FreeBSD Support] および [Discussion #29550: Unofficial FreeBSD port for Zed] を参照してください。

## トラブルシューティング

### 依存クレートが unstable な機能を使用しているとする Cargo のエラー

`cargo clean` と `cargo build` を試してください。
