// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "Destinations",
    platforms: [.iOS(.v14), .macOS(.v11), .macCatalyst(.v14), .tvOS(.v14), .watchOS(.v7)],
    products: [
        .library(
            name: "Destinations",
            targets: ["Destinations"]
        ),
    ],
    targets: [
        .target(
            name: "Destinations"),
    ]
)
