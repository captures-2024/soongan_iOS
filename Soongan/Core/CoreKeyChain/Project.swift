import ProjectDescription

let project = Project(
    name: "CoreKeyChain",
    targets: [
        .target(
            name: "CoreKeyChain",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.captures.CoreKeyChain.Soongan",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: []
        )
    ]
)
