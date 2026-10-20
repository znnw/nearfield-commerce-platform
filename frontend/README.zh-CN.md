# 近场消费 Web 前端

[English](README.md) | 简体中文

这是近场消费服务平台的浏览器端。前端与 Spring Boot 后端一起放在同一个 monorepo 中，后端位于 `local-commerce-service/`。

## 项目简介

这是一个面向移动端展示的本地生活静态多页应用，提供商户浏览、商户详情、优惠券与秒杀、探店笔记发布、用户关注和个人中心等页面。

前端不使用 npm 包管理器或打包器。Vue、Element UI 和 Axios 已作为静态依赖放入 `js/`，页面由 Nginx 直接托管。

## 技术栈

| 领域 | 技术 | 说明 |
| --- | --- | --- |
| 页面结构 | HTML5 | 每个主要页面使用独立 HTML 文档 |
| 样式 | CSS3 | 公共样式、页面样式和定制主题 |
| 前端框架 | Vue 2 | 从 `js/vue.js` 加载 |
| UI 组件库 | Element UI 2.15.3 | 从 `js/element.js` 加载 |
| HTTP 客户端 | Axios | 从 `js/axios.min.js` 加载 |
| 静态服务器 | Nginx | 托管前端并将 `/api` 代理到后端 |
| 构建系统 | 无 | 没有 `package.json`、npm install 或打包步骤 |

## 页面说明

| 页面 | 功能 |
| --- | --- |
| `index.html` | 首页，包含热门探店轮播、分类入口、笔记滚动加载和点赞 |
| `shop-list.html` | 按商户分类展示列表，支持前端排序和滚动加载 |
| `shop-detail.html` | 商户详情、优惠券列表和秒杀下单入口 |
| `blog-detail.html` | 探店笔记详情、作者信息、点赞和关注操作 |
| `blog-edit.html` | 探店笔记发布，包含商户搜索、图片上传和提交 |
| `login.html` | 手机号和验证码登录 |
| `login2.html` | 带密码字段的备用登录页 |
| `info.html` | 当前用户资料、我的笔记、关注流和退出登录 |
| `info-edit.html` | 使用缓存用户信息展示资料编辑页面 |
| `other-info.html` | 其他用户资料、笔记、关注状态和共同关注 |

## API 接入

API 配置位于 `js/common.js`：

```javascript
let commonURL = "/api";
axios.defaults.baseURL = commonURL;
```

前端要求 Nginx 将后端统一暴露在 `/api` 路径下：

- `/api/shop/**` 重写为后端的 `/shop/**`。
- `/api/blog/**` 重写为后端的 `/blog/**`。
- `/api/user/**`、`/api/follow/**`、`/api/voucher/**` 等接口使用相同规则。

鉴权行为：

- 登录成功后，Token 保存在 `sessionStorage` 的 `token` 中。
- Axios 请求拦截器通过 `authorization` 请求头携带 Token。
- 后端返回 `401` 时，前端清理用户状态并跳转到 `/login.html`。
- Axios 响应拦截器统一处理后端 `success`、`errorMsg` 和 `data` 响应结构。

## 目录结构

```text
frontend/
|-- index.html
|-- shop-list.html
|-- shop-detail.html
|-- blog-detail.html
|-- blog-edit.html
|-- login.html
|-- login2.html
|-- info.html
|-- info-edit.html
|-- other-info.html
|-- css/                 # 页面样式、Element UI 样式和主题
|-- imgs/                # 商户、笔记、图标和分类图片
|-- js/
|   |-- common.js        # Axios 配置和公共工具
|   |-- footer.js        # 公共底部导航组件
|   |-- vue.js           # 本地 Vue 2
|   |-- element.js       # 本地 Element UI
|   `-- axios.min.js     # 本地 Axios
`-- .gitignore
```

## 本地运行

前端没有构建命令。推荐通过 Nginx 托管该目录，以便 `/api` 代理正常工作。

`nginx.conf` 示例：

```nginx
server {
    listen 8080;
    server_name localhost;

    location / {
        root C:/path/to/nearfield-commerce-platform/frontend;
        index index.html;
        try_files $uri $uri/ =404;
        add_header Cache-Control "no-store, no-cache, must-revalidate";
    }

    location /api {
        rewrite ^/api(/.*)$ $1 break;
        proxy_pass http://127.0.0.1:8081;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

启动 Nginx 和后端后，访问 `http://localhost:8080`。

如果后端部署多个实例，可以将 `proxy_pass` 改为 `upstream` 配置，原本地 Nginx 配置已经使用这种形式。

## 配置说明

- API 基础路径：`js/common.js`，当前为 `/api`。
- 请求超时时间：`js/common.js` 中配置为 `2000` ms。
- 登录 Token 存储位置：`sessionStorage.token`。
- 用户资料缓存位置：`sessionStorage.userInfo`。
- 静态主题入口：`css/theme.css` 和 `css/theme-v2.css`。

## 当前限制

- 前端没有 npm 依赖清单、模块打包器、代码检查配置或自动化 UI 测试。
- API 基础路径目前写死在 `js/common.js`。
- `login2.html` 是备用或历史登录页面，与 `login.html` 的流程存在重复。
- 当前商户列表只发送分类和分页参数，没有申请浏览器定位；后端虽然支持经纬度附近搜索，但前端暂时没有接入。
- 后端的退出登录接口仍然是占位实现。
- 后端具备评论表结构，但前端还没有评论流程。
- 页面依赖 Nginx 或其他反向代理提供 `/api`。直接通过文件系统打开 `index.html` 无法连接后端。

## 相关文档

- [项目根 README](../README.zh-CN.md)
- [后端代码目录](../local-commerce-service/)
