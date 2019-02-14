//
//  Category.swift
//  Todoey
//
//  Created by Haoran Hu on 2/13/19.
//  Copyright © 2019 hhr. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name : String = ""
    let items = List<Item>()
    
}
