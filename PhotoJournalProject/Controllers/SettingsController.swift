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
    @IBOutlet weak var sideButton: UIButton!
    @IBOutlet weak var upButton: UIButton!
    
    lazy var colorButtons: [UIButton] = [pinkButton, greenButton, yellowButon]
    
    lazy var directionButtons: [UIButton] = [sideButton, upButton]
    
    var backgroundColor: UIColor?
    var direction = Direction.vertical
    
    var delegate: SettingsDelegate? // making this a weak didnt work
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        _ = colorButtons.map { $0.layer.cornerRadius = ($0.frame.width )/2 }
        _ = directionButtons.map { $0.layer.cornerRadius = ($0.frame.width )/2 }
    }
    
    @IBAction func colorWasSelected(_ sender: UIButton) {
        backgroundColor = sender.backgroundColor
        
        _ = colorButtons.map { $0.setImage(nil, for: .normal) }
        
        sender.tintColor = .black
        sender.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        
        
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
        UserSetting.shared.updateDirection(with: direction)
        
    }
    
    @IBAction func applyWasPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    

}
