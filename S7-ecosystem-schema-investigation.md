# S7 Ecosystem: Schema & Structured Output Investigation

> Investigation date: April 12, 2026  
> Download stats window: March 12 – April 10, 2026 (cranlogs)

---

## Part 1: All CRAN Packages That Import S7

64 CRAN packages carry S7 in their `Imports` field as of April 2026.  
Two additional packages (`anansi`, `plyxp`) import S7 but live on Bioconductor only — no CRAN download stats available.

### Ranked by Monthly Downloads

| Rank | Package | Downloads (30d) | Notes |
|------|---------|----------------|-------|
| 1 | [ggplot2](https://cran.r-project.org/package=ggplot2) | 1,964,872 | |
| 2 | [ggrepel](https://cran.r-project.org/package=ggrepel) | 534,614 | |
| 3 | [ggiraph](https://cran.r-project.org/package=ggiraph) | 94,250 | |
| 4 | [GGally](https://cran.r-project.org/package=GGally) | 80,376 | |
| 5 | [CVXR](https://cran.r-project.org/package=CVXR) | 39,812 | |
| 6 | [ggh4x](https://cran.r-project.org/package=ggh4x) | 23,166 | |
| 7 | [shadowtext](https://cran.r-project.org/package=shadowtext) | 19,524 | |
| 8 | [osqp](https://cran.r-project.org/package=osqp) | 17,714 | |
| 9 | [ellmer](https://cran.r-project.org/package=ellmer) | 12,171 | LLM client; canonical type system |
| 10 | [ggside](https://cran.r-project.org/package=ggside) | 10,288 | |
| 11 | [marquee](https://cran.r-project.org/package=marquee) | 6,764 | |
| 12 | [shinychat](https://cran.r-project.org/package=shinychat) | 4,556 | |
| 13 | [ggarrow](https://cran.r-project.org/package=ggarrow) | 3,761 | |
| 14 | [arcgisutils](https://cran.r-project.org/package=arcgisutils) | 1,865 | |
| 15 | [parsermd](https://cran.r-project.org/package=parsermd) | 1,689 | |
| 16 | [btw](https://cran.r-project.org/package=btw) | 1,488 | LLM context tool |
| 17 | [ragnar](https://cran.r-project.org/package=ragnar) | 1,308 | RAG framework |
| 18 | [measr](https://cran.r-project.org/package=measr) | 1,107 | |
| 19 | [nflplotR](https://cran.r-project.org/package=nflplotR) | 926 | |
| 20 | [ggpath](https://cran.r-project.org/package=ggpath) | 898 | |
| 21 | [tidyllm](https://cran.r-project.org/package=tidyllm) | 874 | LLM client; own schema DSL |
| 22 | [ale](https://cran.r-project.org/package=ale) | 853 | |
| 23 | [fr](https://cran.r-project.org/package=fr) | 752 | Frictionless table schema |
| 24 | [deltapif](https://cran.r-project.org/package=deltapif) | 697 | |
| 25 | [apa7](https://cran.r-project.org/package=apa7) | 694 | |
| 26 | [ggdiagram](https://cran.r-project.org/package=ggdiagram) | 693 | |
| 27 | [csdb](https://cran.r-project.org/package=csdb) | 656 | |
| 28 | [corrselect](https://cran.r-project.org/package=corrselect) | 646 | |
| 29 | [desirability2](https://cran.r-project.org/package=desirability2) | 644 | |
| 30 | [monad](https://cran.r-project.org/package=monad) | 643 | |
| 31 | [sooty](https://cran.r-project.org/package=sooty) | 616 | |
| 32 | [S7schema](https://cran.r-project.org/package=S7schema) | 594 | JSON Schema validator via ajv/V8 |
| 33 | [shidashi](https://cran.r-project.org/package=shidashi) | 578 | |
| 34 | [caugi](https://cran.r-project.org/package=caugi) | 566 | |
| 35 | [ggalign](https://cran.r-project.org/package=ggalign) | 493 | |
| 36 | [ravecore](https://cran.r-project.org/package=ravecore) | 490 | |
| 37 | [filtro](https://cran.r-project.org/package=filtro) | 428 | |
| 38 | [causalDisco](https://cran.r-project.org/package=causalDisco) | 425 | |
| 39 | [PFIM](https://cran.r-project.org/package=PFIM) | 413 | |
| 40 | [querychat](https://cran.r-project.org/package=querychat) | 406 | LLM-powered SQL chat |
| 41 | [rtemis](https://cran.r-project.org/package=rtemis) | 398 | |
| 42 | [ife](https://cran.r-project.org/package=ife) | 393 | |
| 43 | [bakerrr](https://cran.r-project.org/package=bakerrr) | 364 | |
| 44 | [bregr](https://cran.r-project.org/package=bregr) | 361 | |
| 45 | [shinyOAuth](https://cran.r-project.org/package=shinyOAuth) | 360 | |
| 46 | [iAR](https://cran.r-project.org/package=iAR) | 356 | |
| 47 | [vitals](https://cran.r-project.org/package=vitals) | 348 | LLM eval framework |
| 48 | [piqp](https://cran.r-project.org/package=piqp) | 341 | |
| 49 | [bidsr](https://cran.r-project.org/package=bidsr) | 338 | BIDS format |
| 50 | [GitAI](https://cran.r-project.org/package=GitAI) | 316 | |
| 51 | [dcmstan](https://cran.r-project.org/package=dcmstan) | 315 | |
| 52 | [tidyprompt](https://cran.r-project.org/package=tidyprompt) | 312 | LLM prompting middleware |
| 53 | [myTAI](https://cran.r-project.org/package=myTAI) | 310 | |
| 54 | [SimpleUpset](https://cran.r-project.org/package=SimpleUpset) | 295 | |
| 55 | [quickr](https://cran.r-project.org/package=quickr) | 279 | |
| 56 | [crumble](https://cran.r-project.org/package=crumble) | 269 | |
| 57 | [important](https://cran.r-project.org/package=important) | 261 | |
| 58 | [meetupr](https://cran.r-project.org/package=meetupr) | 254 | |
| 59 | [silviculture](https://cran.r-project.org/package=silviculture) | 240 | |
| 60 | [pscDesign](https://cran.r-project.org/package=pscDesign) | 217 | |
| 61 | [tinylens](https://cran.r-project.org/package=tinylens) | 216 | |
| 62 | [sqlm](https://cran.r-project.org/package=sqlm) | 199 | |
| 63 | [shinyfilters](https://cran.r-project.org/package=shinyfilters) | 197 | |
| 64 | [shinyreprex](https://cran.r-project.org/package=shinyreprex) | 88 | |
| — | anansi | (Bioconductor) | |
| — | plyxp | (Bioconductor) | |

### Observations

- ggplot2 alone accounts for ~73% of all S7 reverse-import downloads.
- There is a steep cliff after ggrepel (534k) down to ggiraph (94k).
- The top 4 are all ggplot2-ecosystem packages; S7 adoption outside that cluster is still nascent.
- A distinct LLM/AI tooling cluster exists: ellmer, shinychat, btw, ragnar, tidyllm, vitals, querychat, tidyprompt, GitAI. Most are new and growing.
- 40+ packages have under 1,000 downloads/month.

---

## Part 2: Packages Attempting JSON Schema / Pydantic-Style Approaches

Excluding `S7schema` (which directly wraps JSON Schema validation via `ajv`/V8), five packages in or adjacent to this ecosystem implement structured type/schema systems of interest.

---

### 1. `ellmer` — Canonical Type System (closest to pydantic)

- **Repo:** <https://github.com/tidyverse/ellmer>
- **Docs:** <https://ellmer.tidyverse.org>
- **Author:** Hadley Wickham + Posit (tidyverse)
- **CRAN downloads (30d):** 12,171

#### What it does

`ellmer` defines a composable type algebra used for both **tool calling** and **structured data extraction** from LLMs. Types are S7 classes that compile to JSON Schema before being sent to the provider API. The naming maps directly onto JSON Schema primitives:

| ellmer function | JSON Schema equivalent | R analog |
|---|---|---|
| `type_boolean()` | `{"type": "boolean"}` | `logical(1)` |
| `type_integer()` | `{"type": "integer"}` | `integer(1)` |
| `type_number()` | `{"type": "number"}` | `numeric(1)` |
| `type_string()` | `{"type": "string"}` | `character(1)` |
| `type_enum(values)` | `{"type": "string", "enum": [...]}` | `factor(1)` |
| `type_array(items)` | `{"type": "array", "items": ...}` | vector / list |
| `type_object(...)` | `{"type": "object", "properties": ...}` | named list |
| `type_ignore()` | *(omit from schema)* | argument with default |
| `type_from_schema(path/text)` | pass-through | load raw JSON Schema |

Example:

```r
person_type <- type_object(
  name    = type_string("Full name"),
  age     = type_integer("Age in years"),
  hobbies = type_array(type_string()),
  status  = type_enum(c("active", "inactive"))
)

chat$chat_structured("Describe Alice", type = person_type)
```

`df_schema()` is a utility that auto-generates a schema description of a data.frame for sending to an LLM (column names, types, ranges, unique values).

#### Gaps vs. pydantic

- No runtime validation of arbitrary R objects — it only operates at the LLM API call boundary (constrained generation or function-calling).
- No field validators, no `default=`, no `model_validate()` for general-purpose use.
- Nested objects work, but there is no equivalent to pydantic's `model_json_schema()` for exporting a standalone schema artifact.

---

### 2. `tidyllm` — Independent Schema DSL

- **Repo:** <https://github.com/edubruell/tidyllm>
- **Docs:** <https://edubruell.github.io/tidyllm/>
- **Author:** Eduard Brüll
- **CRAN downloads (30d):** 874

#### What it does

`tidyllm` defines its own S7-based schema DSL aimed at practical, flat-to-moderately-nested extraction tasks. The core class is `tidyllm_field` (S7), and the entry point is `tidyllm_schema()`.

```r
document_schema <- tidyllm_schema(
  name    = "DocumentSchema",
  Title   = field_chr("Full title of the document"),
  Authors = field_chr("Semicolon-separated author list"),
  Year    = field_dbl("Publication year"),
  Type    = field_fct("Document type", .levels = c("Policy", "Research")),
  Tags    = field_chr("Key topics", .vector = TRUE),
  Address = field_object("Mailing address",
              street = field_chr("Street name"),
              city   = field_chr("City"),
              zip    = field_chr("Postal code")
            )
)
```

Field constructors:

| Function | JSON Schema type | Notes |
|---|---|---|
| `field_chr(.description, .vector)` | `string` / `array of string` | |
| `field_dbl(.description, .vector)` | `number` / `array of number` | |
| `field_lgl(.description, .vector)` | `boolean` | |
| `field_fct(.description, .levels, .vector)` | `string` + `enum` | closest to `Literal[...]` |
| `field_object(.description, ..., .vector)` | `object` / `array of object` | nested fields |

The `parse_field()` internal function explicitly checks for ellmer type objects and calls `to_schema()` on them — so ellmer types are valid inputs to `tidyllm_schema()`. This means the two systems are interoperable at the schema level.

`tidyllm_schema` serializes to a JSON Schema R list, which is posted as `json_schema` to the provider.

```r
# Usage
response <- llm_message("Analyze this paper", .pdf = path) |>
  chat(openai(.json_schema = document_schema))

get_reply_data(response)
```

#### Differences from ellmer

- Flatter, more ergonomic DSL for the common case (tabular extraction from docs).
- Less expressive for deeply nested or recursive schemas.
- Not the canonical upstream standard — explicitly defers to ellmer types when available.

---

### 3. `fr` — Frictionless Table Schema

- **Repo:** <https://github.com/cole-brokamp/fr>
- **Docs:** <https://cole-brokamp.github.io/fr/>
- **Author:** Cole Brokamp
- **CRAN downloads (30d):** 752

#### What it does

`fr` implements the [Frictionless Data](https://specs.frictionlessdata.io/) `Tabular Data Resource` standard in R using S7 classes: `fr_tdr`, `fr_schema`, and `fr_field`.

This is a **data publishing and interchange** schema system, not an LLM structured output system. It describes tabular files by providing field types, constraints, and relations — the R equivalent of a JSON Schema-backed data contract for CSV/tabular data.

Frictionless standards hierarchy:
- **Table Schema** — field types, constraints, foreign keys
- **Data Resource** — file path + Table Schema + metadata
- **Tabular Data Resource** = Data Resource + Table Schema
- **Data Package** — collection of Tabular Data Resources

```r
library(fr)

# Read a Frictionless Tabular Data Resource from disk or URL
tdr <- read_fr_tdr("path/to/datapackage.json")

# Access schema metadata
fr_schema(tdr)
fr_fields(tdr)

# Coerce to data.frame with type enforcement from schema
as.data.frame(tdr)
```

#### Relationship to JSON Schema / pydantic

The Frictionless `Table Schema` spec is itself a subset of JSON Schema (field-level `type`, `constraints`, `enum`). This is the closest thing in R to Python's `pandera` (DataFrame schema validation) rather than pydantic (object model validation). The validation is schema-against-tabular-data, not schema-against-arbitrary-object.

---

### 4. `tidyprompt` — Schema Consumer / Prompting Middleware

- **Repo:** <https://github.com/KennispuntTwente/tidyprompt>
- **Docs:** <https://kennispunttwente.github.io/tidyprompt/>
- **Author:** Luka Koning, Tjark Van de Merwe (Kennispunt Twente)
- **CRAN downloads (30d):** 312

#### What it does

`tidyprompt` does **not** define its own type system. It is a prompting pipeline framework that wraps LLM interactions in composable `prompt_wrap()` layers. The schema-relevant piece is `answer_as_json()`:

```r
# Using an ellmer type definition
ellmer_schema <- ellmer::type_object(
  name    = ellmer::type_string(),
  age     = ellmer::type_integer(),
  hobbies = ellmer::type_array(ellmer::type_string())
)

"Create a persona" |>
  answer_as_json(ellmer_schema) |>
  send_prompt(llm_provider_ellmer(ellmer::chat_openai()))
```

`answer_as_json(schema)` accepts either:
- An **ellmer type object** (converted to JSON Schema via ellmer's `to_schema()`)
- A **raw JSON Schema R list**

It handles text-based fallback (works with any provider regardless of native JSON support) and native structured output for OpenAI, Ollama, and ellmer providers.

The `prompt_wrap()` mechanism is the interesting architectural idea: each wrap contributes a `modify_fn` (alters the prompt text), an `extraction_fn` (parses the response), and/or a `validation_fn` (validates and optionally sends feedback back to the LLM for retry). This is a retry-with-feedback loop at the prompt level rather than a schema validation step.

```r
# The pipeline approach
"What is 2 + 2?" |>
  answer_as_integer() |>         # adds instruction + parses int
  answer_by_chain_of_thought() | # adds CoT instruction
  send_prompt(ollama)
```

---

### 5. `wizrd` — R Objects and S7 Classes *as* Schema (GitHub only)

- **Repo:** <https://github.com/lawremi/wizrd>
- **Docs:** <https://lawremi.github.io/wizrd/>
- **Author:** Michael Lawrence (R-Core, one of the S7 authors)
- **Status:** GitHub-only, not on CRAN, not in S7 reverse imports

#### What it does

`wizrd` takes the most architecturally distinct approach of the group. Rather than a schema DSL, `output_as()` accepts **any S7 class or any R object as a prototype** — the output schema is derived from the R type system itself.

```r
agent <- openai_agent("gpt-4o-mini") |>
  instruct("Answer questions about this dataset:", mtcars)

# S7 primitive class → constrain to scalar
agent |>
  output_as(S7::class_numeric) |>
  predict("What is the correlation between mpg and wt?")
#> [1] -0.8676594

# Existing data.frame as prototype → same structure returned
agent |>
  output_as(mtcars) |>
  predict("Cars with mpg > 20")

# Stub data.frame → schema defined inline as R code
agent |>
  output_as(data.frame(cyl = integer(), avg_mpg = numeric(), avg_hp = numeric())) |>
  predict("Average mpg and hp by cylinders")
#>   cyl avg_mpg avg_hp
#> 1   4    24.1   91.5

# General class
agent |>
  output_as(S7::class_data.frame) |>
  predict("Top 5 most fuel efficient cars")
```

Because the agent is typed, S7's `convert()` generic works directly:

```r
# Materialize a constrained agent as an actual R function
filter_cars <- S7::convert(filtered_agent, S7::class_function)
filter_cars("Cars with mpg > 30")
```

#### Why this is different

Every other approach in this space maintains a **separation** between the schema definition (a type object, a schema DSL, a JSON object) and R's native type system. `wizrd` collapses that separation — R objects *are* the schema. A `data.frame` stub with typed columns defines both the shape and the types. Any S7 class is a valid constraint.

This is the closest philosophical analog to pydantic in this entire ecosystem: in pydantic you define a class with type annotations and the schema falls out. In `wizrd` you hand the agent an R object or S7 class and the schema falls out.

#### Caveats

- Not on CRAN; experimental.
- Expressive for tabular/numeric outputs; less obviously ergonomic for nested objects with enum constraints (you'd need a full S7 class with a validator property).
- No documented retry-with-feedback loop (unlike `tidyprompt`).
- Very thin adoption/community as of April 2026.

---

## Part 3: Synthesis

### Comparison Table

| Package | Schema style | Target use case | Own type system | Serializes to | Bidir validation |
|---|---|---|---|---|---|
| `ellmer` | `type_*()` composable types | LLM structured output + tools | Yes (S7) | JSON Schema → API | No (generation-side only) |
| `tidyllm` | `field_*()` + `tidyllm_schema()` | LLM structured output | Yes (S7); consumes ellmer | JSON Schema → API | No |
| `fr` | `fr_schema` / `fr_field` | Data publishing / tabular interchange | Yes (S7) | Frictionless spec → JSON | Schema-against-data (read) |
| `tidyprompt` | pass-through + retry loop | LLM prompting pipeline | No — delegates to ellmer | JSON Schema → API | Yes (text-level retry loop) |
| `wizrd` | any S7 class or R prototype | LLM as typed R function | No — R type system is the schema | Inferred JSON Schema → API | No |
| `S7schema` | JSON Schema via ajv/V8 | YAML config validation | No — wraps ajv | JSON Schema (ajv) | Yes (full JSON Schema validation) |

### The Pydantic Gap

None of these packages reach pydantic's full scope. The critical missing piece is **runtime validation of arbitrary R data against a schema** — a `model_validate(data, schema)` primitive that:

1. Accepts any R object
2. Validates it against a defined schema
3. Returns typed, coerced output or a structured error

All of the LLM-facing packages (ellmer, tidyllm, tidyprompt, wizrd) only enforce schemas at the API call boundary via constrained generation. They do not validate R objects produced by other means.

`S7schema` is the only CRAN package here that does genuine schema validation (via `ajv`), but it targets YAML config files rather than general R objects.

### Convergence Signal

`ellmer`'s `type_*()` system is becoming the de facto standard that others converge on:
- `tidyllm`'s `parse_field()` explicitly detects and delegates to ellmer types
- `tidyprompt`'s `answer_as_json()` accepts ellmer types as first-class input
- `tidyllm` README explicitly positions ellmer as the canonical structured-extraction package

The open question is whether `wizrd`'s "R objects as schema" approach — which has a cleaner R-idiomatic feel and is authored by an S7 core author — will influence how the ecosystem evolves, particularly if it reaches CRAN.

---

## References

| Resource | URL |
|---|---|
| S7 CRAN page | <https://cran.r-project.org/package=S7> |
| ellmer structured data article | <https://ellmer.tidyverse.org/articles/structured-data.html> |
| ellmer type reference | <https://ellmer.tidyverse.org/reference/type_boolean.html> |
| tidyllm schema source | <https://github.com/edubruell/tidyllm/blob/main/R/tidyllm_schema.R> |
| tidyllm structured output article | <https://edubruell.github.io/tidyllm/articles/tidyllm-pdfquestions.html> |
| fr package | <https://github.com/cole-brokamp/fr> |
| Frictionless Table Schema spec | <https://specs.frictionlessdata.io/table-schema/> |
| tidyprompt answer_as_json | <https://kennispunttwente.github.io/tidyprompt/reference/answer_as_json.html> |
| wizrd vignette | <https://lawremi.github.io/wizrd/articles/wizrd.html> |
| wizrd reference | <https://lawremi.github.io/wizrd/reference/index.html> |
| cranlogs API | <https://cranlogs.r-pkg.org/> |
