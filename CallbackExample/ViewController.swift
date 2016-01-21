//
//  ViewController.swift
//  CallbackExample
//
//  Created by Oky Sabeni on 1/21/16.
//  Copyright © 2016 Oky Sabeni. All rights reserved.
//

import UIKit

import Alamofire

class Person: NSObject {
    static let sharedInstance = Person()
    var object: AnyObject
    private override init() {
        object = ""
    }
}

class ViewController: UIViewController {
    var object = Person.sharedInstance.object
    var anotherObject: AnyObject?
    override func viewDidLoad() {
        super.viewDidLoad()
        print(unsafeAddressOf(object)) // 0x00007f91835899b0
        print(unsafeAddressOf(Person.sharedInstance.object)) // 0x00007f91835899b0
        Person.sharedInstance.object = "SOMETHING"
        print(self.object)
        get { _ in
            // Doesn't work
            Person.sharedInstance.object = "SOMETHING"
            print(self.object)
            print(self.anotherObject)
        }
    }
    
    func get(completionHandler: (result: AnyObject?) -> Void) {
        Alamofire.request(.GET, "http://private-9bd21-callbackexample1.apiary-mock.com/questions")
            .responseJSON { [unowned self] response in
                print(unsafeAddressOf(self.object)) // 0x00007f91835899b0
                print(unsafeAddressOf(Person.sharedInstance.object)) // 0x00007f91835899b0
                Person.sharedInstance.object = response.result.value!
                self.anotherObject = response.result.value!
                completionHandler(result: response.result.value)
        }
    }
}

