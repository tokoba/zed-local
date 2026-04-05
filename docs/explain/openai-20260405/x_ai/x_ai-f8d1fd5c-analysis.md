# x_ai/ ディレクトリ解説

## 1. ざっくり一言

`x_ai` クレートは、x.ai の Grok 系モデル群を表現する `Model` 列挙体と、そのモデルに関するメタ情報（ID、表示名、トークン上限、画像対応・ツール対応など）を提供する小さなユーティリティクレートです。

---

## 2. このモジュールの役割

### 2.1 概要

- このディレクトリ（クレート）は、x.ai の各種モデル（Grok 2/3/4/4.1、コード用モデル、カスタムモデル）を **型安全に扱うための列挙体** を提供します。
- 文字列 ID（例: `"grok-4"` や `"grok-3-fast"`）と `Model` 型の間の変換、およびモデルごとの **能力・制約情報（最大トークン数、画像対応、ツール対応など）** を取得するメソッドをまとめています。
- HTTP 通信自体は実装しておらず、API ベース URL の定数 `XAI_API_URL` のみを提供します。

### 2.2 アーキテクチャ内での位置づけ

このクレートは、外部 HTTP クライアントやアプリケーションロジックから利用される「**モデル定義用のドメイン層**」のような位置づけになっています。

依存関係は次のようになります。

```mermaid
graph LR
    subgraph "クレート x_ai"
        ModelEnum["enum Model"]
        ApiUrl["const XAI_API_URL"]
    end

    ModelEnum --> Serde["serde（シリアライズ/デシリアライズ）"]
    ModelEnum --> Strum["strum::EnumIter（列挙体の列挙）"]
    ModelEnum --> Anyhow["anyhow::Result（エラー処理）"]
    ModelEnum -->|feature \"schemars\"| Schemars["schemars::JsonSchema（スキーマ生成）"]
```

- このチャンクには、`x_ai` を利用する側のクレートや HTTP クライアントコードは含まれていません。
- そのため、このクレートは **他のクレートから取り込まれて使われる前提の「下位レイヤー」** であると解釈できます。

### 2.3 設計上のポイント

- **列挙体ベースのモデル管理**  
  すべての公式モデルとカスタムモデルを `Model` 列挙体のバリアントとして表現しています。
- **serde による ID のマッピング**  
  `#[serde(rename = "...", alias = "...")]` により、JSON 上のモデル名と Rust のバリアント名とのマッピングを定義しています。
- **エラーハンドリング**  
  文字列 ID から `Model` を生成する `from_id` は `anyhow::Result` を返し、不正な ID の場合は `bail!` でエラーにします。
- **能力フラグのまとめ**  
  「画像対応」「ツール対応」「並列ツール呼び出し対応」「JSON Schema サブセット制限」などの能力を `Model` 上のメソッドで一元的に判断できます。
- **カスタムモデルの柔軟性**  
  `Model::Custom` バリアントには、最大トークン数やオプション能力フラグをフィールドとして持たせ、利用者側でカスタマイズ可能にしています。

---

## 3. 主要な機能一覧

- **モデル列挙体 `Model` の定義**  
  Grok 2/3/4/4.1 系モデルとコード用モデル、カスタムモデルを1つの列挙体で表現します。
- **モデル ID との変換**  
  - `Model::from_id(&str) -> Result<Model>`: 文字列 ID から `Model` へ変換  
  - `Model::id(&self) -> &str`: `Model` から内部的に使う ID 文字列を取得
- **表示名の取得**  
  - `Model::display_name(&self) -> &str`: UI などで利用するための人間向け名称を返します。
- **トークン関連情報の取得**  
  - `Model::max_token_count(&self) -> u64`  
  - `Model::max_output_tokens(&self) -> Option<u64>`
- **能力フラグの取得**  
  - `Model::supports_tool(&self) -> bool`  
  - `Model::supports_parallel_tool_calls(&self) -> bool`  
  - `Model::supports_images(&self) -> bool`  
  - `Model::requires_json_schema_subset(&self) -> bool`  
  - `Model::supports_prompt_cache_key(&self) -> bool`（現在は常に `false`）
- **デフォルトモデルの選択**  
  - `Model::default()` と `Model::default_fast()` による標準的なモデル選択。
