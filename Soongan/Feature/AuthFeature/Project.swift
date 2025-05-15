import ProjectDescription

let project = Project(
    name: "AuthFeature",
    packages: [
      .package(
        url: "https://github.com/pointfreeco/swift-composable-architecture.git",
        from: "1.17.0"
      ),
    ],
    targets: [
        .target(
            name: "AuthFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.captures.AuthFeature.Soongan",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .external(name: "ComposableArchitecture"),
                .project(target: "DesignSystem", path: "../../DesignSystem")
            ]
        )
    ]
)
