// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Roxas",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "Roxas",
            targets: ["Roxas"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Roxas",
            path: "Roxas",
            exclude: [
                "Info.plist",
                "Roxas-Prefix.pch"
            ],
            resources: [
                .process("RSTCollectionViewCell.xib", localization: nil),
                .process("RSTPlaceholderView.xib", localization: nil),
            ],
            publicHeadersPath: ""
        )
    ]
)
