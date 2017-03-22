//
//  SwinjectStoryboardSpec.swift
//  Swinject
//
//  Created by Yoichi Tagaya on 7/31/15.
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
            it("injects dependency definded by initCompleted handler.") {
                container.storyboardInitCompleted(AnimalViewController.self) { r, c in
                    c.animal = r.resolve(Animal.self)
                }
                container.register(Animal.self) { _ in Cat(name: "Mimi") }
                
                let storyboard = SwinjectStoryboard.create(name: "Animals", bundle: bundle, container: container)
                let animalViewController = storyboard.instantiateViewController(withIdentifier: "AnimalAsCat") as! AnimalViewController
                expect(animalViewController.hasAnimal(named: "Mimi")) == true
            }
            it("injects dependency to child view controllers.") {
                container.storyboardInitCompleted(AnimalViewController.self) { r, c in
                    c.animal = r.resolve(Animal.self)
                }
                container.register(Animal.self) { _ in Cat() }
                    .inObjectScope(.container)

                let storyboard = SwinjectStoryboard.create(name: "Tabs", bundle: bundle, container: container)
                let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController")
                let animalViewController1 = tabBarController.childViewControllers[0] as! AnimalViewController
                let animalViewController2 = tabBarController.childViewControllers[1] as! AnimalViewController
                let cat1 = animalViewController1.animal as! Cat
                let cat2 = animalViewController2.animal as! Cat
                expect(cat1 === cat2).to(beTrue()) // Workaround for crash in Nimble.
            }
            context("with a registration name set as a user defined runtime attribute on Interface Builder") {
                it("injects dependency definded by initCompleted handler with the registration name.") {
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
                    expect(animalViewController.hasAnimal(named: "Hachi")) == true
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
                    let animalViewController = storyboard.instantiateViewController(withIdentifier: "AnimalAsCat") as! AnimalViewController
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
                    let pagesController = storyboard.instantiateInitialViewController() as! AnimalPagesViewController
                    expect(pagesController.animalPage.hasAnimal(named: "Mimi")) == true
                }
            }
        }
        describe("Initial view controller") {
            it("injects dependency definded by initCompleted handler.") {
                container.storyboardInitCompleted(AnimalViewController.self) { r, c in
                    c.animal = r.resolve(Animal.self)
                }
                container.register(Animal.self) { _ in Cat(name: "Mimi") }
                
                let storyboard = SwinjectStoryboard.create(name: "Animals", bundle: bundle, container: container)
                let animalViewController = storyboard.instantiateInitialViewController() as! AnimalViewController
                expect(animalViewController.hasAnimal(named: "Mimi")) == true
            }
        }
        describe("AVPlayerViewController") { // Test for Issue #18
            it("is able to inject a subclass of AVPlayerViewController") {
                container.storyboardInitCompleted(AnimalPlayerViewController.self) { r, c in
                    c.animal = r.resolve(Animal.self)
                }
                container.register(Animal.self) { _ in Cat(name: "Mimi") }
                
                let storyboard = SwinjectStoryboard.create(name: "AnimalPlayerViewController", bundle: bundle, container: container)
                let animalPlayerViewController = storyboard.instantiateInitialViewController() as! AnimalPlayerViewController
                expect(animalPlayerViewController.hasAnimal(named: "Mimi")) == true
            }
        }
        describe("Factory method") {
            it("uses the default shared container if no container is passed.") {
                SwinjectStoryboard.defaultContainer.storyboardInitCompleted(AnimalViewController.self) { _, _ in }
                
                let storyboard = SwinjectStoryboard.create(name: "Animals", bundle: bundle)
                let animalViewController = storyboard.instantiateViewController(withIdentifier: "AnimalAsCat")
                expect(animalViewController).notTo(beNil())
            }
            
            afterEach {
                SwinjectStoryboard.defaultContainer.removeAll()
            }
        }
        // We need to have test bundle deployment target on iOS 9.0 in order to compile storyboards with references.
        // However, we need to disable these tests when running on iOS <9.0
        // Using #available(iOS 9.0, *) produces complier warning for the reasons above
        if ProcessInfo().isOperatingSystemAtLeast(OperatingSystemVersion(majorVersion: 9, minorVersion: 0, patchVersion: 0)) {
            describe("Storyboard reference") {
                it("inject dependency to the view controller in the referenced storyboard.") {
                    SwinjectStoryboard.defaultContainer.storyboardInitCompleted(AnimalViewController.self) { r, c in
                        c.animal = r.resolve(Animal.self)
                    }
                    SwinjectStoryboard.defaultContainer.register(Animal.self) { _ in Cat(name: "Mimi") }

                    let storyboard1 = SwinjectStoryboard.create(name: "Storyboard1", bundle: bundle)
                    let navigationController = storyboard1.instantiateInitialViewController() as! UINavigationController
                    navigationController.performSegue(withIdentifier: "ToStoryboard2", sender: navigationController)
                    let animalViewController = navigationController.topViewController as! AnimalViewController
                    expect(animalViewController.hasAnimal(named: "Mimi")) == true
                }
                context("referencing storyboard via relationship segue") {
                    it("should inject dependencies once") {
                        var injectedTimes = 0
                        SwinjectStoryboard.defaultContainer.storyboardInitCompleted(UIViewController.self) { r, c in
                            injectedTimes += 1
                        }

                        let storyboard = SwinjectStoryboard.create(name: "RelationshipReference1", bundle: bundle)
                        storyboard.instantiateInitialViewController()

                        expect(injectedTimes) == 1
                    }
                    context("not using defaultContainer") {
                        it("injects dependency to the view controller opened via segue") {
                            container.storyboardInitCompleted(AnimalViewController.self) { r, c in
                                c.animal = r.resolve(Animal.self)
                            }
                            container.register(Animal.self) { _ in Cat(name: "Mimi") }

                            let storyboard = SwinjectStoryboard.create(name: "RelationshipReference1", bundle: bundle, container: container)
                            let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
                            navigationController.topViewController!.performSegue(withIdentifier: "ToAnimalViewController", sender: nil)
                            let animalViewController = navigationController.topViewController as! AnimalViewController

                            expect(animalViewController.hasAnimal(named: "Mimi")) == true
                        }
                    }
                }
                
                afterEach {
                    SwinjectStoryboard.defaultContainer.removeAll()
                }
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
