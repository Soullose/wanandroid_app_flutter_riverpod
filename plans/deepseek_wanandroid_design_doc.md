# 玩Android 客户端 — 功能实现全景分析与设计文档 (DeepSeek)

> **项目**: wanandroid_app_flutter_riverpod  
> **文档版本**: v1.0  
> **对标 API**: [玩Android 开放API](https://www.wanandroid.com/blog/show/2)  
> **日期**: 2026-06-18

---

## 目录

1. [项目技术栈总览](#1-项目技术栈总览)
2. [API 全景对比表](#2-api-全景对比表)
3. [已完成功能详览](#3-已完成功能详览)
4. [未完成功能清单（按优先级）](#4-未完成功能清单按优先级)
5. [UI 设计规范](#5-ui-设计规范)
6. [功能模块 UI 设计与实现思路](#6-功能模块-ui-设计与实现思路)
   - 6.1 [登录 / 注册](#61-登录--注册)
   - 6.2 [搜索](#62-搜索)
   - 6.3 [体系（知识树）](#63-体系知识树)
   - 6.4 [项目](#64-项目)
   - 6.5 [公众号](#65-公众号)
   - 6.6 [问答（完整实现）](#66-问答完整实现)
   - 6.7 [导航（完整实现）](#67-导航完整实现)
   - 6.8 [收藏](#68-收藏)
   - 6.9 [我的 / 个人中心](#69-我的--个人中心)
   - 6.10 [积分系统](#610-积分系统)
   - 6.11 [广场](#611-广场)
   - 6.12 [站内消息](#612-站内消息)
   - 6.13 [教程](#613-教程)
   - 6.14 [最新项目 Tab](#614-最新项目-tab)
   - 6.15 [工具列表](#615-工具列表)
   - 6.16 [鸿蒙专栏](#616-鸿蒙专栏)
   - 6.17 [首页最受欢迎板块](#617-首页最受欢迎板块)
7. [Bottom Navigation 重构方案](#7-bottom-navigation-重构方案)
8. [路由增补计划](#8-路由增补计划)
9. [数据模型复用与新增](#9-数据模型复用与新增)
10. [依赖评估](#10-依赖评估)

---

## 1. 项目技术栈总览

| 层级 | 技术选型 | 版本 |
|------|---------|------|
| **语言** | Dart / Flutter | SDK `^3.8.0` |
| **状态管理** | Riverpod (code-gen) | `flutter_riverpod ^3.0.3` + `riverpod_annotation ^3.0.3` |
| **路由** | go_router (declarative) | `^15.0.0` |
| **网络请求** | Dio | `^5.9.0` |
| **数据序列化** | freezed + json_serializable | `freezed ^3.2.3` + `json_annotation ^4.9.0` |
| **主题** | flex_color_scheme (Material 3) | `^8.3.0` |
| **自适应布局** | flutter_screenutil + 自定义 ResponsiveBuilder | `^5.9.3` |
| **图片缓存** | cached_network_image | `^3.4.1` |
| **WebView** | webview_flutter | `^4.13.0` |
| **本地存储** | shared_preferences | `^2.5.3` |
| **消息提示** | flutter_easyloading / fluttertoast | `^3.0.5` / `^9.1.0` |
| **代码生成** | build_runner + riverpod_generator | `^2.13.1` / `^3.0.3` |
| **原生桥接** | flutter_rust_bridge | `2.12.0` |

### 架构模式

```
lib/
├── common/          # 跨层共享（路由）
├── core/            # 基础设施层
│   ├── constants/   #   API 地址、常量
│   ├── net/         #   Dio 封装、拦截器、ResultData
│   └── services/    #   设备/存储/日志服务
├── features/        # 功能模块（Feature-First）
│   ├── {module}/
│   │   ├── domain/
│   │   │   ├── entities/      # freezed 实体
│   │   │   └── repositories/  # 抽象接口
│   │   ├── infrastructure/
│   │   │   └── repositories/  # Dio 实现
│   │   └── presentation/
│   │       ├── providers/     # Riverpod providers
│   │       ├── screens/       # 页面
│   │       └── widgets/       # 可复用组件
├── model/           # 共享数据模型
├── shared/          # 共享 UI / 工具
```

---

## 2. API 全景对比表

> ✅ = 已实现并集成到 UI  
> 🔶 = ApiAddress 已定义但 UI 未使用  
> 🔴 = 完全未定义  
> ➖ = 无需实现（web 端管理类）

### 2.1 首页

| # | API 端点 | 方法 | 状态 | 说明 |
|---|---------|------|------|------|
| 1.1 | `/article/list/{page}/json` | GET | ✅ | 首页文章列表（含 page_size 参数） |
| 1.2 | `/banner/json` | GET | ✅ | 首页 Banner |
| 1.3 | `/friend/json` | GET | 🔶 | 常用网站（ApiAddress 已定义，无 UI） |
| 1.4 | `//hotkey/json` | GET | 🔶 | 搜索热词（ApiAddress 已定义，无 UI） |
| 1.5 | `/article/top/json` | GET | ✅ | 置顶文章（Repository 已实现） |

### 2.2 体系

| # | API 端点 | 方法 | 状态 | 说明 |
|---|---------|------|------|------|
| 2.1 | `/tree/json` | GET | 🔶 | 体系数据（ApiAddress 已定义，Architecture 模型存在，无 UI） |
| 2.2 | `/article/list/{page}/json?cid=` | GET | 🔴 | 体系下文章列表 |
| 2.3 | `/article/list/{page}/json?author=` | GET | 🔴 | 按作者搜索文章 |

### 2.3 导航

| # | API 端点 | 方法 | 状态 | 说明 |
|---|---------|------|------|------|
| 3.1 | `/navi/json` | GET | 🔶 | 导航数据（ApiAddress 已定义，Navi 模型存在，UI 用硬编码） |

### 2.4 项目

| # | API 端点 | 方法 | 状态 | 说明 |
|---|---------|------|------|------|
| 4.1 | `/project/tree/json` | GET | 🔶 | 项目分类（ApiAddress 已定义，无 UI） |
| 4.2 | `/project/list/{page}/json?cid=` | GET | 🔴 | 项目列表 |

### 2.5 登录与注册

| # | API 端点 | 方法 | 状态 | 说明 |
|---|---------|------|------|------|
| 5.1 | `/user/login` | POST | 🔶 | 登录（ApiAddress 已定义，SignInPage 为存根） |
| 5.2 | `/user/register` | POST | 🔶 | 注册（ApiAddress 已定义，SignUpPage 为存根） |
| 5.3 | `/user/logout/json` | GET | 🔶 | 退出（ApiAddress 已定义，SettingPage 有按钮但无 API 调用） |

### 2.6 收藏

| # | API 端点 | 方法 | 状态 | 说明 |
|---|---------|------|------|------|
| 6.1 | `/lg/collect/list/{page}/json` | GET | 🔶 | 收藏文章列表（ApiAddress 已定义，无 UI） |
| 6.2 | `/lg/collect/{id}/json` | POST | 🔶 | 收藏站内文章（ApiAddress 已定义，无 UI） |
| 6.3 | `/lg/collect/add/json` | POST | 🔴 | 收藏站外文章 |
| — | `/lg/collect/user_article/update/{id}/json` | POST | 🔴 | 编辑收藏文章 |
| 6.4.1 | `/lg/uncollect_originId/{id}/json` | POST | 🔴 | 从列表取消收藏 |
| 6.4.2 | `/lg/uncollect/{id}/json` | POST | 🔴 | 从收藏页取消收藏 |
| 6.5 | `/lg/collect/usertools/json` | GET | 🔴 | 收藏网站列表 |
| 6.6 | `/lg/collect/addtool/json` | POST | 🔴 | 收藏网址 |
| 6.7 | `/lg/collect/updatetool/json` | POST | 🔴 | 编辑收藏网站 |
| 6.8 | `/lg/collect/deletetool/json` | POST | 🔴 | 删除收藏网站 |

### 2.7 搜索

| # | API 端点 | 方法 | 状态 | 说明 |
|---|---------|------|------|------|
| 7.1 | `/article/query/{page}/json` | POST | 🔴 | 搜索文章（k 关键词参数） |

### 2.8 TODO

| # | API 端点 | 方法 | 状态 | 说明 |
|---|---------|------|------|------|
| 8 | TODO v2 | — | 🔴 | 待办工具（官方已推荐 v2，暂不实现） |

### 2.9 积分

| # | API 端点 | 方法 | 状态 | 说明 |
|---|---------|------|------|------|
| — | `/coin/rank/{page}/json` | GET | 🔴 | 积分排行榜 |
| — | `/lg/coin/userinfo/json` | GET | 🔴 | 个人积分信息 |
| — | `/lg/coin/list/{page}/json` | GET | 🔴 | 积分获取列表 |

### 2.10 广场

| # | API 端点 | 方法 | 状态 | 说明 |
|---|---------|------|------|------|
| 10.1 | `/user_article/list/{page}/json` | GET | 🔴 | 广场列表 |
| 10.2 | `/user/{userId}/share_articles/{page}/json` | GET | 🔴 | 分享人文章列表 |
| 10.3 | `/user/lg/private_articles/{page}/json` | GET | 🔴 | 自己的分享文章列表 |
| 10.4 | `/lg/user_article/delete/{id}/json` | POST | 🔴 | 删除分享文章 |
| 10.5 | `/lg/user_article/add/json` | POST | 🔴 | 分享文章 |

### 2.11 问答

| # | API 端点 | 方法 | 状态 | 说明 |
|---|---------|------|------|------|
| 11 | `/wenda/list/{page}/json` | GET | 🔴 | 问答列表（UI 为存根硬编码） |

### 2.12 个人信息

| # | API 端点 | 方法 | 状态 | 说明 |
|---|---------|------|------|------|
| 12 | `/user/lg/userinfo/json` | GET | 🔴 | 用户个人信息 + 积分信息 |

### 2.13 问答评论

| # | API 端点 | 方法 | 状态 | 说明 |
|---|---------|------|------|------|
| 13 | `/wenda/comments/{id}/json` | GET | 🔴 | 问答评论列表 |

### 2.14 站内消息

| # | API 端点 | 方法 | 状态 | 说明 |
|---|---------|------|------|------|
| 14.1 | `/message/lg/count_unread/json` | GET | 🔴 | 未读消息数量 |
| 14.2 | `/message/lg/readed_list/{page}/json` | GET | 🔴 | 已读消息列表 |
| 14.3 | `/message/lg/unread_list/{page}/json` | GET | 🔴 | 未读消息列表 |

### 2.15 公众号

| # | API 端点 | 方法 | 状态 | 说明 |
|---|---------|------|------|------|
| 15.1 | `/wxarticle/chapters/json` | GET | 🔴 | 公众号列表 |
| 15.2 | `/wxarticle/list/{id}/{page}/json` | GET | 🔴 | 公众号历史文章 |
| 15.3 | `/wxarticle/list/{id}/{page}/json?k=` | GET | 🔴 | 公众号内搜索文章 |

### 2.16 最新项目

| # | API 端点 | 方法 | 状态 | 说明 |
|---|---------|------|------|------|
| 16.1 | `/article/listproject/{page}/json` | GET | 🔴 | 最新项目列表（首页第二个 tab） |

### 2.17 工具列表

| # | API 端点 | 方法 | 状态 | 说明 |
|---|---------|------|------|------|
| 17 | `/tools/list/json` | GET | 🔴 | 工具列表 |

### 2.18 教程

| # | API 端点 | 方法 | 状态 | 说明 |
|---|---------|------|------|------|
| 18.1 | `/chapter/547/sublist/json` | GET | 🔴 | 教程列表 |
| 18.2 | `/article/list/{page}/json?cid=&order_type=1` | GET | 🔴 | 教程下文章列表 |

### 2.19 鸿蒙专栏 & 热门板块

| # | API 端点 | 方法 | 状态 | 说明 |
|---|---------|------|------|------|
| — | `/harmony/index/json` | GET | 🔴 | 鸿蒙专栏 |
| — | `/popular/wenda/json` | GET | 🔴 | 最受欢迎问答 |
| — | `/popular/column/json` | GET | 🔴 | 最受欢迎专栏 |
| — | `/popular/route/json` | GET | 🔴 | 最受欢迎路线 |

---

## 3. 已完成功能详览

| 功能模块 | 页面 | API 集成 | 状态详情 |
|---------|------|---------|---------|
| **欢迎页** | `welcome/view.dart` | 无 API | Rive 动画 → 网络检查 → 自动跳转首页 |
| **首页 + 文章列表** | `home/view.dart` | `/article/list/{page}/json` | 无限滚动、骨架屏、置顶文章、下拉刷新、FAB 返回顶部 |
| **Banner** | `banner/` 全套 | `/banner/json` | carousel_slider + cached_network_image |
| **主题切换** | `setting/view.dart` | 本地 | 跟随系统 / 浅色 / 深色 + flex_color_scheme |
| **日志系统** | `logger/` 全套 | 本地 | 文件日志、设备信息、搜索/筛选/删除 |
| **网络错误页** | `network_error/view.dart` | connectivity_plus | 断网检测 + 自动重连 |
| **自适应布局** | `shared/widgets/responsive/` | 无 API | 手机 / 小平板 / 大平板三档布局 |

---

## 4. 未完成功能清单（按优先级）

### P0 — 核心体验（必须完成）

| 功能 | 涉及 API 数 | 当前状态 | 建议工作量 |
|------|-----------|---------|-----------|
| 登录 / 注册 / 退出 | 3 | 存根页面 | 中 |
| 搜索 | 2（热词 + 搜索） | 未实现 | 中 |
| 我的 / 个人中心 | 1（用户信息） | 存根 | 中 |

### P1 — 主要导航 Tab

| 功能 | 涉及 API 数 | 当前状态 | 建议工作量 |
|------|-----------|---------|-----------|
| 体系（知识树） | 2 | 仅定义了地址 | 大 |
| 项目分类 + 列表 | 2 | 仅定义了分类地址 | 中 |
| 问答（完整实现） | 2 | 存根页面 | 中 |
| 导航（完整实现） | 1 | 硬编码页面 | 中 |

### P2 — 延伸功能

| 功能 | 涉及 API 数 | 当前状态 | 建议工作量 |
|------|-----------|---------|-----------|
| 收藏完整流程 | 8 | 仅定义了 2 个地址 | 大 |
| 公众号 | 3 | 未实现 | 中 |
| 积分系统 | 3 | 未实现 | 中 |
| 广场 | 5 | 未实现 | 大 |

### P3 — 增强功能

| 功能 | 涉及 API 数 | 当前状态 | 建议工作量 |
|------|-----------|---------|-----------|
| 最新项目 Tab | 1 | 未实现 | 小 |
| 教程 | 2 | 未实现 | 中 |
| 站内消息 | 3 | 未实现 | 中 |
| 鸿蒙专栏 | 1 | 未实现 | 小 |
| 最受欢迎板块 | 3 | 未实现 | 小 |
| 工具列表 | 1 | 未实现 | 小 |
| TODO 工具 | — | 不实现（推荐 v2） | — |

---

## 5. UI 设计规范

### 5.1 设计语言

- **Material Design 3**（已通过 `flex_color_scheme` 启用）
- 色彩系统跟随 `ColorScheme.of(context)`
- 字体排版使用 `Theme.of(context).textTheme.*`
- 圆角统一使用 `Card(shape: RoundedRectangleBorder(...))` + `BorderRadius.circular(12)`

### 5.2 布局响应式策略

| 断点 | DeviceType | 布局策略 |
|------|-----------|---------|
| `< 600dp` | `mobile` | 单列列表 + BottomNavigationBar |
| `600dp–840dp` | `smallTablet` | 双列网格 + NavigationRail |
| `> 840dp` | `largeTablet` | 三列网格 + NavigationRail |

### 5.3 通用组件复用

| 组件 | 用途 | 文件位置 |
|------|-----|---------|
| `ArticleCard` | 单篇文章卡片（列表） | `article/presentation/widgets/article_card.dart` |
| `ArticleGridCard` | 单篇文章卡片（网格） | `article/presentation/widgets/article_grid_card.dart` |
| `WebViewPage` | 通用 WebView | `shared/widgets/webview_page.dart` |
| `ResponsiveBuilder` | 自适应布局构建器 | `shared/widgets/responsive/responsive_builder.dart` |
| `BannerScreen` | 轮播 Banner | `banner/presentation/screens/banner_screen.dart` |

### 5.4 加载与错误状态模式

统一使用三种状态容器：

```
1. 加载中 → Shimmer / CircularProgressIndicator
2. 数据空 → EmptyStateWidget（图标 + 文案 + 操作按钮）
3. 加载失败 → ErrorStateWidget（错误信息 + 重试按钮）
```

---

## 6. 功能模块 UI 设计与实现思路

### 6.1 登录 / 注册

#### UI 设计

**登录页 (`/sign_in`)**

```
┌─────────────────────────────┐
│          ← 返回              │  AppBar
│                             │
│       🔑 玩 Android         │  Logo / 标题
│                             │
│  ┌───────────────────────┐  │
│  │  请输入用户名           │  │  TextField
│  └───────────────────────┘  │
│  ┌───────────────────────┐  │
│  │  请输入密码             │  │  TextField (obscure)
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │       登  录           │  │  FilledButton
│  └───────────────────────┘  │
│                             │
│  没有账号？去注册            │  TextButton
└─────────────────────────────┘
```

**注册页 (`/sign_up`)**

```
┌─────────────────────────────┐
│          ← 返回              │
│                             │
│       📝 注册账号            │
│                             │
│  ┌───────────────────────┐  │
│  │  请输入用户名           │  │
│  └───────────────────────┘  │
│  ┌───────────────────────┐  │
│  │  请输入密码             │  │
│  └───────────────────────┘  │
│  ┌───────────────────────┐  │
│  │  确认密码               │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │       注  册           │  │
│  └───────────────────────┘  │
│                             │
│  已有账号？去登录            │
└─────────────────────────────┘
```

#### 实现思路

1. **数据层**
   - 在 `ApiAddress` 中已定义 `signIn`、`signUp`、`signOut`
   - 新增 `lib/features/auth/` 模块（domain + infrastructure + presentation）
   - 新增 `AuthRepository` 接口及其 Dio 实现
   - Cookie 持久化：启用 `CookieInterceptors`（目前被注释），或手动从响应头提取 cookie 存入 `shared_preferences`

2. **状态管理**
   - `authProvider`：`StateNotifier` 管理 `AuthState`（未登录 / 登录中 / 已登录 / 错误）
   - `userProvider`：缓存当前用户信息
   - 登录成功后通过 `ref.read(routerProvider.notifier).redirect(...)` 跳转

3. **Token / Cookie 持久化**

   ```dart
   // 核心思路：登录后服务端通过 Set-Cookie 下发凭证
   // CookieInterceptors 自动处理后续请求的 cookie 携带
   // 启用 cookie_interceptors.dart 中 CookieInterceptors
   // 在 dio.interceptors 中添加 CookieInterceptors(ref: ref)
   ```

### 6.2 搜索

#### UI 设计

```
┌─────────────────────────────┐
│ 🔍 搜索文章...       [取消]  │  SearchBar
├─────────────────────────────┤
│  热门搜索                     │
│  [Android]  [Flutter]       │  Wrap(chip)
│  [Kotlin]   [Jetpack]      │
│  [Compose]                  │
├─────────────────────────────┤
│  搜索历史                     │
│  · Flutter开发  ✕            │
│  · 鸿蒙开发     ✕            │  ListTile + delete
│                             │
│  —— 清空搜索历史 ——          │
├─────────────────────────────┤
│  (搜索结果区域 — 输入后显示)   │
│  ┌───────────────────────┐  │
│  │ ArticleCard ...       │  │  复用 ArticleCard
│  └───────────────────────┘  │
└─────────────────────────────┘
```

#### 实现思路

1. **API**
   - `//hotkey/json` → `Hotkey` 模型已存在
   - `/article/query/{page}/json` → POST，参数 `k`
   - 新增 `SearchRepository`

2. **Provider**
   - `searchProvider`：关键词 → `AsyncValue<PaginationDataState<Articles>>`
   - `hotKeysProvider`：`FutureProvider` 加载热门关键词
   - `searchHistoryProvider`：基于 `shared_preferences` 持久化

3. **路由**
   - 新增 `GoRoute(path: '/search')`，首页搜索图标导航至此页

### 6.3 体系（知识树）

#### UI 设计

**手机端**

```
┌─────────────────────────────┐
│      体系                    │  SliverAppBar(pinned)
├─────────────────────────────┤
│  📁 开发环境          ▸     │  ExpansionTile
│    ├ Android Studio相关     │   → 点击跳转文章列表
│    ├ ADB                   │
│    └ 构建工具               │
├─────────────────────────────┤
│  📁 语言             ▸      │
│    ├ Java                  │
│    ├ Kotlin                │
│    └ Dart                  │
├─────────────────────────────┤
│  📁 四大组件         ▸      │
│    └ ...                   │
└─────────────────────────────┘
```

**平板端**

```
┌─────────────────────────────────────────┐
│  体系                                     │
├──────────────┬──────────────────────────┤
│  一级分类列表  │  二级分类标签 (Chip)       │
│              │                           │
│  开发环境     │  [Android Studio] [ADB]  │
│  语言         │  [构建工具]               │
│  四大组件     │                           │
│  UI          │  二级文章列表 (ArticleCard)│
│  工具         │                           │
│  网络         │                           │
│  等等         │                           │
├──────────────┴──────────────────────────┤
```

#### 实现思路

1. **数据层**
   - `/tree/json` → `Architecture` 模型已存在（含递归 `children`）
   - 新增 `TreeRepository`
   - `/article/list/{page}/json?cid=` → 复用 `ArticleRepository` 或新增方法

2. **状态管理**
   - `treeProvider`：`FutureProvider` 加载体系树
   - 展开状态用 `TreeExpansionState` 管理

3. **路由**
   - 新增 `/tree` 页面
   - 新增 `/article_list?cid={cid}&title={name}` 通用文章列表页（复用 `ArticleCard`）

### 6.4 项目

#### UI 设计

```
┌─────────────────────────────┐
│      项目                    │  TabBar
├─────────────────────────────┤
│ [完整项目] [开源库] [工具] ...│  Tab 切换分类
├─────────────────────────────┤
│  ┌───────────────────────┐  │
│  │ 📱 项目卡片            │  │  Card
│  │ 项目名称               │  │
│  │ 项目描述描述描述...     │  │
│  │ ⭐ 100  🍴 50         │  │
│  └───────────────────────┘  │
│  ┌───────────────────────┐  │
│  │ 📱 另一项目            │  │  无限滚动
│  └───────────────────────┘  │
│         ...                 │
└─────────────────────────────┘
```

#### 实现思路

1. **数据层**
   - `/project/tree/json` → 返回项目分类列表（ApiAddress 已定义 `projectTypeUrl`）
   - `/project/list/{page}/json?cid=` → 分类下项目列表（新增 `projectListUrl`）
   - 新增 `ProjectRepository`
   - 新增 `Project` 模型（与 `Articles` 结构类似可复用）

2. **状态管理**
   - `projectCategoriesProvider`：加载分类列表
   - `projectListProvider`：带 `cid` 参数的分页加载

3. **UI**
   - `TabBar` 横向滑动切换分类
   - 每个 tab 内为 `RefreshIndicator` + 列表
   - 可新增 `ProjectCard` 组件（可复用 `ArticleCard` 或单独设计）

### 6.5 公众号

#### UI 设计

```
┌─────────────────────────────┐
│      公众号                  │
├─────────────────────────────┤
│  ┌───────────────────────┐  │
│  │ 📰 郭霖               │  │  Card → 点击进入文章列表
│  │    最新: Android ...  │  │
│  ├───────────────────────┤  │
│  │ 📰 鸿洋               │  │
│  │    最新: Flutter ...  │  │
│  ├───────────────────────┤  │
│  │ 📰 谷歌开发者          │  │
│  │    最新: Jetpack ...  │  │
│  └───────────────────────┘  │
└─────────────────────────────┘
```

**公众号内文章列表**

```
┌─────────────────────────────┐
│  ← 郭霖         [🔍 搜索]   │  AppBar
├─────────────────────────────┤
│  ArticleCard ...            │  复用 ArticleCard
│  ArticleCard ...            │
│  ArticleCard ...            │  无限滚动
└─────────────────────────────┘
```

#### 实现思路

1. **数据层**
   - `/wxarticle/chapters/json` → 公众号列表
   - `/wxarticle/list/{id}/{page}/json` → 文章列表
   - `/wxarticle/list/{id}/{page}/json?k=` → 搜索
   - 新增 `WxArticleRepository`
   - 新增 `WxChapter` 模型（id, name）

2. **路由**
   - 新增 `/wx_article` 页面
   - 新增 `/wx_article/{id}/{name}` 公众号文章列表

### 6.6 问答（完整实现）

#### UI 设计

```
┌─────────────────────────────┐
│      问答                    │  SliverAppBar
├─────────────────────────────┤
│  ❓ Android如何...    ▸     │  Card
│     鸿洋 · 2024-01-01      │  → 点击进入 WebView
├─────────────────────────────┤
│  ❓ Flutter状态管理...  ▸    │
│     郭霖 · 2024-01-02      │
├─────────────────────────────┤
│         ...                 │  无限滚动
└─────────────────────────────┘
```

#### 实现思路

- 替换当前 `QuestionAndAnswersPage` 的硬编码数据
- API：`/wenda/list/{page}/json`
- 复用 `ArticleCard` 组件（问答字段结构与文章类似）
- 点击项导航至 `WebViewPage`（URL 为 `https://www.wanandroid.com/wenda`）

### 6.7 导航（完整实现）

#### UI 设计

```
┌─────────────────────────────┐
│      导航                    │  SliverAppBar(pinned)
├─────────────────────────────┤
│  📁 Android          ▸     │  ExpansionTile
│    ├ 开源项目               │
│    │  [Github] [码云]      │  Chip 点击 → WebView
│    ├ 开发工具               │
│    │  [Android Studio]     │
├─────────────────────────────┤
│  📁 iOS              ▸      │
│    ├ ...                   │
└─────────────────────────────┘
```

#### 实现思路

- API：`/navi/json` → `Navi` 模型已存在（含 `articles` 列表）
- 替换 `NaviPage` 硬编码数据
- 每个导航分类为 `ExpansionTile`，内部 `articles` 列表为 `ListTile` + `Icon(Icons.open_in_new)`
- 点击跳转 `WebViewPage(url: article.link)`

### 6.8 收藏

#### UI 设计

**收藏文章列表**

```
┌─────────────────────────────┐
│  ← 我的收藏     [管理/编辑]   │  AppBar
├─────────────────────────────┤
│  ❤️ ArticleCard ...        │  与首页 ArticleCard 相同
│  ❤️ ArticleCard ...        │  但 collect 状态为 true
│  ❤️ ArticleCard ...        │
│         ...                 │  无限滚动
├─────────────────────────────┤
│  「管理」模式下显示删除按钮    │
└─────────────────────────────┘
```

#### 实现思路

1. **数据层**
   - 新增 `CollectRepository`（包含增删改查所有收藏 API）
   - 收藏/取消收藏可在文章卡片上直接操作（`ArticleCard` 扩展心形按钮）
   - 收藏列表页复用 `ArticleCard`，加 `collect` 状态标记

2. **状态管理**
   - `collectListProvider`：分页加载收藏列表
   - `collectActionProvider`：收藏/取消收藏操作

3. **路由**
   - 新增 `/collect` 页面
   - 从 `ProfilePage` 菜单 "我的收藏" 进入

### 6.9 我的 / 个人中心

#### UI 设计

```
┌─────────────────────────────┐
│      我的                    │  SliverAppBar(pinned)
├─────────────────────────────┤
│  ┌───────────────────────┐  │
│  │   👤 用户名            │  │  用户信息卡片
│  │   user@example.com    │  │  （登录后显示真实数据）
│  │                       │  │
│  │  [收藏]  [积分]  [排名]│  │  统计项
│  │   12    1024    256   │  │
│  └───────────────────────┘  │
│                             │
│  ❤️  我的收藏        ▸      │  ListTile
│  📰  我的文章        ▸      │
│  📊  积分排行        ▸      │
│  🏠  我的分享        ▸      │
│  💬  站内消息        ▸      │
│  ⚙️  设置            ▸      │
│  ℹ️  关于            ▸      │
└─────────────────────────────┘
```

#### 实现思路

- 替换 `ProfilePage` 的静态数据
- 未登录时显示"点击登录"卡片
- API：`/user/lg/userinfo/json` 获取用户信息
- 积分数据从 `/lg/coin/userinfo/json` 获取
- 菜单项功能映射到对应路由

### 6.10 积分系统

#### UI 设计

**积分排行榜**

```
┌─────────────────────────────┐
│  ← 积分排行                 │  AppBar
├─────────────────────────────┤
│  🏆  🥇  鸿洋    36662     │  Top 3 特殊样式
│  🥈  🥉  等                │
├─────────────────────────────┤
│  4    userA    2000        │  普通列表
│  5    userB    1800        │
│  6    userC    1500        │
│         ...                │  无限滚动
└─────────────────────────────┘
```

**积分历史**

```
┌─────────────────────────────┐
│  ← 积分记录                 │
├─────────────────────────────┤
│  📈 +10  登录积分  01-01    │
│  📈 +20  发表文章  01-02    │
│  📉 -5   下载资源  01-03    │
└─────────────────────────────┘
```

#### 实现思路

- 新增 `CoinRepository`
- 三个 API：排行 / 个人信息 / 获取列表
- 排行榜页：`/coin/rank/{page}/json`
- 个人积分卡片：集成在 `ProfilePage` 和收藏列表页

### 6.11 广场

#### UI 设计

```
┌─────────────────────────────┐
│      广场                    │  SliverAppBar
├─────────────────────────────┤
│  📝 分享文章标题...          │  ArticleCard
│     分享人 · 2024-01-01    │  （可显示 "审核中" 标签）
├─────────────────────────────┤
│  📝 另一分享文章...          │
│     分享人 · 2024-01-02    │
├─────────────────────────────┤
│  ┌───────────────────────┐  │
│  │   ✏️  分享文章        │  │  FAB → 分享弹窗
│  └───────────────────────┘  │
└─────────────────────────────┘
```

#### 实现思路

- 新增 `SquareRepository`
- 列表：`/user_article/list/{page}/json`
- 分享：`/lg/user_article/add/json`（POST title + link）
- 新增 `SquarePage` 和路由 `/square`

### 6.12 站内消息

#### UI 设计

```
┌─────────────────────────────┐
│  ← 消息中心    [🔔 3条未读]  │  AppBar
├─────────────────────────────┤
│  ┌───────────────────────┐  │
│  │  🔵 新消息标题        │  │  未读消息（蓝色圆点标识）
│  │  消息内容摘要...      │  │
│  └───────────────────────┘  │
│  ┌───────────────────────┐  │
│  │  已读消息标题          │  │  已读消息
│  │  消息内容摘要...      │  │
│  └───────────────────────┘  │
│         ...                 │  分页
├─────────────────────────────┤
│  [未读] [已读]              │  Tab 切换
└─────────────────────────────┘
```

#### 实现思路

- 新增 `MessageRepository`
- 注意：读取未读列表会自动标记为已读
- 未读数量显示在 BottomNavigation 的「我的」tab 上

### 6.13 教程

#### UI 设计

```
┌─────────────────────────────┐
│      教程                    │  SliverAppBar
├─────────────────────────────┤
│  📖 C 语言入门教程_阮一峰     │  Card
│     C 语言入门教程...       │  → 展开文章列表
│  📖 HTML 教程_阮一峰        │
│     HTML 入门教程...        │
│  📖 JavaScript 教程_阮一峰  │
│     JS 入门教程...          │
└─────────────────────────────┘
```

#### 实现思路

- API：`/chapter/547/sublist/json` → 教程列表
- API：`/article/list/{page}/json?cid=&order_type=1` → 教程文章（正序）
- 注意 `order_type=1` 参数保持教程的章节顺序
- 文章详情跳转 `WebViewPage`

### 6.14 最新项目 Tab

#### UI 设计

```
┌─────────────────────────────┐
│  [首页]  [最新项目]          │  TabBar（首页顶部）
├─────────────────────────────┤
│  📱 项目名称                │  ArticleCard
│     项目描述描述...          │  （可复用 ArticleCard）
│     作者 · 日期             │
├─────────────────────────────┤
│  ...                        │  无限滚动
└─────────────────────────────┘
```

#### 实现思路

- API：`/article/listproject/{page}/json`
- 在 `HomePage` 顶部加 `TabBar`，两个 tab：「首页」和「最新项目」
- 复用 `ArticleCard` 组件

### 6.15 工具列表

#### UI 设计

```
┌─────────────────────────────┐
│      工具                    │
├─────────────────────────────┤
│  🔧 工具名称     ▸          │  Card
│     工具描述...             │
│  🔧 工具名称     ▸          │
│     工具描述...             │
└─────────────────────────────┘
```

#### 实现思路

- API：`/tools/list/json`
- 新增 `Tool` 模型
- 点击跳转 WebView

### 6.16 鸿蒙专栏

#### UI 设计

```
┌─────────────────────────────┐
│      鸿蒙开发                │
├─────────────────────────────┤
│  常用链接                     │
│  [链接1] [链接2] [链接3]    │  Chip
├─────────────────────────────┤
│  开源项目                     │
│  📦 项目名   ▸              │  Card
│  📦 项目名   ▸              │
├─────────────────────────────┤
│  常用工具                     │
│  🔧 工具名   ▸              │
└─────────────────────────────┘
```

#### 实现思路

- API：`/harmony/index/json`
- 复用 `Architecture` / `Article` 模型（官方说明可复用）
- 新增 `HarmonyPage`

### 6.17 首页最受欢迎板块

#### UI 设计

```
┌─────────────────────────────┐
│   🔥 最受欢迎                │  HomePage 中的 Section
├─────────────────────────────┤
│  [问答]  [专栏]  [路线]     │  Chip Group
├─────────────────────────────┤
│  内容列表...                 │
└─────────────────────────────┘
```

#### 实现思路

- 三个 API：`/popular/wenda/json`、`/popular/column/json`、`/popular/route/json`
- 在 `HomePage` 的 Banner 下方添加一个 Section
- 可复用 `ArticleCard` 或 `ChapterCard`

---

## 7. Bottom Navigation 重构方案

当前底部导航栏 4 个 tab：

| 序号 | 当前 | 建议 |
|------|------|------|
| 1 | 首页 | 首页（维持） |
| 2 | 问答 | 问答（完整实现） |
| 3 | 导航 | 体系（替换） |
| 4 | 我的 | 我的（完整实现） |

**备选方案一（推荐）：5 Tab**

```
[🏠 首页] [📚 体系] [📱 项目] [💬 问答] [👤 我的]
```

- 新增「项目」tab，将「导航」合并到首页中

**备选方案二：保留 4 Tab**

```
[🏠 首页] [📚 体系] [📱 项目] [👤 我的]
```

- 问答合并到首页作为 section
- 导航合并到体系内

方案选择需根据用户使用习惯，建议采用方案一。

---

## 8. 路由增补计划

在现有 `go_router` 配置基础上新增以下路由：

| 路由路径 | 页面组件 | 说明 |
|---------|---------|------|
| `/search` | `SearchPage` | 搜索页 |
| `/login` | `SignInPage` | 登录（从存根替换） |
| `/register` | `SignUpPage` | 注册（从存根替换） |
| `/tree` | `TreePage` | 体系知识树 |
| `/article_list?cid=&title=` | `ArticleListPage` | 通用文章列表（体系/分类/作者） |
| `/project` | `ProjectPage` | 项目首页 |
| `/project_list?cid=&title=` | `ProjectListPage` | 项目分类文章列表 |
| `/wx_article` | `WxArticlePage` | 公众号列表 |
| `/wx_article/:id/:name` | `WxArticleListPage` | 公众号文章列表 |
| `/collect` | `CollectPage` | 我的收藏 |
| `/coin_rank` | `CoinRankPage` | 积分排行榜 |
| `/square` | `SquarePage` | 广场 |
| `/message` | `MessagePage` | 消息中心 |
| `/harmony` | `HarmonyPage` | 鸿蒙专栏 |
| `/tutorial` | `TutorialPage` | 教程 |
| `/tools` | `ToolsPage` | 工具列表 |

### 路由配置模式

```dart
// 通用文章列表页路由示例
GoRoute(
  path: '/article_list',
  builder: (context, state) {
    final cid = state.uri.queryParameters['cid'];
    final title = state.uri.queryParameters['title'] ?? '文章列表';
    return ArticleListPage(cid: cid, title: title);
  },
),
```

---

## 9. 数据模型复用与新增

### 可直接复用的现有模型

| 模型 | 文件 | 复用场景 |
|------|------|---------|
| `Articles` | `features/article/domain/entities/` | 所有文章列表（首页、体系、项目、问答、收藏、公众号） |
| `Banner` | `features/banner/domain/entities/` | 首页 Banner |
| `Architecture` | `model/architecture/` | 体系树 |
| `Navi` | `model/navi/` | 导航数据 |
| `Article` (navi) | `model/navi/` | 导航内文章子项 |
| `Hotkey` | `model/hotkey/` | 搜索热词 |
| `PaginationData` | `model/pagination_data.dart` | 所有分页列表 |

### 需要新增的模型

| 模型 | 建议位置 | 字段示例 |
|------|---------|---------|
| `WxChapter` | `features/wx_article/` | id, name |
| `Project` | `features/project/` | 同 Articles 结构 |
| `CoinInfo` | `features/coin/` | coinCount, rank, userId, username |
| `CoinHistory` | `features/coin/` | coinCount, reason, date, type |
| `UserInfo` | `features/auth/` | id, username, email, icon, coinInfo, collectIds |
| `Message` | `features/message/` | id, title, content, date, read |
| `Tool` | `features/tools/` | name, link, desc, icon |
| `Tutorial` | `features/tutorial/` | id, name, desc, cover, author |

---

## 10. 依赖评估

**现有依赖足以支撑所有新增功能，无需新增第三方包。** 理由如下：

| 需求 | 已有依赖 | 说明 |
|------|---------|------|
| HTTP 请求 | `dio ^5.9.0` | 全部 API 调用 |
| 状态管理 | `flutter_riverpod ^3.0.3` | Riverpod 足以管理所有模块状态 |
| 路由 | `go_router ^15.0.0` | 声明式路由 |
| 序列化 | `freezed ^3.2.3` + `json_annotation ^4.9.0` | 所有模型 |
| 网络图片 | `cached_network_image ^3.4.1` | Banner + 文章图片 |
| 自适应 | `flutter_screenutil ^5.9.3` + `ResponsiveBuilder` | 所有新页面 |
| WebView | `webview_flutter ^4.13.0` | 文章详情、外部链接 |
| 本地存储 | `shared_preferences ^2.5.3` | 搜索历史、用户 token、登录状态 |
| 消息提示 | `fluttertoast ^9.1.0` / `flutter_easyloading ^3.0.5` | 操作反馈 |

---

## 附录 A：实施顺序建议

| 阶段 | 功能 | 预估工作量 |
|------|------|-----------|
| **Phase 1** | 登录/注册 + 退出（启用 Cookie 持久化） | 3–5 天 |
| **Phase 2** | 底部导航重构 + 体系 + 导航 | 4–6 天 |
| **Phase 3** | 项目 + 公众号 + 问答完善 | 4–6 天 |
| **Phase 4** | 搜索 + 收藏完整流程 | 4–6 天 |
| **Phase 5** | 我的/个人中心 + 积分系统 | 3–5 天 |
| **Phase 6** | 广场 + 站内消息 | 3–5 天 |
| **Phase 7** | 教程 + 工具 + 鸿蒙 + 热门 + 最新项目 | 3–5 天 |

> **总预估**：约 24–38 人天（约 1.5–2 人月）

---

*本文档基于 [玩Android 开放API](https://www.wanandroid.com/blog/show/2) 和项目现有代码结构编写，所有设计均适配当前项目技术栈版本（Flutter SDK ^3.8.0、Riverpod 3.0.3、go_router 15.0.0、Dio 5.9.0）。*
