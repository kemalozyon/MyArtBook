//
//  ViewController.swift
//  SaveImagesToCoreData
//
//  Created by Kemal Özyön on 1.07.2024.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var tableView: UITableView!
    var myName = [String]()
    var myId = [UUID] ()
    var selectedImage = ""
    var id = UUID()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(goToDetailsVC))
        getItems()
        
    }
    @objc func goToDetailsVC(){
        selectedImage = ""
        performSegue(withIdentifier: "goToDetails", sender: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myName.count
    }
    @objc func getItems(){
        myName.removeAll(keepingCapacity: false)
        myId.removeAll(keepingCapacity: false)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pictures")
        fetchRequest.returnsObjectsAsFaults = false
        do{
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject]{
                if let name = result.value(forKey: "name") as? String{
                    self.myName.append(name)
                }
                if let id = result.value(forKey: "id") as? UUID{
                    self.myId.append(id)
                }
            }
        }catch{
            print("An Error was occored while trying to fetch.")
        }
        
        self.tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var context = cell.defaultContentConfiguration()
        context.text = myName[indexPath.row]
        cell.contentConfiguration = context
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getItems), name: Notification.Name(rawValue: "newData"), object: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedImage = myName[indexPath.row]
        id = myId[indexPath.row]
        performSegue(withIdentifier: "goToDetails", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetails"{
            let destinationVC = segue.destination as! DetailsViewController
            destinationVC.chosenImage = selectedImage
            destinationVC.chosenID = id
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pictures")
            
            fetchRequest.predicate = NSPredicate(format: "id = %@", myId[indexPath.row].uuidString)
            
            fetchRequest.returnsObjectsAsFaults = false
            do{
                var results = try context.fetch(fetchRequest)
                if results.count > 0{
                    for result in results as! [NSManagedObject]{
                        if let idLocal = result.value(forKey: "id") as? UUID{
                            if idLocal == myId[indexPath.row]{
                                context.delete(result)
                                myName.remove(at: indexPath.row)
                                myId.remove(at: indexPath.row)
                                self.tableView.reloadData()
                            }
                                
                                
                                
                            
                        }
                    }
                }
            }catch{
                
            }
            
        }
    }
}

