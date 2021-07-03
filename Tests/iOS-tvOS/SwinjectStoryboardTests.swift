//
//  SwinjectStoryboardTests.swift
//  SwinjectStoryboard
//
//  Created by Yoichi Tagaya on 2021/07/03.
//  Copyright © 2021 Swinject Contributors. All rights reserved.
//

import XCTest
import Swinject
@testable import SwinjectStoryboard

private var swinjectStoryboardSetupCount = 0
extension SwinjectStoryboard {
    static func setup() {
        swinjectStoryboardSetupCount += 1
    }
}

class SwinjectStoryboardTests: XCTestCase {
    let bundle = Bundle(for: SwinjectStoryboardTests.self)
    var container: Container!

    override func setUpWithError() throws {
        container = Container()
    }

    // MARK: Instantiation from storyboard
    func testSwinjectStoryboardInjectsDependencyDefindedByInitCompletedHandler() {
        container.storyboardInitCompleted(AnimalViewController.self) { r, c in
            c.animal = r.resolve(Animal.self)
        }
        container.register(Animal.self) { _ in Cat(name: "Mimi") }
        
        let storyboard = SwinjectStoryboard.create(name: "Animals", bundle: bundle, container: container)
        let animalViewController = storyboard.instantiateViewController(withIdentifier: "AnimalAsCat") as! AnimalViewController
        XCTAssert(animalViewController.hasAnimal(named: "Mimi"))
    }
    
    func testSwinjectStoryboardInjectsDependencyToChildViewControllers() {
        container.storyboardInitCompleted(AnimalViewController.self) { r, c in
            c.animal = r.resolve(Animal.self)
        }
        container.register(Animal.self) { _ in Cat() }
            .inObjectScope(.container)

        let storyboard = SwinjectStoryboard.create(name: "Tabs", bundle: bundle, container: container)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController")
    #if swift(>=4.2)
        let animalViewController1 = tabBarController.children[0] as! AnimalViewController
        let animalViewController2 = tabBarController.children[1] as! AnimalViewController
    #else
        let animalViewController1 = tabBarController.childViewControllers[0] as! AnimalViewController
        let animalViewController2 = tabBarController.childViewControllers[1] as! AnimalViewController
    #endif
        let cat1 = animalViewController1.animal as! Cat
        let cat2 = animalViewController2.animal as! Cat
        XCTAssert(cat1 === cat2)
    }
    
    func testSwinjectStoryboardInjectsDependencyDefindedByInitCompletedHandlerWithRegistrationNameAsUserDefinedRuntimeAttributeOnInterfaceBuilder() {
        // The registration name "hachi" is set in the storyboard.
        container.storyboardInitCompleted(AnimalViewController.self, name: "hachi") { r, c in
            c.animal = r.resolve(Animal.self)
        }
        container.register(Animal.self) { _ in Dog(name: "Hachi") }
        
        // This registration should not be resolved.
        container.storyboardInitCompleted(AnimalViewController.self) { _, c in
            c.animal = Cat(name: "Mimi")
        }
        
        let storyboard = SwinjectStoryboard.create(name: "Animals", bundle: bundle, container: container)
        let animalViewController = storyboard.instantiateViewController(withIdentifier: "AnimalAsDog") as! AnimalViewController
        XCTAssert(animalViewController.hasAnimal(named: "Hachi"))
    }
    
    func testSwinjectStoryboardInjectsViewControllerDependencyDefindedInParentContainerWithContainerHierarchy() {
        container.storyboardInitCompleted(AnimalViewController.self) { r, c in
            c.animal = r.resolve(Animal.self)
        }
        container.register(Animal.self) { _ in Cat(name: "Mimi") }
        let childContainer = Container(parent: container)
        
        let storyboard = SwinjectStoryboard.create(name: "Animals", bundle: bundle, container: childContainer)
        let animalViewController = storyboard.instantiateViewController(withIdentifier: "AnimalAsCat") as! AnimalViewController
        XCTAssert(animalViewController.hasAnimal(named: "Mimi"))
    }
    
    func testSwinjectStoryboardInjectsSecondControllerWithSecondControllerInstantiationDuringInstantiationOfInitialOne() {
        container.storyboardInitCompleted(AnimalViewController.self) { r, c in
            c.animal = r.resolve(Animal.self)
        }
        container.register(Animal.self) { _ in Cat(name: "Mimi") }

        let storyboard = SwinjectStoryboard.create(name: "Pages", bundle: bundle, container: container)
        let pagesController = storyboard.instantiateInitialViewController() as! AnimalPagesViewController
        XCTAssert(pagesController.animalPage.hasAnimal(named: "Mimi"))
    }
    
