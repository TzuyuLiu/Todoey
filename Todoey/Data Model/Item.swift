//
//  Item.swift
//  Todoey
//
//  Created by 劉子瑜 on 2019/4/18.
//  Copyright © 2019 劉子瑜. All rights reserved.
//

import Foundation

class Item : Codable{ // <-- 'Encodable'，itemArray才能encode，要與encoder一致的data type，同理也要Decodable，兩者合起來就是Codable
    var title : String = ""
    var done : Bool = false
    
}
