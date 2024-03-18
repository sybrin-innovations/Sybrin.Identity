// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Sybrin.Identity",
    defaultLocalization: "en",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Sybrin.Identity",
            targets: ["Sybrin.Identity"]),
        
    ],
    dependencies: [
        .package(url: "https://github.com/sybrin-innovations/Sybrin.Common", branch: "main"),
//        .package(url: "https://github.com/d-date/google-mlkit-swiftpm", .upToNextMajor(from: "3.2.1")),
//        .package(url: "https://github.com/kientux/google-mlkit-spm.git", from: "0.0.2"),
        ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Sybrin.Identity",
            dependencies: [.product(name: "Sybrin.Common", package: "Sybrin.Common")]),
    ]
)
