//
//  ViewController.swift
//  PhotoJournalProject
//
//  Created by Amy Alsaydi on 1/22/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class PhotoJournalController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
    }


}

extension PhotoJournalController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath)
        
        return cell 
    }
    
    
}

