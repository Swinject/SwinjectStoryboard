//
//  SwinjectStoryboardTests.swift
//  SwinjectStoryboard-OSXTests
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
    func testSwinjectStoryboardInjectsViewControllerDependencyDefindedByInitCompletedHandler() {
        container.storyboardInitCompleted(AnimalViewController.self) { r, c in
            c.animal = r.resolve(Animal.self)
        }
        container.register(Animal.self) { _ in Cat(name: "Mimi") }
        
        let storyboard = SwinjectStoryboard.create(name: .animals, bundle: bundle, container: container)
        let animalViewController = storyboard.instantiateController(withIdentifier: .animalView) as! AnimalViewController
        XCTAssert(animalViewController.hasAnimal(named: "Mimi"))
    }
    
    func testSwinjectStoryboardInjectsWindowControllerDependencyDefindedByInitCompletedHandler() {
        container.storyboardInitCompleted(AnimalWindowController.self) { r, c in
            c.animal = r.resolve(Animal.self)
        }
        container.register(Animal.self) { _ in Cat(name: "Mew") }
        
        let storyboard = SwinjectStoryboard.create(name: .animals, bundle: bundle, container: container)
        let animalViewController = storyboard.instantiateController(withIdentifier: .animalWindow) as! AnimalWindowController
        XCTAssert(animalViewController.hasAnimal(named: "Mew"))
    }
   
    func testSwinjectStoryboardInjectsDependencyToChildViewControllers() {
        container.storyboardInitCompleted(AnimalViewController.self) { r, c in
            c.animal = r.resolve(Animal.self)
        }
        container.register(Animal.self) { _ in Cat() }
            .inObjectScope(.container)
        
        let storyboard = SwinjectStoryboard.create(name: .tabs, bundle: bundle, container: container)
        let tabBarController = storyboard.instantiateController(withIdentifier: .tabBarController) as! NSTabViewController
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

    func testSwinjectStoryboardInjectsViewContrllerDependencyDefindedByInitCompletedHandlerWithRegistrationNameAsUserDefinedRuntimeAttributeOnInterfaceBuilder() {
        // The registration name "hachi" is set in the storyboard.
        container.storyboardInitCompleted(AnimalViewController.self, name: "hachi") { r, c in
            c.animal = r.resolve(Animal.self)
        }
        container.register(Animal.self) { _ in Dog(name: "Hachi") }
        
        // This registration should not be resolved.
        container.storyboardInitCompleted(AnimalViewController.self) { _, c in
            c.animal = Cat(name: "Mimi")
        }
        
        let storyboard = SwinjectStoryboard.create(name: .animals, bundle: bundle, container: container)
        let animalViewController = storyboard.instantiateController(withIdentifier: .hachiView) as! AnimalViewController
        XCTAssert(animalViewController.hasAnimal(named: "Hachi"))
    }
    
    func testSwinjectStoryboardInjectsWindowContrllerDependencyDefindedByInitCompletedHandlerWithRegistrationNameAsUserDefinedRuntimeAttributeOnInterfaceBuilder() {
        // The registration name "hachi" is set in the storyboard.
        container.storyboardInitCompleted(AnimalWindowController.self, name: "pochi") { r, c in
            c.animal = r.resolve(Animal.self)
        }
        container.register(Animal.self) { _ in Dog(name: "Pochi") }
        
        // This registration should not be resolved.
        container.storyboardInitCompleted(AnimalWindowController.self) { _, c in
            c.animal = Cat(name: "Mimi")
        }
        
        let storyboard = SwinjectStoryboard.create(name: .animals, bundle: bundle, container: container)
        let animalViewController = storyboard.instantiateController(withIdentifier: .pochiWindow) as! AnimalWindowController
        XCTAssert(animalViewController.hasAnimal(named: "Pochi"))
    }

    func testSwinjectStoryboardInjectsViewControllerDependencyDefindedInParentContainerWithContainerHierarchy() {
        container.storyboardInitCompleted(AnimalViewController.self) { r, c in
            c.animal = r.resolve(Animal.self)
        }
        container.register(Animal.self) { _ in Cat(name: "Mimi") }
        let childContainer = Container(parent: container)
        
        let storyboard = SwinjectStoryboard.create(name: .animals, bundle: bundle, container: childContainer)
        let animalViewController = storyboard.instantiateController(withIdentifier: .animalView) as! AnimalViewController
        XCTAssert(animalViewController.hasAnimal(named: "Mimi"))
    }

    func testSwinjectStoryboardInjectsSecondControllerWithSecondControllerInstantiationDuringInstantiationOfInitialOne() {
        container.storyboardInitCompleted(AnimalViewController.self) { r, c in
            c.animal = r.resolve(Animal.self)
        }
        container.register(Animal.self) { _ in Cat(name: "Mimi") }

        let storyboard = SwinjectStoryboard.create(name: .pages, bundle: bundle, container: container)
        let pagesController = storyboard.instantiateInitialController() as! AnimalPagesViewController
        XCTAssert(pagesController.animalPage.hasAnimal(named: "Mimi"))
    }

    // MARK: Initial controller
    func testInitialViewControllerInjectsDependencyDefindedByInitCompletedHandler() {
        container.storyboardInitCompleted(AnimalWindowController.self) { r, c in
            c.animal = r.resolve(Animal.self)
        }
        container.register(Animal.self) { _ in Cat(name: "Mew") }
        
        let storyboard = SwinjectStoryboard.create(name: .animals, bundle: bundle, container: container)
        let animalViewController = storyboard.instantiateInitialController() as! AnimalWindowController
        XCTAssert(animalViewController.hasAnimal(named: "Mew"))
    }

    // MARK: Factory method
    func testFactoryMethodUsesDefaultSharedContainerIfNoContainerIsPassed() {
        SwinjectStoryboard.defaultContainer.storyboardInitCompleted(AnimalViewController.self) { _, _ in }
        defer {
            SwinjectStoryboard.defaultContainer.removeAll()
        }
        
        let storyboard = SwinjectStoryboard.create(name: .animals, bundle: bundle)
        let animalViewController = storyboard.instantiateController(withIdentifier: .animalView)
        XCTAssertNotNil(animalViewController)
    }

    // MARK: Storyboard reference
    func testStoryboardReferenceInjectsDependencyToViewControllerInReferencedStoryboard() {
        SwinjectStoryboard.defaultContainer.storyboardInitCompleted(AnimalViewController.self) { r, c in
            c.animal = r.resolve(Animal.self)
        }
        SwinjectStoryboard.defaultContainer.register(Animal.self) { _ in Cat(name: "Mimi") }
        defer {
            SwinjectStoryboard.defaultContainer.removeAll()
        }
        
        let storyboard1 = SwinjectStoryboard.create(name: .storyboard1, bundle: bundle)
        let windowController = storyboard1.instantiateInitialController() as! NSWindowController
        let viewController1 = windowController.contentViewController as! ViewController1
        viewController1.performSegue(withIdentifier: .toStoryboard2, sender: nil)

        assertEventually {
            viewController1.animalViewController?.hasAnimal(named: "Mimi") == true
        }
    }

    func testStoryboardReferenceShouldInjectDependenciesOnceIfReferencingStoryboardViaRelationshipSegue() {
        var injectedTimes = 0
        SwinjectStoryboard.defaultContainer.storyboardInitCompleted(ViewController1.self) { r, c in
            injectedTimes += 1
        }
        defer {
            SwinjectStoryboard.defaultContainer.removeAll()
        }

        let storyboard = SwinjectStoryboard.create(name: .relationshipReference1, bundle: bundle)
        storyboard.instantiateInitialController()

        XCTAssertEqual(injectedTimes, 1)
    }

    func testStoryboardReferenceInjectsDependencyToViewControllerpenedViaSegueIfNotUsingDefaultContainer() {
        container.storyboardInitCompleted(AnimalViewController.self) { r, c in
            c.animal = r.resolve(Animal.self)
        }
        container.register(Animal.self) { _ in Cat(name: "Mimi") }

        let storyboard = SwinjectStoryboard.create(name: .relationshipReference1, bundle: bundle, container: container)
        let windowController = storyboard.instantiateInitialController() as! NSWindowController
        let viewController1 = windowController.contentViewController as! ViewController1
        viewController1.performSegue(withIdentifier: .toAnimalViewController, sender: nil)

        assertEventually {
            viewController1.animalViewController?.hasAnimal(named: "Mimi") == true
        }
    }

    // MARK: Setup
    func testSetupIsCalledOnlyOnce() {
        _ = SwinjectStoryboard.create(name: .animals, bundle: bundle)
        _ = SwinjectStoryboard.create(name: .animals, bundle: bundle)
        XCTAssertEqual(swinjectStoryboardSetupCount, 1)
    }
}

