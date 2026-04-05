# PowerShell

Zed における PowerShell 言語サポートは、コミュニティによってメンテナンスされている [Zed PowerShell extension](https://github.com/wingyplus/zed-powershell) によって提供されています。問題が発生した場合は次に報告してください: [github.com/wingyplus/zed-powershell/issues](https://github.com/wingyplus/zed-powershell/issues)

- Tree-sitter: [airbus-cert/tree-sitter-powershell](https://github.com/airbus-cert/tree-sitter-powershell)
- Language Server: [PowerShell/PowerShellEditorServices](https://github.com/PowerShell/PowerShellEditorServices)

## Setup

### PowerShell 7+ のインストール {#powershell-install}

- macOS: `brew install powershell/tap/powershell`
- Alpine: [Installing PowerShell on Alpine Linux](https://learn.microsoft.com/en-us/powershell/scripting/install/install-alpine)
- Debian: [Install PowerShell on Debian Linux](https://learn.microsoft.com/en-us/powershell/scripting/install/install-debian)
- RedHat: [Install PowerShell on RHEL](https://learn.microsoft.com/en-us/powershell/scripting/install/install-rhel)
- Ubuntu: [Install PowerShell on RHEL](https://learn.microsoft.com/en-us/powershell/scripting/install/install-ubuntu)
- Windows: [Install PowerShell on Windows](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows)

Zed PowerShell 拡張機能は、パス上で見つかった `pwsh` 実行ファイルをデフォルトで使用します。

### PowerShell Editor Services のインストール（任意） {#powershell-editor-services}

Zed PowerShell 拡張機能は、自動的に [PowerShell Editor Services](https://github.com/PowerShell/PowerShellEditorServices) をダウンロードしようとします。

特定のバイナリを使用したい場合は、Zed の settings.json で次のように指定できます:

```json [settings]
  "lsp": {
    "powershell-es": {
      "binary": {
        "path": "/path/to/PowerShellEditorServices"
      }
    }
  }
```
