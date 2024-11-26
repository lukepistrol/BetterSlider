// swift-tools-version: 6.0

import PackageDescription

let betterSlider = "BetterSlider"

let package = Package(
    name: betterSlider,
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: betterSlider,
            targets: [betterSlider]
        ),
    ],
    targets: [
        .target(
            name: betterSlider
        ),
    ]
)
