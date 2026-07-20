# 玩 Android 未开发 API 与 UI 设计文档（kimi-k3）

> 数据来源：<https://wanandroid.com/blog/show/2>（玩 Android 开放 API 官方文档，含 2024-05-26 新增）
> 适用项目：`wanandroid_app_flutter_riverpod`（Flutter + Riverpod 3 + Dio + Freezed + go_router）
> 版本：v1.0 ｜ 生成日期：2026-07-20

---

## 目录

- [1. 项目现状总结](#1-项目现状总结)
- [2. 文档阅读指南](#2-文档阅读指南)
- [3. 未开发 API 清单总表](#3-未开发-api-清单总表)
- [4. 各模块 API 设计](#4-各模块-api-设计)
- [5. UI 设计方案](#5-ui-设计方案)
- [6. 开发优先级建议](#6-开发优先级建议)

---

## 1. 项目现状总结

### 1.1 技术栈

| 类别 | 选型 |
| --- | --- |
| 状态管理 | flutter_riverpod 3.x + riverpod_annotation（代码生成） |
| 网络 | dio 5.x，统一入口 `HttpManager.netFetch()`，统一响应包装 `ResultData` |
| 模型 | freezed + json_serializable，泛型分页 `PaginationData<T>` |
| 路由 | go_router 15.x（`StatefulShellRoute.indexedStack` 四 Tab + 独立路由） |
| 屏幕适配 | flutter_screenutil |
| 本地存储 | hive、shared_preferences |
| UI 辅助 | cached_network_image、carousel_slider、flutter_svg、rive、webview_flutter、flutter_easyloading、fluttertoast、share_plus、flex_color_scheme |

### 1.2 已实现的接口（3 个）

| 接口 | 说明 | 证据 |
| --- | --- | --- |
| `GET /banner/json` | 首页 Banner | `lib/features/banner/infrastructure/repositories/banner_repository_impl.dart:18` |
| `GET /article/list/{page}/json` | 首页文章列表（页码从 0 开始） | `lib/features/article/infrastructure/repositories/article_repository_impl.dart:19,46` |
| `GET /article/top/json` | 置顶文章（已接入仓库，**页面尚未调用**） | `lib/features/article/infrastructure/repositories/article_repository_impl.dart:72` |

### 1.3 部分实现（有 UI 或模型，未接真实数据）

| 模块 | 现状 | 证据 |
| --- | --- | --- |
| 问答 | 假数据 UI（硬编码"问题标题 n"），详情跳 webview | `lib/features/question_and_answers/view.dart:71-88` |
| 导航 | 假数据 UI；`Navi` 模型已建、`/navi/json` 常量已定义未接 | `lib/features/navi/view.dart:72`、`lib/model/navi/navi.dart:9` |
| 我的 Profile | 静态 UI（积分写死 1024），菜单 onTap 全为 TODO | `lib/features/profile/view.dart:134,178-211` |
| 登录 / 注册 | 占位页只有一行 Text；API 常量已定义 | `lib/features/sign_in/view.dart:11-15`、`lib/features/sign_up/view.dart:11-15` |
| 体系 | 仅 `Architecture` 模型，无页面/路由/请求 | `lib/model/architecture/architecture.dart:18` |
| 搜索 | 首页搜索按钮为空回调；`Hotkey` 模型已建 | `lib/features/home/view.dart:106-109`、`lib/model/hotkey/hot_key.dart:14` |

### 1.4 关键基建缺口

- **Cookie 拦截器未挂载**：`CookieInterceptors`（读写 SharedPreferences）已实现但在 `lib/core/net/http_client.dart:57` 被注释，导致所有需要登录的接口（收藏、积分、消息、TODO、分享等）当前无法使用。登录链路是一切"我的"类功能的前置。
- **登录态管理缺失**：无全局 Auth Provider，go_router 的 `redirect` 守卫钩子（`router_notifier`）已存在但未做登录判断。
- **`ApiAddress` 中已定义未调用的常量**：`/friend/json`、`/hotkey/json`、`/tree/json`、`/navi/json`、`/project/tree/json`、`/user/login`、`/user/register`、`/user/logout/json`、`/lg/collect/list/{page}/json`、`/lg/collect/{id}/json`（`lib/core/constants/api_address.dart`）。

---

## 2. 文档阅读指南

- 第 3 章给出官方 18 大类全部接口与项目实现状态的对照总表，标注 ✅ 已实现 / 🟡 部分实现 / ❌ 未实现。
- 第 4 章针对每个未开发模块给出 Dart 侧 API 设计：`ApiAddress` 常量、Freezed 模型、Repository 方法签名、Riverpod Provider、路由。
- 第 5 章给出每个模块的页面结构、交互设计与主流组件选型（区分"现有依赖复用"与"建议新增包"）。
- 接口 URL 均以 `https://wanandroid.com` 为 baseUrl（官方建议不带 www）；`page_size` 参数（1-40）所有分页接口通用，一旦传入后续分页必须一直携带。
- 官方约定：`errorCode = 0` 成功，`-1001` 登录失效，其他负数均为错误；除文章标题、链接外字段都可能为 `null`，模型必须全可空、UI 必须做空值兜底。

---

## 3. 未开发 API 清单总表

> 图例：✅ 已实现 ｜ 🟡 部分实现（仅有 UI/模型/常量）｜ ❌ 未实现
> baseUrl：`https://wanandroid.com`

### 3.0 2024-05-26 新增

| # | 接口 | 方法 | 参数 / 页码 | 登录 | 状态 |
| --- | --- | --- | --- | --- | --- |
| 0.1 | `/harmony/index/json` | GET | 无 | 否 | ❌ |
| 0.2 | `/popular/wenda/json` | GET | 无（最受欢迎问答） | 否 | ❌ |
| 0.3 | `/popular/column/json` | GET | 无（最受欢迎专栏） | 否 | ❌ |
| 0.4 | `/popular/route/json` | GET | 无（最受欢迎路线） | 否 | ❌ |

### 3.1 首页相关

| # | 接口 | 方法 | 参数 / 页码 | 登录 | 状态 |
| --- | --- | --- | --- | --- | --- |
| 1.1 | `/article/list/{page}/json` | GET | 页码从 0 开始，拼在 URL | 否 | ✅ |
| 1.2 | `/banner/json` | GET | 无 | 否 | ✅ |
| 1.3 | `/friend/json` | GET | 无（常用网站） | 否 | 🟡 常量已定义 |
| 1.4 | `/hotkey/json` | GET | 无（搜索热词） | 否 | 🟡 常量+模型已建 |
| 1.5 | `/article/top/json` | GET | 无（置顶文章） | 否 | ✅（页面未调用） |

### 3.2 体系

| # | 接口 | 方法 | 参数 / 页码 | 登录 | 状态 |
| --- | --- | --- | --- | --- | --- |
| 2.1 | `/tree/json` | GET | 无（体系二级目录） | 否 | 🟡 常量+模型已建 |
| 2.2 | `/article/list/{page}/json?cid=` | GET | 页码从 0；`cid` 二级目录 id | 否 | ❌（列表接口复用 1.1） |
| 2.3 | `/article/list/{page}/json?author=` | GET | 页码从 0；`author` 作者昵称精确匹配 | 否 | ❌（列表接口复用 1.1） |

### 3.3 导航

| # | 接口 | 方法 | 参数 / 页码 | 登录 | 状态 |
| --- | --- | --- | --- | --- | --- |
| 3.1 | `/navi/json` | GET | 无（导航分类+站点） | 否 | 🟡 假数据 UI + 常量 + 模型 |

### 3.4 项目

| # | 接口 | 方法 | 参数 / 页码 | 登录 | 状态 |
| --- | --- | --- | --- | --- | --- |
| 4.1 | `/project/tree/json` | GET | 无（项目分类） | 否 | 🟡 常量已定义 |
| 4.2 | `/project/list/{page}/json?cid=` | GET | **页码从 1 开始**；`cid` 分类 id | 否 | ❌ |

### 3.5 登录与注册

| # | 接口 | 方法 | 参数 / 页码 | 登录 | 状态 |
| --- | --- | --- | --- | --- | --- |
| 5.1 | `/user/login` | POST | 表单：`username`、`password`；Cookie 返回凭据 | — | 🟡 占位页 + 常量 |
| 5.2 | `/user/register` | POST | 表单：`username`、`password`、`repassword` | — | 🟡 占位页 + 常量 |
| 5.3 | `/user/logout/json` | GET | 无；服务端清 Cookie | 是 | 🟡 常量已定义 |

### 3.6 收藏（全部需登录）

| # | 接口 | 方法 | 参数 / 页码 | 登录 | 状态 |
| --- | --- | --- | --- | --- | --- |
| 6.1 | `/lg/collect/list/{page}/json` | GET | 页码从 0 | 是 | 🟡 常量已定义 |
| 6.2 | `/lg/collect/{id}/json` | POST | `id` 文章 id 拼在 URL | 是 | 🟡 常量已定义 |
| 6.3 | `/lg/collect/add/json` | POST | 表单：`title`、`author`、`link`（收藏站外文章） | 是 | ❌ |
| 6.3b | `/lg/collect/user_article/update/{id}/json` | POST | `id` 拼 URL；表单：`title`、`link`、`author`（编辑收藏，**三个参数必带**） | 是 | ❌ |
| 6.4.1 | `/lg/uncollect_originId/{id}/json` | POST | `id` 文章 id 拼 URL（文章列表内取消） | 是 | ❌ |
| 6.4.2 | `/lg/uncollect/{id}/json` | POST | `id` 拼 URL；表单：`originId`（收藏页内取消，无则 -1） | 是 | ❌ |
| 6.5 | `/lg/collect/usertools/json` | GET | 无（收藏网站列表） | 是 | ❌ |
| 6.6 | `/lg/collect/addtool/json` | POST | 表单：`name`、`link` | 是 | ❌ |
| 6.7 | `/lg/collect/updatetool/json` | POST | 表单：`id`、`name`、`link` | 是 | ❌ |
| 6.8 | `/lg/collect/deletetool/json` | POST | 表单：`id` | 是 | ❌ |

### 3.7 搜索

| # | 接口 | 方法 | 参数 / 页码 | 登录 | 状态 |
| --- | --- | --- | --- | --- | --- |
| 7.1 | `/article/query/{page}/json` | POST | 页码从 0；表单：`k` 关键词，多关键词空格分隔 | 否 | ❌ |

### 3.8 TODO 工具

| # | 接口 | 方法 | 参数 / 页码 | 登录 | 状态 |
| --- | --- | --- | --- | --- | --- |
| 8.x | TODO Open API v2 | GET/POST | 见 <https://www.wanandroid.com/blog/show/2442>（官方推荐 v2，老接口不再推荐） | 是 | ❌ |

### 3.9 积分

| # | 接口 | 方法 | 参数 / 页码 | 登录 | 状态 |
| --- | --- | --- | --- | --- | --- |
| 9.1 | `/coin/rank/{page}/json` | GET | **页码从 1 开始**（积分排行榜） | 否 | ❌ |
| 9.2 | `/lg/coin/userinfo/json` | GET | 无（个人积分：coinCount/rank/userId/username） | 是 | ❌ |
| 9.3 | `/lg/coin/list/{page}/json` | GET | **页码从 1 开始**（个人积分获取记录） | 是 | ❌ |

### 3.10 广场

| # | 接口 | 方法 | 参数 / 页码 | 登录 | 状态 |
| --- | --- | --- | --- | --- | --- |
| 10.1 | `/user_article/list/{page}/json` | GET | 页码从 0（广场列表） | 否 | ❌ |
| 10.2 | `/user/{userId}/share_articles/{page}/json` | GET | **页码从 1**；`userId` 拼 URL；返回 `coinInfo`+`shareArticles` 复合对象 | 否 | ❌ |
| 10.3 | `/user/lg/private_articles/{page}/json` | GET | **页码从 1**（自己分享的文章） | 是 | ❌ |
| 10.4 | `/lg/user_article/delete/{id}/json` | POST | `id` 文章 id 拼 URL（删除自己分享） | 是 | ❌ |
| 10.5 | `/lg/user_article/add/json` | POST | 表单：`title`、`link`（分享文章） | 是 | ❌ |

### 3.11 问答

| # | 接口 | 方法 | 参数 / 页码 | 登录 | 状态 |
| --- | --- | --- | --- | --- | --- |
| 11.1 | `/wenda/list/{page}/json` | GET | **页码从 1 开始** | 否 | ❌（列表页为假数据 UI） |

### 3.12 个人信息

| # | 接口 | 方法 | 参数 / 页码 | 登录 | 状态 |
| --- | --- | --- | --- | --- | --- |
| 12.1 | `/user/lg/userinfo/json` | GET | 无；返回 `coinInfo`（积分/等级/排名）+`userInfo`（含 `collectIds` 收藏 id 列表） | 是 | ❌ |

### 3.13 问答评论

| # | 接口 | 方法 | 参数 / 页码 | 登录 | 状态 |
| --- | --- | --- | --- | --- | --- |
| 13.1 | `/wenda/comments/{id}/json` | GET | `id` 问答 id 拼 URL；按点赞数倒序，登录后本人评论置顶 | 否 | ❌ |

### 3.14 站内消息（全部需登录）

| # | 接口 | 方法 | 参数 / 页码 | 登录 | 状态 |
| --- | --- | --- | --- | --- | --- |
| 14.1 | `/message/lg/count_unread/json` | GET | 无（未读消息数量） | 是 | ❌ |
| 14.2 | `/message/lg/readed_list/{page}/json` | GET | **页码从 1**（已读消息列表） | 是 | ❌ |
| 14.3 | `/message/lg/unread_list/{page}/json` | GET | **页码从 1**（未读列表；**注意：访问后全部置为已读**，获取未读数不要用此接口） | 是 | ❌ |

### 3.15 公众号 Tab

| # | 接口 | 方法 | 参数 / 页码 | 登录 | 状态 |
| --- | --- | --- | --- | --- | --- |
| 15.1 | `/wxarticle/chapters/json` | GET | 无（公众号列表） | 否 | ❌ |
| 15.2 | `/wxarticle/list/{id}/{page}/json` | GET | **页码从 1**；`id` 公众号 id | 否 | ❌ |
| 15.3 | `/wxarticle/list/{id}/{page}/json?k=` | GET | 同上；`k` 号内搜索关键词 | 否 | ❌ |

### 3.16 最新项目 Tab

| # | 接口 | 方法 | 参数 / 页码 | 登录 | 状态 |
| --- | --- | --- | --- | --- | --- |
| 16.1 | `/article/listproject/{page}/json` | GET | 页码从 0（按时间分页的全部项目） | 否 | ❌ |

### 3.17 工具列表

| # | 接口 | 方法 | 参数 / 页码 | 登录 | 状态 |
| --- | --- | --- | --- | --- | --- |
| 17.1 | `/tools/list/json` | GET | 无（单个工具详情页可能未适配移动端，不一定适合 App 内展示） | 否 | ❌ |

### 3.18 教程

| # | 接口 | 方法 | 参数 / 页码 | 登录 | 状态 |
| --- | --- | --- | --- | --- | --- |
| 18.1 | `/chapter/547/sublist/json` | GET | 无；`547` 为固定值（教程列表） | 否 | ❌ |
| 18.2 | `/article/list/0/json?cid=` | GET | 页码从 0；`cid` 教程对象 id；**需传 `order_type=1` 保持目录正序** | 否 | ❌（列表接口复用 1.1） |

> **页码起始规则速查**：从 **0** 开始——首页文章、体系文章、作者搜索、收藏列表、搜索、广场、最新项目、教程文章；从 **1** 开始——项目列表、分享人文章、我的分享、积分排行、积分记录、问答、已读/未读消息、公众号历史。

---

## 4. 各模块 API 设计

> 约定：
> - 所有常量写入 `lib/core/constants/api_address.dart`，命名风格与现有一致（`xxxUrl` 常量 / 带命名参数的静态方法）。
> - 所有模型放 `lib/model/<模块>/`，`@freezed` + 全字段可空（官方明确"除标题、链接外字段都可能为 null"）。
> - Repository 沿用 `ArticleRepository` 样板：`domain/repositories` 抽象接口 + `infrastructure/repositories` 实现，构造注入 `Ref`，内部 `_ref.read(httpManagerProvider.notifier).netFetch(...)`，解析用 `parseData / parseList / parsePagination`。
> - POST 请求统一 `method: DioMethod.post, data: {...}`（dio 默认 `application/x-www-form-urlencoded`，与官方表单参数一致）。
> - Provider 用 `@riverpod` 代码生成；分页列表复刻 `ArticleList`（`lib/features/home/provider/article_list_provider.dart`）的 AsyncNotifier 模式。

### 4.1 `ApiAddress` 常量补充设计

```dart
// lib/core/constants/api_address.dart 追加
class ApiAddress {
  // ... 现有常量保留 ...

  /// ===== 2024 新增 =====
  static const String harmonyUrl = '/harmony/index/json';
  static const String popularWendaUrl = '/popular/wenda/json';
  static const String popularColumnUrl = '/popular/column/json';
  static const String popularRouteUrl = '/popular/route/json';

  /// ===== 体系（systemTree 已有） =====
  // 体系文章 / 按作者搜索：复用 articleUrl(pageNumber)，
  // 由 netFetch 的 params 传 {'cid': cid} 或 {'author': name}

  /// ===== 项目 =====
  static String projectListUrl({required int page}) => '/project/list/$page/json'; // params: {'cid': cid}，页码从 1
  static String latestProjectUrl({required int page}) => '/article/listproject/$page/json'; // 页码从 0

  /// ===== 搜索 =====
  static String searchUrl({required int page}) => '/article/query/$page/json'; // POST data: {'k': keyword}

  /// ===== 收藏（collectListUrl / collectInUrl 已有） =====
  static const String collectOutUrl = '/lg/collect/add/json'; // POST data: {title, author, link}
  static String collectUpdateUrl({required int id}) => '/lg/collect/user_article/update/$id/json'; // POST data: {title, link, author} 必带
  static String uncollectOriginUrl({required int id}) => '/lg/uncollect_originId/$id/json'; // 文章列表取消
  static String uncollectUrl({required int id}) => '/lg/uncollect/$id/json'; // 收藏页取消，POST data: {'originId': originId ?? -1}
  static const String collectSitesUrl = '/lg/collect/usertools/json';
  static const String collectSiteAddUrl = '/lg/collect/addtool/json'; // POST data: {name, link}
  static const String collectSiteUpdateUrl = '/lg/collect/updatetool/json'; // POST data: {id, name, link}
  static const String collectSiteDeleteUrl = '/lg/collect/deletetool/json'; // POST data: {id}

  /// ===== 积分 =====
  static String coinRankUrl({required int page}) => '/coin/rank/$page/json'; // 页码从 1
  static const String coinUserInfoUrl = '/lg/coin/userinfo/json';
  static String coinListUrl({required int page}) => '/lg/coin/list/$page/json'; // 页码从 1

  /// ===== 广场 =====
  static String squareUrl({required int page}) => '/user_article/list/$page/json'; // 页码从 0
  static String userShareArticlesUrl({required int userId, required int page}) =>
      '/user/$userId/share_articles/$page/json'; // 页码从 1
  static String myShareArticlesUrl({required int page}) => '/user/lg/private_articles/$page/json'; // 页码从 1
  static String shareArticleDeleteUrl({required int id}) => '/lg/user_article/delete/$id/json';
  static const String shareArticleAddUrl = '/lg/user_article/add/json'; // POST data: {title, link}

  /// ===== 问答 =====
  static String wendaUrl({required int page}) => '/wenda/list/$page/json'; // 页码从 1
  static String wendaCommentsUrl({required int id}) => '/wenda/comments/$id/json';

  /// ===== 个人信息 =====
  static const String userInfoUrl = '/user/lg/userinfo/json';

  /// ===== 站内消息 =====
  static const String unreadCountUrl = '/message/lg/count_unread/json';
  static String readedMessageUrl({required int page}) => '/message/lg/readed_list/$page/json'; // 页码从 1
  static String unreadMessageUrl({required int page}) => '/message/lg/unread_list/$page/json'; // 页码从 1，访问后全置已读

  /// ===== 公众号 =====
  static const String wxChaptersUrl = '/wxarticle/chapters/json';
  static String wxArticleListUrl({required int id, required int page}) =>
      '/wxarticle/list/$id/$page/json'; // 页码从 1，params: {'k': keyword} 可选

  /// ===== 工具列表 =====
  static const String toolsUrl = '/tools/list/json';

  /// ===== 教程 =====
  static const String tutorialUrl = '/chapter/547/sublist/json'; // 547 固定
  // 教程文章：复用 articleUrl(pageNumber: 0)，params: {'cid': id, 'order_type': 1}
}
```

### 4.2 Freezed 数据模型设计

```dart
// lib/model/chapter/chapter.dart —— 体系 / 教程 / 公众号 / 最受欢迎板块 通用
@freezed
abstract class Chapter with _$Chapter {
  const factory Chapter({
    List<Chapter>? children,
    int? courseId,
    int? id,
    String? name,
    int? order,
    int? parentChapterId,
    int? visible,
    // 教程列表扩展字段
    String? author,
    String? cover,
    String? desc,
    String? lisense,
    String? lisenseLink,
    bool? userControlSetTop,
  }) = _Chapter;
  factory Chapter.fromJson(Map<String, dynamic> json) => _$ChapterFromJson(json);
}

// lib/model/navi/navi.dart —— 已有，保持：Navi(name, articles: List<Articles>)
// lib/model/hotkey/hot_key.dart —— 已有，保持：Hotkey(id, link, name, order, visible)

// lib/model/friend/friend_link.dart —— 常用网站
@freezed
abstract class FriendLink with _$FriendLink {
  const factory FriendLink({String? category, String? icon, int? id,
      String? link, String? name, int? order, int? visible}) = _FriendLink;
  factory FriendLink.fromJson(Map<String, dynamic> json) => _$FriendLinkFromJson(json);
}

// lib/model/coin/coin_info.dart —— 积分（9.2 / 10.2 / 12.1 复用）
@freezed
abstract class CoinInfo with _$CoinInfo {
  const factory CoinInfo({int? coinCount, int? level, String? nickname,
      String? rank, int? userId, String? username}) = _CoinInfo;
  factory CoinInfo.fromJson(Map<String, dynamic> json) => _$CoinInfoFromJson(json);
}

// lib/model/coin/coin_record.dart —— 积分获取记录（9.3）
@freezed
abstract class CoinRecord with _$CoinRecord {
  const factory CoinRecord({int? coinCount, int? date, String? desc,
      int? id, String? reason, int? type, int? userId, String? userName}) = _CoinRecord;
  factory CoinRecord.fromJson(Map<String, dynamic> json) => _$CoinRecordFromJson(json);
}

// lib/model/share/share_articles_data.dart —— 分享人文章（10.2 复合结构）
@freezed
abstract class ShareArticlesData with _$ShareArticlesData {
  const factory ShareArticlesData({
    CoinInfo? coinInfo,
    PaginationData<Articles>? shareArticles, // 分页对象，手工嵌套解析
  }) = _ShareArticlesData;
  // 注：PaginationData 为泛型 @JsonSerializable，此处建议手写 fromJson 工厂解析
}

// lib/model/user/user_info_data.dart —— 个人信息（12.1 复合结构）
@freezed
abstract class UserInfoData with _$UserInfoData {
  const factory UserInfoData({CoinInfo? coinInfo, UserInfo? userInfo}) = _UserInfoData;
  factory UserInfoData.fromJson(Map<String, dynamic> json) => _$UserInfoDataFromJson(json);
}

@freezed
abstract class UserInfo with _$UserInfo {
  const factory UserInfo({bool? admin, List<int>? collectIds, String? email,
      String? icon, int? id, String? nickname, String? publicName,
      String? token, int? type, String? username}) = _UserInfo;
  factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserInfoFromJson(json);
}

// lib/model/message/message.dart —— 站内消息（14.x）
@freezed
abstract class Message with _$Message {
  const factory Message({String? category, int? date, int? fromUserId,
      String? fullLink, int? id, int? isRead, String? link, String? message,
      String? niceDate, String? tag, String? title, int? userId}) = _Message;
  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);
}

// lib/model/wenda/wenda_comment.dart —— 问答评论（13.1）
@freezed
abstract class WendaComment with _$WendaComment {
  const factory WendaComment({String? anonymous, String? content, int? id,
      int? replyCommentId, int? rootCommentId, int? status, String? toUserId,
      String? toUserName, String? userId, String? userName, int? zan}) = _WendaComment;
  factory WendaComment.fromJson(Map<String, dynamic> json) => _$WendaCommentFromJson(json);
}

// lib/model/tool/tool_item.dart —— 工具列表（17.1）
@freezed
abstract class ToolItem with _$ToolItem {
  const factory ToolItem({String? desc, String? icon, int? id, int? isNew,
      String? link, String? name, int? order, String? tabName, int? visible}) = _ToolItem;
  factory ToolItem.fromJson(Map<String, dynamic> json) => _$ToolItemFromJson(json);
}

// lib/model/harmony/harmony_data.dart —— 鸿蒙专栏（0.1，官方：可复用 Chapter / Article）
@freezed
abstract class HarmonyData with _$HarmonyData {
  const factory HarmonyData({
    List<Chapter>? links,        // 常用链接
    List<Chapter>? openSources,  // 开源项目
    List<Chapter>? tools,        // 常用工具
  }) = _HarmonyData;
  factory HarmonyData.fromJson(Map<String, dynamic> json) => _$HarmonyDataFromJson(json);
}
```

> 问答列表、广场、公众号文章、项目列表的元素结构均与首页文章一致，直接复用现有 `Articles` 实体（`lib/features/article/domain/entities/article_list.dart`）+ `PaginationData<Articles>`。

### 4.3 Repository 接口 + 方法签名设计

```dart
/// ===== 认证（前置：挂载 Cookie 持久化，见 4.6） =====
abstract class AuthRepository {
  Future<UserInfo?> login({required String username, required String password});
  // netFetch(ApiAddress.signIn, method: DioMethod.post, data: {'username': u, 'password': p})
  Future<UserInfo?> register({required String username, required String password, required String repassword});
  Future<bool> logout(); // GET ApiAddress.signOut，成功后清理本地登录态
}

/// ===== 体系 =====
abstract class TreeRepository {
  Future<List<Chapter>> getTree(); // parseList(Chapter.fromJson)
  Future<PaginationData<Articles>?> getTreeArticles({required int cid, required int page});
  // articleUrl(pageNumber: page), params: {'cid': cid}
  Future<PaginationData<Articles>?> getArticlesByAuthor({required String author, required int page});
}

/// ===== 导航 =====
abstract class NaviRepository {
  Future<List<Navi>> getNavi(); // parseList(Navi.fromJson)
}

/// ===== 项目 =====
abstract class ProjectRepository {
  Future<List<Chapter>> getProjectTree();
  Future<PaginationData<Articles>?> getProjectList({required int cid, required int page}); // 页码从 1
  Future<PaginationData<Articles>?> getLatestProjects({required int page}); // 页码从 0
}

/// ===== 搜索 =====
abstract class SearchRepository {
  Future<List<Hotkey>> getHotKeys();
  Future<List<FriendLink>> getFriendLinks(); // 常用网站（1.3）
  Future<PaginationData<Articles>?> query({required String keyword, required int page});
  // POST searchUrl, data: {'k': keyword}，多关键词空格分隔
}

/// ===== 收藏（全部需登录，未登录 code == -1001 时由 AuthNotifier 处理） =====
abstract class CollectRepository {
  Future<PaginationData<Articles>?> getCollectList({required int page}); // 页码从 0
  Future<bool> collectInner({required int id});
  Future<bool> collectOuter({required String title, required String author, required String link});
  Future<bool> updateCollect({required int id, required String title, required String link, required String author});
  Future<bool> uncollectFromList({required int id}); // 文章列表内取消
  Future<bool> uncollectFromCollectPage({required int id, int originId = -1}); // 收藏页内取消
  // 网址收藏
  Future<List<FriendLink>> getCollectSites();
  Future<bool> addSite({required String name, required String link});
  Future<bool> updateSite({required int id, required String name, required String link});
  Future<bool> deleteSite({required int id});
}

/// ===== 积分 =====
abstract class CoinRepository {
  Future<PaginationData<CoinInfo>?> getRank({required int page}); // 页码从 1
  Future<CoinInfo?> getMyCoin(); // parseData(CoinInfo.fromJson)，需登录
  Future<PaginationData<CoinRecord>?> getCoinRecords({required int page}); // 页码从 1，需登录
}

/// ===== 广场 =====
abstract class SquareRepository {
  Future<PaginationData<Articles>?> getSquareList({required int page}); // 页码从 0
  Future<ShareArticlesData?> getUserShareArticles({required int userId, required int page}); // 页码从 1
  Future<PaginationData<Articles>?> getMyShareArticles({required int page}); // 页码从 1，需登录
  Future<bool> shareArticle({required String title, required String link}); // 需登录
  Future<bool> deleteShareArticle({required int id}); // 需登录
}

/// ===== 问答 =====
abstract class WendaRepository {
  Future<PaginationData<Articles>?> getWendaList({required int page}); // 页码从 1
  Future<PaginationData<WendaComment>?> getWendaComments({required int id}); // 按点赞倒序
}

/// ===== 个人信息 =====
abstract class ProfileRepository {
  Future<UserInfoData?> getUserInfo(); // 需登录；userInfo.collectIds 用于列表收藏态高亮
}

/// ===== 站内消息（需登录） =====
abstract class MessageRepository {
  Future<int> getUnreadCount(); // parseData 取 int，进入 App / 下拉刷新时调用
  Future<PaginationData<Message>?> getReadedList({required int page}); // 页码从 1
  Future<PaginationData<Message>?> getUnreadList({required int page}); // 页码从 1；访问后全部置为已读
}

/// ===== 公众号 =====
abstract class WxArticleRepository {
  Future<List<Chapter>> getChapters();
  Future<PaginationData<Articles>?> getWxArticles({required int id, required int page, String? keyword});
  // 页码从 1；keyword != null 时 params: {'k': keyword}
}

/// ===== 教程 =====
abstract class TutorialRepository {
  Future<List<Chapter>> getTutorials(); // parseList(Chapter.fromJson)
  Future<PaginationData<Articles>?> getTutorialArticles({required int cid, required int page});
  // params: {'cid': cid, 'order_type': 1} 保持目录正序
}

/// ===== 鸿蒙专栏 / 最受欢迎板块 / 工具 =====
abstract class HarmonyRepository {
  Future<HarmonyData?> getHarmonyIndex();
}
abstract class PopularRepository {
  Future<List<Chapter>> getPopularWenda();
  Future<List<Chapter>> getPopularColumn();
  Future<List<Chapter>> getPopularRoute();
}
abstract class ToolsRepository {
  Future<List<ToolItem>> getTools();
}
```

### 4.4 Riverpod Provider 设计

```dart
/// A. 登录态（全局，keepAlive）
@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  @override
  FutureOr<UserInfoData?> build() => null; // App 启动时读本地 Cookie 尝试恢复
  Future<bool> login(String username, String password);
  Future<void> logout();
  bool get isLoggedIn => state.value?.userInfo != null;
  List<int> get collectIds => state.value?.userInfo?.collectIds ?? [];
  // 配合 ResponseInterceptors：errorCode == -1001 时 ref.invalidateSelf() 强制登出
}

/// B. 分页列表（复刻 ArticleList 模式：currentPage / pageCount / fetchMore 追加）
@riverpod class TreeArticleList extends _$TreeArticleList { /* build(cid) 家族，family 传 cid */ }
@riverpod class ProjectList extends _$ProjectList { /* family 传 cid，初始页 1 */ }
@riverpod class SearchResultList extends _$SearchResultList { /* family 传 keyword */ }
@riverpod class SquareList extends _$SquareList { /* 初始页 0 */ }
@riverpod class CollectList extends _$CollectList { /* 需登录 */ }
@riverpod class CoinRankList extends _$CoinRankList { /* 初始页 1 */ }
@riverpod class CoinRecordList extends _$CoinRecordList { /* 需登录 */ }
@riverpod class WendaList extends _$WendaList { /* 初始页 1，替换假数据 */ }
@riverpod class WxArticleList extends _$WxArticleList { /* family 传 (id, keyword?) */ }
@riverpod class MessageList extends _$MessageList { /* family 传 read/unread 枚举 */ }
@riverpod class MyShareList extends _$MyShareList { /* 需登录 */ }

/// C. 一次性数据（@riverpod Future，自动缓存 + ref.invalidate 刷新）
@riverpod Future<List<Chapter>> tree(TreeRef ref);
@riverpod Future<List<Navi>> naviList(NaviRef ref); // 替换假数据
@riverpod Future<List<Chapter>> projectTree(ProjectTreeRef ref);
@riverpod Future<List<Hotkey>> hotKeys(HotKeysRef ref);
@riverpod Future<List<FriendLink>> friendLinks(FriendLinksRef ref);
@riverpod Future<HarmonyData?> harmonyIndex(HarmonyIndexRef ref);
@riverpod Future<List<Chapter>> popularWenda(PopularWendaRef ref); // column / route 同理
@riverpod Future<List<ToolItem>> toolList(ToolListRef ref);
@riverpod Future<List<Chapter>> tutorialList(TutorialListRef ref);
@riverpod Future<int> unreadMessageCount(UnreadMessageCountRef ref); // 登录后定时/事件刷新
```

### 4.5 go_router 路由补充设计

```dart
// lib/common/router/router_path.dart 枚举追加（path / description 双 getter 保持现有风格）
enum RouterPath {
  // ... 现有 ...
  search,            // /search                搜索（含历史/热词，结果同页展示）
  tree,              // /tree                  体系（一级/二级分类）
  treeArticles,      // /tree/articles         体系文章列表，query: cid & name
  project,           // /project               项目（分类 Tab + 列表）
  square,            // /square                广场
  userShare,         // /square/user/:userId   分享人主页
  shareAdd,          // /square/add            分享文章（需登录）
  myShare,           // /square/mine           我的分享（需登录）
  collect,           // /collect               收藏文章（需登录）
  collectSites,      // /collect/sites         收藏网址管理（需登录）
  coin,              // /coin                  我的积分（需登录）
  coinRank,          // /coin/rank             积分排行
  coinRecords,       // /coin/records          积分记录（需登录）
  message,           // /message               站内消息 Tab 已读/未读（需登录）
  wxArticle,         // /wx_article            公众号
  wxArticleHistory,  // /wx_article/:id        公众号历史（含号内搜索）
  tutorial,          // /tutorial              教程列表
  tutorialArticles,  // /tutorial/:id/articles 教程目录
  harmony,           // /harmony               鸿蒙专栏
  tools,             // /tools                 工具列表
  todo,              // /todo                  TODO 工具（需登录）
  webDetail,         // /web?url=&title=       通用文章详情（webview）
  wendaComments;     // /qAnda/:id/comments    问答评论
}

// 登录守卫：在 router_notifier.redirect 内追加
// 需登录集合：{collect, collectSites, shareAdd, myShare, coin, coinRecords, message, todo}
// 未登录访问 → 重定向 '/sign_in?from=${state.uri}'，登录成功后 context.go(from)
```

### 4.6 前置基建：登录 Cookie 持久化

登录/收藏/积分/消息/TODO 等全部依赖 Cookie 认证，开发顺序上必须最先做：

1. **推荐方案**：引入 `dio_cookie_manager` + `cookie_jar`（持久化到 `path_provider` 应用目录），替换 `http_client.dart:57` 被注释的手写 `CookieInterceptors`——自动处理 Set-Cookie 存取与 logout 后的 `max-Age=0` 清理。
2. **保守方案**：取消注释现有 `CookieInterceptors(ref: ref)`（`lib/core/net/interceptors/cookie_interceptors.dart`），补齐 expires 持久化逻辑。
3. `ResponseInterceptors` 增加 `errorCode == -1001` 分支：失效时通知 `Auth` Provider 清空登录态并跳转登录页。

---

## 5. UI 设计方案

### 5.1 设计原则

- 所有尺寸用 flutter_screenutil（`.w / .h / .sp`），主题色沿用 flex_color_scheme 已有配置。
- 所有分页列表统一交互：**下拉刷新 + 上拉加载 + 首屏骨架屏 + 空态/错误态占位 + 点击进 `/web` 详情**。
- 文章详情统一走 `webview_flutter`，并在 `NavigationDelegate.onNavigationRequest`（对应官方建议的 `shouldOverrideUrlLoading`）拦截淘宝等恶意跳转。
- 文章条目抽成公共组件 `ArticleItemWidget`（标题 `Html` 解码、作者/分享人二选一显示——`author` 为 null 时显示 `shareUser`、分类 `superChapterName/chapterName`、时间 `niceDate`、收藏心形按钮按 `authProvider.collectIds` 高亮）。

### 5.2 各模块页面结构与交互设计

#### 5.2.1 登录 / 注册（改造现有占位页）

| 页面 | 结构 | 交互 |
| --- | --- | --- |
| SignInPage | `Scaffold` + 顶部 Logo（rive 动画可选）+ `Form`：`TextFormField` 用户名 / 密码（`obscureText` + 可见性切换 `IconButton`）+ 登录 `FilledButton` + 底部"去注册"`TextButton` | 表单校验（非空、长度）；提交时 `flutter_easyloading` 展示加载；成功 → 写登录态 → `context.go(from ?? '/profile')`；失败 toast 官方 `errorMsg` |
| SignUpPage | 同风格表单：用户名 / 密码 / 确认密码 | 两次密码一致性校验；注册成功自动登录并回跳 |

#### 5.2.2 搜索（新增 `/search`）

- **结构**：`Scaffold` + `AppBar` 内嵌 `SearchBar`（自动聚焦）→ 未输入时展示两区：**搜索热词**（`hotKeysProvider`，`Wrap` + `ActionChip` 随机淡色背景）与**搜索历史**（hive 持久化，`ListView` + 单条删除 `IconButton` + "清空"`TextButton`）；输入后展示结果列表。
- **交互**：提交即调 `SearchResultList`（POST `k`），结果复用 `ArticleItemWidget`；支持多关键词空格分隔；关键词命中部分可用 `RichText` 高亮。

#### 5.2.3 体系（新增 `/tree`、`/tree/articles`）

- **TreePage**：左右联动布局——左侧一级分类 `ListView`（宽度 `120.w`，选中态左侧指示条 + 主题色文字），右侧二级分类 `SingleChildScrollView` + 分组 `Wrap` of `ActionChip`。
- **TreeArticlesPage**：`AppBar(title: Text(name))` + 文章分页列表（`TreeArticleList` family 传 cid）。
- 数据来自 `treeProvider`；`RefreshIndicator` 整页刷新。

#### 5.2.4 项目（新增 `/project`）

- **结构**：`DefaultTabController` + `TabBar`（`projectTreeProvider` 分类，可滚动 `isScrollable: true`）+ `TabBarView` 每 tab 一个项目分页列表。
- **列表项**：卡片式——`cached_network_image` 封面（`envelopePic`，`16:9` 圆角）+ 标题 + `desc`（2 行省略）+ 作者/时间行。
- 另可挂"最新项目"入口（16.1），作为第一个固定 Tab。

#### 5.2.5 导航（改造假数据页 `/navi`）

- **结构**：左右锚点联动——左侧分类 `ListView`，右侧 `ListView` 按分类分组，每组标题 + `Wrap` of `ActionChip`（站点名）。
- **交互**：点左侧滚动定位（可用 `scrollable_positioned_list` 或简化为一一对应的点击选中+右侧滚动）；点 chip 进 `/web` 详情。
- 数据：`naviListProvider` 替换硬编码（`lib/features/navi/view.dart:72`）。

#### 5.2.6 问答（改造假数据页 `/qAnda` + 新增评论页）

- **列表**：`WendaList`（页码从 1）替换硬编码"问题标题 n"（`lib/features/question_and_answers/view.dart:71-88`）；条目显示标题、`descMd/desc` 摘要（`flutter_html` 渲染）、回答数、时间。
- **评论页** `/qAnda/:id/comments`：`AppBar` + 评论列表（点赞数倒序，登录后本人置顶）——头像 `CircleAvatar`、昵称、时间、`flutter_html` 内容、右侧 `zan` 点赞数 `Badge`。

#### 5.2.7 广场（新增 `/square`）

- **结构**：文章分页列表 + 右下角 `FloatingActionButton(Icons.add)`（分享文章，未登录点击先跳登录）。
- **分享人主页** `/square/user/:userId`：顶部用户卡片（`CoinInfo`：昵称/积分/排名，`SliverAppBar`）+ 该用户分享文章分页列表。
- **分享文章** `/square/add`：`Form`（标题 + 链接，URL 格式校验）+ 提交按钮；成功 toast 并返回刷新。
- **我的分享** `/square/mine`：分页列表 + `Dismissible` 侧滑删除（二次确认 `AlertDialog`）。

#### 5.2.8 公众号（新增 `/wx_article`）

- **结构**：`DefaultTabController` + 公众号 `TabBar`（`wxChaptersProvider`）+ 每 tab 历史文章分页列表（`WxArticleList`，页码从 1）。
- **交互**：`AppBar` 搜索按钮 → 当前公众号内搜索（`k` 参数），搜索态复用列表容器。

#### 5.2.9 教程（新增 `/tutorial`）

- **TutorialPage**：`ListView` 封面卡片——`cached_network_image`（`cover`）+ 名称 + 作者 + `desc`。
- **TutorialArticlesPage** `/tutorial/:id/articles`：目录式列表（**正序**，`order_type=1`），序号 + 标题，点击进入 `/web` 详情（官方明确详情页已适配移动端）。

#### 5.2.10 收藏（新增 `/collect`、`/collect/sites`，需登录）

- **收藏文章**：分页列表 + `Dismissible` 侧滑取消收藏（调用 6.4.2，`originId` 缺省 -1）+ 右上角"添加站外文章" `IconButton`（`Form`：标题/作者/链接）+ 长按弹 `BottomSheet` 编辑（6.3b，三字段必填）。
- **收藏网址**：`ListView` 站点项（名称 + 链接）+ `FloatingActionButton` 新增；每行 `PopupMenuButton`（编辑/删除）；点击进 `/web`。

#### 5.2.11 积分（新增 `/coin` 系列）

- **我的积分**：顶部卡片（`coinCount` 大数字 + `rank`/`level` `Chip`）+ 两入口列表项（排行榜 / 积分记录）。
- **排行榜**：分页列表——名次（前三名主题色放大 + `Icons.emoji_events`）+ 用户名 + 积分；当前登录用户行高亮。
- **积分记录**：时间线风格——`date` 格式化日期 + `reason` + `desc` + `coinCount` 正/负着色。

#### 5.2.12 站内消息（新增 `/message`，需登录）

- **入口**：我的页菜单 + `AppBar` 消息图标带 `badges` 未读角标（`unreadMessageCountProvider`）。
- **结构**：`DefaultTabController`（未读 / 已读两 Tab）+ 各自分页列表——标题、类型 `tag Chip`、`niceDate`、内容摘要；点击进入 `/web`（`fullLink` 拼接）。
- **注意**：未读列表一旦访问即全部置为已读（官方语义），UI 上进入未读 Tab 前提示或直接刷新角标为 0。

#### 5.2.13 鸿蒙专栏（新增 `/harmony`）

- **结构**：`SingleChildScrollView` 三段分组——常用链接 / 开源项目 / 常用工具，每组标题 + 条目列表（名称 + 简介），点击进 `/web`。
- 数据：`harmonyIndexProvider`（`HarmonyData`）。

#### 5.2.14 工具列表（新增 `/tools`）

- **结构**：`GridView.count`（2 列）卡片——`flutter_svg`/`cached_network_image` 图标 + 名称 + `desc`；`isNew == 1` 显示 "NEW" `Badge`。
- **交互**：点击优先 `url_launcher` 外跳浏览器（官方提示详情页可能未适配移动端），或进 `/web`。

#### 5.2.15 TODO 工具（新增 `/todo`，需登录，v2 API）

- **结构**：`AppBar` + 状态 `TabBar`（待办 / 已完成）+ 筛选 `DropdownButton`（优先级、分类）+ 分页列表 + `FloatingActionButton` 新增。
- **列表项**：`CheckboxListTile` 风格——标题、内容摘要、截止日期、优先级色条；勾选完成、侧滑删除、点击编辑 `BottomSheet` 表单。
- 接口细节以官方 v2 文档（blog/show/2442）为准，建议放最后迭代。

#### 5.2.16 我的 Profile（改造静态页）

- 接入 `authProvider`：未登录显示"点击登录"头部（跳 `/sign_in`）；已登录显示昵称/ID/积分（12.1 实时拉取，替换写死的 1024）。
- 菜单接入真实路由：我的收藏 → `/collect`、我的积分 → `/coin`、我的分享 → `/square/mine`、站内消息 → `/message`（带角标）、TODO → `/todo`、设置 → `/setting`（已有）、退出登录（二次确认 → `logout()` → 清登录态）。

### 5.3 组件选型表

#### A. 现有依赖直接复用

| 包 | 用途 | 适用模块 |
| --- | --- | --- |
| `flutter_screenutil` | 屏幕适配 `.w/.h/.sp` | 全部页面 |
| `flutter_riverpod` + `riverpod_annotation` | 状态管理（见 4.4） | 全部模块 |
| `dio` + `pretty_dio_logger` | 网络请求与调试日志 | 全部模块 |
| `freezed` + `json_serializable` | 不可变模型 / JSON 序列化（见 4.2） | 全部模块 |
| `go_router` | 路由 + 登录守卫 redirect（见 4.5） | 全部模块 |
| `cached_network_image` | 项目封面、教程封面、头像、工具图标 | 项目、教程、广场、工具 |
| `carousel_slider` | Banner 轮播（已用于首页） | 首页（可复用到鸿蒙/推荐位） |
| `webview_flutter` | 文章/教程/问答详情 H5；`onNavigationRequest` 拦截恶意跳转（官方 1.1 建议） | 全部文章类详情 |
| `flutter_easyloading` / `fluttertoast` | 加载指示、结果提示 | 登录、注册、分享、收藏操作 |
| `share_plus` | 分享文章给好友 | 文章详情、广场 |
| `flutter_svg` | SVG 图标（工具图标等） | 工具列表、空态插画 |
| `rive` | 登录页 Logo 动画、空态动画 | 登录、空列表 |
| `hive` | 搜索历史、草稿箱本地存储 | 搜索 |
| `shared_preferences` | 登录态标记、轻量配置 | 认证 |
| `flex_color_scheme` | 主题配色 | 全部页面 |

#### B. 建议新增的主流包

| 包 | 版本建议 | 用途 | 适用模块 | 选型理由 |
| --- | --- | --- | --- | --- |
| `easy_refresh` | ^3.x | 下拉刷新 + 上拉加载 | 全部分页列表 | 当前 Flutter 社区最主流的分页刷新组件，与 `ListView/CustomScrollView` 兼容好，替代手写 `RefreshIndicator` + 滚动监听 |
| `shimmer` | ^3.x | 骨架屏占位 | 全部分页列表首屏 | 轻量、官方样例常用方案 |
| `badges` | ^3.x | 未读消息角标 | 我的页、消息入口 | 社区标准角标组件 |
| `flutter_html` | ^3.x | 富文本渲染（问答内容/评论/消息、文章标题 HTML 解码） | 问答、消息、文章条目 | 官方数据含 HTML 标签（`descMd`、评论内容），必需 |
| `dio_cookie_manager` + `cookie_jar` | 最新 | 登录 Cookie 自动持久化 | 认证及全部需登录接口 | 替换被注释的手写 `CookieInterceptors`，自动处理 Set-Cookie 与 logout 清理，与 dio 5 配套主流方案 |
| `url_launcher` | ^6.x | 外跳浏览器 | 常用网站、工具列表 | 官方提示工具详情未适配移动端，外跳体验更好 |
| `flutter_form_builder` | ^10.x（可选） | 表单构建与校验 | 登录、注册、分享文章、收藏编辑 | 表单较多时可减少样板代码；小项目也可只用原生 `Form` |
| `marquee` | ^2.x（可选） | 长文本滚动 | 公告、长标题 | 可选增强 |

#### C. Flutter SDK 内置组件选型速查

| 场景 | 推荐组件 |
| --- | --- |
| 分类 Tab（项目/公众号） | `DefaultTabController` + `TabBar`（`isScrollable: true`）+ `TabBarView` |
| 左右联动（体系/导航） | 左 `ListView` + 右 `CustomScrollView`（锚点滚动可配 `scrollable_positioned_list`） |
| 侧滑删除（收藏/我的分享） | `Dismissible` + 二次确认 `AlertDialog` |
| 标签流（热词/二级分类/导航站点） | `Wrap` + `ActionChip` |
| 底部操作（编辑收藏） | `showModalBottomSheet` |
| 下拉菜单（TODO 筛选） | `DropdownButton` / `PopupMenuButton` |
| 列表分隔/吸顶分组 | `SliverPersistentHeader`（导航分组标题吸顶） |
| 空态/错误态 | 自定义 `EmptyView`（`rive` 动画 + 重试按钮） |

---

## 6. 开发优先级建议

| 批次 | 内容 | 理由 |
| --- | --- | --- |
| P0 | Cookie 持久化（4.6）+ 登录/注册/退出 + Auth Provider + 路由守卫 | 一切需登录功能的前置；同时打通"我的"页真实数据 |
| P1 | 搜索（热词+历史+结果）、体系（含体系文章）、导航接入真实数据 | 已有常量/模型/假 UI，改造成本低、收益高 |
| P2 | 收藏（文章+网址）、项目、问答接入真实数据 + 评论 | 核心用户闭环功能 |
| P3 | 广场（列表/分享/我的分享）、积分（排行/记录）、公众号 | 内容生态扩展 |
| P4 | 个人信息增强、站内消息、教程、鸿蒙专栏、最受欢迎板块、工具列表、最新项目 Tab | 增量体验 |
| P5 | TODO 工具 v2 | 独立工具属性，官方另立文档，最后迭代 |

> 每批次落地时：先补 `ApiAddress` 常量与模型（跑 `build_runner` 生成 freezed/json 代码），再写 Repository + Provider，最后接 UI 与路由；全程保持 `Articles` 实体与 `ArticleItemWidget` 公共组件复用，避免重复造轮子。
