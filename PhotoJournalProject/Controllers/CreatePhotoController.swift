//
//  EntryViewController.swift
//  PhotoJournalProject
//
//  Created by Amy Alsaydi on 1/22/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

import AVFoundation // we want to use AVMakeRect() to maintain image aspect ratio


enum PhotoState: String {
    case newPhoto
    case existingPhoto
}

protocol CreateVCDelegate: AnyObject {
    func didCreateJournalEntry(journalEntry: JournalEntry)
    func didUpdateJournalEntry(oldEntry: JournalEntry, newEntry: JournalEntry)
    
}

class CreatePhotoController: UIViewController {
    
    // outlets
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    private var imagePickerController = UIImagePickerController()
    
    weak var delegate: CreateVCDelegate?
    
    public private(set) var photoState = PhotoState.newPhoto // by default its a newPhoto
    
    var photo: JournalEntry? {
        didSet {
            photoState = PhotoState.existingPhoto
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false
        
        captionTextView.delegate = self
        imagePickerController.delegate = self
        checkCamera()
        updateUI()
        addDoneToKeyBoard()
        
    }
    
    @objc private func doneClicked() {
        view.endEditing(true)
    }
    
    private func addDoneToKeyBoard() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let donebutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done , target: self, action: #selector(self.doneClicked))
        toolbar.setItems([donebutton], animated: true)
        captionTextView.inputAccessoryView = toolbar
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
        
        if photoState == .existingPhoto {
            guard let photo = photo else {
                fatalError("no photo journal passed")
            }
            captionTextView.text = photo.caption
            imageView.image = UIImage(data: photo.imageData)
            saveButton.title = "Update"
        }
    }
    
    // actions
    
    @IBAction func libraryButtonPressed(_ sender: UIBarButtonItem) {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    
    
    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
        
        imagePickerController.sourceType = UIImagePickerController.SourceType.camera
        
        present(imagePickerController, animated: true)
    }
    
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        // TODO: fix this so that the default image and caption arent added once the save button is pressed.
        
        // create the journalEntry
        
        let thisImage = imageView.image
        
        guard let image = thisImage else {
            print("image is nil")
            return
        }
        // we will resize image: the size for the resizing of the image
        let size = UIScreen.main.bounds.size
        
        //we will maintain the aspect ratio of the image
        
        let rect = AVMakeRect(aspectRatio: image.size, insideRect: CGRect(origin: CGPoint.zero, size: size))
        
        // resize image
        let resizeImage = image.resizeImage(to: rect.size.width, height: rect.size.height)
        
        guard let resizedImageData = resizeImage.jpegData(compressionQuality: 1.0) else {
            return
        }
        
        let journalEntry = JournalEntry(imageData: resizedImageData, caption: captionTextView.text, date: Date())
        
        switch photoState {
        case .newPhoto:
            delegate?.didCreateJournalEntry(journalEntry: journalEntry) // works
        case .existingPhoto:
            guard let photo = photo else { 
                fatalError("no photo journal passed")
            }
            delegate?.didUpdateJournalEntry(oldEntry: photo, newEntry: journalEntry)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension CreatePhotoController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // we need to access the UIImagePickerController.InfoKey.orignalImage key to get the UIImage that was selected
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage]  as? UIImage else {
            print("image not found")
            return
        }
        imageView.image = image
        dismiss(animated: true)
    }
}

extension CreatePhotoController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        switch photoState {
        case .existingPhoto:
            break
        case .newPhoto:
            textView.text = ""
        }
        
        saveButton.isEnabled = true
    }
}


extension UIImage {
    func resizeImage(to width: CGFloat, height: CGFloat) -> UIImage {
        let size = CGSize(width: width, height: height)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
