// swift-tools-version: 6.1
import PackageDescription

let package: Package = Package(
    name: "Stackboard",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        .executable(name: "Stackboard", targets: ["Stackboard"])
    ],
    dependencies: [
        .package(url: "https://github.com/soffes/HotKey", from: "0.2.1")
    ],
    targets: [
        .executableTarget(
            name: "Stackboard",
            dependencies: [
                .product(name: "HotKey", package: "HotKey")
            ],
            path: "Sources/Stackboard"
        )
    ]
)
