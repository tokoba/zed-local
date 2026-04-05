#!/bin/bash
# markdown の lint および mermaid チェック
markdownlint-cli2 "**/*.md" --fix && mermaid-validate "**/*.md"
# 以下の mermaid linter は処理が重い
# md-mermaid-lint "**/*.md"
