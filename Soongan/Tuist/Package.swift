// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,]
        productTypes: [
            "ComposableArchitectureMacros": .macro,
            "Alamofire": .framework,
        ]
    )
#endif

let package = Package(
    name: "Soongan",
    dependencies: [
        // Add your own dependencies here:
        // .package(url: "https://github.com/Alamofire/Alamofire", from: "5.0.0"),
        // You can read more about dependencies here: https://docs.tuist.io/documentation/tuist/dependencies
        
        .package(url: "https://github.com/kakao/kakao-ios-sdk", from: "2.24.0"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.18.0"),
        .package(url: "https://github.com/pointfreeco/swift-navigation", from: "2.4.0"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.1"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.24.0"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMajor(from: "7.10.0"))
    ]
)
