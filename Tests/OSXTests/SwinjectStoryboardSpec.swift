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
                
                let storyboard = SwinjectStoryboard.create(name: "Animals", bundle: bundle, container: container)
                let animalViewController = storyboard.instantiateController(withIdentifier: "AnimalView") as! AnimalViewController
                expect(animalViewController.hasAnimal(named: "Mimi")) == true
            }
            it("injects window controller dependency definded by initCompleted handler.") {
                container.storyboardInitCompleted(AnimalWindowController.self) { r, c in
                    c.animal = r.resolve(Animal.self)
                }
                container.register(Animal.self) { _ in Cat(name: "Mew") }
                
                let storyboard = SwinjectStoryboard.create(name: "Animals", bundle: bundle, container: container)
                let animalViewController = storyboard.instantiateController(withIdentifier: "AnimalWindow") as! AnimalWindowController
                expect(animalViewController.hasAnimal(named: "Mew")) == true
            }
            it("injects dependency to child view controllers.") {
                container.storyboardInitCompleted(AnimalViewController.self) { r, c in
                    c.animal = r.resolve(Animal.self)
                }
                container.register(Animal.self) { _ in Cat() }
                    .inObjectScope(.container)
                
                let storyboard = SwinjectStoryboard.create(name: "Tabs", bundle: bundle, container: container)
                let tabBarController = storyboard.instantiateController(withIdentifier: "TabBarController") as! NSTabViewController
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
                    
                    let storyboard = SwinjectStoryboard.create(name: "Animals", bundle: bundle, container: container)
                    let animalViewController = storyboard.instantiateController(withIdentifier: "HachiView") as! AnimalViewController
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
                    
                    let storyboard = SwinjectStoryboard.create(name: "Animals", bundle: bundle, container: container)
                    let animalViewController = storyboard.instantiateController(withIdentifier: "PochiWindow") as! AnimalWindowController
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
                    
                    let storyboard = SwinjectStoryboard.create(name: "Animals", bundle: bundle, container: childContainer)
                    let animalViewController = storyboard.instantiateController(withIdentifier: "AnimalView") as! AnimalViewController
                    expect(animalViewController.hasAnimal(named: "Mimi")) == true
                }
            }
            context("with second controller instantiation during instantiation of initial one") {
                it("injects second controller.") {
                    container.storyboardInitCompleted(AnimalViewController.self) { r, c in
                        c.animal = r.resolve(Animal.self)
                    }
                    container.register(Animal.self) { _ in Cat(name: "Mimi") }

                    let storyboard = SwinjectStoryboard.create(name: "Pages", bundle: bundle, container: container)
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
                
                let storyboard = SwinjectStoryboard.create(name: "Animals", bundle: bundle, container: container)
                let animalViewController = storyboard.instantiateInitialController() as! AnimalWindowController
                expect(animalViewController.hasAnimal(named: "Mew")) == true
            }
        }
        describe("Factory method") {
            it("uses the default shared container if no container is passed.") {
                SwinjectStoryboard.defaultContainer.storyboardInitCompleted(AnimalViewController.self) { _, _ in }
                
                let storyboard = SwinjectStoryboard.create(name: "Animals", bundle: bundle)
                let animalViewController = storyboard.instantiateController(withIdentifier: "AnimalView")
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
                
                let storyboard1 = SwinjectStoryboard.create(name: "Storyboard1", bundle: bundle)
                let windowController = storyboard1.instantiateInitialController() as! NSWindowController
                let viewController1 = windowController.contentViewController as! ViewController1
                viewController1.performSegue(withIdentifier: "ToStoryboard2", sender: nil)
                expect(viewController1.animalViewController?.hasAnimal(named: "Mimi")).toEventually(beTrue())
            }
            context("referencing storyboard via relationship segue") {
                it("should inject dependencies once") {
                    var injectedTimes = 0
                    SwinjectStoryboard.defaultContainer.storyboardInitCompleted(ViewController1.self) { r, c in
                        injectedTimes += 1
                    }

                    let storyboard = SwinjectStoryboard.create(name: "RelationshipReference1", bundle: bundle)
                    storyboard.instantiateInitialController()

                    expect(injectedTimes) == 1
                }
                context("not using default container") {
                    it("injects dependency to the view controller opened via segue") {
                        container.storyboardInitCompleted(AnimalViewController.self) { r, c in
                            c.animal = r.resolve(Animal.self)
                        }
                        container.register(Animal.self) { _ in Cat(name: "Mimi") }

                        let storyboard = SwinjectStoryboard.create(name: "RelationshipReference1", bundle: bundle, container: container)
                        let windowController = storyboard.instantiateInitialController() as! NSWindowController
                        let viewController1 = windowController.contentViewController as! ViewController1
                        viewController1.performSegue(withIdentifier: "ToAnimalViewController", sender: nil)

                        expect(viewController1.animalViewController?.hasAnimal(named: "Mimi")).toEventually(beTrue())
                    }
                }
            }
            
            afterEach {
                SwinjectStoryboard.defaultContainer.removeAll()
            }
        }
        describe("Setup") {
            it("calls setup function only once.") {
                _ = SwinjectStoryboard.create(name: "Animals", bundle: bundle)
                _ = SwinjectStoryboard.create(name: "Animals", bundle: bundle)
                expect(swinjectStoryboardSetupCount) == 1
            }
        }
    }
}
