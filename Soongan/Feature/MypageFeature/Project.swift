import ProjectDescription

let project = Project(
    name: "MypageFeature",
    packages: [
      .package(
        url: "https://github.com/pointfreeco/swift-composable-architecture.git",
        from: "1.17.0"
      ),
    ],
    targets: [
        .target(
            name: "MypageFeature",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.captures.MypageFeature.Soongan",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .external(name: "ComposableArchitecture"),
                .project(target: "DesignSystem", path: "../../DesignSystem"),
                .project(target: "Shared", path: "../../Shared"),
                .project(target: "CoreNetwork", path: "../../Core/CoreNetwork"),
                .project(target: "AppDependencies", path: "../../AppDependencies"),
                .project(target: "DetailContestFeature", path: "../DetailContestFeature"),
            ]
        )
    ]
)
