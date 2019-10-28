import Foundation

internal extension DispatchQueue {

    private static var _onceTracker: [String] = []

    static func once(token: String, block: () -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }

        if _onceTracker.contains(token) {
            return
        }

        _onceTracker.append(token)
        block()
    }
}

extension Selector {
    @available(iOS, message: "")
    public static func swiftInit(_ string: String) -> Self {
        return self.init(string)
    }
}
