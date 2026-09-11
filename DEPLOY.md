# Deploy (you must click — Grok cannot log into Railway/Oracle)

## Fastest: Railway template

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/omniroute--omni-route)

1. Open that link while logged into Railway.
2. Deploy. Confirm volume `/app/data`.
3. Variables: copy `INITIAL_PASSWORD`.
4. Open the Railway public domain.
5. Login → Providers → connect OpenCode Free, Pollinations, Qwen, Qoder, Kiro.
6. Create an API key.
7. Point OpenCode at `https://YOUR_RAILWAY_DOMAIN/v1`.

Template: https://railway.com/deploy/omniroute--omni-route

Railway is **trial credit**, not forever $0.

## $0 always-on: Oracle

https://www.oracle.com/cloud/free/

After the ARM VM exists, SSH:

```bash
curl -fsSL https://raw.githubusercontent.com/Gtownrter77/pixel8-omniroute-lite/main/cloud/oracle-bootstrap.sh | bash
```

Open TCP 20128.

## After you have a URL

Paste the URL back in this chat. I will write the exact OpenCode config.
