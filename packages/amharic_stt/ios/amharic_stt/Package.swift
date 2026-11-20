// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "amharic_stt",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "amharic-stt", targets: ["amharic_stt"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "amharic_stt",
            dependencies: [],
            resources: [
                // The plugin records audio (a required-reason API), so it ships a privacy manifest.
                .process("PrivacyInfo.xcprivacy"),
            ]
        )
    ]
)
