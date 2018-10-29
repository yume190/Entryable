// swift-tools-version:4.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "YumeAlamofire",
    products: [
        .library(name: "YumeAlamofire", type: .static, targets: ["YumeAlamofire"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "4.7.3"),
        .package(url: "https://github.com/yume190/JSONDecodeKit.git", from: "4.1.0"),
        .package(url: "https://github.com/yannickl/AwaitKit.git", from: "5.0.1"),
        .package(url: "https://github.com/mxcl/PromiseKit.git", from: "6.5.2")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "YumeAlamofire",
            dependencies: [
                "Alamofire",
                "JSONDecodeKit",
                "AwaitKit",
                "PromiseKit"
            ]
        ),
        .testTarget(
            name: "YumeAlamofireTests",
            dependencies: [
                "YumeAlamofire",
                "Alamofire",
                "JSONDecodeKit",
                "AwaitKit",
                "PromiseKit"
            ],
            path: "YumeAlamofireTests"
        ),
    ]
)
