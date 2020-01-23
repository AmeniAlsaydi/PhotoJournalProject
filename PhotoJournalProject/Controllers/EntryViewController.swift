//
//  EntryViewController.swift
//  PhotoJournalProject
//
//  Created by Amy Alsaydi on 1/22/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class EntryViewController: UIViewController {
    
    // outlets
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    private var imagePickerController = UIImagePickerController()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerController.delegate = self

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

}

extension EntryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}