- **API ベース URL の公開**  
  - `XAI_API_URL`: `"https://api.x.ai/v1"` という定数を提供します。

---

## 4. 関数・構造体の解説

### 4.1 型・定数一覧

| 名前           | 種別   | 役割 / 用途 |
|----------------|--------|-------------|
| `Model`        | 列挙体 | x.ai の各種モデルとカスタムモデルを表現するメインの型です。 |
| `XAI_API_URL`  | 定数   | x.ai API のベース URL（`https://api.x.ai/v1`）を表します。 |

#### enum `Model`

- 代表的なバリアント（抜粋）:
  - `Grok2Vision` (`"grok-2-vision-latest"` としてシリアライズ)
  - `Grok3` (`"grok-3-latest"`)
  - `Grok3Mini` (`"grok-3-mini-latest"`)
  - `Grok3Fast` (`"grok-3-fast-latest"`)
  - `Grok3MiniFast` (`"grok-3-mini-fast-latest"`)
  - `Grok4` (`"grok-4"` / `"grok-4-latest"`)
  - `Grok4FastReasoning` (`"grok-4-fast-reasoning"` / `"grok-4-fast-reasoning-latest"`)
  - `Grok4FastNonReasoning` (`"grok-4-fast-non-reasoning"` / `"grok-4-fast-non-reasoning-latest"`)
  - `Grok41FastNonReasoning` (`"grok-4-1-fast-non-reasoning"` / `"grok-4-1-fast-non-reasoning-latest"`)
  - `Grok41FastReasoning` (`"grok-4-1-fast-reasoning"`, `"grok-4-1-fast-reasoning-latest"`, `"grok-4-1-fast"`)
  - `GrokCodeFast1` (`"grok-code-fast-1"` / `"grok-code-fast-1-0825"`)
  - `Custom { ... }`（カスタムモデル）

- `Custom` バリアントのフィールド:

  ```rust
  Custom {
      name: String,                 // モデルの内部名・ID
      display_name: Option<String>, // UI に表示する名前
      max_tokens: u64,              // 入力 + 出力の合計トークン上限などに相当
      max_output_tokens: Option<u64>,
      max_completion_tokens: Option<u64>, // このファイル内では未使用
      supports_images: Option<bool>,
      supports_tools: Option<bool>,
      parallel_tool_calls: Option<bool>,
  }
  ```

- derive 属性:
  - `Clone`, `Debug`, `Default`, `Serialize`, `Deserialize`, `PartialEq`, `EnumIter`
  - `Default` は `Model::Grok3` をデフォルトにします。
  - `EnumIter` により、`Model::iter()`（strum が提供）で全バリアントを列挙できます。
  - `feature = "schemars"` 有効時は `JsonSchema` も derive します。

---

### 4.2 主要メソッド詳細

ここでは特に利用頻度が高そうなメソッドを中心に説明します。

#### `Model::from_id(id: &str) -> Result<Self>`

**概要**

- 文字列 ID（例: `"grok-4"`, `"grok-3-fast"`）から対応する `Model` バリアントを生成します。

**引数**

| 引数名 | 型      | 説明                           |
|--------|---------|--------------------------------|
| `id`   | `&str`  | モデルを表す文字列 ID です。  |

**戻り値**

- `Ok(Model)` または `Err(anyhow::Error)` を返します。
- 対応するバリアントが存在しない ID の場合は `Err` になります。

**内部処理の流れ**

1. `match id` で既知の ID 文字列と比較します。
2. 一致した場合は対応するバリアント（例: `"grok-4"` → `Model::Grok4`）を返します。
3. 一致しない場合は `anyhow::bail!("invalid model id '{id}'")` でエラーを返します。

**対応している ID の例**

- `"grok-4"`, `"grok-4-fast-reasoning"`, `"grok-4-fast-non-reasoning"`
- `"grok-4-1-fast-non-reasoning"`, `"grok-4-1-fast-reasoning"`, `"grok-4-1-fast"`
- `"grok-2-vision"`, `"grok-3"`, `"grok-3-mini"`, `"grok-3-fast"`, `"grok-3-mini-fast"`
- `"grok-code-fast-1"`

※ `Custom` はここでは生成されません。`Model::Custom { .. }` を直接構築します。

