// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GuardianBlockLists",
    products: [
        .library(name: "GuardianBlockLists", targets: ["GuardianBlockLists"]),
        .executable(name: "GuardianBlockListsUpdater", targets: ["GuardianBlockListsUpdater"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "GuardianBlockLists",
            dependencies: [],
            resources: [
                .copy("./Lists/adlist.txt"),
                .copy("./Lists/contentlist.txt"),
                .copy("./Lists/keywordlist.txt"),
                .copy("./Lists/urllist.txt"),
            ]),
        .target(
            name: "GuardianBlockListsUpdater",
            dependencies: []),
        .testTarget(
            name: "GuardianBlockListsTests",
            dependencies: ["GuardianBlockLists"]),
    ]
)
