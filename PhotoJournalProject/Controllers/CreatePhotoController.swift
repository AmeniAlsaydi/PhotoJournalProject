//
//  EntryViewController.swift
//  PhotoJournalProject
//
//  Created by Amy Alsaydi on 1/22/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

enum PhotoState: String {
  case newPhoto
  case existingPhoto
}

protocol EntryVCDelegate: AnyObject {
    func didCreateJournalEntry(journalEntry: JournalEntry)
}

class CreatePhotoController: UIViewController {

    // outlets
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    private var imagePickerController = UIImagePickerController()
    
    var delegate: EntryVCDelegate?
    
    public private(set) var photoState = PhotoState.newPhoto // by default its a newPhoto
    
    var photo: JournalEntry? {
        didSet {
            photoState = PhotoState.existingPhoto
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captionTextView.delegate = self
        imagePickerController.delegate = self
        checkCamera()
        updateUI()
        
    }
    
    private func checkCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            // is the source of image OF TYPE CAMERA availble
            cameraButton.isEnabled = true
        } else {
            cameraButton.isEnabled = false
        }
    }
    
    private func updateUI() {
        
        switch photoState {
        case .existingPhoto:
            guard let photo = photo else {
                fatalError("no photo journal passed")
            }
            captionTextView.text = photo.caption
            imageView.image = UIImage(data: photo.imageData)
            saveButton.title = "Update"
        case .newPhoto:
            break
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
        
        // TODO: fix this so that the default image and caption arent added once the save button is pressed.
        
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension CreatePhotoController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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

extension CreatePhotoController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        resignFirstResponder()
    }
    
    
}
