import ProjectDescription

let project = Project(
    name: "HomeFeature",
    targets: [
        .target(
            name: "HomeFeature",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.captures.HomeFeature.Soongan",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .external(name: "ComposableArchitecture"),
                .project(target: "DesignSystem", path: "../../DesignSystem"),
                .project(target: "Shared", path: "../../Shared"),
                .project(target: "CoreNetwork", path: "../../Core/CoreNetwork"),
                .project(target: "DetailContestFeature", path: "../DetailContestFeature"),
                .project(target: "PostPictureFeature", path: "../PostPictureFeature"),
                .project(target: "ExplainFeature", path: "../ExplainFeature"),
            ]
        )
    ]
)
