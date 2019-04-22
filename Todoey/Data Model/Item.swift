//
//  Item.swift
//  Todoey
//
//  Created by 劉子瑜 on 2019/4/21.
//  Copyright © 2019 劉子瑜. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
   @objc dynamic var title : String = ""
   @objc dynamic var done : Bool = false
   @objc dynamic var dateCreated : Date?
   //將每個property連回parentCategory，fromType是指parentCategory的type，property是指parentCategory的名字
   var parentCategory = LinkingObjects(fromType: Category.self, property: "items")      //加了.self才是type
    

}