    // MARK: Initial view controller
    func testInitialViewControllerInjectsDependencyDefindedByInitCompletedHandler() {
        container.storyboardInitCompleted(AnimalViewController.self) { r, c in
            c.animal = r.resolve(Animal.self)
        }
        container.register(Animal.self) { _ in Cat(name: "Mimi") }
        
        let storyboard = SwinjectStoryboard.create(name: "Animals", bundle: bundle, container: container)
        let animalViewController = storyboard.instantiateInitialViewController() as! AnimalViewController
        XCTAssert(animalViewController.hasAnimal(named: "Mimi"))
    }
    
    // MARK: AVPlayerViewController
    // Test for Issue #18
    func testAVPlayerViewControllerIsAbleToInjectSubclassOfAVPlayerViewController() {
        container.storyboardInitCompleted(AnimalPlayerViewController.self) { r, c in
            c.animal = r.resolve(Animal.self)
        }
        container.register(Animal.self) { _ in Cat(name: "Mimi") }
        
        let storyboard = SwinjectStoryboard.create(name: "AnimalPlayerViewController", bundle: bundle, container: container)
        let animalPlayerViewController = storyboard.instantiateInitialViewController() as! AnimalPlayerViewController
        XCTAssert(animalPlayerViewController.hasAnimal(named: "Mimi"))
    }
    
    // MARK: Factory method
    func testFactoryMethodUsesDefaultSharedContainerIfNoContainerIsPassed() {
        SwinjectStoryboard.defaultContainer.storyboardInitCompleted(AnimalViewController.self) { _, _ in }
        defer {
            SwinjectStoryboard.defaultContainer.removeAll()
        }
        
        let storyboard = SwinjectStoryboard.create(name: "Animals", bundle: bundle)
        let animalViewController = storyboard.instantiateViewController(withIdentifier: "AnimalAsCat")
        XCTAssertNotNil(animalViewController)
    }
    
    // MARK: Storyboard reference
    func testStoryboardReferenceInjectsDependencyToViewControllerInReferencedStoryboard() {
        SwinjectStoryboard.defaultContainer.storyboardInitCompleted(AnimalViewController.self) { r, c in
            c.animal = r.resolve(Animal.self)
        }
        SwinjectStoryboard.defaultContainer.register(Animal.self) { _ in Cat(name: "Mimi") }
        defer {
            SwinjectStoryboard.defaultContainer.removeAll()
        }

        let storyboard1 = SwinjectStoryboard.create(name: "Storyboard1", bundle: bundle)
        let navigationController = storyboard1.instantiateInitialViewController() as! UINavigationController
        navigationController.performSegue(withIdentifier: "ToStoryboard2", sender: navigationController)
        let animalViewController = navigationController.topViewController as! AnimalViewController
        XCTAssert(animalViewController.hasAnimal(named: "Mimi"))
    }
    
    func testStoryboardReferenceShouldInjectDependenciesOnceIfReferencingStoryboardViaRelationshipSegue() {
        var injectedTimes = 0
        SwinjectStoryboard.defaultContainer.storyboardInitCompleted(UIViewController.self) { r, c in
            injectedTimes += 1
        }
        defer {
            SwinjectStoryboard.defaultContainer.removeAll()
        }

        let storyboard = SwinjectStoryboard.create(name: "RelationshipReference1", bundle: bundle)
        storyboard.instantiateInitialViewController()

        XCTAssertEqual(injectedTimes, 1)
    }
    
    func testStoryboardReferenceInjectsDependencyToViewControllerpenedViaSegueIfNotUsingDefaultContainer() {
        container.storyboardInitCompleted(AnimalViewController.self) { r, c in
            c.animal = r.resolve(Animal.self)
        }
        container.register(Animal.self) { _ in Cat(name: "Mimi") }

        let storyboard = SwinjectStoryboard.create(name: "RelationshipReference1", bundle: bundle, container: container)
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        navigationController.topViewController!.performSegue(withIdentifier: "ToAnimalViewController", sender: nil)
        let animalViewController = navigationController.topViewController as! AnimalViewController

        XCTAssert(animalViewController.hasAnimal(named: "Mimi"))
    }

    // MARK: Setup
    func testSetupIsCalledOnlyOnce() {
        _ = SwinjectStoryboard.create(name: "Animals", bundle: bundle)
        _ = SwinjectStoryboard.create(name: "Animals", bundle: bundle)
        XCTAssertEqual(swinjectStoryboardSetupCount, 1)
    }
}
