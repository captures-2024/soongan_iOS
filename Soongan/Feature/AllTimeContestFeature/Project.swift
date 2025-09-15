import ProjectDescription

let project = Project(
    name: "AllTimeContestFeature",
    targets: [
        .target(
            name: "AllTimeContestFeature",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.captures.AllTimeContestFeature.Soongan",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .external(name: "ComposableArchitecture"),
                .project(target: "DesignSystem", path: "../../DesignSystem"),
                .project(target: "CoreNetwork", path: "../../Core/CoreNetwork"),
                .project(target: "Shared", path: "../../Shared"),
                .project(target: "DetailContestFeature", path: "../DetailContestFeature"),
                .project(target: "ExplainFeature", path: "../ExplainFeature"),
            ]
        )
    ]
)
