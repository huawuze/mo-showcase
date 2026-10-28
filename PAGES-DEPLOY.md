# 发布到 Cloudflare Pages（去回源版）

> 为什么：现在 `mo.moask.cc` 走 Cloudflare Tunnel，隧道落地在**洛杉矶**（`location=lax08/lax09/lax12/lax13`），链路是「北京 → 洛杉矶 → 北京」，所以首访 1.0–1.5s、偶发 40s+。
> Pages 把**静态文件直接放在边缘**，不再回北京源站，只剩「客户端 → 边缘」一跳。

---

## 一次性准备（约 10 分钟，只需做一次）

### 1. 建 Pages 项目（二选一）

**A. 网页拖拽（最省事）**
1. Cloudflare Dashboard → **Workers & Pages** → **Create** → **Pages** → **Upload assets**
2. 项目名：`mo-showcase`
3. 把 `bash deploy-pages.sh --build-only` 生成的 `pages-dist/` 整个目录拖进去 → Deploy

**B. 命令行（以后每次一键）**
```bash
npm i -g wrangler
wrangler login          # 浏览器授权一次
wrangler pages project create mo-showcase --production-branch=main
```

### 2. 绑定自定义域名（保持品牌）

Pages 项目 → **Custom domains** → **Set up a custom domain** → 填：

```
showcase.moask.cc
```

CF 会自动在你的 DNS 里加 CNAME（`showcase` → `mo-showcase.pages.dev`）。
> 如果提示记录冲突，先把 `showcase` 已有的记录删掉再加。

### 3. 建 API Token（走命令行才需要）

My Profile → **API Tokens** → **Create Token** → 自定义模板 → 权限：
- **Account · Cloudflare Pages · Edit**

存到环境变量（不要提交）：
```bash
setx CLOUDFLARE_API_TOKEN "你的token"
```

---

## 每次发布

```bash
cd C:/Projects/Claude/mo-showcase
bash deploy-pages.sh            # 生成 dist + 上传
```

只生成不上传：
```bash
bash deploy-pages.sh --build-only
```

---

## 验证

```bash
curl -s -o /dev/null -w "%{http_code} %{time_total}s\n" https://showcase.moask.cc/
curl -s -o /dev/null -w "%{http_code} %{time_total}s\n" https://mo.moask.cc/showcase
```

**预期**：Pages 入口 ≈ 0.3–0.6s（单跳），Tunnel 入口仍 1.0–1.5s。两条都保留，谁快用谁。

内容核验：
```bash
curl -s https://showcase.moask.cc/ | grep -c 'v3.8'    # ≥1
```

---

## 回滚

```bash
wrangler pages deployment list --project-name=mo-showcase
wrangler pages deployment rollback <deployment-id> --project-name=mo-showcase
```
或直接在 Pages 后台把某个历史部署设为 Production。

---

## 边界

- Pages 只托管**静态文件**（index.html / data.json / favicon.svg / logos）；PWA 的 WebSocket 仍走 `mo.moask.cc` 隧道，**不受影响**。
- `index.html` 里的数据是构建时内联的（`inject-inline`），改数据要重新 `deploy-pages.sh`。
- 自定义域在 CF 后台，Mo 无账号权限；绑定那一步需要不凝操作。
