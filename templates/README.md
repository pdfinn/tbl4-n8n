# n8n workflow templates

Reusable starting points. Import from inside n8n: **Workflows → top-right menu → Import from File**.

## `tool-server.workflow.json`

**The one-time setup that makes every exercise's webhook callable from OpenWebUI.**

OpenWebUI's Tool Servers feature doesn't talk directly to webhooks — it talks to an **OpenAPI 3.x spec**. This workflow publishes that spec over a GET webhook. Register it once in OpenWebUI; then, as students complete each exercise, they append a new path to the spec inside this workflow and the new tool appears automatically.

### Setup (do this first)

1. Import this workflow into n8n. **Publish** it (newer n8n) or toggle it Active (older n8n).
2. In OpenWebUI → **Admin Settings → Tools → Tool Servers → Add Tool Server**:
   - URL: `http://host.docker.internal:5678/webhook`
   - (OpenWebUI will append `/openapi.json` automatically, and uses that same base URL to call tools. Spec paths are relative to it — e.g. `/summarise-url`, **not** `/webhook/summarise-url`.)
3. Click *Verify* or save. OpenWebUI fetches the spec and lists the tools.

### To add a new tool later

1. Build the tool's workflow (its Webhook trigger, its logic, its response).
2. Activate that workflow.
3. Open the **OpenAPI Spec** node inside `tool-server.workflow.json`, add a new entry under `paths: { ... }` describing the new endpoint. Copy the `summarise-url` example; edit `operationId`, `summary`, `description`, `requestBody`, `responses`.
4. Save. The spec node now emits the updated spec on the next fetch.
5. In OpenWebUI → Tool Servers → click refresh. The new tool appears.

The `description` field is what the LLM reads to decide *when* to call the tool. Write it as an instruction to the model, not a developer comment.

## `dual-trigger.workflow.json`

## `dual-trigger.workflow.json`

One workflow, two entry points, shared business logic:

```
Webhook Trigger ─┐
                 ├──> Normalise Input ──> Your Business Logic ──> Respond
MCP Server Trigger ─┘   (add from palette)
```

The template ships with the Webhook side wired up and a placeholder for your work. Add the **MCP Server Trigger** node from the n8n palette (search "MCP Server Trigger") and connect it to the `Normalise Input` node — this is deliberately left out of the JSON so you pick up whatever parameter schema your n8n version ships with.

### Why this pattern exists

- **Webhook-only** — simplest, every HTTP client can call it. Good for OpenWebUI's *External Tools* panel with a hand-written OpenAPI spec.
- **MCP-only** — the LLM discovers the tool automatically and sees a typed schema. Good for agent workflows and for reuse across MCP clients (Claude Desktop, Cursor, etc.).
- **Both** — students pick the access pattern based on the task without reinventing the business logic.

### Wiring to OpenWebUI

- **Webhook** — register the full URL (e.g. `http://host.docker.internal:5678/webhook/dual-trigger`) under Admin Settings → External Tools, paired with a minimal OpenAPI spec describing the `prompt` field.
- **MCP** — add an entry to `tbl4-local-llm/mcpo.config.json` pointing at the MCP Server Trigger URL (e.g. `http://host.docker.internal:5678/mcp/<your-path>/sse` with the bearer token n8n generated), then register `http://mcpo:8000/<name>` under External Tools.

Both stacks reach each other over `host.docker.internal` because they live on separate Docker Compose networks.
