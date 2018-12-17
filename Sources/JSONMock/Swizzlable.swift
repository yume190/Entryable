//
//  Swizzlable.swift
//  YumeAlamofireTests
//
//  Created by Yume on 2018/12/11.
//  Copyright © 2018 Yume. All rights reserved.
//

import Foundation

// http://blog.yaoli.site/post/如何优雅地在Swift4中实现Method-Swizzling
// http://jordansmith.io/handling-the-deprecation-of-initialize/

public protocol Swizzlable: class {
    static func swizzle()
}

internal class Swizzle {
    static func swizzle() {
        let typeCount = Int(objc_getClassList(nil, 0))
        let types = UnsafeMutablePointer<AnyClass>.allocate(capacity: typeCount)
        let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
        objc_getClassList(autoreleasingTypes, Int32(typeCount))
        for index in 0 ..< typeCount {
            if let swizzlable = types[index] as? Swizzlable.Type {
                swizzlable.swizzle()
            }
        }
        types.deallocate()
    }
}

//extension UIApplication {
//    private static let runOnce: Void = {
//        Swizzle.swizzle()
//    }()
//    
//    override open var next: UIResponder? {
//        // Called before applicationDidFinishLaunching
//        UIApplication.runOnce
//        return super.next
//    }
//}
