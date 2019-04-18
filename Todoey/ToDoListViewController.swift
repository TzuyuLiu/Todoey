//
//  ViewController.swift
//  Todoey
//
//  Created by 劉子瑜 on 2019/4/18.
//  Copyright © 2019 劉子瑜. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController{

    @IBOutlet var messageTableView: UITableView!
    
    let itemArray = ["Find Mike","Buy Eggos","Destory Demogorgon"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    //Mark - Tableview Datasource Methods 有兩個method
    
    //顯示的列數
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //顯示每一列的資料
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDOItemCell" , for: indexPath)
        
    
        cell.textLabel?.text = itemArray[indexPath.row]
        
        
        return cell
    }
    
    
    //Mark - TableView Delegate Methods
    //ells the delegate that the specified row is now selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(indexPath.row)
        print(itemArray[indexPath.row])
        
        tableView.deselectRow(at: indexPath , animated: true)   //選了之後會自己灰色調會消失
        
        //增加或移除原本有的check markaccessoryType在Main.storyborad 中的 ToDOItemCell 可以找到
        if  tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
             tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }

    }
}

