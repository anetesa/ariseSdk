// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
// This package provides AriseMobileSdk v2 as a binary-only distribution.
// To use this package, add it to your project via:
//   .package(url: "https://github.com/your-org/arise-merchant-app.git", from: "2.0.0")
//
// Or use a specific version:
//   .package(url: "https://github.com/your-org/arise-merchant-app.git", exact: "2.0.0")

import PackageDescription

let package = Package(
    name: "AriseMobileSdk",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "AriseMobileSdk",
            targets: ["AriseMobileSdkWrapper"]
        ),
    ],
    dependencies: [
        // OpenAPI dependencies used by AriseMobileSdk
        // Using closed version ranges (patch updates only) to prevent breaking changes
        .package(url: "https://github.com/apple/swift-openapi-runtime", "1.8.3"..<"1.9.0"),
        .package(url: "https://github.com/apple/swift-openapi-urlsession", "1.2.0"..<"1.3.0"),
        
        // CloudCommerce dependencies
        // Using closed version ranges to prevent breaking changes
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", "1.8.2"..<"2.0.0"),
        .package(url: "https://github.com/apple/swift-certificates.git", "1.4.0"..<"2.0.0"),
        .package(url: "https://github.com/apple/swift-asn1", "1.2.0"..<"2.0.0"),
    ],
    targets: [
        // CloudCommerce binary target
        .binaryTarget(
            name: "CloudCommerce",
            path: "libs/CloudCommerce.xcframework"
        ),
        // AriseMobileSdk binary target
        // Note: Module name exported is "AriseMobileSdk"
        .binaryTarget(
            name: "AriseMobileSdkBinary",
            path: "libs/AriseMobileSdk.xcframework"
        ),
        // Wrapper target that links all dependencies with binary frameworks
        // This target re-exports the binary framework and ensures dependencies are available
        .target(
            name: "AriseMobileSdkWrapper",
            dependencies: [
                "AriseMobileSdkBinary",  // Provides "AriseMobileSdk" module
                "CloudCommerce",          // Provides "CloudCommerce" module
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
                .product(name: "OpenAPIURLSession", package: "swift-openapi-urlsession"),
                .product(name: "CryptoSwift", package: "CryptoSwift"),
                .product(name: "SwiftASN1", package: "swift-asn1"),
                .product(name: "X509", package: "swift-certificates"),
            ],
            path: "Sources/AriseMobileSdkWrapper"
        ),
    ]
)










