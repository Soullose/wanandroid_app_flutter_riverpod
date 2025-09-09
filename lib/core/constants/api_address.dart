class ApiAddress {
  const ApiAddress._();

  ///首页

  ///首页banner
  static const String bannerUrl = '/banner/json';

  ///常用网站
  static const String friendUrl = 'friend/json';

  ///搜索热词
  static const String hotkeyUrl = '/hotkey/json';

  ///置顶文章
  static const String topArticleUrl = '/article/top/json';

  ///首页文章列表
  static String articleUrl({required int pageNumber}) =>
      '/article/list/$pageNumber/json';

  ///体系

  ///体系数据
  static const String systemTree = '/tree/json';

  ///知识体系下的文章 https://www.wanandroid.com/article/list/0/json?cid=60 cid 取自体系id
  ///按照作者昵称搜索文章 https://wanandroid.com/article/list/0/json?author=鸿洋

  ///导航

  ///导航数据
  static const String naviUrl = '/navi/json';

  ///项目

  ///项目分类
  static const String projectTypeUrl = '/project/tree/json';

  ///项目列表数据 https://www.wanandroid.com/project/list/1/json?cid=294 cid 取自项目分类id

  ///登录与注册

  ///登录
  static const String signIn = '/user/login';

  ///注册
  static const String signUp = '/user/register';

  ///退出
  static const String signOut = '/user/logout/json';

  ///收藏

  ///收藏列表
  static String collectListUrl({required int pageNumber}) =>
      '/lg/collect/list/$pageNumber/json';

  ///收藏站内文章
  static String collectInUrl({required String id}) => '/lg/collect/$id/json';
}
