// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "RaspPiBluetooth",
    targets: [
        Target(name: "RaspPiBluetooth", dependencies: ["CoreServer"]),
        Target(name: "CoreServer")
    ],
    dependencies: [
        .Package(url: "git@github.com:PureSwift/GATT.git", majorVersion: 1)
    ]
)

#if os(macOS)
let dependency: Package.Dependency = .Package(url: "https://github.com/PureSwift/BluetoothDarwin.git", majorVersion: 1)
package.dependencies.append(dependency)
#elseif os(Linux)
let dependency: Package.Dependency = .Package(url: "https://github.com/PureSwift/BluetoothLinux.git", majorVersion: 3)
package.dependencies.append(dependency)
#endif