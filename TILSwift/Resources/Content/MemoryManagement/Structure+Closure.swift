import Foundation

func log(_ message: String) {
    guard let data = message.data(using: .utf8) else { return }
    FileHandle.standardOutput.write(data)
}

final class SomeClass {
    var closure: (() -> Void)?

    init() {}

    deinit {
        log("Class deinit")
    }
}

struct AnyStructure {
    let someClass: SomeClass

    init(someClass: SomeClass) {
        self.someClass = someClass
        someClass.closure = doSomething
    }

    func doSomething() {

    }
}

_ = AnyStructure(someClass: SomeClass())

log("After setup")
