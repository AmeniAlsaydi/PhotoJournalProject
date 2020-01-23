//
//  PersistenceHelper.swift
//  PhotoJournalProject
//
//  Created by Amy Alsaydi on 1/23/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation

enum DataPersistenceError: Error { // conforming to the Error protocol
  case savingError(Error) // associative value
  case fileDoesNotExist(String)
  case noData
  case decodingError(Error)
  case deletingError(Error)
}

class PersistenceHelper {
  
  // CRUD - create, read, update, delete
  
  // array of entries
  private var journalEntries = [JournalEntry]()
  
  private var filename: String
  
  init(filename: String) {
    self.filename = filename
  }
  
  private func save() throws {
    // step 1.
     // get url path to the file that the Entry will be saved to
     let url = FileManager.pathToDocumentsDirectory(with: filename)
    
    // entries array will be object being converted to Data
    // we will use the Data object and write (save) it to documents directory
    do {
      // step 3.
      // convert (serialize) the journalEntries array to Data
      let data = try PropertyListEncoder().encode(journalEntries)
      
      // step 4.
      // writes, saves, persist the data to the documents directory
      try data.write(to: url, options: .atomic)
    } catch {
      // step 5.
      throw DataPersistenceError.savingError(error)
    }
  }
  
  // for re-ordering
  public func reorderEntries(journalEntries: [JournalEntry]) {
    self.journalEntries = journalEntries
    try? save()
  }
  
  // DRY - don't repeat yourself
  
  // create - save item to documents directory
  public func create(entry: JournalEntry) throws {
    // step 2.
    // append new entry to the entry array
    journalEntries.append(entry)
    
    do {
      try save()
    } catch {
      throw DataPersistenceError.savingError(error)
    }
  }

  // read - load (retrieve) items from documents directory
  public func loadEntries() throws -> [JournalEntry] {
    // we need access to the filename URL that we are reading from
    let url = FileManager.pathToDocumentsDirectory(with: filename)
    
    // check if file exist
    // to convert URL to String we use .path on the URL
    if FileManager.default.fileExists(atPath: url.path) {
      if let data = FileManager.default.contents(atPath: url.path) {
        do {
          journalEntries = try PropertyListDecoder().decode([JournalEntry].self, from: data)
        } catch {
          throw DataPersistenceError.decodingError(error)
        }
      } else {
        throw DataPersistenceError.noData
      }
    }
    else {
      throw DataPersistenceError.fileDoesNotExist(filename)
    }
    return journalEntries
  }
  
  // delete - remove item from documents directory
  public func delete(entry index: Int) throws {
    // remove the item from the entry array
    journalEntries.remove(at: index)
    
    // save our entry array to the documents directory
    do {
      try save()
    } catch {
      throw DataPersistenceError.deletingError(error)
    }
  }
}
