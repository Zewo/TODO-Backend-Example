import PackageDescription

let package = Package(
    name: "TodoBackend",
    dependencies: [
        .Package(url: "https://github.com/VeniceX/HTTPServer.git", majorVersion: 0, minor: 7),
        .Package(url: "../Resource", majorVersion: 0),
        .Package(url: "https://github.com/Zewo/LogMiddleware", majorVersion: 0, minor: 7),
        .Package(url: "https://github.com/Zewo/JSONMediaType", majorVersion: 0, minor: 7),
    ]
)
