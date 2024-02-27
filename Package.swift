// swift-tools-version: 5.9

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
