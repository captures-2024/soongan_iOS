import ProjectDescription

let project = Project(
    name: "CoreNetwork",
    targets: [
        .target(
            name: "CoreNetwork",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.captures.CoreNetwork.Soongan",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .external(name: "Alamofire"),
                .project(target: "CoreKeyChain", path: "../CoreKeyChain")
            ]
        )
    ]
)
