//
//  Category.swift
//  ToDo
//
//  Created by Antarpunit Singh on 2012-06-06.
//  Copyright © 2019 AntarpunitSingh. All rights reserved.
//

import Foundation
import RealmSwift
class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
