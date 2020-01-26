//
//  SettingsController.swift
//  PhotoJournalProject
//
//  Created by Amy Alsaydi on 1/25/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

enum ColorName: Int {
    case purple = 0
    case green = 1
    case yellow = 2
}

enum Direction: String {
    case horizontal
    case vertical
}

protocol SettingsDelegate: AnyObject {
    func didSelectColor(backgroundColor: UIColor, colorName: ColorName)
    func didSelectDirection(direction: Direction)
}

class SettingsController: UIViewController {
    
    @IBOutlet weak var pinkButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var yellowButon: UIButton!
    
    var buttons = [UIButton]()
    
    var backgroundColor: UIColor? {
        didSet {
            // store in user defaults
        }
    }
    var direction = Direction.vertical {
        didSet {
            // store in user defaults 
            
        }
    }
    
    var delegate: SettingsDelegate? // making this a weak didnt work
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        buttons = [pinkButton, greenButton, yellowButon]
        
        
        buttons.map { $0.layer.cornerRadius = ($0.frame.width ?? 1)/2 }
    }
    
    @IBAction func colorWasSelected(_ sender: UIButton) {
        backgroundColor = sender.backgroundColor
        
        // sender.setImage(UIImage(systemName: "checkmark.circle"), for: .normal) // works but doesnt disappear if another disappears.
        print(backgroundColor)
        
        let color = ColorName(rawValue: sender.tag) ?? .purple
        delegate?.didSelectColor(backgroundColor: backgroundColor ?? .red, colorName: color)
        
        UserSetting.shared.updateColor(with: sender.tag)
        
    }
    
    
    @IBAction func directionWasSelected(_ sender: UIButton) {
        if sender.tag == 0 {
            direction = Direction.horizontal
        } else if sender.tag == 1 {
            direction = Direction.vertical
        }
        
        delegate?.didSelectDirection(direction: direction)
        
    }
    

}
