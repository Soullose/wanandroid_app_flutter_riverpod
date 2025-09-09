# wanandroid_app_flutter_riverpod

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### 使用riverpod代码生成模式 下面指令选一个执行即可(第一次将项目clone下来时需执行一下下面的命令)

```shell
dart run build_runner watch
dart run build_runner build
```
## frb gen
```shell
flutter_rust_bridge_codegen generate --watch
```

##打包命令

```shell
flutter build apk --release --target-platform android-arm,android-arm64,android-x64 --split-per-abi
```
### 结构调整
![结构调整](Screenshot_20250726_193056_com.tencent.mm.jpg)