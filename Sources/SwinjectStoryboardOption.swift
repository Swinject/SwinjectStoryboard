//
//  SwinjectStoryboardOption.swift
//  Swinject
//
//  Created by Yoichi Tagaya on 2/28/16.
//  Copyright © 2016 Swinject Contributors. All rights reserved.
//

import Swinject

#if os(iOS) || os(OSX) || os(tvOS)
internal struct SwinjectStoryboardOption: ServiceKeyOption {
    internal let controllerType: String

    func hash(into: inout Hasher) {
        into.combine(controllerType)
    }
    
    internal init(controllerType: Container.Controller.Type) {
        self.controllerType = String(reflecting: controllerType)
    }
    
    internal func isEqualTo(_ another: ServiceKeyOption) -> Bool {
        guard let another = another as? SwinjectStoryboardOption else {
            return false
        }
        
        return self.controllerType == another.controllerType
    }
    
    internal var hashValue: Int {
        return controllerType.hashValue
    }
    
    internal var description: String {
        return "Storyboard: \(controllerType)"
    }
}
#endif
