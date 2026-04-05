# Swift

Zed における Swift 言語サポートは、コミュニティにより保守されている [Swift extension](https://github.com/zed-extensions/swift) によって提供されています。
問題は次に報告してください: <https://github.com/zed-extensions/swift/issues>

- Tree-sitter: [alex-pinkus/tree-sitter-swift](https://github.com/alex-pinkus/tree-sitter-swift)
- Language Server: [swiftlang/sourcekit-lsp](https://github.com/swiftlang/sourcekit-lsp)
- Debug Adapter: [`lldb-dap`](https://github.com/swiftlang/llvm-project/blob/next/lldb/tools/lldb-dap/README.md)

## Language Server の設定

ホームディレクトリ直下、またはプロジェクトルートに `.sourcekit-lsp/config.json` を作成することで、SourceKit LSP の動作を変更できます。詳細なドキュメントは [SourceKit-LSP configuration file](https://github.com/swiftlang/sourcekit-lsp/blob/main/Documentation/Configuration%20File.md) を参照してください。

## デバッグ

Swift extension は、Swift コードをデバッグするためのデバッグアダプターを提供します。
Zed におけるこのアダプターの名称（UI および `debug.json` 内）は `Swift` であり、内部的には Swift ツールチェーンが提供する [`lldb-dap`](https://github.com/swiftlang/llvm-project/blob/next/lldb/tools/lldb-dap/README.md) を使用します。
この拡張機能は、`swiftly` を使用する方法、`xcrun` を使用する方法、`$PATH` を検索する方法の優先順位で、`lldb-dap` バイナリを探します。
`lldb-dap` が見つからない場合でも、この拡張機能がそれをダウンロードしようとすることはありません。

- [lldb-dap の設定ドキュメント](https://github.com/llvm/llvm-project/blob/main/lldb/tools/lldb-dap/README.md#configuration-settings-reference)

### 例

#### Swift バイナリをビルドしてデバッグする

```json [debug]
[
  {
    "label": "Debug Swift",
    "build": {
      "command": "swift",
      "args": ["build"]
    },
    "program": "$ZED_WORKTREE_ROOT/swift-app/.build/arm64-apple-macosx/debug/swift-app",
    "request": "launch",
    "adapter": "Swift"
  }
]
```
