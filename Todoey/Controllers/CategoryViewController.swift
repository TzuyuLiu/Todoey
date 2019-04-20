//
//  CategoryViewController.swift
//  Todoey
//
//  Created by 劉子瑜 on 2019/4/19.
//  Copyright © 2019 劉子瑜. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categories = [Category]()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    //顯示每一列的資料
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell" , for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }
    
    //Mark - TableVIew Datasource Methods
    
    //顯示的列數
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
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
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    
    
    //Mark - Manipulation Methods
    
    func saveCategories(){
        do{
            try context.save()
        }catch{
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadCategories(){
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do{
            categories = try context.fetch(request)
        }catch{
            print("Error loading categories \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    //Mark - Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categories.append(newCategory)
            
            self.saveCategories()
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
}
