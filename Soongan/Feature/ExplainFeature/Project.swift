//import ProjectDescription
//
//let project = Project(
//    name: "ExplainFeature",
//    packages: [
//      .package(
//        url: "https://github.com/pointfreeco/swift-composable-architecture.git",
//        from: "1.17.0"
//      ),
//    ],
//    targets: [
//        .target(
//            name: "ExplainFeature",
//            destinations: .iOS,
//            product: .staticFramework,
//            bundleId: "com.captures.ExplainFeature.Soongan",
//            deploymentTargets: .iOS("17.0"),
//            infoPlist: .default,
//            sources: ["Sources/**"],
//            resources: [],
//            dependencies: [
//                .external(name: "ComposableArchitecture"),
//                .project(target: "DesignSystem", path: "../../DesignSystem"),
//                .project(target: "CoreNetwork", path: "../../Core/CoreNetwork"),
//                .project(target: "CoreUserDefault", path: "../../Core/CoreUserDefault"),
//            ]
//        )
//    ]
//)


import ProjectDescription

// MARK: - Project

// 프로젝트 이름을 상수로 정의하여 오타를 방지하고 관리를 용이하게 합니다.
let featureName = "ExplainFeature"

let project = Project(
    name: featureName,
    organizationName: "soongan",
    targets: [
        // =====================================================================
        // 1. 핵심 로직 (Framework) 타겟
        // - 이 타겟은 실제 프로덕션 앱에 포함될 재사용 가능한 모듈입니다.
        // =====================================================================
        .target(
            name: featureName,
            destinations: .iOS,
            product: .framework, // 다른 곳에서 import해서 쓸 수 있도록 .framework로 설정
            bundleId: "com.soongan.\(featureName).Soongan",
            deploymentTargets: .iOS("18.0"),
            sources: ["Sources/**"], // Feature의 핵심 소스 코드는 Sources 폴더에 위치
            resources: [], // 리소스가 있다면 ["Resources/**"] 추가
            dependencies: [
                .external(name: "ComposableArchitecture"),
                .project(target: "DesignSystem", path: "../../DesignSystem"),
                .project(target: "CoreNetwork", path: "../../Core/CoreNetwork"),
                .project(target: "CoreUserDefault", path: "../../Core/CoreUserDefault"),
            ]
        ),
        
        // =====================================================================
        // 2. 데모 앱 (App) 타겟
        // - 이 타겟은 ExplainFeature만 독립적으로 실행하여 테스트하기 위한 용도입니다.
        // - 최종 프로덕션 빌드에는 포함되지 않습니다.
        // =====================================================================
            .target(
                name: "\(featureName)App", // 타겟 이름: ExplainFeatureApp
                destinations: .iOS,
                product: .app, // 실행 가능한 앱이므로 .app으로 설정
                bundleId: "com.soongan.\(featureName)App",
                deploymentTargets: .iOS("18.0"),
                infoPlist: .extendingDefault(
                    with: [
                        "UILaunchScreen": [
                            "UIColorName": "",
                            "UIImageName": "",
                        ],
                        "UIAppFonts": [
                            "Pretendard-Bold.ttf",
                            "Pretendard-SemiBold.ttf",
                            "Pretendard-Medium.ttf",
                            "Pretendard-Regular.ttf",
                        ]
                    ]
                ), // 데모 앱을 위한 기본 Info.plist
                sources: ["Example/Sources/**"], // 데모 앱의 소스 코드는 Example/Sources 폴더에 위치
                resources: ["Example/Resources/**"], // 데모 앱에서만 사용할 리소스가 있다면 여기에 추가
                dependencies: [
                    // ✅ 데모 앱은 방금 위에서 정의한 핵심 로직 타겟을 의존합니다.
                    .target(name: featureName)
                ]
            ),
        
        // =====================================================================
        // 3. 유닛 테스트 타겟 (선택 사항이지만 권장)
        // - ExplainFeature의 로직을 테스트하기 위한 타겟입니다.
        // =====================================================================
            .target(
                name: "\(featureName)Tests",
                destinations: .iOS,
                product: .unitTests,
                bundleId: "com.soongan.\(featureName)Tests",
                sources: [], // 테스트 코드는 Tests 폴더에 위치
                dependencies: [
                    // ✅ 테스트 타겟은 핵심 로직 타겟을 의존합니다.
                    .target(name: featureName)
                ]
            )
    ]
)
