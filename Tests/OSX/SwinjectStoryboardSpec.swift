//
//  SwinjectStoryboardSpec.swift
//  Swinject
//
//  Created by Yoichi Tagaya on 8/1/15.
//  Copyright © 2015 Swinject Contributors. All rights reserved.
//

import Quick
import Nimble
import Swinject
@testable import SwinjectStoryboard

private var swinjectStoryboardSetupCount = 0
extension SwinjectStoryboard {
    static func setup() {
        swinjectStoryboardSetupCount += 1
    }
}

class SwinjectStoryboardSpec: QuickSpec {
    override func spec() {
        let bundle = Bundle(for: SwinjectStoryboardSpec.self)
        var container: Container!
        beforeEach {
            container = Container()
        }
        
        describe("Instantiation from storyboard") {
            it("injects view controller dependency definded by initCompleted handler.") {
                container.storyboardInitCompleted(AnimalViewController.self) { r, c in
                    c.animal = r.resolve(Animal.self)
                }
                container.register(Animal.self) { _ in Cat(name: "Mimi") }
                
                let storyboard = SwinjectStoryboard.create(name: .animals, bundle: bundle, container: container)
                let animalViewController = storyboard.instantiateController(withIdentifier: .animalView) as! AnimalViewController
                expect(animalViewController.hasAnimal(named: "Mimi")) == true
            }
            it("injects window controller dependency definded by initCompleted handler.") {
                container.storyboardInitCompleted(AnimalWindowController.self) { r, c in
                    c.animal = r.resolve(Animal.self)
                }
                container.register(Animal.self) { _ in Cat(name: "Mew") }
                
                let storyboard = SwinjectStoryboard.create(name: .animals, bundle: bundle, container: container)
                let animalViewController = storyboard.instantiateController(withIdentifier: .animalWindow) as! AnimalWindowController
                expect(animalViewController.hasAnimal(named: "Mew")) == true
            }
            it("injects dependency to child view controllers.") {
                container.storyboardInitCompleted(AnimalViewController.self) { r, c in
                    c.animal = r.resolve(Animal.self)
                }
                container.register(Animal.self) { _ in Cat() }
                    .inObjectScope(.container)
                
                let storyboard = SwinjectStoryboard.create(name: .tabs, bundle: bundle, container: container)
                let tabBarController = storyboard.instantiateController(withIdentifier: .tabBarController) as! NSTabViewController
                let animalViewController1 = tabBarController.childViewControllers[0] as! AnimalViewController
                let animalViewController2 = tabBarController.childViewControllers[1] as! AnimalViewController
                let cat1 = animalViewController1.animal as! Cat
                let cat2 = animalViewController2.animal as! Cat
                expect(cat1 === cat2).to(beTrue()) // Workaround for crash in Nimble.
            }
            context("with a registration name set as a user defined runtime attribute on Interface Builder") {
                it("injects view controller dependency definded by initCompleted handler with the registration name.") {
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
                    expect(animalViewController.hasAnimal(named: "Hachi")) == true
                }
                it("injects window controller dependency definded by initCompleted handler with the registration name.") {
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
                    expect(animalViewController.hasAnimal(named: "Pochi")) == true
                }
            }
            context("with container hierarchy") {
                it("injects view controller dependency definded in the parent container.") {
                    container.storyboardInitCompleted(AnimalViewController.self) { r, c in
                        c.animal = r.resolve(Animal.self)
                    }
                    container.register(Animal.self) { _ in Cat(name: "Mimi") }
                    let childContainer = Container(parent: container)
                    
                    let storyboard = SwinjectStoryboard.create(name: .animals, bundle: bundle, container: childContainer)
                    let animalViewController = storyboard.instantiateController(withIdentifier: .animalView) as! AnimalViewController
                    expect(animalViewController.hasAnimal(named: "Mimi")) == true
                }
            }
            context("with second controller instantiation during instantiation of initial one") {
                it("injects second controller.") {
                    container.storyboardInitCompleted(AnimalViewController.self) { r, c in
                        c.animal = r.resolve(Animal.self)
                    }
                    container.register(Animal.self) { _ in Cat(name: "Mimi") }

                    let storyboard = SwinjectStoryboard.create(name: .pages, bundle: bundle, container: container)
                    let pagesController = storyboard.instantiateInitialController() as! AnimalPagesViewController
                    expect(pagesController.animalPage.hasAnimal(named: "Mimi")) == true
                }
            }
        }
        describe("Initial controller") {
            it("injects dependency definded by initCompleted handler.") {
                container.storyboardInitCompleted(AnimalWindowController.self) { r, c in
                    c.animal = r.resolve(Animal.self)
                }
                container.register(Animal.self) { _ in Cat(name: "Mew") }
                
                let storyboard = SwinjectStoryboard.create(name: .animals, bundle: bundle, container: container)
                let animalViewController = storyboard.instantiateInitialController() as! AnimalWindowController
                expect(animalViewController.hasAnimal(named: "Mew")) == true
            }
        }
        describe("Factory method") {
            it("uses the default shared container if no container is passed.") {
                SwinjectStoryboard.defaultContainer.storyboardInitCompleted(AnimalViewController.self) { _, _ in }
                
                let storyboard = SwinjectStoryboard.create(name: .animals, bundle: bundle)
                let animalViewController = storyboard.instantiateController(withIdentifier: .animalView)
                expect(animalViewController).notTo(beNil())
            }
            
            afterEach {
                SwinjectStoryboard.defaultContainer.removeAll()
            }
        }
        describe("Storyboard reference") {
            it("inject dependency to the view controller in the referenced storyboard.") {
                SwinjectStoryboard.defaultContainer.storyboardInitCompleted(AnimalViewController.self) { r, c in
                    c.animal = r.resolve(Animal.self)
                }
                SwinjectStoryboard.defaultContainer.register(Animal.self) { _ in Cat(name: "Mimi") }
                
                let storyboard1 = SwinjectStoryboard.create(name: .storyboard1, bundle: bundle)
                let windowController = storyboard1.instantiateInitialController() as! NSWindowController
                let viewController1 = windowController.contentViewController as! ViewController1
                viewController1.performSegue(withIdentifier: .toStoryboard2, sender: nil)
                expect(viewController1.animalViewController?.hasAnimal(named: "Mimi")).toEventually(beTrue())
            }
            context("referencing storyboard via relationship segue") {
                it("should inject dependencies once") {
                    var injectedTimes = 0
                    SwinjectStoryboard.defaultContainer.storyboardInitCompleted(ViewController1.self) { r, c in
                        injectedTimes += 1
                    }

                    let storyboard = SwinjectStoryboard.create(name: .relationshipReference1, bundle: bundle)
                    storyboard.instantiateInitialController()

                    expect(injectedTimes) == 1
                }
                context("not using default container") {
                    it("injects dependency to the view controller opened via segue") {
                        container.storyboardInitCompleted(AnimalViewController.self) { r, c in
                            c.animal = r.resolve(Animal.self)
                        }
                        container.register(Animal.self) { _ in Cat(name: "Mimi") }

                        let storyboard = SwinjectStoryboard.create(name: .relationshipReference1, bundle: bundle, container: container)
                        let windowController = storyboard.instantiateInitialController() as! NSWindowController
                        let viewController1 = windowController.contentViewController as! ViewController1
                        viewController1.performSegue(withIdentifier: .toAnimalViewController, sender: nil)

                        expect(viewController1.animalViewController?.hasAnimal(named: "Mimi")).toEventually(beTrue())
                    }
                }
            }
            
            afterEach {
                SwinjectStoryboard.defaultContainer.removeAll()
            }
        }
        describe("Arguments passed through instantiate view controller") {
            it("should inject data passed into a view controller - 1 arg") {
                guard let container = container else {
                    fail()
                    return
                }

                container.storyboardInitCompletedArg(AnimalViewController.self) { (r, c, name: (String)) in
                    c.animal = r.resolve(Animal.self)
                    // Try to use the injected name argument to set a new name on the Cat
                    if let cat = c.animal as? Cat {
                        cat.name = name
                    }
                }
                container.register(Animal.self) { _ in Cat(name: "Mimi") }
                let storyboard = SwinjectStoryboard.create(name: .animals, bundle: bundle, container: container)
                // Instantiate the view controller, with an extra argument of a new name for the Cat.
                let animalViewController = storyboard.instantiateController(withIdentifier: .animalView, arguments: "Whiskers") as! AnimalViewController
                // Assert that the name was passed through correctly.
                expect(animalViewController.hasAnimal(named: "Whiskers")) == true
            }
            it("should inject data passed into a view controller - 2 args") {
                guard let container = container else {
                    fail()
                    return
                }

                container.storyboardInitCompletedArg(AnimalViewController.self) { (r, c, arguments: (String, Bool)) in
                    c.animal = r.resolve(Animal.self)
                    // Try to use the injected name argument to set a new name on the Cat
                    if let cat = c.animal as? Cat {
                        let name = arguments.0
                        let sleeping = arguments.1
                        cat.name = name
                        cat.sleeping = sleeping
                    }
                }
                container.register(Animal.self) { _ in Cat(name: "Mimi") }
                let storyboard = SwinjectStoryboard.create(name: .animals, bundle: bundle, container: container)

                // Instantiate the view controller, with an extra argument of a new name for the Cat, and a new sleeping param
                let animalViewController = storyboard.instantiateController(withIdentifier: .animalView, arguments: ("Whiskers", true)) as! AnimalViewController
                // Assert that extra context was passed through correctly.
                expect(animalViewController.hasAnimal(named: "Whiskers")) == true
                guard let cat = animalViewController.animal as? Cat else {
                    fail()
                    return
                }
                expect(cat.sleeping)==true
            }
            it("should inject data passed into a view controller - 3 args") {
                guard let container = container else {
                    fail()
                    return
                }

                container.storyboardInitCompletedArg(AnimalViewController.self) { (r, c, arguments: (String, Bool, Food)) in
                    c.animal = r.resolve(Animal.self)
                    // Try to use the injected name argument to set a new name on the Cat
                    if let cat = c.animal as? Cat {
                        cat.name = arguments.0
                        cat.sleeping = arguments.1
                        cat.favoriteFood = arguments.2
                    }
                }
                container.register(Animal.self) { _ in Cat(name: "Mimi") }
                let storyboard = SwinjectStoryboard.create(name: .animals, bundle: bundle, container: container)

                let arguments: (String, Bool, Food) = ("Whiskers", true, Sushi())
                // Instantiate the view controller, with an extra argument of a new name for the Cat.
                let animalViewController = storyboard.instantiateController(withIdentifier: .animalView, arguments: arguments) as! AnimalViewController
                // Assert that the name was passed through correctly.
                expect(animalViewController.hasAnimal(named: "Whiskers")) == true
                guard let cat = animalViewController.animal as? Cat else {
                    fail()
                    return
                }
                expect(cat.sleeping)==true
                expect(cat.favoriteFood is Sushi) == true
            }
            afterEach {
                SwinjectStoryboard.defaultContainer.removeAll()
            }
        }
        describe("Setup") {
            it("calls setup function only once.") {
                _ = SwinjectStoryboard.create(name: .animals, bundle: bundle)
                _ = SwinjectStoryboard.create(name: .animals, bundle: bundle)
                expect(swinjectStoryboardSetupCount) == 1
            }
        }
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

