# 整体架构方案：

swift + swiftUI + MVVM + Clean Architecture

对于现在这个项目来说，可以使用layer First的架构，其实可以，也比较简单。但是考虑到长期发展，以及业务增多的可能性，维持边界感和多团队宾兴。这里使用feature first架构。

## 环境与支持

| 项目       | 信息                |
| ---------- | ------------------- |
| 支持平台   | iPhone、iPad、macOS |
| Swift 版本 | Swift 5.9+          |
| 最低 iOS   | 17.0                |
| 最低 macOS | 14.0                |

## Code style guideline

严格遵守Swift的 style guideline，包括但不限于：
https://www.swift.org/documentation/api-design-guidelines/
实际的情况可以团队内部约定，扩展以及完善。
可以使用swiftLint来检查代码是否符合guideline。

## 功能与需求

- 搜索地点（支持输入防抖、取消过期请求）
- 查看当前天气
- 查看未来 7 天预报
- 加载中 / 错误（可重试）/ 空结果状态

## 非功能性要求

- 单元测试
- 天气api设计好，数据源可以随时替换，但不需要改动业务逻辑，即插即用。
- feature之间不能互相依赖
- 一些标准化的东西要组件化可复用，比如网络请求，UI组件等。
- 自适应布局（支持屏幕旋转）

## 可拓展性功能（将来可能要做）

- 多语言支持
- 定位当前位置天气。（需要权限流程和隐私说明）
- Appearance 支持。
- 是否需要缓存天气数据。
- 弱网的表现。

## 技术选型

- 天气api目前采用 Open-Meteo(https://open-meteo.com)。方便demo设计，因为不需要key等。实际情况可能考虑比如Apple的weatherKit等。

（注意： 如果涉及到使用api key一定要注意安全策略。不能放到代码仓库）

# Build & Run

1. 环境 Xcode 27.0
2. 打开Weatherly.xcodeproj, 选择 `Weatherly` scheme，Run
3. 不需要三方库，和额外配置。
4. 单元测试运行 Cmd + U

# CI&CD

1. 项目使用github actions来实现CI&CD。
2. 每次push到develop分支，会自动触发构建和测试。
3. 如果构建和测试通过，会自动部署到测试环境。（这里自动通知等暂不实现）

# workflow
- 单人开发，使用Githubflow，不采用gitflow
- `main` 分支始终保持可以编译测试通过。
- 一个分支开发一个功能，开发完成后合并到`main`分支命名使用`feature/`、`fix/`等前缀。
