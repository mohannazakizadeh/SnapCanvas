// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "spm-modules",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Networking",
            targets: ["Networking"]),
        .library(
            name: "NetworkingInterface",
            targets: ["NetworkingInterface"]),
        .library(name: "SwiftUIComponents", targets: ["SwiftUIComponents"])
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Networking",
            dependencies: ["NetworkingInterface"]),
        .target(
            name: "NetworkingInterface"),
        .target(name: "SwiftUIComponents")
    ]
)
