//
//  MVCacherTests.swift
//  MVCacher_Example
//
//  Created by M. Ahsan Ali on 15/09/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import MVCacher

class MVCacherTests: QuickSpec {
    
    let identifier1 = "Mind Valley, Kuala Lumpur, Malaysia"
    
    let identifier2 = "Nokia, Japan"

    lazy var string1Data: Data = {
        return identifier1.data(using: .utf8)!
    }()
    
    lazy var string2Data: Data = {
        return identifier2.data(using: .utf8)!
    }()
    
    var cacheData = MVCacher(cacheType: .memory)
    
    override func spec() {
        
        cacheData.memoryCapacity = 50 * 1024 * 1024
        cacheData.memoryUsageAfterPurge = 20 * 1024 * 1024
        
        describe("Testing MVCacher Library") {
            
            it("Get the cached Image if exists") {
                self.test_get_item()
            }
            
            it("Add new item to cacher") {
                self.test_add_new_item()
            }
            
            it("Add new item to cacher with duplicate identifier") {
                self.test_add_item_duplicate_identifier()
            }
            
            it("Remove item") {
                self.test_remove_item()
            }
            
            it("Clear cache") {
                self.test_empty_cache()
            }
            
            it("Memory Warnings") {
                self.test_memory_warnings()
            }
            
            it("Item maximum memory capacity") {
                self.test_item_memory_max_capacity()
            }

        }
    }
    
    func test_get_item() {
        var item = cacheData.getItem(identifier: identifier1)
        expect(item).toEventually(beNil())
        
        cacheData.addItem(string1Data, identifier: identifier1)
    
        item = cacheData.getItem(identifier: identifier1)
        expect(item).toEventuallyNot(beNil())
    }
    
    func test_add_new_item() {
        cacheData.addItem(string1Data, identifier: identifier1)
        let item = cacheData.getItem(identifier: identifier1)
        
        expect(item).toEventuallyNot(beNil())
        expect(item).toEventually(equal(string1Data))
    }
    
    func test_add_item_duplicate_identifier() {
        
        cacheData.addItem(string1Data, identifier: identifier1)
        let item1 = cacheData.getItem(identifier: identifier1)
        
        cacheData.addItem(string2Data, identifier: identifier1)
        let item2 = cacheData.getItem(identifier: identifier1)
        
        expect(item1).toEventuallyNot(beNil())
        expect(item2).toEventuallyNot(beNil())
        expect(item1).toEventually(equal(string1Data))
        expect(item2).toEventually(equal(string2Data))
        expect(item1).toEventuallyNot(equal(item2))
    }
    
    func test_remove_item() {
        cacheData.addItem(string1Data, identifier: identifier1)
        var existingItem = cacheData.getItem(identifier: identifier1)
        expect(existingItem).toEventuallyNot(beNil())
        
        cacheData.removeItem(identifier: identifier1)
        existingItem = cacheData.getItem(identifier: identifier1)
        
        expect(existingItem).toEventually(beNil())
    }
    
    func test_empty_cache() {
        cacheData.addItem(string1Data, identifier: identifier1)
        cacheData.addItem(string2Data, identifier: identifier2)
        
        var existingItem = cacheData.getItem(identifier: identifier1)
        expect(existingItem).toEventuallyNot(beNil())
        
        existingItem = cacheData.getItem(identifier: identifier2)
        expect(existingItem).toEventuallyNot(beNil())
        
        cacheData.clearCache()
        
        existingItem = cacheData.getItem(identifier: identifier1)
        expect(existingItem).toEventually(beNil())

        existingItem = cacheData.getItem(identifier: identifier2)
        expect(existingItem).toEventually(beNil())
    }
    
    func test_memory_warnings() {
        cacheData.addItem(string1Data, identifier: identifier1)
        
        let item1 = cacheData.getItem(identifier: identifier1)
        expect(item1).toEventuallyNot(beNil())

        NotificationCenter.default.post(
            name: NSNotification.Name.UIApplicationDidReceiveMemoryWarning,
            object: nil
        )

        expect(item1).toEventuallyNot(beNil())
        expect(item1 != nil).toEventuallyNot(beFalse())

    }
    
    func test_item_memory_max_capacity() {
        
        var memoryUsage = [UInt64]()
        (1...10).forEach {
            cacheData.addItem(string1Data, identifier: "\(identifier1)-\($0)")
            memoryUsage.append(cacheData.memoryUsage)
        }
        
        expect(memoryUsage[0]).toEventually(equal(70))
        expect(memoryUsage[1]).toEventually(equal(105))
        expect(memoryUsage[2]).toEventually(equal(140))
    }

}

