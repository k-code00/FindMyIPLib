// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FindMyIPLib",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "FindMyIPLib",
            targets: ["FindMyIPLib"]),
    ],
    dependencies: [
        // Alamofire dependency
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.1"),
    ],
    targets: [
        .target(
            name: "FindMyIPLib",
            dependencies: ["Alamofire"]), // Include Alamofire in the target dependencies
        .testTarget(
            name: "FindMyIPLibTests",
            dependencies: ["FindMyIPLib"]),
    ]
)
