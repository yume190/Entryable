// swift-tools-version:4.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "YumeAlamofire",
    products: [
        .library(name: "YumeAlamofire", type: .static, targets: ["YumeAlamofire"]),
        .library(name: "RxYumeAlamofire", type: .static, targets: ["Rx"]),
        .library(name: "AwaitYumeAlamofire", type: .static, targets: ["Await"]),
        .library(name: "JSONMock", type: .static, targets: ["JSONMock"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "4.8.0"),
        .package(url: "https://github.com/yume190/JSONDecodeKit.git", from: "4.1.0"),
        .package(url: "https://github.com/yannickl/AwaitKit.git", from: "5.0.1"),
        .package(url: "https://github.com/ReactiveX/RxSwift", from: "4.4.0")
        
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
        .target(
            name: "JSONMock",
            dependencies: [
                "YumeAlamofire",
            ]
        ),

        .target(
            name: "Rx",
            dependencies: [
                "YumeAlamofire",
                "RxSwift"
            ]
        ),
        .target(
            name: "Await",
            dependencies: [
                "YumeAlamofire",
                "AwaitKit"
            ]
        ),
        .testTarget(
            name: "YumeAlamofireTests",
            dependencies: [
                "YumeAlamofire",
                "JSONMock",
                
                "Alamofire",
                "JSONDecodeKit",
                "AwaitKit",
                "PromiseKit"
            ],
            path: "YumeAlamofireTests"
        ),
    ]
)
