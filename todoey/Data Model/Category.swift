//
//  Data.swift
//  todoey
//
//  Created by Marcos Lee on 2/3/19.
//  Copyright © 2019 Marcos Lee. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var bgColor: String = ""
    let items = List<Item>()
}
