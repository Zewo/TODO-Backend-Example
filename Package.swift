import PackageDescription

let package = Package(
    name: "TODOBackend",
    dependencies: [
        .Package(url: "https://github.com/Zewo/Zewo.git", majorVersion: 0, minor: 4)
    ]
)
