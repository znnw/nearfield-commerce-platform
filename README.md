# 近场消费服务

这是一个本地生活服务全栈项目。当前仓库先纳入 Spring Boot 后端，前端代码放入根目录的 `frontend/` 后即可与后端在同一个仓库中管理。

## 目录结构

```text
.
├── local-commerce-service/   # Spring Boot 后端
├── frontend/                 # 前端代码（放入后创建）
└── README.md
```

建议统一使用一个 GitHub 仓库管理前后端，部署和联调时版本更容易对应。

## 后端环境

- JDK 8
- Maven 3.6+
- MySQL 5.7+
- Redis 5+

后端默认端口为 `8081`。数据库和 Redis 配置通过环境变量传入，仓库中不保存密码。

| 环境变量 | 默认值 | 说明 |
| --- | --- | --- |
| `SERVER_PORT` | `8081` | 后端端口 |
| `MYSQL_URL` | `jdbc:mysql://127.0.0.1:3306/local_commerce?useSSL=false&serverTimezone=UTC` | MySQL 地址 |
| `MYSQL_USERNAME` | `root` | MySQL 用户名 |
| `MYSQL_PASSWORD` | 空 | MySQL 密码 |
| `REDIS_HOST` | `127.0.0.1` | Redis 地址 |
| `REDIS_PORT` | `6379` | Redis 端口 |
| `REDIS_PASSWORD` | 空 | Redis 密码 |

PowerShell 中临时设置并启动：

```powershell
$env:MYSQL_PASSWORD = "你的本地数据库密码"
$env:REDIS_PASSWORD = "你的本地 Redis 密码"
Set-Location .\local-commerce-service
mvn spring-boot:run
```

首次运行时，按顺序导入 `local-commerce-service/src/main/resources/db/` 下的建库脚本和种子脚本。

## 加入前端

将前端项目源码复制到根目录的 `frontend/`（不要复制 `node_modules`、`dist` 等构建产物），然后提交：

```powershell
git add frontend
git commit -m "feat: add frontend"
git push
```

前端代码中的后端地址应通过环境变量或构建配置区分本地与线上环境，不要把服务器密码、私钥、访问令牌或云服务密钥提交到仓库。
