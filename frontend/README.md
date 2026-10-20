# NearField Commerce Web Client

English | [简体中文](README.zh-CN.md)

The browser client for the NearField Commerce Platform. It is part of the monorepo and lives next to the Spring Boot backend under `local-commerce-service/`.

## Overview

This is a mobile-oriented static multi-page application for local lifestyle discovery. It provides merchant browsing, merchant details, vouchers and flash sales, review publishing, social following, and user profile pages.

The frontend does not use a package manager or bundler. Vue, Element UI, and Axios are vendored into `js/` and the application is served directly by Nginx.

## Technology Stack

| Area | Technology | Notes |
| --- | --- | --- |
| Markup | HTML5 | One HTML document per major page |
| Styling | CSS3 | Shared styles, page styles, and custom theme layers |
| UI framework | Vue 2 | Loaded from `js/vue.js` |
| Component library | Element UI 2.15.3 | Loaded from `js/element.js` |
| HTTP client | Axios | Loaded from `js/axios.min.js` |
| Static server | Nginx | Serves the site and proxies `/api` to the backend |
| Build system | None | No `package.json`, npm install, or bundling step |

## Pages

| Page | Purpose |
| --- | --- |
| `index.html` | Home page with featured reviews, category entry points, infinite review loading, and likes |
| `shop-list.html` | Merchant list filtered by category, with client-side sorting and infinite scrolling |
| `shop-detail.html` | Merchant profile, voucher list, and flash-sale purchase action |
| `blog-detail.html` | Review detail, author information, likes, and follow/unfollow actions |
| `blog-edit.html` | Review publishing form with merchant search, image upload, and submission |
| `login.html` | Phone-number and verification-code login |
| `login2.html` | Alternate login page with a password field |
| `info.html` | Current-user profile, own reviews, following feed, and logout action |
| `info-edit.html` | Profile editing view using cached user information |
| `other-info.html` | Another user's profile, reviews, follow status, and common follows |

## API Integration

The API configuration is defined in `js/common.js`:

```javascript
let commonURL = "/api";
axios.defaults.baseURL = commonURL;
```

The frontend expects Nginx to expose the backend under `/api`:

- `/api/shop/**` is rewritten to `/shop/**` on the backend.
- `/api/blog/**` is rewritten to `/blog/**` on the backend.
- `/api/user/**`, `/api/follow/**`, `/api/voucher/**`, and other API groups follow the same rule.

Authentication behavior:

- The login response token is stored in `sessionStorage` under `token`.
- Axios sends the token through the `authorization` header.
- A `401` response removes the user context and redirects to `/login.html`.
- The frontend unwraps the common `success`, `errorMsg`, and `data` response envelope in an Axios response interceptor.

## Directory Layout

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
|-- css/                 # page styles, Element UI styles, and custom themes
|-- imgs/                # merchant, review, icon, and category images
|-- js/
|   |-- common.js        # Axios configuration and shared utilities
|   |-- footer.js        # shared bottom navigation component
|   |-- vue.js           # vendored Vue 2
|   |-- element.js       # vendored Element UI
|   `-- axios.min.js     # vendored Axios
`-- .gitignore
```

## Local Development

There is no build command. Serve this directory through Nginx so the `/api` proxy works.

Example `nginx.conf`:

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

Open `http://localhost:8080` after starting Nginx and the backend.

If the backend is deployed with multiple instances, replace `proxy_pass` with an `upstream` block, as in the original local Nginx configuration.

## Configuration

- API base path: `js/common.js`, currently `/api`.
- Request timeout: `2000` ms in `js/common.js`.
- Login token storage key: `sessionStorage.token`.
- Cached user profile: `sessionStorage.userInfo`.
- Static theme entry points: `css/theme.css` and `css/theme-v2.css`.

## Current Limitations

- The frontend has no npm package manifest, module bundler, lint configuration, or automated UI tests.
- The API base path is hard-coded in `js/common.js`.
- `login2.html` is an alternate or legacy login page and duplicates part of the `login.html` flow.
- The current merchant list sends category and pagination parameters but does not request browser geolocation, even though the backend supports coordinate-based nearby search.
- The logout endpoint on the backend is still a placeholder.
- Review comments have database support on the backend but no implemented frontend workflow.
- The site relies on Nginx or another reverse proxy for the `/api` path. Opening `index.html` directly from the filesystem will not connect to the backend.

## Related Documentation

- [Root project README](../README.md)
- [Backend source](../local-commerce-service/)
