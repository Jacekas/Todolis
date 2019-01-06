//
//  Item.swift
//  Todolis
//
//  Created by Jacekas Antulis on 06/01/2019.
//  Copyright © 2019 Jacekas Antulis. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    // following we define "reverse" relationship
    // type of the destination of the link: "Category.self"
    // the propertyname of reverse relationship "items"
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}


