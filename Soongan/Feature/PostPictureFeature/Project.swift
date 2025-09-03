import ProjectDescription

let project = Project(
    name: "PostPictureFeature",
    targets: [
        .target(
            name: "PostPictureFeature",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.captures.PostPictureFeature.Soongan",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .external(name: "ComposableArchitecture"),
                .external(name: "Kingfisher"),
                .project(target: "DesignSystem", path: "../../DesignSystem"),
                .project(target: "Shared", path: "../../Shared"),
                .project(target: "CoreNetwork", path: "../../Core/CoreNetwork"),
            ]
        )
    ]
)