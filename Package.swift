import PackageDescription

let package = Package(
    name: "YumeAlamofire",
    products: [
        .library(name: "YumeAlamofire", type: .static, targets: ["YumeAlamofire"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "4.4.0"),
        .package(url: "https://github.com/yume190/JSONDecodeKit.git", from: "4.0.1"),
    ],
    targets: [
        .target(
            name: "YumeAlamofire",
            dependencies: [
                "Alamofire",
                "JSONDecodeKit",
            ],
            path: "YumeAlamofire/Lib"
        ),
    ]
)
