//
//  CategoryViewController.swift
//  Todoey
//
//  Created by 劉子瑜 on 2019/4/19.
//  Copyright © 2019 劉子瑜. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    

    var categories: Results<Category>?    //data type是看category object回傳的型態決定，?:optional
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    //顯示每一列的資料
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell" , for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Category Added Yet"
        
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
            try realm.write {   //commit change realm
                realm.add(category)
            }
        }catch{
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    //load up all of the categories that we currently own
    func loadCategories(){
        categories = realm.objects(Category.self)   //會拿出所有在realm且type是category的東西
        tableView.reloadData()
        
    }
    
    //Mark - Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            
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
