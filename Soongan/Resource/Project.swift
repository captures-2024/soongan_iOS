import ProjectDescription

let project = Project(
    name: "Resource",
    targets: [
        .target(
            name: "Resource",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.captures.Resource",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: []
        )
    ]
)
