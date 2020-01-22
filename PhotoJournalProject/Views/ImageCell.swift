//
//  ImageCell.swift
//  PhotoJournalProject
//
//  Created by Amy Alsaydi on 1/22/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    func confiureCell(image: ImageObject) {
        captionLabel.text = image.caption
        dateLabel.text = image.date.description
        
        guard let photo = UIImage(data: image.imageData) else {
            return
        }
        imageView.image = photo
    }
    
}
