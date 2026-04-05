# OpenTofu

OpenTofu のサポートは [OpenTofu extension](https://github.com/ashpool37/zed-extension-opentofu) を通じて利用できます。

- Tree-sitter: [MichaHoffmann/tree-sitter-hcl](https://github.com/MichaHoffmann/tree-sitter-hcl)
- 言語サーバー: [opentofu/tofu-ls](https://github.com/opentofu/tofu-ls)

## 設定

`.tf` および `.tfvars` ファイルを編集するときに OpenTofu extension と言語サーバーを自動的に使用するには、
Terraform extension をアンインストールするか、次を settings.json に追加してください:

```json
"file_types": {
  "OpenTofu": ["tf"],
  "OpenTofu Vars": ["tfvars"]
},
```

サーバー設定の完全な一覧は[こちら](https://github.com/opentofu/tofu-ls/blob/main/docs/SETTINGS.md)を参照してください。
