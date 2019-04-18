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
    
    let defaults = UserDefaults.standard
    
    var itemArray = ["Find Mike","Buy Eggos","Destory Demogorgon"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //將存在Documents裡面的data放回itemArray
        if let  items = defaults.array(forKey: "TodoListArray") as? [String]{
            itemArray = items
        }
        
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
    //Mark - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        
        var textFiled = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            //what will happen once the user clicks the Add item button on our UIAlert
            
            self.itemArray.append(textFiled.text!)
            print("Success!")
            print(textFiled.text)
            
            self.defaults.set(self.itemArray, forKey: "TodoListArray")  //使用defaluts來將資料儲存進iphone記憶體中(Documents資料夾裡)，記憶體內容不會隨著關閉程式而消失，儲存格式永遠都是plist，所以要有key去儲存value
            
            self.tableView.reloadData() //增加東西之後都需要reload data才會將新增的東西顯示出來
        }
        
        //在alert的時候增加text field，按下add button之後就會觸發裡面的事件(在使用者送出textfield之前)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textFiled = alertTextField  //將alertTextField裡的內容從closure拿出來
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}

