// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ManaTelugu",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ManaTelugu",
            targets: ["ManaTelugu"])
    ],
    dependencies: [
        .package(url: "https://github.com/supabase/supabase-swift", from: "2.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ManaTelugu",
            dependencies: [
                .product(name: "Supabase", package: "supabase-swift")
            ],
            path: "ManaTelugu",
            exclude: [
                "Info.plist",
                "LaunchScreen.storyboard",
                "PrivacyInfo.xcprivacy",
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "ManaTeluguTests",
            dependencies: ["ManaTelugu"],
            path: "ManaTeluguTests"
        ),
    ]
)
