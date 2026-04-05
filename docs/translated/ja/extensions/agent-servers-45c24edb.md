# Agent Server 拡張機能

<div class="warning">

`v0.221`.x 以降、Zed に外部エージェントをインストールするには [ACP Registry](https://agentclientprotocol.com/registry) を使用することが推奨されます。
詳しくは [リリースブログ記事](https://zed.dev/blog/acp-registry) を参照してください。

近い将来、Agent Server 拡張機能は非推奨となる予定です。

</div>

Agent Server は、[Agent Client Protocol (ACP)](https://agentclientprotocol.com) を通じて AI エージェントの実装を提供するプログラムです。
Agent Server 拡張機能は、Agent Server をパッケージ化し、ユーザーが拡張機能をインストールして Zed 内であなたのエージェントを利用できるようにします。

現在の Agent Server 拡張機能は、Zed で Extensions タブを開き（`zed: extensions` コマンドを実行）、フィルターを `All` から `Agent Servers` に変更するか、[Zed のウェブサイト](https://zed.dev/extensions?filter=agent-servers)を訪問することで確認できます。

## Agent Server 拡張機能の定義

拡張機能は `extension.toml` 内で 1 つ以上のエージェントサーバーを登録できます:

```toml
[agent_servers.my-agent]
name = "My Agent"

[agent_servers.my-agent.targets.darwin-aarch64]
archive = "https://github.com/owner/repo/releases/download/v1.0.0/agent-darwin-arm64.tar.gz"
cmd = "./agent"
args = ["--serve"]

[agent_servers.my-agent.targets.linux-x86_64]
archive = "https://github.com/owner/repo/releases/download/v1.0.0/agent-linux-x64.tar.gz"
cmd = "./agent"
args = ["--serve"]

[agent_servers.my-agent.targets.windows-x86_64]
archive = "https://github.com/owner/repo/releases/download/v1.0.0/agent-windows-x64.zip"
cmd = "./agent.exe"
args = ["--serve"]
```

### 必須フィールド

- `name`: エージェントサーバーの、人間が判読しやすい表示名（メニューに表示されます）
- `targets`: エージェントのダウンロードと実行に関する、プラットフォーム固有の設定

### ターゲットの構成

各ターゲットキーは `{os}-{arch}` という形式を使用します。ここで:

- **os**: `darwin` (macOS), `linux`, または `windows`
- **arch**: `aarch64` (ARM64) または `x86_64`

各ターゲットでは次を指定する必要があります:

- `archive`: アーカイブをダウンロードするための URL（`.tar.gz`、`.zip` などをサポート）
- `cmd`: エージェントサーバーを実行するコマンド（展開されたアーカイブからの相対パス）
- `args`: エージェントサーバーに渡すコマンドライン引数（任意）
- `sha256`: アーカイブのバイト列の SHA-256 ハッシュ文字列（任意ですが、セキュリティのため推奨）
- `env`: このターゲット専用の環境変数（任意。同名のエージェントレベルの環境変数を上書きします）

### 任意フィールド

エージェントサーバーレベルで、次の項目を任意で指定できます:

- `env`: エージェントの生成されたプロセスで設定される環境変数。デフォルトではすべてのターゲットに適用されます。
- `icon`: メニューに表示するための SVG アイコンへのパス（拡張機能のルートからの相対パス）。

### 環境変数

環境変数は 2 つのレベルで設定できます:

1. **Agent-level** (`[agent_servers.my-agent.env]`): すべてのプラットフォームに適用される変数
2. **Target-level** (`[agent_servers.my-agent.targets.{platform}.env]`): プラットフォーム固有の変数

両方が指定されている場合、ターゲットレベルの環境変数が、同名のエージェントレベルの変数を上書きします。エージェントレベルでのみ定義された変数は、すべてのターゲットに継承されます。

### 完全なサンプル

すべての任意フィールドを含んだ、より完全なサンプルです:

```toml
[agent_servers.example-agent]
name = "Example Agent"
icon = "icon/agent.svg"

[agent_servers.example-agent.env]
AGENT_LOG_LEVEL = "info"
AGENT_MODE = "production"

[agent_servers.example-agent.targets.darwin-aarch64]
archive = "https://github.com/example/agent/releases/download/v2.0.0/agent-darwin-arm64.tar.gz"
cmd = "./bin/agent"
args = ["serve", "--port", "8080"]
sha256 = "abc123def456..."

[agent_servers.example-agent.targets.linux-x86_64]
archive = "https://github.com/example/agent/releases/download/v2.0.0/agent-linux-x64.tar.gz"
cmd = "./bin/agent"
args = ["serve", "--port", "8080"]
sha256 = "def456abc123..."

[agent_servers.example-agent.targets.linux-x86_64.env]
AGENT_MEMORY_LIMIT = "2GB"  # Linux 固有のオーバーライド
```

## インストールプロセス

ユーザーが拡張機能をインストールし、エージェントサーバーを選択すると、次の処理が行われます:

1. Zed がユーザーのプラットフォームに適したアーカイブをダウンロードする
2. アーカイブがキャッシュディレクトリに展開される
3. Zed が指定されたコマンドと引数を使ってエージェントを起動する
4. 設定された環境変数が適用される
5. エージェントサーバーがバックグラウンドで動作し、ユーザーを支援する準備が整う

アーカイブはローカルにキャッシュされるため、次回以降の起動は高速です。

## 配布に関するベストプラクティス

### GitHub Releases を使用する

GitHub Releases は、エージェントサーバーのバイナリを配布するための信頼性の高い方法です:

1. 各プラットフォーム向けにエージェントをビルドします（macOS ARM64、macOS x86_64、Linux x86_64、Windows x86_64）
2. 各ビルドを圧縮アーカイブ（`.tar.gz` または `.zip`）としてパッケージ化します
3. GitHub リリースを作成し、アーカイブをアップロードします
4. `extension.toml` 内で、そのリリース URL を使用します

## SHA-256 ハッシュ

サプライチェーンセキュリティを高めるために、アーカイブの SHA-256 ハッシュを `extension.toml` に含めてください。以下はハッシュの生成方法です:

### macOS および Linux

```bash
shasum -a 256 agent-darwin-arm64.tar.gz
```

### Windows

```bash
certutil -hashfile agent-windows-x64.zip SHA256
```

その文字列をターゲットの構成に追加します:

```toml
[agent_servers.my-agent.targets.darwin-aarch64]
archive = "https://github.com/owner/repo/releases/download/v1.0.0/agent-darwin-arm64.tar.gz"
cmd = "./agent"
sha256 = "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
```

## テスト

Agent Server 拡張機能をテストするには、次の手順を実行します:

1. [開発用拡張機能としてインストールします](./developing-extensions.md#developing-an-extension-locally)
2. [Agent Panel](../ai/agent-panel.md) を開きます
3. リストから自分のエージェントサーバーを選択します
4. ダウンロード、インストール、および起動が正しく行われることを確認します
5. 実際に対話し、[ACP ログ](../ai/external-agents.md#debugging-agents) を確認しながら機能をテストします

## アイコンのガイドライン

エージェントサーバーにロゴがある場合は、SVG アイコンとして追加してください。
一貫したレンダリングのため、次のガイドラインに従ってください:

- SVG を、1～2 ピクセル程度の余白を含む 16x16 のバウンディングボックスに収まるようリサイズする
- [SVGOMG](https://jakearchibald.github.io/svgomg/) を使って SVG マークアップをクリーンに保つ
- SVG の複雑さを増し、レンダリングが不安定になりがちなグラデーションの使用は避ける

Zed のデザインの一貫性を保つため、アイコンは自動的にモノクロに変換される点に注意してください。
（それでも、SVG の異なるパスで不透明度を使うことで、視覚的なレイヤー表現を加えることは可能です。）

## 公開

拡張機能の準備ができたら、Zed 拡張機能レジストリへの登録方法については、[Publishing your extension](./developing-extensions.md#publishing-your-extension) を参照してください。
