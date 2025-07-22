import ProjectDescription

let project = Project(
    name: "HomeFeature",
    packages: [
      .package(
        url: "https://github.com/pointfreeco/swift-composable-architecture.git",
        from: "1.17.0"
      ),
    ],
    targets: [
        .target(
            name: "HomeFeature",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.captures.HomeFeature.Soongan",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .external(name: "ComposableArchitecture"),
                .project(target: "DesignSystem", path: "../../DesignSystem"),
                .project(target: "Shared", path: "../../Shared"),
                .project(target: "CoreNetwork", path: "../../Core/CoreNetwork"),
                .project(target: "DetailContestFeature", path: "../DetailContestFeature"),
            ]
        )
    ]
)
