import Foundation

@objc
public protocol SwinjectStoryboardProtocol {

    /// Called by Swinject framework once before SwinjectStoryboard is instantiated.
    ///
    /// - Note:
    ///   Implement this method and setup the default container if you implicitly instantiate UIWindow
    ///   and its root view controller from "Main" storyboard.
    ///
    /// ```swift
    /// extension SwinjectStoryboard {
    ///     @objc class func setup() {
    ///         let container = defaultContainer
    ///         container.register(SomeType.self) {
    ///             _ in
    ///             SomeClass()
    ///         }
    ///         container.storyboardInitCompleted(ViewController.self) {
    ///             r, c in
    ///             c.something = r.resolve(SomeType.self)
    ///         }
    ///     }
    /// }
    /// ```
    @objc optional static func setup()
}
