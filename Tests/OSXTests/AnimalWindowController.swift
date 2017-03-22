//
//  AnimalWindowController.swift
//  Swinject
//
//  Created by Yoichi Tagaya on 8/1/15.
//  Copyright © 2015 Swinject Contributors. All rights reserved.
//

import AppKit

internal class AnimalWindowController: NSWindowController {
    internal var animal: Animal?
    
    internal required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    internal func hasAnimal(named name: String) -> Bool {
        return animal?.name == name
    }
}
