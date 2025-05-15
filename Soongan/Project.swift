import ProjectDescription

let project = Project(
    name: "Soongan",
    organizationName: "Captures",
    settings: .settings(
        base: [
            "DEVELOPMENT_TEAM": "9KHXTZ4SZ9"
        ]
    ),
    targets: [
        .target(
            name: "Soongan",
            destinations: .iOS,
            product: .app,
            bundleId: "com.captures.Soongan",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["Soongan/Sources/**"],
            resources: ["Soongan/Resources/**"],
            dependencies: [
                .external(name: "KakaoSDKCommon"),
                .external(name: "KakaoSDKAuth"),
                .external(name: "KakaoSDKUser"),
                .external(name: "ComposableArchitecture"),
                .project(target: "Resource", path: "Resource"),
                .project(target: "Shared", path: "Shared"),
                .project(target: "DesignSystem", path: "DesignSystem"),
                .project(target: "AuthFeature", path: "Feature/AuthFeature"),
                .project(target: "HomeFeature", path: "Feature/HomeFeature")
            ]
        ),
        .target(
            name: "SoonganTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.captures.SoonganTests",
            infoPlist: .default,
            sources: ["Soongan/Tests/**"],
            resources: [],
            dependencies: [.target(name: "Soongan")]
        ),
    ]
)
