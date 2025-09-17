import ProjectDescription

let project = Project(
    name: "DesignSystem",
    targets: [
        .target(
            name: "DesignSystem",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.captures.DesignSystem",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .external(name: "Kingfisher"),
                .project(target: "Resource", path: "../Resource"),
                .project(target: "Shared", path: "../Shared")
            ]
        )
    ]
)
