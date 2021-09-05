// swift-tools-version:5.3
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
        .target(
            name: "SwinjectStoryboard-ObjC",
            path: "Sources/ObjectiveC",
            cSettings: [
                .headerSearchPath("Others")
            ]
        ),
        .target(
            name: "SwinjectStoryboard",
            dependencies: [
                "Swinject",
                "SwinjectStoryboard-ObjC"
            ],
            path: "Sources",
            exclude: [
                "ObjectiveC",
                "Info.plist"
            ]
        ),
    ]
)
