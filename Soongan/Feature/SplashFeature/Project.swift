import ProjectDescription

let project = Project(
    name: "SplashFeature",
    targets: [
        .target(
            name: "SplashFeature",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.captures.SplashFeature.Soongan",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .external(name: "ComposableArchitecture"),
                .project(target: "DesignSystem", path: "../../DesignSystem"),
                .project(target: "CoreNetwork", path: "../../Core/CoreNetwork"),
                .project(target: "AppDependencies", path: "../../AppDependencies")
            ]
        )
    ]
)
