# Remote Development

Remote Development を使うと、Zed をローカルで実行しながら、リモートサーバー上のコードを編集できます。UI はあなたのマシン上で動作するため常に応答性が高く、言語サーバー、タスク、ターミナルはサーバー側で実行されます。

日常的なワークフローでは、リモート開発を [Tasks](./tasks.md)、[Terminal](./terminal.md)、[Debugger](./debugger.md) と組み合わせて使ってください。

## Overview

リモート開発には 2 台のコンピューターが必要です。Zed の UI を実行するローカルマシンと、Zed のヘッドレスサーバーを実行するリモートサーバーです。両者は SSH 経由で通信するため、この機能を使うにはローカルマシンからリモートサーバーに SSH 接続できる必要があります。

![Architectural overview of Zed Remote Development](https://zed.dev/img/remote-development/diagram.png)

ローカルマシン上では、Zed が UI を実行し、言語モデルと通信し、Tree-sitter を使ってコードを構文解析およびシンタックスハイライトし、未保存の変更や最近のプロジェクトを保持します。ソースコード、言語サーバー、タスク、ターミナルはすべてリモートサーバー上で実行されます。[AI features](./ai/overview.md) は Agent Panel や Inline Assistant を含め、リモートセッションでも動作します。

> **Note:** Remote Development の最初のバージョンでは、トラフィックは Zed のサーバー経由で送信されていました。Zed v0.157 以降、このモードは使用できなくなりました。

## Setup

1. 最新の [Zed](https://zed.dev/releases) をダウンロードしてインストールします。少なくとも Zed v0.159 が必要です。
1. {#kb projects::OpenRemote} を使用して "Remote Projects" ダイアログを開きます。
1. "Connect New Server" をクリックし、サーバーに SSH 接続するために使用しているコマンドを入力します。指定できるオプションについては [Supported SSH options](#supported-ssh-options) を参照してください。
1. ローカルマシンは、パス上にある `ssh` バイナリを使ってリモートサーバーへの接続を試みます。接続が成功すると、Zed はリモートホストにサーバーをダウンロードして起動します。
1. Zed サーバーが起動すると、リモートサーバー上で開くパスを選択するように促されます。
   > **Note:** Zed は現在、非常に大きなディレクトリ（たとえば、>100,000 ファイルを含む可能性のある `/` や `~`）を開く処理をあまりうまく扱えません。この点は改善に取り組んでいますが、それまでは特定のプロジェクトや、大規模なモノレポのサブフォルダのみを開くことを推奨します。

SSH 引数が不要なシンプルなケースでは、`zed ssh://[<user>@]<host>[:<port>]/<path>` を実行して、リモートのフォルダ/ファイルを直接開くことができます。SSH プロジェクトへのホットリンクを作成したい場合は、`zed://ssh/[<user>@]<host>[:<port>]/<path>` 形式のリンクを使用してください。

## Supported platforms

リモートマシンは Zed のサーバーを実行できる必要があります。以下のプラットフォームで動作するはずですが、すべての Linux ディストリビューションを網羅的にテストしているわけではない点に注意してください。

- macOS Catalina 以降（Intel または Apple Silicon）
- Linux（x86_64 または arm64、32-bit プラットフォームはまだサポートしていません）
- Windows はリモートサーバーとしてはまだサポートされていませんが、リモートサーバーへの接続を行うローカルマシンとしては利用できます。

## Configuration

リモートサーバーの一覧は設定ファイル {#kb zed::OpenSettings} に保存されます。この一覧は Remote Projects ダイアログ {#kb projects::OpenRemote} を使って編集できます。このダイアログでは、設定ファイルに書き込む前に接続が確立できるかどうかをチェックするなど、一定の堅牢性が提供されます。

```json [settings]
{
  "ssh_connections": [
    {
      "host": "192.168.1.10",
      "projects": [{ "paths": ["~/code/zed/zed"] }]
    }
  ]
}
```

Zed はパス上の `ssh` をサブプロセスとして実行するため、指定したホストに対して `~/.ssh/config` に設定されている構成を引き継ぎます。それでも、何かを上書きする必要がある場合は、各接続ごとに次の追加オプションを設定できます。

```json [settings]
{
  "ssh_connections": [
    {
      "host": "192.168.1.10",
      "projects": [{ "paths": ["~/code/zed/zed"] }],
      // ssh マスタープロセスに渡す任意の引数
      "args": ["-i", "~/.ssh/work_id_file"],
      "port": 22, // デフォルトは 22
      // デフォルトはローカルマシン上のあなたのユーザー名
      "username": "me"
    }
  ]
}
```

接続ごとに指定できる Zed 固有のオプションとして、`upload_binary_over_ssh` と `nickname` の 2 つがあります。

```json [settings]
{
  "ssh_connections": [
    {
      "host": "192.168.1.10",
      "projects": [{ "paths": ["~/code/zed/zed"] }],
      // デフォルトでは Zed はリモート上でインターネットからサーバーバイナリをダウンロードします。
      // これが true の場合、バイナリはあなたのラップトップにダウンロードされ、SSH 経由でアップロードされます。
      // これはリモートサーバーのインターネットアクセスが制限されている場合に有用です。
      "upload_binary_over_ssh": true,
      // 複数のホストを見分けるために Zed UI に表示されます。
      "nickname": "lil-linux"
    }
  ]
}
```

`zed ssh://192.168.1.10/~/.vimrc` のようにコマンドラインからホストへの接続を開く場合、追加オプションは設定ファイルから読み込まれます。このとき、コマンドラインの URL の host/username/port に一致する最初の接続エントリが参照されます。

また、`zed ssh://user:password@host/~` のようにコマンドラインでパスワードを渡すことはできますが、設定ファイルにパスワードを書き込むことはサポートしていない点にも注意してください。同じホストに繰り返し接続する場合は、鍵認証を設定するべきです。

## Remote Development on Windows (SSH)

Windows 上の Zed は SSH remoting をサポートしており、必要に応じて認証情報の入力を求めます。

認証に問題が発生した場合は、SSH キーエージェント（たとえば ssh-agent や Git クライアントのエージェント）が実行されていること、そして ssh.exe が PATH に含まれていることを確認してください。

### Troubleshooting SSH on Windows

認証情報の入力を求められたときは、グラフィカルな askpass ダイアログを使用してください。これが表示されない場合は、credential manager の競合がないか、GUI プロンプトがターミナルによってブロックされていないかを確認してください。

## WSL Support

Zed は Windows 上で WSL 内のフォルダをネイティブに開くことをサポートしています。

### Opening a local folder in WSL

WSL コンテナ内でローカルフォルダを開くには、`projects: open in wsl` アクションを使用し、開きたいフォルダを選択します。利用可能な WSL ディストリビューションの一覧が表示されるので、フォルダを開くディストリビューションを選択してください。

### Opening a folder already in WSL

すでに WSL コンテナ内にあるフォルダを開くには、`projects: open wsl` アクションを使用し、WSL ディストリビューションを選択します。そのディストリビューションは `Remote Projects` ウィンドウに追加され、そこからフォルダを開くことができます。

## Port forwarding

ローカルマシンからリモートサーバー上のポートに接続できるようにしたい場合は、設定ファイルでポートフォワーディングを構成できます。これは、ブラウザでサイトを読み込みながら作業できるため、ウェブサイトの開発に特に便利です。

```json [settings]
{
  "ssh_connections": [
    {
      "host": "192.168.1.10",
      "port_forwards": [{ "local_port": 8080, "remote_port": 80 }]
    }
  ]
}
```

これにより、ローカルマシンから `localhost:8080` へのリクエストはリモートマシンのポート 80 にフォワードされます。内部的には、これは ssh の `-L` 引数を使って実現されています。

デフォルトでは、これらのポートは localhost にバインドされるため、同じネットワーク上の他のコンピューターからはアクセスできません。`local_host` を設定して別のインターフェイスにバインドすることもできます。たとえば 0.0.0.0 を指定すると、すべてのローカルインターフェイスにバインドされます。

```json [settings]
{
  "ssh_connections": [
    {
      "host": "192.168.1.10",
      "port_forwards": [
        {
          "local_port": 8080,
          "remote_port": 80,
          "local_host": "0.0.0.0"
        }
      ]
    }
  ]
}
```

これらのポートも、リモートホスト上の `localhost` インターフェイスをデフォルトとして使用します。これを変更する必要がある場合は、リモートホストも設定できます:

```json [settings]
{
  "ssh_connections": [
    {
      "host": "192.168.1.10",
      "port_forwards": [
        {
          "local_port": 8080,
          "remote_port": 80,
          "remote_host": "docker-host"
        }
      ]
    }
  ]
}
```

## Zed の設定

リモートプロジェクトを開くとき、関連する設定の場所は 3 つあります:

- ローカルマシン上のローカル Zed 設定（macOS では `~/.zed/settings.json`、Linux では `~/.config/zed/settings.json`）。
- リモートサーバー上のサーバー Zed 設定（同じ場所）。
- プロジェクト設定（プロジェクト内の `.zed/settings.json` または `.editorconfig`）

ローカルの Zed とサーバーの Zed はどちらもプロジェクト設定を読み込みますが、互いのメイン設定ファイルについては認識していません。

どの設定ファイルを使うべきかは、行いたい設定の種類によって異なります:

- プロジェクトに影響する項目（インデント設定、使用するフォーマッタ / Language Server など）にはプロジェクト設定を使用します。
- サーバーに影響する項目（Language Server へのパス、プロキシ設定など）にはサーバー設定を使用します。
- UI に影響する項目（フォントサイズなど）にはローカル設定を使用します。

さらに、ローカルにインストールしている拡張機能はすべてリモートサーバーに伝播されます。これにより、Language Server なども正しく動作します。

## プロキシの設定

リモートサーバーは、ローカルマシンのプロキシ設定を使用しません。異なるネットワークポリシーの下にある可能性があるためです。リモートサーバーがインターネットアクセスにプロキシを必要とする場合は、リモートサーバー側でプロキシを設定する必要があります。

ほとんどの場合、リモートサーバーにはすでにプロキシ用の環境変数が設定されています。Zed は、Language Server のダウンロードや LLM モデルとの通信などを行う際に、これらを自動的に使用します。

必要に応じて、これらの環境変数をサーバーのシェル設定ファイル（例: `~/.bashrc`）に設定できます:

```bash
export http_proxy="http://proxy.example.com:8080"
export https_proxy="http://proxy.example.com:8080"
export no_proxy="localhost,127.0.0.1"
```

または、リモートマシンの `~/.config/zed/settings.json`（Linux）または `~/.zed/settings.json`（macOS）でプロキシを設定することもできます:

```json
{
  "proxy": "http://proxy.example.com:8080"
}
```

サポートされているプロキシの種類や追加の設定オプションについては、[proxy のドキュメント](./reference/all-settings.md#network-proxy)を参照してください。

## リモートサーバーの初期化

SSH オプションを指定すると、Zed はローカルマシン上の `ssh` を実行し、指定したオプションで ControlMaster 接続を作成します。

SSH が必要とするプロンプトはすべて UI に表示されるため、ホストキーの確認や鍵パスワードの入力などを行えます。

マスター接続が確立されると、Zed はリモートの `~/.zed_server` にリモートサーバーのバイナリが存在するかどうか、またそのバージョンが現在使用している Zed のバージョンと一致しているかどうかを確認します。

バイナリが存在しない場合やバージョンが一致しない場合、Zed は最新バージョンのダウンロードを試みます。デフォルトでは `https://zed.dev` から直接ダウンロードしますが、そのサーバーの設定で `{"upload_binary_over_ssh":true}` を指定している場合は、いったんローカルマシンにバイナリをダウンロードしてからリモートサーバーへアップロードします。

サーバーバイナリを自分で管理したい場合は、そのようにすることもできます。[GitHub](https://github.com/zed-industries/zed/releases) からあらかじめビルドされたバージョンをダウンロードするか、`cargo build -p remote_server --release` を使って[自分でビルド](https://zed.dev/docs/development)できます。これを行う場合は、サーバー上の `~/.zed_server/zed-remote-server-{RELEASE_CHANNEL}-{VERSION}` にアップロードする必要があります（例: `~/.zed_server/zed-remote-server-stable-0.217.3+stable.105.80433cb239e868271457ac376673a5f75bc4adb1`）。このバージョンは、使用している Zed 本体のバージョンと完全に一致していなければなりません。

## SSH 接続の維持

サーバーが初期化されると、Zed はリモート開発サーバーを実行するために、新しい SSH 接続（既存の ControlMaster を再利用）を作成します。

各接続は、開発サーバーをプロキシモードで実行しようとします。このモードでは、デーモンが動作していなければ起動し、動作していれば再接続します。これにより、接続が切断されて再確立された場合でも、中断することなく作業を続けることができます。

再接続に失敗した場合、そのデーモンは再利用されません。ただし、未保存の変更はデフォルトでローカルに保持されるため、作業内容が失われることはありません。後からいつでもプロジェクトに再接続でき、Zed が未保存の変更を復元します。

接続の問題で困っている場合は、Zed のログ `cmd-shift-p Open Log` で詳細な情報を確認できます。想定外の挙動が見られる場合は、[GitHub issue](https://github.com/zed-industries/zed/issues/new) を作成するか、[Zed Discord](https://zed.dev/community-links) の #remoting-feedback チャンネルでお問い合わせください。

## サポートされている SSH オプション

内部的には、Zed は `ssh` バイナリを実行してリモートサーバーに接続します。プロジェクトごとに 1 つの SSH ControlMaster を作成し、それを使って Zed プロトコル自身、開いたターミナル、実行したタスク用の SSH 接続を多重化します。Zed は SSH 設定ファイルから設定を読み込みますが、SSH ControlMaster に追加のオプションを指定したい場合は、Zed の設定でそれらを指定できます。

「Connect New Server」ダイアログで入力する際、スペースを含むオプションを渡すために bash 風のクォートを使用できます。サーバーを一度作成すると、そのサーバーは設定ファイルの `"ssh_connections": []` 配列に追加されます。SSH 接続を変更したい場合は、この設定ファイルを直接編集できます。

サポートされているオプション:

- `-p` / `-l` - これらはホスト文字列でポート番号とユーザー名を指定するのと同等です。
- `-L` / `-R` - ポートフォワーディング用
- `-i` - 特定の鍵ファイルを使用する
- `-o` - カスタムオプションを設定する
- `-J` / `-w` - SSH 接続をプロキシする
- `-F` - `ssh_config` を指定する
- さらに... `-4`, `-6`, `-A`, `-B`, `-C`, `-D`, `-I`, `-K`, `-P`, `-X`, `-Y`, `-a`, `-b`, `-c`, `-i`, `-k`, `-l`, `-m`, `-o`, `-p`, `-w`, `-x`, `-y`

なお、Zed が自動的に設定する一部のオプション（例: `-t` や `-T`）は、意図的に指定できないようにしています。

## 既知の制限事項

- リモートターミナルで `zed` コマンドを入力しても、ファイルを開くことはできません。

## フィードバック

ぜひ [Zed Discord](https://zed.dev/community-links) の #remoting-feedback チャンネルに参加してください。

## 関連項目

- [Running & Testing](./running-testing.md): リモートで作業しながらタスク、ターミナルコマンド、
  デバッガーセッションを実行します。
- [Configuring Zed](./configuring-zed.md): 共有設定とプロジェクト設定を管理します。
  `.zed/settings.json` も含まれます。
- [Agent Panel](./ai/agent-panel.md): リモートプロジェクトで AI ワークフローを利用します。
- [Remote Development on zed.dev](https://zed.dev/remote-development): 製品の概要と
  リリースの最新情報。
