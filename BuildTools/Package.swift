// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "BuildTools",
	platforms: [.macOS(.v10_11)],
    dependencies: [
        .package(url: "https://github.com/mac-cain13/R.swift", from: "5.3.0"),
    ]
)
