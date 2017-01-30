//
//  AnimalPagesViewController.swift
//  Swinject
//
//  Created by Jakub Vaňo on 27/10/16.
//  Copyright © 2016 Swinject Contributors. All rights reserved.
//

import UIKit
import Swinject

internal class AnimalPagesViewController: UIPageViewController {
    let animalPage: AnimalViewController

    required init?(coder aDecoder: NSCoder) {
        animalPage = UIStoryboard(
            name: "Pages",
            bundle: Bundle(for: AnimalPagesViewController.self)
        ).instantiateViewController(withIdentifier: "AnimalPage") as! AnimalViewController

        super.init(coder: aDecoder)
    }
}
