//
//  AlarmTableViewController.swift
//  Alarmadillo
//
//  Created by Eros Campos on 8/3/20.
//  Copyright © 2020 Eros Campos. All rights reserved.
//

import UIKit

class AlarmTableViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tapToSelectImageLabel: UILabel!

    var alarm: Alarm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting the user interface correctly
        title = alarm.name
        nameTextField.text = alarm.name
        captionTextField.text = alarm.caption
        datePicker.date = alarm.time
        
        if alarm.image.count > 0 {
            // If we have an image, try to load it
            let imageFileName = Helper.getDocumentsDirectory().appendingPathComponent(alarm.image)
            
            imageView.image = UIImage(contentsOfFile: imageFileName.path)
            tapToSelectImageLabel.isHidden = true
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 2
        } else {
            return 1
        }
    }
    
    //MARK: - TEXTFIELD DELEGATES
    func textFieldDidEndEditing(_ textField: UITextField) {
        alarm.name = nameTextField.text!
        alarm.caption = captionTextField.text!
        title = alarm.name
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - CUSTOM FUNCTIONS
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        alarm.time = datePicker.date
    }
    
    //Taken from HappyDays project
    @IBAction func imageViewTapped(_ sender: UIImageView) {
        let vc = UIImagePickerController()
        
        vc.modalPresentationStyle = .formSheet
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //1. Dismiss the image picker
        dismiss(animated: true)
        
        //2. fetch the image that was picked
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        
        let fm = FileManager()
        
        if alarm.image.count > 0 {
            //3. The alarm has an image, so discard it first
            do {
                let currentImage = Helper.getDocumentsDirectory().appendingPathComponent(alarm.image)
                
                if fm.fileExists(atPath: currentImage.path) {
                    try fm.removeItem(at: currentImage)
                }
            } catch {
                print("Failed to remove current image")
            }
        }
        
        do {
            //4. Generate a new filename for the image
            alarm.image = "\(UUID().uuidString).jpg"
            
            //5. Write the new image to the documents directory
            let newPath = Helper.getDocumentsDirectory().appendingPathComponent(alarm.image)
            
            let jpeg = image.jpegData(compressionQuality: 0.8)
            
            try jpeg?.write(to: newPath)
            
        } catch {
           print("Failed to save new image")
        }
        
        //6. Update the user interface
        imageView.image = image
        tapToSelectImageLabel.isHidden = true
    }
}
