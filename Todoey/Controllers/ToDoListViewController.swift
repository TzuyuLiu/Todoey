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
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    var itemArray = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(dataFilePath)
        
//        let newItem = Item()
//        newItem.title = "Find Mike"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "Buy Eggos"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Destory Demogorgon"
//        itemArray.append(newItem3)
        
        loadItems()

        
        //將存在Documents裡面的data放回itemArray
        if let  items = defaults.array(forKey: "TodoListArray") as? [Item]{
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
        
        //let cell = UITableViewCell(Style: .default, reuseIdentifier:"ToDoItemCell")   不用這行是因為cell一到view之外就會被砍掉，重新製照一個cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell" , for: indexPath)
        
        print("cell for row at index path call")
        
        let item = itemArray[indexPath.row]
    
        cell.textLabel?.text = item.title
        
        //Ternary operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done == true ? .checkmark : .none //等同以下註解程式，
        //增加或移除原本有的check markaccessoryType在Main.storyborad 中的 ToDOItemCell 可以找到
//        if itemArray[indexPath.row].done == true{
//            cell.accessoryType = .checkmark
//        }else{
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    
    //Mark - TableView Delegate Methods
    //ells the delegate that the specified row is now selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(indexPath.row)
        //print(itemArray[indexPath.row])
        
        tableView.deselectRow(at: indexPath , animated: true)   //選了之後會自己灰色調會消失
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done //等同以下五行，只會修改tableview裡面的check mark，並沒有改到plist裡面的，必須使用encoder才能修改到
        saveItem()  //使用encoder儲存
//        if itemArray[indexPath.row].done == false{
//            itemArray[indexPath.row].done = true
//        }else{
//            itemArray[indexPath.row].done = false
//        }
    }
    //Mark - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        
        var textFiled = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            //what will happen once the user clicks the Add item button on our UIAlert
            
            let newItem = Item()
            newItem.title = textFiled.text!
            self.itemArray.append(newItem)
//            print("Success!")
//            print(textFiled.text)
            
            self.saveItem()
       }
        
        //在alert的時候增加text field，按下add button之後就會觸發裡面的事件(在使用者送出textfield之前)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textFiled = alertTextField  //將alertTextField裡的內容從closure拿出來
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    // Mark - model manupulation Method
    func saveItem(){    //用encoder儲存item
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(self.itemArray)  //itemArray要可以encode必須要在class上面(Item)加上 encodable
            try data.write(to:self.dataFilePath!)
        }catch{
            print("Error encoding item array, \(error)")
        }
        //self.defaults.set(self.itemArray, forKey: "TodoListArray")    原先加入在addButtonPressed //使用defaluts來將資料儲存進iphone記憶體中(Documents資料夾裡)，記憶體內容不會隨著關閉程式而消失，儲存格式永遠都是plist，所以要有key去儲存value
        self.tableView.reloadData() //增加東西之後都需要reload data才會將新增的東西顯示出來
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{   //[Item].self:data type，type is array of item，所以要加上.self
                itemArray = try decoder.decode([Item].self, from: data) //decode data from dataFilePath
            }catch{
                print("Error decoding item array, \(error)")
            }
        }
    }
}

