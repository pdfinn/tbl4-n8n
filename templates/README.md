# n8n workflow templates

Reusable starting points. Import from inside n8n: **Workflows → top-right menu → Import from File**.

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
