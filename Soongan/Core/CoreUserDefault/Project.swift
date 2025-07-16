import ProjectDescription

let project = Project(
    name: "CoreUserDefault",
    targets: [
        .target(
            name: "CoreUserDefault",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.captures.CoreUserDefault.Soongan",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: []
        )
    ]
)
