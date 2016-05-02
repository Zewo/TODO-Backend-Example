import PackageDescription

let package = Package(
    name: "TodoBackend",
    dependencies: [
        .Package(url: "https://github.com/Zewo/Zewo.git", majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/Resource.git", majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/StandardOutputAppender", majorVersion: 0, minor: 5),
    ]
)
