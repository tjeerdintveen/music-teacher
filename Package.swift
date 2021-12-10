// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Music",
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
    ],
    targets: [
        .target(name: "Music"), // New target
        .executableTarget(
            name: "MusicCLT", // Music is renamed to MusicCLT
            dependencies: [
                "Music", // MusicCLT depends on Music
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]),
        .testTarget(
            name: "MusicTests",
            dependencies: ["MusicCLT"]), // Now depends on MusicCLT
    ]
)

