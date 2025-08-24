import ProjectDescription

let project = Project(
    name: "Soongan",
    organizationName: "Captures",
    settings: .settings(
        base: [
            "DEVELOPMENT_TEAM": "N3H27N59VG",
            "OTHER_LDFLAGS": ["-all_load"]
        ],
        configurations: [
            .debug(name: "Debug", xcconfig: .relativeToRoot("Soongan/Configs/Debug.xcconfig")),
        ]
    ),
    targets: [
        .target(
            name: "Soongan",
            destinations: .iOS,
            product: .app,
            bundleId: "com.captures.Soongan",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                    "BASE_URL": "$(BASE_URL)",
                    "PROJECT_KEY": "$(PROJECT_KEY)",
                    "ACCESS_TOKEN_KEY": "$(ACCESS_TOKEN_KEY)",
                    "REFRESH_TOKEN_KEY": "$(REFRESH_TOKEN_KEY)",
                    "KAKAO_NATIVE_APP_KEY": "$(KAKAO_NATIVE_APP_KEY)",
                    "CFBundleURLTypes": [
                        [
                            "CFBundleURLSchemes": [ "kakao$(KAKAO_NATIVE_APP_KEY)" ]
                        ]
                    ],
                    "LSApplicationQueriesSchemes": [
                      "kakaokompassauth",
                      "kakaolink"
                    ],
                    "UIBackgroundModes": [
                        "remote-notification"
                    ],
                    "UIAppFonts": [
                        "Pretendard-Bold.ttf",
                        "Pretendard-SemiBold.ttf",
                        "Pretendard-Medium.ttf",
                        "Pretendard-Regular.ttf",
                    ]
                ]
            ),
            sources: ["Soongan/Sources/**"],
            resources: [
                "Soongan/Resources/**",
                "Soongan/GoogleService-Info.plist"
            ],
            entitlements: .file(path: "Soongan/Soongan.entitlements"),
            dependencies: [
                .external(name: "ComposableArchitecture"),
                .external(name: "FirebaseMessaging"),
                .external(name: "Kingfisher"),
                .project(target: "Resource", path: "Resource"),
                .project(target: "Shared", path: "Shared"),
                .project(target: "DesignSystem", path: "DesignSystem"),
                .project(target: "AuthFeature", path: "Feature/AuthFeature"),
                .project(target: "SplashFeature", path: "Feature/SplashFeature"),
                .project(target: "HomeFeature", path: "Feature/HomeFeature"),
                .project(target: "ContestFeature", path: "Feature/ContestFeature"),
                .project(target: "AllTimeContestFeature", path: "Feature/AllTimeContestFeature"),
                .project(target: "MypageFeature", path: "Feature/MypageFeature"),
                .project(target: "ExplainFeature", path: "Feature/ExplainFeature"),
                .project(target: "CoreNetwork", path: "Core/CoreNetwork")
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
