# C #

C# のサポートは [C# extension](https://github.com/zed-extensions/csharp) によって提供されています。

- Tree-sitter: [tree-sitter/tree-sitter-c-sharp](https://github.com/tree-sitter/tree-sitter-c-sharp)
- Language Servers:
  - [roslyn-language-server](https://www.nuget.org/packages/roslyn-language-server#readme)
  - [OmniSharp/omnisharp-roslyn](https://github.com/OmniSharp/omnisharp-roslyn)

Roslyn はデフォルトで有効になっています。OmniSharp に戻すには、次の内容を Zed の設定ファイルに追加します:

```json [settings]
{
  "languages": {
    "CSharp": {
      "language_servers": ["omnisharp", "!roslyn", "..."]
    }
  }
}
```

注意: 設定で使用される言語名は "C#" ではなく "CSharp" です。

## Configuration

Roslyn は、次の言語サーバー設定で構成できます:

```json [settings]
{
  "lsp": {
    "roslyn": {
      "settings": {
        // 以下にデフォルト値と、必要に応じて選択可能な代替オプションを示します。
        "csharp|symbol_search": {
          "dotnet_search_reference_assemblies": true
        },
        "csharp|type_members": {
          "dotnet_member_insertion_location": "atTheEnd", // または "withOtherMembersOfTheSameKind"
          "dotnet_property_generation_behavior": "preferThrowingProperties" // または "preferAutoProperties"
        },
        "csharp|completion": {
          "dotnet_show_name_completion_suggestions": true,
          "dotnet_provide_regex_completions": true,
          "dotnet_show_completion_items_from_unimported_namespaces": true,
          "dotnet_trigger_completion_in_argument_lists": true
        },
        "csharp|quick_info": {
          "dotnet_show_remarks_in_quick_info": true
        },
        "csharp|navigation": {
          "dotnet_navigate_to_decompiled_sources": true,
          "dotnet_navigate_to_source_link_and_embedded_sources": true
        },
        "csharp|highlighting": {
          "dotnet_highlight_related_json_components": true,
          "dotnet_highlight_related_regex_components": true
        },
        "csharp|inlay_hints": {
          "dotnet_enable_inlay_hints_for_parameters": true,
          "dotnet_enable_inlay_hints_for_literal_parameters": true,
          "dotnet_enable_inlay_hints_for_indexer_parameters": true,
          "dotnet_enable_inlay_hints_for_object_creation_parameters": true,
          "dotnet_enable_inlay_hints_for_other_parameters": true,
          "dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix": true,
          "dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent": true,
          "dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name": true,
          "csharp_enable_inlay_hints_for_types": true,
          "csharp_enable_inlay_hints_for_implicit_variable_types": true,
          "csharp_enable_inlay_hints_for_lambda_parameter_types": true,
          "csharp_enable_inlay_hints_for_implicit_object_creation": true,
          "csharp_enable_inlay_hints_for_collection_expressions": true
        },
        "csharp|code_style.formatting.indentation_and_spacing": {
          "tab_width": 4,
          "indent_size": 4,
          "indent_style": "space" // または "tab"
        },
        "csharp|code_style.formatting.new_line": {
          "end_of_line": "...", // プラットフォーム固有のデフォルト値
          "insert_final_newline": false
        },
        "csharp|background_analysis": {
          "dotnet_analyzer_diagnostics_scope": "default", // または "none" "openFiles" "fullSolution"
          "dotnet_compiler_diagnostics_scope": "openFiles" // または "fullSolution"
        },
        "csharp|code_lens": {
          "dotnet_enable_references_code_lens": false,
          "dotnet_enable_tests_code_lens": false
        },
        "csharp|auto_insert": {
          "dotnet_enable_auto_insert": true
        },
        "csharp|projects": {
          "dotnet_binary_log_path": null,
          "dotnet_enable_automatic_restore": true,
          "dotnet_enable_file_based_programs": true,
          "dotnet_enable_file_based_programs_when_ambiguous": true
        },
        "csharp|formatting": {
          "dotnet_organize_imports_on_format": false
        }
      },
      "binary": {
        "path": "/path/to/roslyn-language-server",
        "arguments": ["--stdio", "--autoLoadProjects" /* 追加の引数を指定 */]
      }
    }
  }
}
```

OmniSharp は、Zed の設定ファイルで次のように構成できます:

```json [settings]
{
  "lsp": {
    "omnisharp": {
      "binary": {
        "path": "/path/to/OmniSharp",
        "arguments": ["-lsp" /* 追加の引数を指定 */]
      }
    }
  }
}
```
