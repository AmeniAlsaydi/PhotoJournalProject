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
        collectionView.delegate = self
    }
    
    private var jouralEntries = [JournalEntry]() {
        didSet {
            collectionView.reloadData() // reload collection view fucntions once an entry is added
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let EntryVC = segue.destination as? EntryViewController else {
            print("couldnt get Entry VC")
            return
        }
        EntryVC.delegate = self
    }
}

extension PhotoJournalController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jouralEntries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? ImageCell else {
            fatalError("no custom cell")
        }
        
        let journalEntry = jouralEntries[indexPath.row]
        
        cell.confiureCell(image: journalEntry)
        
        return cell 
    }
    
}

extension PhotoJournalController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // expecting a cg size which is a tuple of two values
        
        let interItemSpacing: CGFloat = 10 // space betweem items
        let maxWidth = UIScreen.main.bounds.size.width // device width
        
        let numberOfItems: CGFloat = 2 // items
        let totalSpacing: CGFloat = numberOfItems * interItemSpacing
        
        let itemWidth: CGFloat = (maxWidth - totalSpacing)/numberOfItems
        
        return CGSize(width: itemWidth, height: itemWidth) 
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // padding sround collectionview
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5
    }
}

extension PhotoJournalController: EntryVCDelegate {
    func didCreateJournalEntry(journalEntry: JournalEntry) {
        // at this point I have the newly created journal entry
        // I'll pass it into the doc directory
        // but then am i passing it to an array of journal entries and reloading the collection view
        // OR am i just inserting it into the collection view, and into the doc direcory?
        
        jouralEntries.append(journalEntry)
        
    }
    
    
}
