//
//  ViewController.swift
//  ToDoListCoreData
//
//  Created by Gokhan Gokova on 9.10.2018.
//  Copyright © 2018 Gokhan Gokova. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var selectedCategories: Category? {
        //kategori seçildiğinde ne yapacak buradaki didSet ozel kullandığımız bir parametre.
        didSet{
            loadItems()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK - TableView DataSource Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) as! ToDoListTableViewCell
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        let item = itemArray[indexPath.row]
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MArk - TableView Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //itemArray[indexPath.row].done = !itemArray[indexPath.row].done - aşağıdaki kullanımın kısa olanı
        if itemArray[indexPath.row].done ==  false{
            itemArray[indexPath.row].done = true
        }else{
            itemArray[indexPath.row].done = false
        }
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
        case .delete:
            let alert = UIAlertController(title: "Silmek istediğinizden emin misiniz?", message: "", preferredStyle: UIAlertController.Style.actionSheet)
            let actionDelete = UIAlertAction(title: "Sil", style: UIAlertAction.Style.destructive) { (actionDelete) in
                self.context.delete(self.itemArray[indexPath.row])
                self.itemArray.remove(at: indexPath.row)
                self.saveItems()
            }
            //alert.view.tintColor = UIColor.red
            let actionCancel = UIAlertAction(title: "Geri Dön", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(actionDelete)
            alert.addAction(actionCancel)
            self.present(alert, animated: true, completion: nil)
        default:
            return
        }
        
    }
    //AlertAction butonların ozellikleri ile oynamak için eklenir.
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Sil") { (UITableViewRowAction, IndexPath) in
            self.tableView.dataSource?.tableView!(self.tableView, commit: UITableViewCell.EditingStyle.delete, forRowAt: indexPath)
            return
        }
        delete.backgroundColor = UIColor.orange
        delete.title = "Sil"
        return [delete]
    }
    
    @IBAction func addButtonClicked(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Yeni Liste Ekle", message: "", preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Ekle", style: UIAlertAction.Style.default) { (action) in
            
            if textField.text != ""{
                let newItem = Item(context: self.context)
                newItem.title = textField.text
                newItem.done = false
                newItem.parentCategory = self.selectedCategories
                self.itemArray.append(newItem)
                self.saveItems()
                
                self.tableView.reloadData()
            }else{
                print("Liste Girmediniz.")
            }

        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Liste Adı Girin"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //Mark - Model Manupulation Methods
    func saveItems(){
        do {
            try context.save()
        } catch  {
            print("Kaydedilirken Hata Oluştu: \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategories!.name!)
        
        if let additionalPredicate = predicate {
          request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
                
        do {
            itemArray = try context.fetch(request)
        } catch  {
            print("Okunurken Hata Oluştu: \(error)")
        }
    }
}

//MARK - UISearchBar Methods
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        //aşağıda açıklama satırı olarak gelen kod dizimi code refactoring için yukarıda zaten bu fonskiyonu kullandığımız için fonksiyone sadece bir parametre ekleyerek tekrar eden kod yazımından kurtulmuş olduk.
        loadItems(with: request, predicate: predicate)
//        do {
//            itemArray =  try context.fetch(request)
//        } catch  {
//            print("Arama Yapılırken Hata Oluştu \(error)")
//        }
        tableView.reloadData()
        
    }
    
    //searchbar içerisinde herhangi bir şey yazılı değilse bütün datayı tekrar ekrana basmak için gerekli.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}


