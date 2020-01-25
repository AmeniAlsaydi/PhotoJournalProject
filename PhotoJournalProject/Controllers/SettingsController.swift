//
//  SettingsController.swift
//  PhotoJournalProject
//
//  Created by Amy Alsaydi on 1/25/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

protocol SettingsDelegate: AnyObject {
    func didSelectColor(color: UIColor)
}

class SettingsController: UIViewController {
    
    @IBOutlet weak var pinkButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var yellowButon: UIButton!
    
    var backgroundColor: UIColor?
    
    var delegate: SettingsDelegate? // making this a weak didnt work
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        let buttons = [pinkButton, greenButton, yellowButon]
        
        buttons.map { $0?.layer.cornerRadius = ($0?.frame.width ?? 1)/2 }

    }
    
    @IBAction func colorWasSelected(_ sender: UIButton) {
        backgroundColor = sender.backgroundColor
        
        // sender.setImage(UIImage(systemName: "checkmark.circle"), for: .normal) // works but doesnt disappear if another disappears.
        
        delegate?.didSelectColor(color: backgroundColor ?? .red)
        
        // print(backgroundColor)
        
    }

}
