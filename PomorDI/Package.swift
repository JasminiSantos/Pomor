// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "PomorDI",
    platforms: [
        .iOS(.v16),
        .watchOS(.v9),
    ],
    products: [
        .library(name: "PomorDI", targets: ["PomorDI"]),
    ],
    targets: [
        .target(name: "PomorDI"),
    ]
)
