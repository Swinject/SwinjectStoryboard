// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "SwinjectStoryboard",
    platforms: [
        .macOS(.v10_14),
        .iOS(.v12),
        .tvOS(.v12),
    ],
    products: [
        .library(name: "SwinjectStoryboard", targets: ["SwinjectStoryboard"]),
    ],
    dependencies: [
        .package(url: "https://github.com/hades2308/Swinject.git", .upToNextMajor(from: "2.8.5")),
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
