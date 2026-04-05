# Terraform

Terraform のサポートは [Terraform extension](https://github.com/zed-extensions/terraform) を通じて利用できます。

- Tree-sitter: [MichaHoffmann/tree-sitter-hcl](https://github.com/MichaHoffmann/tree-sitter-hcl)
- 言語サーバー: [hashicorp/terraform-ls](https://github.com/hashicorp/terraform-ls)

## 設定

<!--
TBD: 上流の例 https://github.com/hashicorp/terraform-ls/blob/main/docs/SETTINGS.md#vs-code に合わせるために `rootModulePaths` を使用した例を追加する
-->

Terraform language server は `settings.json` で設定できます。例:

```json [settings]
{
  "lsp": {
    "terraform-ls": {
      "initialization_options": {
        "experimentalFeatures": {
          "prefillRequiredFields": true
        }
      }
    }
  }
}
```

サーバー設定の完全な一覧については [こちら](https://github.com/hashicorp/terraform-ls/blob/main/docs/SETTINGS.md) を参照してください。