**Examples（使用例）**

```rust
use anyhow::Result;                 // anyhow::Result を利用
use x_ai::Model;                    // x_ai クレートから Model をインポート

fn select_model_from_config(id: &str) -> Result<Model> {
    // 設定ファイルなどから読み込んだ文字列 ID を enum Model に変換する
    let model = Model::from_id(id)?; // 不正な ID の場合は Err が返る
    Ok(model)
}
```

**Errors / Panics**

- 対応表に存在しない ID を渡すと `Err(anyhow::Error)` になります。
- panic を発生させるコードは含まれていません。

**Edge cases（エッジケース）**

- 空文字列 `""` を渡した場合: どのパターンにも一致しないため `Err` になります。
- 大文字小文字が異なる ID（例: `"GROK-4"`）も一致しないため `Err` になります。
- `Custom` 用の ID（任意の文字列）については、`from_id` では対応していません。

**使用上の注意点**

- この関数は **正式に認識されているモデル ID のみ** を扱います。  
  カスタムモデルは `Model::Custom { .. }` を直接構築する必要があります。
- 例外を許容しない場合は、呼び出し側で `Result` を必ずハンドリングする必要があります。

---

#### `Model::id(&self) -> &str`

**概要**

- モデルを識別するための **シンプルな ID 文字列** を返します。
- `serde` での `rename` と完全に同じではなく、`"-latest"` が付かない ID になっている点が特徴です。

**戻り値**

- 代表的な返り値:
  - `Grok3` → `"grok-3"`
  - `Grok3Fast` → `"grok-3-fast"`
  - `Grok4` → `"grok-4"`
  - `Grok4FastReasoning` → `"grok-4-fast-reasoning"`
  - `Custom { name, .. }` → `name` の値

**内部処理の流れ**

- `match self` による単純な対応表です。各バリアントに対してリテラル文字列、`Custom` ではフィールド `name` を返します。

**Examples（使用例）**

```rust
use x_ai::Model;

fn print_model_id(model: &Model) {
    // enum Model から ID 文字列を取得して表示する
    println!("Internal model id: {}", model.id());
}
```

**Edge cases（エッジケース）**

- `Custom` の場合は、`name` フィールドをそのまま返します。  
  そのため、`name` に何を入れるかは呼び出し側の責任になります。

**使用上の注意点**

- `serde` の `rename` で定義される JSON 上の名前は `"grok-3-latest"` などですが、  
  `id()` は `"grok-3"` のように `"-latest"` を含まない文字列を返します。  
  どちらを API に渡すかは、利用している API の仕様を確認する必要があります（このチャンクからは分かりません）。

---

#### `Model::display_name(&self) -> &str`

**概要**

- UI などで人間に見せるための **読みやすい表示名** を返します。

**戻り値の例**

- `Grok3` → `"Grok 3"`
- `Grok3MiniFast` → `"Grok 3 Mini Fast"`
- `Grok4FastNonReasoning` → `"Grok 4 Fast (Non-Reasoning)"`
- `Grok41FastReasoning` → `"Grok 4.1 Fast"`
- `Custom` → `display_name` が `Some` ならその値、`None` なら `name` を返します。

**内部処理の流れ**

- バリアントごとの固定文字列、`Custom` では `display_name` が `Some` かどうかで分岐しています。

**Examples（使用例）**

```rust
use x_ai::Model;

fn list_models_for_ui(models: &[Model]) {
    for model in models {
        // UI のドロップダウンなどで表示する名称
        println!("表示名: {}", model.display_name());
    }
}
```

**Edge cases（エッジケース）**

- `Custom { display_name: None, name, .. }` の場合、`name` がそのまま表示名になります。

**使用上の注意点**

- `display_name()` は必ずしも API で使う ID ではありません。  
  あくまで UI 向けであることを前提に利用する必要があります。

---

#### `Model::max_token_count(&self) -> u64`

**概要**

- 各モデルで扱えるトークン数の上限（入力 + 出力の合計に相当すると考えられる値）を返します。

**戻り値（代表的な値）**

