//
//  Category.swift
//  Todoey
//
//  Created by 劉子瑜 on 2019/4/21.
//  Copyright © 2019 劉子瑜. All rights reserved.
//

import Foundation
import RealmSwift
class Category:Object{
   @objc dynamic var name : String = ""
   let items = List<Item>()// List is like array，<>中間放data type，()代表list是空的

}
