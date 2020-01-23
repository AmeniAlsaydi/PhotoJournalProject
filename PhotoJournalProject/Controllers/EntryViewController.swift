//
//  EntryViewController.swift
//  PhotoJournalProject
//
//  Created by Amy Alsaydi on 1/22/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

protocol EntryVCDelegate: AnyObject {
    func didCreateJournalEntry(journalEntry: JournalEntry)
}

class EntryViewController: UIViewController {
    
    
    // outlets
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    private var imagePickerController = UIImagePickerController()
    
    var delegate: EntryVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerController.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            // is the source of image OF TYPE CAMERA availble
            cameraButton.isEnabled = true
        } else {
            cameraButton.isEnabled = false
        }

    }
    

    // actions
    
    @IBAction func libraryButtonPressed(_ sender: UIBarButtonItem) {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    
    
    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
        
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true)
    }
    
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        // create the imageObject
        guard let imageData = imageView.image?.jpegData(compressionQuality: 1.0) else {
        print("Couldnt convert image to data")
        return
        }
        let journalEntry = JournalEntry(imageData: imageData, caption: captionTextView.text, date: Date())
        // pass to delegate (I think)
        // would this vc be the delegating object in this case?
        delegate?.didCreateJournalEntry(journalEntry: journalEntry)
        dump(journalEntry)
        
    }
    
    //TODO: Deal with Cancel button.
    
}

extension EntryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) { // Any
        // we need to access the UIImagePickerController.InfoKey.orignalImage key to get the UIImage that was selected
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage]  as? UIImage else { // uncropped image
            print("image not found")
            return
        }
        imageView.image = image
        
        dismiss(animated: true)
    }
    
}
