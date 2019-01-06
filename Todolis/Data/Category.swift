//
//  Category.swift
//  Todolis
//
//  Created by Jacekas Antulis on 06/01/2019.
//  Copyright © 2019 Jacekas Antulis. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    // following we define "forward" relationship
    // name of relationship of another object here is: "items"
    // name of relationship of current object from outside is: "Item"
    
    // each Category can have list of "Item"s
    let items = List<Item>()
}