private extension NSStoryboard.Name {
    static let animals = NSStoryboard.Name("Animals")
    static let storyboard1 = NSStoryboard.Name("Storyboard1")
    static let relationshipReference1 = NSStoryboard.Name("RelationshipReference1")
    static let pages = NSStoryboard.Name("Pages")
    static let tabs = NSStoryboard.Name("Tabs")
}

private extension NSStoryboard.SceneIdentifier {
    static let animalView = NSStoryboard.SceneIdentifier("AnimalView")
    static let animalWindow = NSStoryboard.SceneIdentifier("AnimalWindow")
    static let tabBarController = NSStoryboard.SceneIdentifier("TabBarController")
    static let hachiView = NSStoryboard.SceneIdentifier("HachiView")
    static let pochiWindow = NSStoryboard.SceneIdentifier("PochiWindow")
}

private extension NSStoryboardSegue.Identifier {
    static let toStoryboard2 = NSStoryboardSegue.Identifier("ToStoryboard2")
    static let toAnimalViewController = NSStoryboardSegue.Identifier("ToAnimalViewController")
}

// Similar to toEventually of Nimble.
private func assertEventually(expression: @escaping () -> Bool) {
    let expectation = XCTestExpectation()
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        XCTAssert(expression())
        expectation.fulfill()
    }
    XCTWaiter().wait(for: [expectation], timeout: 1.0)
}
