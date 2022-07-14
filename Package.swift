// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Entryable",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v10),
        .tvOS(.v10),
        .watchOS(.v3)
    ],
    products: [
        .library(name: "Entryable", type: .static, targets: ["Entryable"]),
        .library(name: "RxEntryable", type: .static, targets: ["RxEntryable"]),
        //        .library(name: "RxYumeAlamofire", type: .static, targets: ["Rx"]),
        //        .library(name: "AwaitYumeAlamofire", type: .static, targets: ["Await"]),
        //        .library(name: "JSONMock", type: .static, targets: ["JSONMock"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        
        // 5.4.4
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.4.4"),
        .package(url: "https://github.com/ReactiveX/RxSwift", from: "6.2.0")
        
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Entryable",
            dependencies: [
                "Alamofire",
                
            ]
        ),
        .target(
            name: "JSONMock",
            dependencies: [
                "Entryable",
            ]
        ),
        .target(
            name: "RxEntryable",
            dependencies: [
                "Entryable",
                "Alamofire",
                "RxSwift",
            ]
        ),
        .testTarget(
            name: "EntryableTests",
            dependencies: [
                "Entryable",
                "RxEntryable",
                "JSONMock",
                
                "Alamofire",
                "RxSwift",
                .product(name: "RxRelay", package: "RxSwift")
            ]
            //                    path: "YumeAlamofireTests"
        ),
    ]
)
