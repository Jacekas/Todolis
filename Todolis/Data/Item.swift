//  Item.swift
//  Todolis
//
//  Created by Jacekas Antulis on 05/01/2019.
//  Copyright © 2019 Jacekas Antulis. All rights reserved.

import Foundation

// Codable = Encodable + Decodable
class Item : Codable {
    var title : String = ""
    var done : Bool = false
}
