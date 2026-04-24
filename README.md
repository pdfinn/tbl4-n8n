<p align="center">
  <h1 align="center">Tarkas Brainlab IV — n8n</h1>
</p>

<p align="center">
  Run n8n locally to build and automate workflows with a visual editor.<br>
  Connect it to your local Ollama LLM for AI-powered automations.
</p>

---

## What you get

- **[n8n](https://n8n.io)** — a visual workflow automation tool at `http://localhost:5678`
- Pre-configured to connect to your **local Ollama** instance for AI workflows

## Prerequisites

You should have already completed the **tbl4-local-llm** setup, which gives you:

- **Docker Desktop** — running and ready
- **Ollama** — running locally with a model pulled

If you haven't done that yet, go to [tbl4-local-llm](https://github.com/pdfinn/tbl4-local-llm) first.

## Setup

1. [Download the repository as a ZIP](https://github.com/pdfinn/tbl4-n8n/archive/refs/heads/main.zip) and unzip it anywhere (e.g. your Desktop).
2. Open the unzipped folder and double-click the file for your operating system:
   - **Windows:** `setup_windows.bat`
   - **macOS:** `setup_macos.command`

A window opens and walks you through the install. Leave it open until it finishes.

> **macOS first run:** Gatekeeper may block the file. Right-click `setup_macos.command` → **Open** → **Open** to approve it once.

<details>
<summary>Prefer the command line?</summary>

```bash
git clone https://github.com/pdfinn/tbl4-n8n.git
cd tbl4-n8n
./setup_macos.command       # macOS
.\setup_windows.bat         # Windows
```

</details>

## First launch

After setup, open your browser to:

**http://localhost:5678**

You will be asked to **create an owner account**. Pick any email and password you like — this is entirely local and never leaves your machine.

## Using Ollama in n8n

The Ollama credential is **already set up for you**. When you add an Ollama Chat Model or Embeddings node to a workflow, pick **Ollama (local)** from the credential dropdown — it points at your local Ollama on `http://host.docker.internal:11434`.

Make sure Ollama itself is running (from the [tbl4-local-llm](https://github.com/pdfinn/tbl4-local-llm) setup) before you try to execute a workflow that uses it.

## What gets seeded on first run

When the container starts for the first time (empty n8n volume), a one-shot `n8n-init` job runs before n8n itself and pre-populates:

- The **Ollama (local)** credential (pointing at `host.docker.internal:11434`).
- The **TBL4 Tool Server** workflow — publishes an OpenAPI spec at `GET /webhook/openapi.json` so OpenWebUI can list the classroom tools.
- The **Summarise URL** workflow — the first reference tool; answers `POST /webhook/summarise-url` with an Ollama-generated summary of any fetched page.

Both workflows are **imported and activated** automatically. You land on a working chain. Open them in the editor to see the sticky notes explaining the pattern.

A `.tbl4-seeded` sentinel file in the n8n data volume makes the seed a one-shot — re-running the setup script is safe and won't clobber edits you've made.

## Shared folders and templates

- **`./notes/`** — bind-mounted into the n8n container at `/data/notes`. Workflows that write Markdown files (e.g. the "save this as a note" pattern) land here, where you can open them in Finder / Explorer immediately.
- **`./templates/`** — source JSONs for the workflows described above, plus extra patterns to import by hand:
  - `tool-server.workflow.json` — the central OpenAPI spec. Auto-imported on first run.
  - `summarise-url.workflow.json` — reference tool implementation. Auto-imported on first run.
  - `dual-trigger.workflow.json` — one workflow, two entry points (Webhook + MCP Server Trigger), shared downstream logic. Pattern for exposing the same capability to OpenWebUI via either a plain HTTP tool or MCP. **Not** auto-imported; import manually when you reach Ex 12.

## Using it next time

Just run the setup again — it is idempotent and will bring n8n back up for you.

- **Windows:** double-click `setup_windows.bat`.
- **macOS:** double-click `setup_macos.command`.

Then open **http://localhost:5678**.

To fully stop n8n (e.g., to free memory), quit Docker Desktop. Next session, re-run the setup.

<details>
<summary>Advanced: start/stop from the command line</summary>

```bash
# Stop
docker compose down

# Start again
docker compose up -d
```

</details>

## Configuration

If port 5678 is already in use on your machine, edit the `.env` file and change `N8N_PORT` to another number (e.g., `5679`), then re-run the setup script.

## Uninstalling

When you're done with the course and want to reclaim disk space, run the teardown script. It asks for confirmation before each step.

Double-click the file for your operating system:

- **Windows:** `teardown_windows.bat`
- **macOS:** `teardown_macos.command`

## Troubleshooting

| Problem | Fix |
|---------|-----|
| "Docker is not running" | Open Docker Desktop and wait for it to finish starting |
| n8n shows a blank page | Wait a minute on first launch — it initialises internal components |
| Port 5678 is already in use | Edit `.env` and change `N8N_PORT` to another number (e.g., `5679`) |
| Ollama node says "connection refused" | Make sure Ollama is running: `ollama serve` |
| Ollama node can't find models | Check the base URL is `http://host.docker.internal:11434` (not `localhost`) |
| Windows: setup window flashes and closes | Right-click `setup_windows.bat` → **Run as administrator**, or run it from an already-open PowerShell/Command Prompt so you can read any error |
| Windows: window opens but body is transparent (only title bar + drop shadow visible) | This is a Windows 11 Terminal rendering bug. Close the ghost window and double-click `setup_windows.bat` again — the script force-launches a classic console window that should render correctly |
| macOS: "cannot be opened because it is from an unidentified developer" | Right-click `setup_macos.command` → **Open** → **Open**. You only need to do this once. |

---

## License

Copyright (c) 2026 Tarkas Brainlab IV (TBL4).

Licensed under the [PolyForm Noncommercial License 1.0.0](./LICENSE).
You may use, modify, and redistribute this software for any noncommercial
purpose, including personal study, research, teaching, and use by
educational or other noncommercial organizations. Commercial use requires
a separate license from the copyright holder.

For commercial licensing inquiries, please [open an issue on this repository](https://github.com/pdfinn/tbl4-n8n/issues/new).

---

<p align="center">
  <a href="https://github.com/Tarkas-Brainlab-IV">Tarkas Brainlab IV</a>
</p>
