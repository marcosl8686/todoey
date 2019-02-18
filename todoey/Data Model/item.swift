//
//  Data.swift
//  todoey
//
//  Created by Marcos Lee on 2/3/19.
//  Copyright © 2019 Marcos Lee. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
