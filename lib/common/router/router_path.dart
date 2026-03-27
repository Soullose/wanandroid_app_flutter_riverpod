enum RouterPath {
  welcome,
  signIn,
  signUp,
  mainWrapper,
  home,
  qAnda,
  navi,
  profile,
  setting,
  logManagement,
  networkError;

  String get path {
    switch (this) {
      case RouterPath.welcome:
        return '/welcome_page';
      case RouterPath.signIn:
        return '/sign_in';
      case RouterPath.signUp:
        return '/sign_up';
      case RouterPath.mainWrapper:
        return '/main_wrapper';
      case RouterPath.home:
        return '/home';
      case RouterPath.qAnda:
        return '/qAnda';
      case RouterPath.navi:
        return '/navi';
      case RouterPath.profile:
        return '/profile';
      case RouterPath.setting:
        return '/setting';
      case RouterPath.logManagement:
        return '/log_management';
      case RouterPath.networkError:
        return '/network_error';
    }
  }

  String get description {
    switch (this) {
      case RouterPath.welcome:
        return '欢迎页';
      case RouterPath.signIn:
        return '登录';
      case RouterPath.signUp:
        return '注册';
      case RouterPath.mainWrapper:
        return '主页';
      case RouterPath.home:
        return '首页';
      case RouterPath.qAnda:
        return '问答';
      case RouterPath.navi:
        return '导航';
      case RouterPath.profile:
        return '我的';
      case RouterPath.setting:
        return '设置';
      case RouterPath.logManagement:
        return '日志管理';
      case RouterPath.networkError:
        return '网络错误';
    }
  }
}
