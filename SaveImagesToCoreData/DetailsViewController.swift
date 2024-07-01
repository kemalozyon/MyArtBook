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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        buttonProperty.isEnabled = false
        //Use imageView as button in order to add photos from library or camera to your imageview.
        imageView.isUserInteractionEnabled = true
        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addImage))
        imageView.addGestureRecognizer(imageGestureRecognizer)
        //This code to close keyboard when u click on view so that u can reach the save button
        let viewGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(viewGestureRecognizer)
        
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
            
            let newPainting = NSEntityDescription.insertNewObject(forEntityName: "Paintings", into: context)
            
            //Adding objects to DataBase
            newPainting.setValue(namefield.text!, forKey: "name")
            newPainting.setValue(artistField.text!, forKey: "artist")
            newPainting.setValue(UUID(), forKey: "id")
            let myPaint = imageView.image!.jpegData(compressionQuality: 0.5)
            newPainting.setValue(myPaint, forKey: "image")
            newPainting.setValue(year, forKey: "year")
        }else{
            let alert = UIAlertController(title: "Error", message: "Please enter a number for the blank of age!", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: nil)
            alert.addAction(okButton)
            present(alert,animated: true)
        }
        
    }
    
}
