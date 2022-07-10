// swift-tools-version: 5.4

import PackageDescription

let package = Package(
    name: "swiftui-drag-and-drop",
    platforms: [
        .iOS(.v13), .macOS(.v10_15), .watchOS(.v6)
    ],
    products: [
        .library(
            name: "DragAndDrop",
            targets: ["DragAndDrop"]),
    ],
    targets: [
        .target(
            name: "DragAndDrop",
            dependencies: []),
        .testTarget(
            name: "DragAndDropTests",
            dependencies: ["DragAndDrop"]),
    ]
)
