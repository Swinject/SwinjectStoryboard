// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "SwinjectStoryboard",
    products: [
        .library(name: "SwinjectStoryboard", targets: ["SwinjectStoryboard"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "SwinjectStoryboard", path: "Sources"),
    ]
)
