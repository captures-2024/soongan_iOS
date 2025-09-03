import ProjectDescription

let project = Project(
    name: "MypageFeature",
    targets: [
        .target(
            name: "MypageFeature",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.captures.MypageFeature.Soongan",
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
                .project(target: "DetailContestFeature", path: "../DetailContestFeature"),
                .project(target: "PostPictureFeature", path: "../PostPictureFeature"),
            ]
        )
    ]
)
