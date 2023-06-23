import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../modules/home/view.dart';
import '../../modules/main_wrapper/view.dart';
import '../../modules/navi/view.dart';
import '../../modules/profile/view.dart';
import '../../modules/question_and_answers/view.dart';
import '../../modules/sign_in/view.dart';
import '../../modules/sign_up/view.dart';
import '../../modules/welcome/view.dart';
import 'router_notifier.dart';
import 'router_path.dart';

final GlobalKey<NavigatorState> _rootKey =
    GlobalKey<NavigatorState>(debugLabel: 'rootKey');

final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellKey');

final routerProvider = Provider.autoDispose<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider.notifier);

  return GoRouter(
    navigatorKey: _rootKey,
    refreshListenable: notifier,
    debugLogDiagnostics: true,
    initialLocation: RouterPath.welcome.path,
    routes: routes,
    redirect: notifier.redirect,
  );
});

List<RouteBase> get routes => [
      GoRoute(
          path: RouterPath.welcome.path,
          name: RouterPath.welcome.description,
          builder: (_, __) => const WelcomePage()),
      GoRoute(
          path: RouterPath.signIn.path,
          name: RouterPath.signIn.description,
          builder: (_, __) => const SignInPage()),
      GoRoute(
          path: RouterPath.signUp.path,
          name: RouterPath.signUp.description,
          builder: (_, __) => const SignUpPage()),
      StatefulShellRoute.indexedStack(
        builder: (BuildContext context, GoRouterState state,
            StatefulNavigationShell navigationShell) {
          return MainWrapperPage(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            navigatorKey: _shellNavigatorKey,
            routes: <RouteBase>[
              ///首页
              GoRoute(
                path: RouterPath.home.path,
                name: RouterPath.home.description,
                builder: (_, __) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              ///问答
              GoRoute(
                path: RouterPath.qAnda.path,
                name: RouterPath.qAnda.description,
                builder: (_, __) => const QuestionAndAnswersPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              ///导航
              GoRoute(
                path: RouterPath.navi.path,
                name: RouterPath.navi.description,
                builder: (_, __) => const NaviPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              ///我的
              GoRoute(
                path: RouterPath.profile.path,
                name: RouterPath.profile.description,
                builder: (_, __) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ];
