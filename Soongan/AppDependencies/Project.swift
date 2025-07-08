import ProjectDescription

let project = Project(
    name: "AppDependencies",
    packages: [
        // 👇 TCA의 메인 저장소가 아닌, 의존성 주입 라이브러리를 추가합니다.
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.2.2")
    ],
    targets: [
        .target(
            name: "AppDependencies",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.captures.Dependencies.Soongan",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .external(name: "Dependencies"),
                .project(target: "CoreUserDefault", path: "../Core/CoreUserDefault")
            ]
        )
    ]
)

