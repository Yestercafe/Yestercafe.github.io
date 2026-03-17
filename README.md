# Yester Vault（Hugo）

个人博客与 Wiki，由 [Hugo](https://gohugo.io/) 构建，版式基于原 Jekyll **Tale** 主题。

## 本地预览

需安装 **Hugo Extended**（与 CI 一致推荐 `0.139.x`，以支持 SCSS）：

```bash
hugo server -D
```

浏览器访问 <http://localhost:1313/>。

## 发布（GitHub Pages）

1. 仓库 **Settings → Pages**：**Build and deployment** 的 Source 选 **GitHub Actions**。
2. 推送到 `main` 或 `master` 分支后，工作流 [.github/workflows/hugo.yml](.github/workflows/hugo.yml) 会执行 `hugo --minify` 并将 `public/` 部署到 Pages。

## 目录说明

| 路径 | 说明 |
|------|------|
| `content/posts/` | 博文（文件名 `YYYY-MM-DD-slug.md`，front matter 含 `date`、`slug` 以匹配旧站 URL） |
| `content/wiki/` | Wiki 条目（`slug` 与文件名一致，对应 `/wiki/<slug>/`） |
| `layouts/` | 模板（含 Tale 风格布局、`search.json` 输出） |
| `assets/scss/` | 样式（Tale SCSS） |
| `static/assets/` | 静态资源（JS、图标等） |

## 关于页 GitHub 仓库列表

构建时会请求 `api.github.com`（无 Token 有速率限制）。若列表为空，可稍后重试构建或在 Actions 中配置 `GITHUB_TOKEN` 调用 API（需自行改 workflow）。

## RSS

订阅地址：`/index.xml`（原 Jekyll `feed.xml` 已改为 Hugo 默认 RSS 路径）。
