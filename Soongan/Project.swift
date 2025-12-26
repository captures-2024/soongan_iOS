import ProjectDescription

// MARK: - Settings

let projectSettings: Settings = .settings(
    base: [
        "MARKETING_VERSION": "1.0.0",
        "CURRENT_PROJECT_VERSION": "6",
        "DEVELOPMENT_TEAM": "9QK3G4VF9N",
        "OTHER_LDFLAGS": ["-all_load"]
    ],
    configurations: [
        .debug(name: "Debug", xcconfig: .relativeToRoot("Soongan/Configs/Debug.xcconfig")),
        .release(name: "Release", xcconfig: .relativeToRoot("Soongan/Configs/Release.xcconfig")),
    ]
)


let project = Project(
    name: "Soongan",
    organizationName: "Captures",
    options: .options(
        defaultKnownRegions: ["Ko"],
        developmentRegion: "Ko",
    ),
    settings: projectSettings,
    targets: [
        .target(
            name: "Soongan",
            destinations: [.iPhone],
            product: .app,
            bundleId: "com.captures.Soongan",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UIUserInterfaceStyle": "Light",
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                    "BASE_URL": "$(BASE_URL)",
                    "PROJECT_KEY": "$(PROJECT_KEY)",
                    "ACCESS_TOKEN_KEY": "$(ACCESS_TOKEN_KEY)",
                    "REFRESH_TOKEN_KEY": "$(REFRESH_TOKEN_KEY)",
                    "KAKAO_NATIVE_APP_KEY": "$(KAKAO_NATIVE_APP_KEY)",
                    "CFBundleShortVersionString": "$(MARKETING_VERSION)",
                    "CFBundleDisplayName": "순간",
                    "CFBundleVersion": "$(CURRENT_PROJECT_VERSION)",
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
