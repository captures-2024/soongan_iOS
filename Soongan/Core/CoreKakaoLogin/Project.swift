import ProjectDescription

let project = Project(
    name: "CoreKakaoLogin",
    targets: [
        .target(
            name: "CoreKakaoLogin",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.captures.CoreKakaoLogin.Soongan",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .external(name: "KakaoSDKCommon"),
                .external(name: "KakaoSDKAuth"),
                .external(name: "KakaoSDKUser")
            ]
        )
    ]
)
