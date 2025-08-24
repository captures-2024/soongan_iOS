import ProjectDescription

let project = Project(
    name: "DetailContestFeature",
    targets: [
        .target(
            name: "DetailContestFeature",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.captures.DetailContestFeature.Soongan",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .external(name: "ComposableArchitecture"),
                .project(target: "DesignSystem", path: "../../DesignSystem"),
                .project(target: "CoreNetwork", path: "../../Core/CoreNetwork"),
                .project(target: "CoreUserDefault", path: "../../Core/CoreUserDefault"),
                .project(target: "UserProfileFeature", path: "../UserProfileFeature"),
            ]
        )
    ]
)
