import PackageDescription

let package = Package(
    name: "TodoBackend",
    dependencies: [
        .Package(url: "https://github.com/VeniceX/HTTPServer.git", majorVersion: 0, minor: 7),
        .Package(url: "https://github.com/Zewo/Resource.git", majorVersion: 0, minor: 7),
        .Package(url: "https://github.com/Zewo/LogMiddleware.git", majorVersion: 0, minor: 7),
        .Package(url: "https://github.com/Zewo/JSONMediaType.git", majorVersion: 0, minor: 7),
    ]
)
