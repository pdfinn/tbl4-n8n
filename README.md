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

### macOS

Open **Terminal** and run:

```bash
git clone https://github.com/pdfinn/tbl4-n8n.git
cd tbl4-n8n
chmod +x setup.sh
./setup.sh
```

### Windows

Open **PowerShell** and run:

```powershell
git clone https://github.com/pdfinn/tbl4-n8n.git
cd tbl4-n8n
.\setup.ps1
```

> If you get a script execution error, run this first:
> `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`

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

## Starting and stopping

**Stop n8n:**
```bash
docker compose down
```

**Start again later:**
```bash
docker compose up -d
```
Then open http://localhost:5678.

## Configuration

If port 5678 is already in use on your machine, edit the `.env` file and change `N8N_PORT` to another number (e.g., `5679`), then re-run the setup script.

## Uninstalling

When you're done with the course and want to reclaim disk space, run the teardown script. It asks for confirmation before each step.

**macOS:**
```bash
chmod +x teardown.sh
./teardown.sh
```

**Windows:**
```powershell
.\teardown.ps1
```

## Troubleshooting

| Problem | Fix |
|---------|-----|
| "Docker is not running" | Open Docker Desktop and wait for it to finish starting |
| n8n shows a blank page | Wait a minute on first launch — it initialises internal components |
| Port 5678 is already in use | Edit `.env` and change `N8N_PORT` to another number (e.g., `5679`) |
| Ollama node says "connection refused" | Make sure Ollama is running: `ollama serve` |
| Ollama node can't find models | Check the base URL is `http://host.docker.internal:11434` (not `localhost`) |
| Windows script won't run | Run: `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` |

---

<p align="center">
  <a href="https://github.com/Tarkas-Brainlab-IV">Tarkas Brainlab IV</a>
</p>
