//
//  DetailsViewController.swift
//  SaveImagesToCoreData
//
//  Created by Kemal Özyön on 1.07.2024.
//

import UIKit

class DetailsViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var namefield: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var artistField: UITextField!
    
    @IBOutlet weak var yearField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
    }
    @IBAction func saveButtonClicked(_ sender: Any) {
    }
    
}
