# Zed のインストール

## Zed のダウンロード

### macOS

最新の安定版ビルドは [ダウンロードページ](https://zed.dev/download)から入手できます。プレビュー版ビルドをダウンロードしたい場合は、対応する[リリースページ](https://zed.dev/releases/preview)にあります。最初に手動でインストールした後は、Zed が定期的にアップデートを確認します。

また、Homebrew を使って Zed の安定版をインストールすることもできます:

```sh
brew install --cask zed
```

Zed のプレビュー版も同様にインストールできます:

```sh
brew install --cask zed@preview
```

### Windows

最新の安定版ビルドは [ダウンロードページ](https://zed.dev/download)から入手できます。プレビュー版ビルドをダウンロードしたい場合は、対応する[リリースページ](https://zed.dev/releases/preview)にあります。最初に手動でインストールした後は、Zed が定期的にアップデートを確認します。

また、winget を使って Zed をインストールすることもできます:

```sh
winget install -e --id ZedIndustries.Zed
```

### Linux

ほとんどの Linux ユーザーにとって、Zed をインストールする最も簡単な方法は、提供しているインストールスクリプトを使用することです:

```sh
curl -f https://zed.dev/install.sh | sh
```

環境変数 `ZED_VERSION` を使って、インストールする Zed の **バージョン** を任意に指定できるようになりました:

```sh
# 最新の安定版をインストール (デフォルト)
curl -f https://zed.dev/install.sh | sh

# 特定のバージョンをインストール
curl -f https://zed.dev/install.sh | ZED_VERSION=0.216.0 sh
```

安定版より約 1 週間早くアップデートを受け取るプレビュー版ビルドをインストールするには、次のようにします:

```sh
curl -f https://zed.dev/install.sh | ZED_CHANNEL=preview sh
```

このスクリプトは `x86_64` と `AArch64` に対応しており、Ubuntu、Arch、Debian、RedHat、CentOS、Fedora などの一般的な Linux ディストリビューションで動作します。

このインストールスクリプトで Zed をインストールした場合、シェルコマンド `zed --uninstall` を実行することで、いつでもアンインストールできます。その後、シェルから設定を保持するか削除するか確認されます。選択すると、Zed が正常にアンインストールされたことを示すメッセージが表示されます。

このスクリプトでは要件を満たせない場合や、Zed の実行時に問題が発生した場合、Zed のアンインストールでエラーが発生した場合は、[Linux 向けドキュメント](./linux.md)を参照してください。

## システム要件

### macOS

Zed は次の macOS リリースをサポートしています:

| Version       | Codename | Apple Status   | Zed Status          |
| ------------- | -------- | -------------- | ------------------- |
| macOS 26.x    | Tahoe    | Supported      | Supported           |
| macOS 15.x    | Sequoia  | Supported      | Supported           |
| macOS 14.x    | Sonoma   | Supported      | Supported           |
| macOS 13.x    | Ventura  | Supported      | Supported           |
| macOS 12.x    | Monterey | EOL 2024-09-16 | Supported           |
| macOS 11.x    | Big Sur  | EOL 2023-09-26 | Partially Supported |
| macOS 10.15.x | Catalina | EOL 2022-09-12 | Partially Supported |

「Partially Supported」とラベル付けされた macOS リリース (Big Sur と Catalina) は、Zed Collaboration を通じた画面共有をサポートしていません。これらの機能は [LiveKit SDK](https://livekit.io) を使用しており、この SDK は [ScreenCaptureKit.framework](https://developer.apple.com/documentation/screencapturekit/) に依存していますが、これは macOS 12 (Monterey) 以降でのみ利用可能です。

#### Mac ハードウェア

Zed は、上記の macOS 要件を満たす Intel (x86_64) または Apple (aarch64) プロセッサを搭載したマシンをサポートしています:

- MacBook Pro (Early 2015 以降)
- MacBook Air (Early 2015 以降)
- MacBook (Early 2016 以降)
- Mac Mini (Late 2014 以降)
- Mac Pro (Late 2013 以降)
- iMac (Late 2015 以降)
- iMac Pro (すべてのモデル)
- Mac Studio (すべてのモデル)

### Linux

Zed は 64 ビット Intel/AMD (x86_64) および 64 ビット Arm (aarch64) プロセッサをサポートしています。

Zed を動作させるには、Vulkan 1.3 ドライバーと、次のデスクトップポータルが必要です:

- `org.freedesktop.portal.FileChooser`
- `org.freedesktop.portal.OpenURI`
- `org.freedesktop.portal.Secret` または `org.freedesktop.Secrets`

### Windows

Zed は次の Windows リリースをサポートしています:

| Version | Zed Status |
| ------------------------- | ------------------- |
| Windows 11, version 22H2 and later | Supported |
| Windows 10, version 1903 and later | Supported |

Zed を実行するには 64 ビットのオペレーティングシステムが必要です。

#### Windows ハードウェア

Zed は、以下の要件を満たす x64 (Intel, AMD) または Arm64 (Qualcomm) プロセッサを搭載したマシンをサポートしています:

- グラフィックス: DirectX 11 をサポートする GPU (2012 年以降のほとんどの PC)。
- ドライバー: 最新の NVIDIA/AMD/Intel/Qualcomm ドライバー (Microsoft Basic Display Adapter ではないもの)。

### FreeBSD

まだ公式なダウンロードは提供されていません。[ソースから](./development/freebsd.md)ビルドできます。

### Web

現在はサポートされていません。[Platform Support の issue](https://github.com/zed-industries/zed/issues/5391)を参照してください。
