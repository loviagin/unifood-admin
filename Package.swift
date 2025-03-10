// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "UniFoodAdmin",
    platforms: [
        .iOS(.v15)
    ],
    dependencies: [
        .package(url: "https://github.com/twostraws/CodeScanner", from: "2.3.3")
    ],
    targets: [
        .target(
            name: "UniFoodAdmin",
            dependencies: ["CodeScanner"]
        )
    ]
) 