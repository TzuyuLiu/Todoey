//
//  ViewController.swift
//  Todoey
//
//  Created by 劉子瑜 on 2019/4/18.
//  Copyright © 2019 劉子瑜. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    @IBOutlet var messageTableView: UITableView!
    
    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext   //用來與persistent container溝通

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(dataFilePath)
        
        
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
        
        return cell
    }
    
    
    //Mark - TableView Delegate Methods
    //ells the delegate that the specified row is now selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        context.delete(itemArray[indexPath.row])      //delete context
//        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done //等同以下五行，只會修改tableview裡面的check mark，並沒有改到plist裡面的，必須使用encoder才能修改到
        saveItem()
        
        tableView.deselectRow(at: indexPath , animated: true)   //選了之後會自己灰色調會消失
    }
    //Mark - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        
        var textFiled = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action)
            in   //what will happen once the user clicks the Add item button on our UIAlert
            
            
            let newItem = Item(context: self.context)
            newItem.title = textFiled.text!
            newItem.done = false
            self.itemArray.append(newItem)
            
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
        do{
            try context.save()
        }catch{
            print("Error saving context \(error)")
        }
        //self.defaults.set(self.itemArray, forKey: "TodoListArray")    原先加入在addButtonPressed //使用defaluts來將資料儲存進iphone記憶體中(Documents資料夾裡)，記憶體內容不會隨著關閉程式而消失，儲存格式永遠都是plist，所以要有key去儲存value
        self.tableView.reloadData() //增加東西之後都需要reload data才會將新增的東西顯示出來
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()){   //如果request沒有值，就會預設Item.fetchRequest()
        do{
           itemArray = try context.fetch(request)
        }catch{
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }

}

extension ToDoListViewController : UISearchBarDelegate{         //extension可以把每種protocol(UISearchBarDelegate)分開
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with:request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) { //textDidChange:每次searchbar內容便的時候都會觸發
        if searchBar.text?.count == 0{  //當searchbar 沒有東西的時候，就把所有儲存的東西都放回去
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder() //將所有的東西變回原來一開始load這個畫面時的狀態，也就是把鍵盤縮回去
            }
        }
    }
}
