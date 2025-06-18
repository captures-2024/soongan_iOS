import ProjectDescription

let project = Project(
    name: "AllTimeContestFeature",
    packages: [
      .package(
        url: "https://github.com/pointfreeco/swift-composable-architecture.git",
        from: "1.17.0"
      ),
    ],
    targets: [
        .target(
            name: "AllTimeContestFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.captures.AllTimeContestFeature.Soongan",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .external(name: "ComposableArchitecture"),
                .project(target: "DesignSystem", path: "../../DesignSystem"),
                .project(target: "CoreNetwork", path: "../../Core/CoreNetwork"),
                .project(target: "Shared", path: "../../Shared")
            ]
        )
    ]
)
