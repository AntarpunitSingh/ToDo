//
//  Item.swift
//  ToDo
//
//  Created by Antarpunit Singh on 2012-06-06.
//  Copyright © 2019 AntarpunitSingh. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var date: Date?
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
