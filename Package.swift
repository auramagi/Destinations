// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "Destinations",
    platforms: [.iOS(.v15), .macOS(.v12), .macCatalyst(.v15), .tvOS(.v15), .watchOS(.v8)],
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
