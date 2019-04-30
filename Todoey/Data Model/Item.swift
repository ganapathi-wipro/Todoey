//
//  Item.swift
//  Todoey
//
//  Created by Ganapathi on 25/04/2019.
//  Copyright © 2019 Ganapathi. All rights reserved.
//

import Foundation

class Item : Encodable, Decodable{
    var title : String = ""
    var done : Bool = false
}
