import ProjectDescription

let project = Project(
    name: "ContestFeature",
    targets: [
        .target(
            name: "ContestFeature",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.captures.ContestFeature.Soongan",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .external(name: "ComposableArchitecture"),
                .project(target: "DesignSystem", path: "../../DesignSystem"),
                .project(target: "CoreNetwork", path: "../../Core/CoreNetwork"),
                .project(target: "CoreUserDefault", path: "../../Core/CoreUserDefault"),
                .project(target: "DetailContestFeature", path: "../DetailContestFeature"),
                .project(target: "PostPictureFeature", path: "../PostPictureFeature"),
            ]
        )
    ]
)
