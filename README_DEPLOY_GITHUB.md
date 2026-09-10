# GitHub + Render quick deployment

```bash
git init
git add .
git commit -m "Add RTX WireMock sandbox"
git branch -M main
git remote add origin https://github.com/<YOUR-USER>/<YOUR-REPO>.git
git push -u origin main
```

In Render:

1. New -> Web Service.
2. Select the GitHub repository.
3. Runtime = Docker.
4. Plan = Free.
5. Create Web Service.

After deployment, test:

```bash
curl -sS -X POST 'https://<your-service>.onrender.com/api/gateway?api=phone_search' \
  -H 'Content-Type: application/json' \
  -d '{"phone":"2222222222","tenant-id":"test","limit":5}'
```