- `Grok3`, `Grok3Mini`, `Grok3Fast`, `Grok3MiniFast` → `131_072`
- `Grok4`, `GrokCodeFast1` → `256_000`
- `Grok4FastReasoning`, `Grok4FastNonReasoning`, `Grok41FastNonReasoning`, `Grok41FastReasoning` → `2_000_000`
- `Grok2Vision` → `8_192`
- `Custom` → `max_tokens` フィールドの値

**内部処理の流れ**

- バリアントごとにマジックナンバー（定数）を返す `match` 文です。
- `Custom` の場合はフィールド `max_tokens` をそのまま返します。

**Examples（使用例）**

```rust
use x_ai::Model;

fn can_accept_tokens(model: &Model, input_tokens: u64, output_tokens: u64) -> bool {
    let total = input_tokens + output_tokens;     // 入力 + 出力の合計
    total <= model.max_token_count()             // 上限以内かどうかをチェック
}
```

**Edge cases（エッジケース）**

- `Custom` モデルで `max_tokens` に非常に小さい値を設定すると、実質的に使用できるトークンが制限されます。

**使用上の注意点**

- ここで返される上限値を、そのまま API が保証する値とみなしてよいかどうかは、  
  実際の API 仕様と突き合わせる必要があります（このチャンクでは仕様は不明です）。

---

#### `Model::max_output_tokens(&self) -> Option<u64>`

**概要**

- モデルごとの **出力トークンの上限** を返します。  
  値がない場合（`None`）は特に制限を管理していないことを意味します。

**戻り値の例**

- `Grok3` 系 (`Grok3`, `Grok3Mini`, `Grok3Fast`, `Grok3MiniFast`) → `Some(8_192)`
- `Grok4`, `Grok4FastReasoning`, `Grok4FastNonReasoning`, `Grok41FastNonReasoning`, `Grok41FastReasoning`, `GrokCodeFast1` → `Some(64_000)`
- `Grok2Vision` → `Some(4_096)`
- `Custom` → フィールド `max_output_tokens` の値（`Some` または `None`）

**Examples（使用例）**

```rust
use x_ai::Model;

fn clamp_output_tokens(model: &Model, requested: u64) -> u64 {
    match model.max_output_tokens() {
        Some(max) if requested > max => max, // 上限を超えていたら上限に丸める
        _ => requested,                      // 上限なし、または上限内の場合はそのまま
    }
}
```

**Edge cases（エッジケース）**

- `Custom` で `max_output_tokens: None` の場合、呼び出し側で別途制限を設ける必要があるかもしれません。

**使用上の注意点**

- `None` を返す場合があるため、呼び出し側は `Option` を必ず考慮する必要があります。

---

#### `Model::supports_tool(&self) -> bool`

**概要**

- モデルが「ツール呼び出し」に対応しているかどうかを返します。

**戻り値**

- 公式モデル:
  - `Grok2Vision` / `Grok3*` / `Grok4*` / `Grok41*` / `GrokCodeFast1` → すべて `true`
- `Custom`:
  - `supports_tools: Some(support)` → `support` の値を返す
  - `supports_tools: None` → `false` を返す

**内部処理の流れ**

- 公式モデルについてはすべて `true` を返します。
- `Custom` の場合、`supports_tools` が `Some` かどうかで分岐します。

**Examples（使用例）**

```rust
use x_ai::Model;

fn enable_tools_if_supported(model: &Model) {
    if model.supports_tool() {
        println!("このモデルはツール呼び出しに対応しています。");
        // ツール呼び出し用の設定を有効にする処理など
    } else {
        println!("このモデルはツール呼び出しに対応していません。");
    }
}
```

**Edge cases（エッジケース）**

- `Custom` で `supports_tools: None` の場合は `false` と扱われます。  
  明示的に `Some(true)` または `Some(false)` を設定しないと、意図しない挙動になる可能性があります。

**使用上の注意点**

- `Custom` モデルでは、能力フラグを `Option<bool>` で表現しているため、  
  「明示的な `false`」と「未設定 (`None`)」を区別したい場合は、呼び出し側設計も合わせる必要があります。

---

#### `Model::supports_images(&self) -> bool`

**概要**

- モデルが画像入力に対応しているかどうかを返します。

**戻り値**

- `true` を返す公式モデル:
  - `Grok2Vision`
  - `Grok4`, `Grok4FastReasoning`, `Grok4FastNonReasoning`
  - `Grok41FastNonReasoning`, `Grok41FastReasoning`
