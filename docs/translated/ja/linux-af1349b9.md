# Linux 上の Zed

## 標準インストール

Zed をインストールする最も手早い方法は、[download](https://zed.dev/download) ページにあるインストールスクリプトを使用することです:

```sh
curl -f https://zed.dev/install.sh | sh
```

また、安定版より約 1 週間早く更新を受け取る Zed のプレビュービルドも提供しています。次のコマンドでインストールできます:

```sh
curl -f https://zed.dev/install.sh | ZED_CHANNEL=preview sh
```

スクリプトでインストールされる Zed は、次の条件を満たすシステムで最も良く動作します:

- Vulkan 対応 GPU が利用可能であること（例: M シリーズ MacBook 上の Linux）
- システム全体で利用可能な glibc を持っていること（NixOS と Alpine はデフォルトでは持ちません）
  - x86_64（Intel/AMD）: glibc バージョン >= 2.31（Ubuntu 20 以降）
  - aarch64（ARM）: glibc バージョン >= 2.35（Ubuntu 22 以降）

Nix と Alpine の両方にはサードパーティ製の Zed パッケージがあります（ただし現在は数週間ほど古いバージョンです）。弊社が提供するビルドを使いたい場合は、glibc 互換レイヤーをインストールすれば動作します。NixOS では [nix-ld](https://github.com/Mic92/nix-ld) を、Alpine では [gcompat](https://wiki.alpinelinux.org/wiki/Running_glibc_programs) を試すことができます。

次の場合はソースからビルドする必要があります:

- 64 ビット Intel または 64 ビット ARM 以外のアーキテクチャ（例: 32 ビットマシンや RISC-V マシン）
- すべてのアーキテクチャにおける Redhat Enterprise Linux 8.x、Rocky Linux 8、AlmaLinux 8、Amazon Linux 2
- aarch64 上の Redhat Enterprise Linux 9.x、Rocky Linux 9.3、AlmaLinux 8、Amazon Linux 2023（x86_x64 は OK）

## Linux に Zed をインストールするその他の方法

Zed はオープンソースであり、[ソースからインストールすることもできます](./development/linux.md)。

### パッケージマネージャー経由でのインストール

さまざまな Linux ディストリビューションとパッケージマネージャー向けに、いくつかのサードパーティ製 Zed パッケージが用意されています。パッケージ名が `zed-editor` となっている場合もあります。これらのパッケージを使って Zed をインストールできる場合があります:

- Flathub: [`dev.zed.Zed`](https://flathub.org/apps/dev.zed.Zed)
- Arch: [`zed`](https://archlinux.org/packages/extra/x86_64/zed/)
- Arch (AUR): [`zed-git`](https://aur.archlinux.org/packages/zed-git), [`zed-preview`](https://aur.archlinux.org/packages/zed-preview), [`zed-preview-bin`](https://aur.archlinux.org/packages/zed-preview-bin)
- Alpine: `zed` ([aarch64](https://pkgs.alpinelinux.org/package/edge/testing/aarch64/zed)) ([x86_64](https://pkgs.alpinelinux.org/package/edge/testing/x86_64/zed))
- Conda: [`zed`](https://anaconda.org/conda-forge/zed)
- Nix: `zed-editor` ([unstable](https://search.nixos.org/packages?channel=unstable&show=zed-editor))
- Fedora/Ultramarine (Terra): [`zed`](https://github.com/terrapkg/packages/tree/frawhide/anda/devs/zed/stable), [`zed-preview`](https://github.com/terrapkg/packages/tree/frawhide/anda/devs/zed/preview), [`zed-nightly`](https://github.com/terrapkg/packages/tree/frawhide/anda/devs/zed/nightly)
- Solus: [`zed`](https://github.com/getsolus/packages/tree/main/packages/z/zed)
- Parabola: [`zed`](https://www.parabola.nu/packages/extra/x86_64/zed/)
- Manjaro: [`zed`](https://packages.manjaro.org/?query=zed)
- ALT Linux (Sisyphus): [`zed`](https://packages.altlinux.org/en/sisyphus/srpms/zed/)
- AOSC OS: [`zed`](https://packages.aosc.io/packages/zed)

さまざまなリポジトリにある Zed パッケージの一覧については [Repology](https://repology.org/project/zed-editor/versions) を参照してください。

### コミュニティ

サードパーティ製パッケージをインストールする際は、必ずしも最新ではなく、弊社が配布している Zed とは多少異なる場合がある点に注意してください（よくある変更として、他のパッケージとの衝突を避けるためにバイナリ名を `zedit` や `zeditor` に変更することがあります）。

Zed をあらゆる人に使ってもらえるようにするため、ぜひあなたの協力をお願いしたいと思っています。もしお使いのパッケージマネージャーでまだ Zed が利用できず、それを改善したい場合は、[その方法](./development/linux.md#notes-for-packaging-zed) に関するノートを用意しています。

このセクションのパッケージは Zed のバイナリインストールを提供しますが、対応するディストリビューションの公式パッケージではありません。これらのパッケージはコミュニティメンバーによってメンテナンスされているため、インストールする際にはより高い注意を払ってください。

#### Debian と Ubuntu

Zed は [コミュニティがメンテナンスしているこのリポジトリ](https://debian.griffo.io/) から入手できます。

各バージョン向けの手順は、パッケージがビルドされるリポジトリの README に記載されています。
各バージョンのビルド方法、パッケージング、および手順は、[リポジトリ](https://github.com/dariogriffo/zed-debian) の README に記載されています。

### 手動でのダウンロード

必要であれば、あらかじめビルド済みの .tar.gz をダウンロードして Zed をインストールすることもできます。これはインストールスクリプトが使用する成果物と同じものですが、以下の手順を調整することで、インストール先の場所をカスタマイズできます。

`.tar.gz` ファイルをダウンロードします:

- [zed-linux-x86_64.tar.gz](https://cloud.zed.dev/releases/stable/latest/download?asset=zed&arch=x86_64&os=linux&source=docs)
  （[プレビュー](https://cloud.zed.dev/releases/preview/latest/download?asset=zed&arch=x86_64&os=linux&source=docs))
- [zed-linux-aarch64.tar.gz](https://cloud.zed.dev/releases/stable/latest/download?asset=zed&arch=aarch64&os=linux&source=docs)
  （[プレビュー](https://cloud.zed.dev/releases/preview/latest/download?asset=zed&arch=aarch64&os=linux&source=docs))

次に、tarball 内の `zed` バイナリが PATH 上にあることを確認します。最も簡単な方法は、tarball を展開してシンボリックリンクを作成することです:

```sh
mkdir -p ~/.local
# zed を ~/.local/zed.app/ に展開する
tar -xvf <path/to/download>.tar.gz -C ~/.local
# zed バイナリを ~/.local/bin（または $PATH に含まれる別のディレクトリ）にリンクする
ln -sf ~/.local/zed.app/bin/zed ~/.local/bin/zed
```

XDG 互換のデスクトップ環境と統合したい場合は、`.desktop` ファイルもインストールする必要があります:

```sh
install -D ~/.local/zed.app/share/applications/dev.zed.Zed.desktop -t ~/.local/share/applications
sed -i "s|Icon=zed|Icon=$HOME/.local/zed.app/share/icons/hicolor/512x512/apps/zed.png|g" ~/.local/share/applications/dev.zed.Zed.desktop
sed -i "s|Exec=zed|Exec=$HOME/.local/zed.app/bin/zed|g" ~/.local/share/applications/dev.zed.Zed.desktop
```

## Zed のアンインストール

### 標準的なアンインストール

Zed をデフォルトのインストールスクリプトでインストールした場合は、`zed` シェルコマンドに `--uninstall` フラグを指定することでアンインストールできます。

```sh
zed --uninstall
```

エラーがなければ、シェルから設定を保持するか削除するかを尋ねるプロンプトが表示されます。どちらかを選択すると、Zed が正常にアンインストールされたことを示すメッセージが表示されます。

PATH 上で `zed` シェルコマンドが見つからない場合は、次のいずれかのコマンドを試すことができます

```sh
$HOME/.local/bin/zed --uninstall
```

または

```sh
$HOME/.local/zed.app/bin.zed --uninstall
```

最初のケースは、`$HOME/.local/bin/zed` と `$HOME/.local/zed.app/bin.zed` の間でシンボリックリンクが正しく設定されていない場合は失敗する可能性があります。しかし、Zed がデフォルトの場所にインストールされている限り、2 つ目のケースは動作するはずです。

Zed が別の場所にインストールされている場合は、そのインストールディレクトリにある `zed` バイナリを実行し、前述のコマンドと同じ形式で `--uninstall` フラグを渡す必要があります。

### パッケージマネージャー

Zed をパッケージマネージャーでインストールした場合は、そのパッケージマネージャーのドキュメントを参照し、パッケージのアンインストール方法を確認してください。

## トラブルシューティング

```
Linux は、多くの異なる方法で構成された非常に幅広い種類のシステム上で動作します。Zed は主に、ユーザーが最もよく利用しているディストリビューションである素の Ubuntu セットアップ上でテストしていますが、さまざまなマシンで動作することを想定しています。

### Zed が起動しない

"/lib64/libc.so.6: version 'GLIBC_2.29' not found" のようなエラーが表示される場合、使用しているディストリビューションの glibc のバージョンが古すぎることを意味します。システムをアップグレードするか、[ソースから Zed をインストール](./development/linux.md)してください。

### グラフィックスの問題

#### Zed がウィンドウを開けない

Zed を効率的に動作させるには GPU が必要です。内部的には、GPU と通信するために [Vulkan](https://www.vulkan.org/) を使用しています。パフォーマンスに問題がある場合や、Zed の読み込みに失敗する場合、原因が Vulkan にある可能性があります。

`Zed failed to open a window: NoSupportedDeviceFound` という通知が表示される場合、Vulkan が互換性のある GPU を見つけられていないことを意味します。問題がどこから来ているかを切り分けるために、[vkcube](https://github.com/krh/vkcube)（多くのディストリビューションでは、`vulkaninfo` または `vulkan-tools` パッケージの一部として利用可能）を次のように実行してみてください。

```

vkcube

```

> **_注意_**: `vkcube -m [x11|wayland]` を実行して、X11 と wayland の両方のモードで試してみてください。一部のバージョンの `vkcube` では、X11 では `vkcube` を、wayland では `vkcube-wayland` を使用して実行します。

これにより、現在のグラフィックス構成を説明する行が出力され、回転する立方体が表示されるはずです。これが動作しない場合、Vulkan 互換の GPU ドライバーをインストールすることで修正できるはずですが、環境によっては Vulkan がまだサポートされていない場合もあります。

Zed がどのグラフィックスカードを使用しているかは、Zed のログ（`~/.local/share/zed/logs/Zed.log`）内の `Using GPU: ...` を確認することで把握できます。

`ERROR_INITIALIZATION_FAILED` や `GPU Crashed`、`ERROR_SURFACE_LOST_KHR` のようなエラーが表示される場合は、GPU 用に別のドライバーをインストールしたり、使用する GPU を変更したりすることで回避できる可能性があります（[#14225](https://github.com/zed-industries/zed/issues/14225) を参照）。

一部のシステムでは、[PRIME](https://wiki.archlinux.org/title/PRIME) を使用して離散 GPU の使用を強制するために、`/etc/prime-discrete` ファイルを使用できます。セットアップの詳細に応じて、このファイルの内容を "on"（離散グラフィックスを強制）または "off"（統合グラフィックスを強制）に変更する必要があるかもしれません。

その他のシステムでは、Zed を実行するときに環境変数 `DRI_PRIME=1` を使用して、離散 GPU の使用を強制できる場合があります。

AMD GPU を使用している場合、「Broken Pipe」エラーが発生することがあります。RADV または Mesa ドライバーの使用を試してください（[#13880](https://github.com/zed-industries/zed/issues/13880) を参照）。

オープンソースの AMD デフォルトグラフィックスドライバーである `amdvlk` を使用している場合、Zed が一貫して起動に失敗することがあります。これは、Omarchy 上など一部のユーザーにとって既知の問題です（[#28851](https://github.com/zed-industries/zed/issues/28851) を参照）。これを修正するには、別のドライバーを使用する必要があります。`amdvlk` と `lib32-amdvlk` パッケージを削除し、代わりに `vulkan-radeon` をインストールすることを推奨します（[#14141](https://github.com/zed-industries/zed/issues/14141) を参照）。

詳細については、[Arch guide to Vulkan](https://wiki.archlinux.org/title/Vulkan) に、多くのディストリビューションにもそのまま当てはまる有用な手順が記載されています。

#### 特定の GPU を Zed に使用させる

特定の GPU を Zed に使用させる方法はいくつかあります。

##### オプション A

`ZED_DEVICE_ID={device_id}` 環境変数を使用して、Zed に使用させたい GPU のデバイス ID を指定できます。

`lspci -nn | grep VGA` を実行すると、各 GPU が 1 行ずつ次のように出力され、GPU のデバイス ID を取得できます。

```

08:00.0 VGA compatible controller [0300]: NVIDIA Corporation GA104 [GeForce RTX 3070] [10de:2484] (rev a1)

```

ここでのデバイス ID は `2484` です。この値は 16 進数なので、この特定の GPU を Zed に使用させるには、次のように環境変数を設定します。

```

ZED_DEVICE_ID=0x2484 zed

```

`.bashrc` などでグローバルに定義する場合は、この変数を `export` することを忘れないでください。

##### オプション B

Mesa を使用している場合、`MESA_VK_DEVICE_SELECT=list zed --foreground` を実行して利用可能な GPU の一覧を取得し、その後 `MESA_VK_DEVICE_SELECT=xxxx:yyyy` を `export` して特定のデバイスを選択できます。さらに、`WAYLAND_DISPLAY=""` を追加で `export` することで xwayland にフォールバックできます。

##### オプション C

[vkdevicechooser](https://github.com/jiriks74/vkdevicechooser) を使用します。

#### グラフィックス関連の問題の報告

Vulkan が正しく設定されているにもかかわらず Zed が動作しない場合は、可能な限り多くの情報を添えて [Issue を作成](https://github.com/zed-industries/zed) してください。

Zed がグラフィックス初期化エラーによって起動に失敗する問題を GitHub で報告する際、Issue テンプレートで案内している `zed: copy system specs into clipboard` コマンドを実行できない場合があります。この状況向けに、システム情報を収集する代替手段を用意しています。

Zed に `--system-specs` フラグを次のように渡すと

```sh
zed --system-specs
```

システム情報が次のようにターミナルに出力されます。読みやすさを確保するために Markdown フォーマットを使用しているため、この出力を GitHub の Issue にそのまま貼り付けることを強く推奨します。

加えて、この種の問題を報告する際には、Zed のログの内容を提供していただくと非常に有用です。ログは通常 `~/.local/share/zed/logs/Zed.log` にあります。有用なログファイルを生成するための推奨手順は次のとおりです。

```sh
truncate -s 0 ~/.local/share/zed/logs/Zed.log # ログファイルをクリアする
ZED_LOG=wgpu=info zed .
cat ~/.local/share/zed/logs/Zed.log
# 出力をコピーする
```

また、Zed の cli を設定済みであれば、次のように実行できます。

```sh
ZED_LOG=wgpu=info /path/to/zed/cli --foreground .
# 出力をコピーする
```

ログを GitHub の Issue に貼り付ける際には、次のテンプレートを使用することも強く推奨します。

> ***注意***: このテンプレートでは空白が重要で、保持しないと書式が崩れます。

````
<details><summary>Zed Log</summary>

```
{zed log contents}
```

</details>
````

これにより、ログがデフォルトで折りたたまれて表示され、Issue が読みやすくなります。

### ファイルをまったく開けない

### リンクをクリックしても動作しない

これらの機能は XDG デスクトップポータルによって提供されており、具体的には次のインターフェイスです。

- `org.freedesktop.portal.FileChooser`
- `org.freedesktop.portal.OpenURI`

`Hyprland` のような一部のウィンドウマネージャは、デフォルトではファイルピッカーを提供していません。代替手段を探す際には、[このリスト](https://wiki.archlinux.org/title/XDG_Desktop_Portal#List_of_backends_and_interfaces) を出発点として参照してください。

### Zed が API キーを記憶してくれない

### Zed がログイン情報を記憶してくれない

これらの機能も XDG デスクトップポータルを必要とし、具体的には次のいずれかです。

- `org.freedesktop.portal.Secret` または
- `org.freedesktop.Secrets`

Zed は、Zed のログイン Cookie や OpenAI API キーなどのシークレットを安全に保存する場所を必要とするため、そのためにシステム提供のキーチェーンを使用します。これを提供するパッケージの代表的な例としては、`gnome-keyring`、`KWallet`、`keepassxc` などがあります。

### inotify を開始できない

Zed は inotify に依存してファイルシステムの変更を監視します。inotify を利用できない場合、Zed は信頼性をもって動作しません。

"too many open files" と表示される場合は、まず `sysctl fs.inotify` を試してください。

- `max_user_instances` が 128 以上になっていることを確認してください（制限は `sudo sysctl fs.inotify.max_user_instances=1024` で変更できます）。Zed が必要とする inotify インスタンスは 1 つだけです。
- `max_user_watches` が 8000 以上になっていることを確認してください（制限は `sudo sysctl fs.inotify.max_user_watches=64000` で変更できます）。Zed が必要とするのは、開いているすべてのプロジェクト内の各ディレクトリごとに 1 つ + 各 git リポジトリごとに 1 つ + 設定、テーマ、キーマップ、拡張機能用にさらにいくつかです。

ファイルディスクリプタが不足している可能性もあります。`ulimit` で制限値を確認し、`/etc/security/limits.conf` を編集して更新できます。

### 音が出ない、または出力デバイスが間違っている

Zed で音が出ない、または音声が誤ったデバイスにルーティングされている場合、オーディオシステム間の不整合が原因の可能性があります。Zed は ALSA に依存していますが、システム側は PipeWire や PulseAudio を使用している場合があります。これを解決するには、ALSA が PipeWire/PulseAudio 経由で音声をルーティングするように設定する必要があります。

システムが PipeWire を使用している場合:

1. **PipeWire ALSA プラグインをインストールする**

   Debian 系システムでは、次を実行します:

   ```bash
   sudo apt install pipewire-alsa
   ```

2. **ALSA が PipeWire を使用するよう設定する**

   次の設定を ALSA の設定ファイルに追加します。`~/.asoundrc`（ユーザーレベル）または `/etc/asound.conf`（システム全体）のいずれかを使用できます。

   ```bash
   pcm.!default {
       type pipewire
   }

   ctl.!default {
       type pipewire
   }
   ```

3. **システムを再起動する**

### X11 のスケール係数を強制する

X11 システムでは、Zed は高 DPI ディスプレイ用に適切なスケール係数を自動検出します。スケール係数は次の優先順位で決定されます。

1. `GPUI_X11_SCALE_FACTOR` 環境変数（設定されている場合）
2. X リソースデータベース（xrdb）の `Xft.dpi`
3. モニターの解像度と物理サイズに基づく RandR による自動検出

Zed の自動検出結果とは異なるスケール係数を設定したい場合は、いくつかの方法があります。

#### 現在のスケール係数を確認する

`Xft.dpi` が設定されているか確認できます。

```sh
xrdb -query | grep Xft.dpi
```

このコマンドが何も出力しない場合、Zed はモニターが報告する解像度と物理サイズに基づいて RandR（X11 のモニター管理拡張）を使用してスケール係数を自動計算しています。

#### オプション 1: Xft.dpi を設定する（X リソースデータベース）

`Xft.dpi` は、多くのアプリケーションがフォントおよび UI スケーリングを一貫させるために使用する標準的な X11 設定です。これを設定すると、Zed はこの設定を尊重する他の X11 アプリケーションと同じようにスケーリングされます。

`~/.Xresources` ファイルを編集または作成します。

```sh
vim ~/.Xresources
```

希望する DPI を指定して次の行を追加します。

```sh
Xft.dpi: 96
```

一般的な DPI 値:

- `96`: 標準の 1 倍スケーリング
- `144`: 1.5 倍スケーリング
- `192`: 2 倍スケーリング
- `288`: 3 倍スケーリング

設定を読み込みます。

```sh
xrdb -merge ~/.Xresources
```

変更を反映させるには Zed を再起動してください。

#### オプション 2: GPUI_X11_SCALE_FACTOR 環境変数を使用する

この Zed 固有の環境変数は、すべての自動検出をバイパスしてスケール係数を直接設定します。

```sh
GPUI_X11_SCALE_FACTOR=1.5 zed
```

`1.25`、`1.5`、`2.0` のような小数値を使用することもできますし、`GPUI_X11_SCALE_FACTOR=randr` を設定して `Xft.dpi` が設定されている場合でも RandR ベースの検出を強制することもできます。

これを恒久的な設定にするには、シェルのプロファイルまたはデスクトップエントリに追加してください。

#### オプション 3: システム全体の RandR DPI を調整する

これは X11 セッション全体の報告 DPI を変更し、RandR を使用するすべてのアプリケーションに対してスケーリング計算に影響します。

`.xprofile` または `.xinitrc` に次を追加します。

```sh
xrandr --dpi 192
```

`192` を希望する DPI 値に置き換えてください。これはシステム全体に影響し、`Xft.dpi` が設定されていない場合、Zed の自動 RandR 検出によって使用されます。

### フォントレンダリングのパラメータ

Linux では、Zed はフォントレンダリングに使用する値として `ZED_FONTS_GAMMA` および `ZED_FONTS_GRAYSCALE_ENHANCED_CONTRAST` 環境変数を参照します。

`ZED_FONTS_GAMMA` は [getgamma](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/nf-dwrite-idwriterenderingparams-getgamma) の値に対応します。
許可される範囲は [1.0, 2.2] で、それ以外の値はクリップされます。
デフォルト: 1.8

`ZED_FONTS_GRAYSCALE_ENHANCED_CONTRAST` は [getgrayscaleenhancedcontrast](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/nf-dwrite_1-idwriterenderingparams1-getgrayscaleenhancedcontrast) の値に対応します。
許可される範囲: [0.0, ..) で、それ以外の値はクリップされます。
デフォルト: 1.0
