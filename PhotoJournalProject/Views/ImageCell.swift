//
//  ImageCell.swift
//  PhotoJournalProject
//
//  Created by Amy Alsaydi on 1/22/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

protocol ImageCellDelegate: AnyObject { // why any object?
    func didPressEdit(_ photoJournal: JournalEntry)
}

class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()

        imageView.layer.cornerRadius = imageView.frame.height/13

    }
    
    var delegate: ImageCellDelegate?
    
    var photoJournal: JournalEntry?
    
    func confiureCell(image: JournalEntry) {
        photoJournal = image
        
        captionLabel.text = image.caption
        dateLabel.text = image.date.description
        
        guard let photo = UIImage(data: image.imageData) else {
            return
        }
        imageView.image = photo
    }
    
    @IBAction func didPressEdit(_ sender: UIButton) {
        
        delegate?.didPressEdit(photoJournal!) // danger force unwrapping
        
    }
    
    
    
    
    
}