- `Custom`:
  - `supports_images: Some(support)` → `support` の値
  - `supports_images: None` → `false`
- その他の公式モデル（`Grok3*`, `GrokCodeFast1`）は `false` です。

**Examples（使用例）**

```rust
use x_ai::Model;

fn can_send_image(model: &Model) -> bool {
    model.supports_images()
}
```

**Edge cases（エッジケース）**

- `Custom` モデルで `supports_images` を `None` のままにすると画像非対応扱いになります。

**使用上の注意点**

- 公式モデルについての対応可否はこのコードに固定値として書かれています。  
  API 側の仕様変更があった場合、この値と実際の挙動がずれる可能性がありますが、  
  このチャンクからは更新ポリシーなどは分かりません。

---

### 4.3 その他のメソッド一覧

| メソッド名                            | 役割（1 行） |
|--------------------------------------|--------------|
| `Model::default()`                   | `Default` トレイトの実装により、`Grok3` を返します。 |
| `Model::default_fast()`              | 「高速」系のデフォルトとして `Grok3Fast` を返します。 |
| `Model::supports_parallel_tool_calls()` | 並列ツール呼び出しに対応しているかを返します。`Custom` は `parallel_tool_calls` を参照し、未設定時は `false` です。 |
| `Model::requires_json_schema_subset()` | ツールスキーマなどが「JSON Schema のサブセット」に制限される必要があるモデルかどうかを返します。`Grok4*`, `Grok41*`, `GrokCodeFast1` で `true`。 |
| `Model::supports_prompt_cache_key()` | 現状は常に `false` を返します。この API ではプロンプトキャッシュキーは使えない前提になっています。 |

---

## 5. データフロー

ここでは、代表的なシナリオとして「アプリケーションがモデルを選択し、メタ情報を使って API リクエストを組み立てる」流れを示します。

```mermaid
sequenceDiagram
    participant App as "アプリケーション"
    participant Model as "enum Model"
    participant Http as "HTTPクライアント"

    App->>Model: Model::from_id(\"grok-4\") を呼び出し
    Model-->>App: Ok(Model::Grok4)

    App->>Model: id()
    Model-->>App: \"grok-4\"

    App->>Model: max_token_count()
    Model-->>App: 256000

    App->>Model: supports_tool()
    Model-->>App: true

    App->>Http: XAI_API_URL と id()/トークン情報を使ってリクエスト組み立て
    Http->>+\"x.ai API\": POST https://api.x.ai/v1/... （詳細はこのチャンクには未定義）
    \"x.ai API\"-->>-Http: レスポンス
    Http-->>App: レスポンス結果
```

- 実際の HTTP 実装はこのディレクトリには含まれていませんが、  
  上記のように `Model` が API リクエストの **パラメータや検証ロジックの入力** として使われることが想定できます（ただし、あくまでコード構造からの読み取りです）。

---

## 6. 使い方（How to Use）

### 6.1 基本的な使用方法

ここでは、`x_ai` クレートを使ってモデルを選択し、簡単なチェックを行う例を示します。

```rust
use anyhow::Result;            // anyhow の Result を利用する
use x_ai::{Model, XAI_API_URL}; // Cargo.toml の name = "x_ai" から推測されるクレート名

fn main() -> Result<()> {
    // 1. デフォルトの高速モデルを選択する
    let model = Model::default_fast(); // Grok3Fast が返る

    // 2. モデルの ID と表示名を取得する
    println!("API base URL: {}", XAI_API_URL);  // https://api.x.ai/v1
    println!("Model id: {}", model.id());       // 例: "grok-3-fast"
    println!("Display name: {}", model.display_name()); // 例: "Grok 3 Fast"

    // 3. トークン上限を使って入力サイズを確認する
    let max_tokens = model.max_token_count();
    println!("Max tokens: {}", max_tokens);

    // 4. ツール・画像対応などの能力フラグを確認する
    println!("Supports tools: {}", model.supports_tool());
    println!("Supports images: {}", model.supports_images());

    // 5. ここで実際の HTTP クライアントを使って API を呼び出す想定
    //    （HTTP 実装はこのチャンクにはありません）
    //    例:
    //    let response = my_http_client.post(format!("{}/chat/completions", XAI_API_URL))
    //        .json(&request_body)
    //        .send()
    //        .await?;

    Ok(())
}
```

