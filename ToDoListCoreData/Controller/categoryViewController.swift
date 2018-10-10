//
//  categoryViewController.swift
//  ToDoListCoreData
//
//  Created by Gokhan Gokova on 10.10.2018.
//  Copyright © 2018 Gokhan Gokova. All rights reserved.
//

import UIKit
import CoreData

class categoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    //oluşturduğumuz tablodan category tablosuna ait bir array oluşturduk bunu daha sonra tableview içerisinde gostermek için kullanacağız.
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
    }
    
    //MARK: TableView Datasource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    //MARK: TableView Delegate Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategories = categories[indexPath.row]
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "categoryDetail", sender: self)
    }
    
    //MARK: Data Manipulation Methods
    
    func saveCategory(){
        do {
            try context.save()
        } catch  {
            print("Kategori Kaydedilirken Hata Alındı: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategory(){
        //okumak için önce NSFetchRequest Oluştur.
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        //contect'e request'i ekle
        do {
            categories = try context.fetch(request)
        } catch  {
           print("Kategori Kaydedilirken Hata Alındı: \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: IBAction
    
    @IBAction func addNewCategoryClicked(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Yeni Liste Oluştur", message: "", preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Ekle", style: UIAlertAction.Style.default) { (action) in
            
            if textField.text != ""{
                let newItem = Category(context: self.context)
                newItem.name = textField.text!
                self.categories.append(newItem)
                self.saveCategory()

            }else{
                print("Liste Girmediniz.")
            }
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Liste Adı Giriniz"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    


}
