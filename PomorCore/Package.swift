// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "PomorCore",
    platforms: [
        .iOS(.v16),
        .watchOS(.v9),
    ],
    products: [
        .library(
            name: "PomorCore",
            targets: ["PomorCore"]
        )
    ],
    targets: [
        .target(
            name: "PomorCore"
        )
    ]
)