### 6.2 よくある使用パターン

#### パターン1: 設定ファイルから文字列 ID を読み込んでモデルを決定する

```rust
use anyhow::{Context, Result};
use x_ai::Model;

fn select_model_from_config(id_from_config: &str) -> Result<Model> {
    // 設定ファイルなどから読み込んだ ID を Model に変換する
    let model = Model::from_id(id_from_config)
        .with_context(|| format!("unknown x.ai model id: {}", id_from_config))?;

    Ok(model)
}
```

- 不正な ID の場合はエラーになるため、`Result` を返して呼び出し元でハンドリングします。

#### パターン2: カスタムモデルを定義する

```rust
use x_ai::Model;

fn build_custom_model() -> Model {
    Model::Custom {
        name: "my-custom-model".to_string(),        // 内部 ID
        display_name: Some("My Custom Model".into()), // UI 表示名
        max_tokens: 100_000,                        // 任意の上限
        max_output_tokens: Some(8_000),             // 出力トークン上限
        max_completion_tokens: None,                // このファイル内では未使用
        supports_images: Some(false),               // 画像は非対応
        supports_tools: Some(true),                 // ツール呼び出しには対応
        parallel_tool_calls: Some(false),           // 並列ツール呼び出しは不可
    }
}
```

- `Custom` を使うことで、公式モデルにない能力セットを呼び出し側で定義できます。

#### パターン3: すべてのモデルを列挙して UI に表示する（EnumIter 利用）

```rust
use strum::IntoEnumIterator;  // EnumIter 派生で利用可能になるトレイト
use x_ai::Model;

fn list_all_models() {
    for model in Model::iter() {
        println!(
            "id = {:<20} display = {:<25} tools = {:<5} images = {:<5}",
            model.id(),
            model.display_name(),
            model.supports_tool(),
            model.supports_images(),
        );
    }
}
```

- `EnumIter` により、全バリアント（`Custom` も含む）を列挙できますが、  
  `Custom` はフィールドを持つため、既存の `Custom` インスタンスとは異なる形になります。  
  ここでは、主に「固定の公式モデル一覧」を出したい用途に向いています。

### 6.3 使用上の注意点（まとめ）

- **`from_id` と `Custom` の関係**  
  `Model::from_id` はあくまで「事前に定義されたモデル ID」のみを扱い、  
  `Custom` は直接 `Model::Custom { .. }` を構築する必要があります。
- **ID と serde の `rename` の違い**  
  - `serde` の `rename` 属性で指定されている JSON 名は `"grok-3-latest"` のように `-latest` が付くものがあります。
  - `Model::id()` は `"grok-3"` のような「ベース名」を返します。  
    API へどちらを渡すかは、利用する API の仕様を確認する必要があります。
- **Option フィールドの扱い（Custom）**  
  - `supports_images`, `supports_tools`, `parallel_tool_calls`, `max_output_tokens` などは `Option` になっています。
  - `None` のときの扱いはメソッドによって異なりますが、ほとんどが「`false` または制限なし」として扱われます。  
    意図を明確にするためには、できるだけ `Some(true)` / `Some(false)` / `Some(value)` を明示する方が安全です。
- **数値の意味づけ**  
  `max_token_count` や `max_output_tokens` の具体的な意味（入力と出力のどこまでを含むかなど）は、  
  このコードからは読み取れません。API ドキュメントと併せて解釈する必要があります。

---

## 7. 関連ファイル

| パス                       | 役割 / 関係 |
|----------------------------|------------|
| `x_ai/Cargo.toml`          | `x_ai` クレートのパッケージ設定・依存関係・feature 定義（`schemars` の optional feature など）を記述したファイルです。 |
| `x_ai/src/x_ai.rs`         | `Model` 列挙体と `XAI_API_URL` 定数、およびモデル関連のユーティリティメソッド群を定義した、このディレクトリの中核となる実装ファイルです。 |

このチャンクにはテストコードや、このクレートを利用する側のコードは含まれていません。そのため、本レポートでは `x_ai` クレート自体の構造と API の挙動に限定して説明しています。
