// swift-tools-version:5.1
import PackageDescription

 let package = Package(
    name: "SwinjectStoryboard",
    platforms: [
        .macOS(.v10_10),
        .iOS(.v9),
        .tvOS(.v9),
    ],
    products: [
        .library(name: "SwinjectStoryboard", targets: ["SwinjectStoryboard"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Swinject/Swinject.git", .upToNextMajor(from: "2.7.1")),
    ],
    targets: [
        .target(name: "SwinjectStoryboard", dependencies: ["Swinject"], path: "Sources"),
    ]
)
