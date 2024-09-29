import ProjectDescription

let project = Project(
    name: "TILSwift",
    targets: [
        .target(
            name: "TILSwift",
            destinations: .macOS,
            product: .app,
            bundleId: "io.tuist.TILSwift",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen.storyboard",
                ]
            ),
            sources: ["TILSwift/Sources/**"],
            resources: [
                .glob(pattern: "TILSwift/Resources/**", excluding: ["**/Content/**"]),
                .folderReference(path: "TILSwift/Resources/Content")
            ],
            dependencies: []
        ),
        .target(
            name: "TILSwiftTests",
            destinations: .macOS,
            product: .unitTests,
            bundleId: "io.tuist.TILSwiftTests",
            infoPlist: .default,
            sources: ["TILSwift/Tests/**"],
            resources: [],
            dependencies: [.target(name: "TILSwift")]
        ),
    ]
)
