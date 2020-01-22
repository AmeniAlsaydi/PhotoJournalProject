//
//  ImageObject.swift
//  PhotoJournalProject
//
//  Created by Amy Alsaydi on 1/22/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation

struct ImageObject: Codable {
    let imageData: Data
    let caption: String
    let date: Date // date it was added
    let identifier = UUID().uuidString
}
