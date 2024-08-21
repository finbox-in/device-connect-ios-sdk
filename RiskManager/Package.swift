// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RiskManager",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        // Products define the excecutables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "RiskManager",
            targets: ["RiskManager"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        .target(
            name: "RiskManager",
            dependencies: [],
            path: "RiskManager"
        ),
        .testTarget(
            name: "RiskManagerTests",
            dependencies: ["RiskManager"],
            path: "Tests"
        ),
    ]
)
