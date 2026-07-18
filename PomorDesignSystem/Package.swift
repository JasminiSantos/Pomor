// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "PomorDesignSystem",
    platforms: [
        .iOS(.v16),
        .watchOS(.v9),
        .macOS(.v13),
    ],
    products: [
        .library(name: "PomorDesignSystem", targets: ["PomorDesignSystem"]),
    ],
    targets: [
        .target(
            name: "PomorDesignSystem",
            resources: [
                .process("Resources"),
            ]
        ),
    ]
)
