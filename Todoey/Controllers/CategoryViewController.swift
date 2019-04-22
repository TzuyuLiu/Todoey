//
//  CategoryViewController.swift
//  Todoey
//
//  Created by 劉子瑜 on 2019/4/19.
//  Copyright © 2019 劉子瑜. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController{
    
    let realm = try! Realm()
    
    var categories: Results<Category>?    //data type是看category object回傳的型態決定，?:optional
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        tableView.rowHeight = 65
        
        tableView.separatorColor = .none
        
        
    }
    
    //顯示每一列的資料
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)  //使用superclass的tableView(tableView, cellForRowAt: indexPath) function裡面的cell
        
        if let category = categories?[indexPath.row]{
            
            cell.textLabel?.text = category.name
            
            guard let categoryColour = UIColor(hexString: category.Colour) else { fatalError()}
            
            cell.backgroundColor = categoryColour

            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
        }

        
        
        return cell
    }
    
 
    
    //Mark - TableVIew Datasource Methods
    
    //顯示的列數
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1   //if categories not nil , return number , else return 1
    }
    
    
    
    //Mark - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //didSelectRowAt:當觸控某一個row時會觸發此
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    //在執行performSegue之前會先執行以下function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController    //所以若有多個view，在此就可以選擇要去哪個畫面
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row] //indexPath.row 會觸發 segue: UIStoryboardSegue
        }
    }
    
    
    
    //Mark - Manipulation Methods
    
    func save(category: Category){
        do{
            try realm.write {   //commit change realm，realm.write會丟出錯誤
                realm.add(category)
            }
        }catch{
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    //會載入所有category的東西
    func loadCategories(){
        categories = realm.objects(Category.self)   //會拿出所有在realm且type是category的東西
        tableView.reloadData()
        
    }
    
    //MARK - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
       if let categoryForDeletion =  self.categories?[indexPath.row]{
            do{
                try self.realm.write {
                self.realm.delete(categoryForDeletion)
                }
            }catch{
                print("Error deleting category, \(error)")
            }
        }
    }
    
    //Mark - Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.Colour = UIColor.randomFlat.hexValue()
            self.save(category: newCategory)
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        
        present(alert, animated: true, completion: nil)
    }
}
