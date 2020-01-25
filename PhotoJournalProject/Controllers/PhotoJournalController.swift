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
    
    private let dataPersistence = PersistenceHelper(filename: "journalEntries.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        loadJournalEntries()
    }
    
    
    private var jouralEntries = [JournalEntry]() {
        didSet {
            collectionView.reloadData() // reload collection view fucntions once an entry is added
        }
    }
    
    private func loadJournalEntries() {
        do {
            jouralEntries = try dataPersistence.loadEntries()
        } catch {
            print("loading objects error: \(error)") // also when its empty this will print
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let entryVC = segue.destination as? CreatePhotoController else {
            print("couldnt get Entry VC")
            return
        }
        entryVC.delegate = self
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
        cell.delegate = self
        
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
        
        return CGSize(width: itemWidth, height: itemWidth * 1.2) 
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
        // I passed it to an array of journal entries and reloading the collection view [below]
        jouralEntries.append(journalEntry)
        
        do {
            try dataPersistence.create(entry: journalEntry)
        } catch {
            print("couldnt save: \(error)")
        }
        // I'll pass it into the doc directory
        // OR am i just inserting it into the collection view, and into the doc direcory?
    }
    
    
}

extension PhotoJournalController: ImageCellDelegate {
    func didPressEdit(_ photoJournal: JournalEntry) {
        
        // at this point we have the photo's info from the cell.
        
        // present the action sheet with the options edit - delete - cancel
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "Edit", style: .default) { [weak self]
            alertAction in
            print("editing...")
            
            // in here include the action to be done if the user selects edit: which is the segue to the entry VC controller but with the cells info already populated.
            
            guard let createPhotoController = self?.storyboard?.instantiateViewController(identifier: "CreatePhotoController") as? CreatePhotoController else {
                // developer error
                fatalError("could not downcast to CreatePhotoController")
            }
            
           createPhotoController.photo = photoJournal // coming from the cell
            // in the createVC have a property observer for the photo var, and when its set change the photoState to exisiting? 
            self?.present(createPhotoController, animated: true)
            
        }
        
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { // [weak self] 
            alertAction in
            print("deleting...")
            // in here include the action to be done if the user selects Delete
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alertController.addAction(editAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    
}

