import PackageDescription

let package = Package(
    name: "TODOBackend",
    dependencies: [
        .Package(url: "https://github.com/VeniceX/HTTPServer.git", majorVersion: 0, minor: 4),
        .Package(url: "https://github.com/Zewo/JSON.git", majorVersion: 0, minor: 4),
        .Package(url: "https://github.com/Zewo/Router.git", majorVersion: 0, minor: 4)
    ]
)
