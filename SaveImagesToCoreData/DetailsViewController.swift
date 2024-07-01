//
//  DetailsViewController.swift
//  SaveImagesToCoreData
//
//  Created by Kemal Özyön on 1.07.2024.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var namefield: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var artistField: UITextField!
    @IBOutlet weak var yearField: UITextField!
    @IBOutlet weak var buttonProperty: UIButton!
    @IBOutlet weak var approvedImage: UIImageView!
    var chosenImage = ""
    var chosenID : UUID?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if chosenImage != ""{
            //Core Data
            buttonProperty.isHidden = true
            artistField.isEnabled = false
            namefield.isEnabled = false
            yearField.isEnabled = false
            imageView.isUserInteractionEnabled = false
            let idString = chosenID?.uuidString
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pictures")
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
            do{
                let results = try context.fetch(fetchRequest)
                if results.count > 0{
                    for result in results as! [NSManagedObject]{
                        if let name = result.value(forKey: "name") as? String{
                            namefield.text = name
                        }
                        if let artist = result.value(forKey: "artist") as? String{
                            artistField.text = artist
                        }
                        if let year = result.value(forKey: "year") as? Int32{
                            yearField.text = String(year)
                        }
                        if let image = result.value(forKey: "picture") as? Data{
                            imageView.image = UIImage(data: image)
                        }
                    }
                }
            }catch{
                
            }
            
        }else{
            approvedImage.isHidden = true
            buttonProperty.isEnabled = false
            //Use imageView as button in order to add photos from library or camera to your imageview.
            imageView.isUserInteractionEnabled = true
            let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addImage))
            imageView.addGestureRecognizer(imageGestureRecognizer)
            //This code to close keyboard when u click on view so that u can reach the save button
            let viewGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
            view.addGestureRecognizer(viewGestureRecognizer)
        }
        
        
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    @objc func addImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        let alert = UIAlertController(title: "Camere or Library", message: "Would you like to choose Photo from library or take one?", preferredStyle: UIAlertController.Style.actionSheet)
        let cameraButton = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) { UIAlertAction in
            picker.sourceType = .camera
            self.present(picker,animated: true)
        }
        let libraryButton = UIAlertAction(title: "Library", style: UIAlertAction.Style.default) { UIAlertAction in
            picker.sourceType = .photoLibrary
            self.present(picker,animated: true,completion: nil)
        }
        let defaulButton = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive, handler: nil)
        
        alert.addAction(cameraButton)
        alert.addAction(libraryButton)
        alert.addAction(defaulButton)
        present(alert, animated: true,completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.editedImage] as? UIImage
        self.dismiss(animated: true,completion: nil)
        //Button shows when you choose the image
        buttonProperty.isEnabled = true
        
    }
    @IBAction func saveButtonClicked(_ sender: Any) {
        if let year = Int(yearField.text!){
            //
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context  = appDelegate.persistentContainer.viewContext
            
            let newPainting = NSEntityDescription.insertNewObject(forEntityName: "Pictures", into: context)
            
            //Adding objects to DataBase
            newPainting.setValue(namefield.text!, forKey: "name")
            newPainting.setValue(artistField.text!, forKey: "artist")
            newPainting.setValue(UUID(), forKey: "id")
            let myPaint = imageView.image!.jpegData(compressionQuality: 0.5)
            newPainting.setValue(myPaint, forKey: "picture")
            newPainting.setValue(year, forKey: "year")
            
            do{
                try context.save()
                let alert = UIAlertController(title: "Succeed", message: "Picture has been successfully saved!", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { UIAlertAction in
                    self.buttonProperty.isHidden=true
                    self.approvedImage.isHidden = false
                    NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(okButton)
                present(alert,animated: true)
            }catch{
                
            }
        }else{
            let alert = UIAlertController(title: "Error", message: "Please enter a number for the blank of age!", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: nil)
            alert.addAction(okButton)
            present(alert,animated: true)
        }
        
    }
    
}
