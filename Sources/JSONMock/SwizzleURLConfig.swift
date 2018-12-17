// swiftlint:disable line_length
import Foundation

extension URLSessionConfiguration: Swizzlable {
    private static func swizzleDefault() {
        let defaultSessionConfiguration = class_getClassMethod(URLSessionConfiguration.self, #selector(getter: URLSessionConfiguration.default))
        let mockingDefaultSessionConfiguration = class_getClassMethod(URLSessionConfiguration.self, #selector(URLSessionConfiguration.mockingDefaultSessionConfiguration))
        method_exchangeImplementations(defaultSessionConfiguration!, mockingDefaultSessionConfiguration!)
    }

    private static func swizzleEphemeral() {
        let ephemeralSessionConfiguration = class_getClassMethod(URLSessionConfiguration.self, #selector(getter: URLSessionConfiguration.ephemeral))
        let mockingEphemeralSessionConfiguration = class_getClassMethod(URLSessionConfiguration.self, #selector(URLSessionConfiguration.mockingEphemeralSessionConfiguration))
        method_exchangeImplementations(ephemeralSessionConfiguration!, mockingEphemeralSessionConfiguration!)
    }

    public static func swizzle() {
        self.swizzleDefault()
        self.swizzleEphemeral()
    }
}

extension URLSessionConfiguration {
    @objc class func mockingDefaultSessionConfiguration() -> URLSessionConfiguration {
        let configuration = mockingDefaultSessionConfiguration()
        configuration.protocolClasses = [JSONMock.self] as [AnyClass] + configuration.protocolClasses!
        return configuration
    }

    @objc class func mockingEphemeralSessionConfiguration() -> URLSessionConfiguration {
        let configuration = mockingEphemeralSessionConfiguration()
        configuration.protocolClasses = [JSONMock.self] as [AnyClass] + configuration.protocolClasses!
        return configuration
    }
}
