import ProjectDescription

let project = Project(
    name: "CoreAppleLogin",
    targets: [
        .target(
            name: "CoreAppleLogin",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.captures.CoreAppleLogin.Soongan",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: []
        )
    ]
)
