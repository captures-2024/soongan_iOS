import ProjectDescription

let project = Project(
    name: "UserProfileFeature",
    packages: [
      .package(
        url: "https://github.com/pointfreeco/swift-composable-architecture.git",
        from: "1.17.0"
      ),
    ],
    targets: [
        .target(
            name: "UserProfileFeature",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.captures.UserProfileFeature.Soongan",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .external(name: "ComposableArchitecture"),
                .project(target: "DesignSystem", path: "../../DesignSystem"),
                .project(target: "Shared", path: "../../Shared"),
                .project(target: "CoreNetwork", path: "../../Core/CoreNetwork"),
                .project(target: "AppDependencies", path: "../../AppDependencies"),
            ]
        )
    ]
)
