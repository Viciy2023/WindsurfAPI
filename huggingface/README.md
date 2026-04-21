---
title: WindsurfAPI
emoji: "🌊"
colorFrom: indigo
colorTo: blue
sdk: docker
pinned: false
---

# WindsurfAPI on Hugging Face Spaces

这个 Space 运行的是 `WindsurfAPI` 的 Docker 版本。

## 运行说明

1. 镜像构建时会下载官方 Linux x64 `tar.gz` 安装包，并自动提取 `language_server_linux_x64`
2. 运行时从 Hugging Face Space Secrets / Variables 生成 `.env`
3. 持久化文件保存在挂载桶的 `/data/windsurf/state/`
4. 外部服务端口固定为 `7860`

## HF Space 最终填写清单

| 名称 | 位置 | 是否必填 | 说明 |
|---|---|---|---|
| `API_KEY` | Secret | 必填 | 对外 API 的访问密钥 |
| `CODEIUM_API_KEY` | Secret | 可选预置 | Windsurf / Codeium API Key；不填也可启动 |
| `CODEIUM_AUTH_TOKEN` | Secret | 可选预置 | `windsurf.com/show-auth-token` 获取的 token；不填也可启动 |
| `DEFAULT_MODEL` | Variable 或 Secret | 推荐 | 默认模型，不填走 `claude-4.5-sonnet-thinking` |
| `MAX_TOKENS` | Variable 或 Secret | 推荐 | 默认最大输出 token，不填走 `8192` |
| `LOG_LEVEL` | Variable 或 Secret | 推荐 | 日志级别，不填走 `info` |
| `DASHBOARD_PASSWORD` | Secret | 推荐 | Dashboard 访问密码 |
| `LS_PORT` | Variable 或 Secret | 可选 | LS gRPC 端口，不填走 `42100` |
| `CODEIUM_API_URL` | Variable 或 Secret | 可选 | 上游接口地址，不填走官方默认值 |

如果没有预先填写 `CODEIUM_API_KEY` 或 `CODEIUM_AUTH_TOKEN`，服务仍然可以启动，之后可以通过以下方式添加账号：

1. Dashboard 一键登录
2. Token 登录
3. 批量导入

## 不要在 HF Space 里填写这些

- `PORT`：启动时会强制写成 `7860`
- `LS_BINARY_PATH`：启动时会强制写成 `/opt/windsurf/language_server_linux_x64`
- `HF_TOKEN`：这是 GitHub Actions 推送 Space 仓库用的，不是运行时变量
- `HF_SPACE_REPO`：这是 GitHub Actions 发布目标，不是运行时变量
- `HF_LS_DOWNLOAD_URL`：这是 GitHub Actions 构建发布包时替换 `Dockerfile` 用的，值应为官方 Linux x64 `tar.gz` 下载链接，不是运行时变量

## 持久化文件

- `/data/windsurf/state/.env`
- `/data/windsurf/state/accounts.json`
- `/data/windsurf/state/proxy.json`
- `/data/windsurf/state/model-access.json`
- `/data/windsurf/state/runtime-config.json`

## 部署来源

这个 Space 仓库由 GitHub Actions 从主仓库的 `huggingface/` 发布目录自动同步生成。
