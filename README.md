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

To use your local LLM in workflows:

1. In n8n, go to **Settings > Credentials > Add Credential**
2. Search for **Ollama**
3. Set the base URL to: `http://host.docker.internal:11434`
4. Save the credential
5. Now you can use the **Ollama Chat Model** and **Ollama Embeddings** nodes in your workflows

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
| macOS: "cannot be opened because it is from an unidentified developer" | Right-click `setup_macos.command` → **Open** → **Open**. You only need to do this once. |

---

<p align="center">
  <a href="https://github.com/Tarkas-Brainlab-IV">Tarkas Brainlab IV</a>
</p>
