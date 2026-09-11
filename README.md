# pixel8-omniroute-lite

Cloud-hosted **OmniRoute** (free providers + OpenRouter `:free` last) with the Pixel as a client.

Repo: https://github.com/Gtownrter77/pixel8-omniroute-lite

OmniRoute is a long-running Node + SQLite process. Do **not** put it on Vercel.

## Recommended free-ish hosts

| Host | Always on? | RAM | Notes |
|---|---|---|---|
| Oracle Cloud Always Free ARM VM | Yes | Enough if you cap heap | Best $0 option. Signup is the hard part. https://www.oracle.com/cloud/free/ |
| Render free web service | No — sleeps ~15 min | 512 MB | OK for light chat. Cold start. https://render.com/ |
| Railway template | Until credit runs out | Better | Official image template. Not forever free. https://railway.com/deploy/omniroute--omni-route |

Official OmniRoute Docker: https://github.com/diegosouzapw/OmniRoute
Termux (phone-only fallback): https://github.com/diegosouzapw/OmniRoute/wiki/Termux-Guide

## Cloud stack (what runs in the VM/container)

- OmniRoute official image, port **20128**
- Heap cap: `OMNIROUTE_MEMORY_MB=512` (lite). Raise only if the host has RAM.
- Memory embeddings off (default)
- Free providers in dashboard: OpenCode Free, Pollinations, Qwen, Qoder, Kiro, LongCat, Cloudflare AI
- Optional free keys: Groq, Cerebras, NVIDIA NIM, Gemini
- OpenRouter `:free` last (50 req/day if you never bought $10 credits)

OpenRouter limits: https://openrouter.ai/docs/api-reference/limits
Free provider list: https://github.com/diegosouzapw/OmniRoute/wiki/Free-Tiers-Guide

## 1. Deploy (pick one)

### A. Oracle Always Free (best $0 always-on)

1. Create an ARM Ampere VM (2–4 OCPU, 8–12 GB if the quota allows).
2. Open ingress **TCP 20128** (or 443 behind Caddy).
3. SSH in and run:

```bash
curl -fsSL https://raw.githubusercontent.com/Gtownrter77/pixel8-omniroute-lite/main/cloud/oracle-bootstrap.sh | bash
```

Set `INITIAL_PASSWORD` before first start. Default in the script is only a placeholder.

### B. Render

Use `render.yaml` in this repo. Expect sleep + 512 MB. Lite chat only.

### C. Railway one-click

https://railway.com/deploy/omniroute--omni-route

Attach a volume at `/app/data` or keys vanish on redeploy.

## 2. Lock it down

On first boot OmniRoute may use dashboard password `CHANGEME` unless `INITIAL_PASSWORD` is set.

Then:

1. Open `http://YOUR_HOST:20128`
2. Change the password
3. Enable API keys
4. Providers → connect Layer A (no-key) then Layer B keys
5. Do not add paid OpenRouter models if you want $0

## 3. Point OpenCode at the cloud

On the Pixel (Termux community OpenCode build) or any laptop:

```bash
export OPENAI_BASE_URL="https://YOUR_HOST/v1"   # or http://IP:20128/v1
export OPENAI_API_KEY="your-omniroute-key"
```

Or copy `client/opencode.json.example` to `~/.config/opencode/opencode.json`.

Model: `auto/cheap` or `auto/offline`.

OmniRoute ↔ OpenCode: https://github.com/diegosouzapw/OmniRoute/blob/main/docs/frameworks/OPENCODE.md

## 4. What you get

- Phone does **not** run the gateway (saves 8 GB RAM / battery)
- Failover across free providers
- OpenRouter `:free` is one shared 50/day bucket, not 50 per model
- Render will feel dead until the first request wakes it
- Oracle is the only common $0 host that stays warm

## Files

- `cloud/docker-compose.yml` — lite compose
- `cloud/oracle-bootstrap.sh` — Docker install + compose up
- `render.yaml` — Render blueprint
- `client/opencode.json.example` — OpenCode provider block
