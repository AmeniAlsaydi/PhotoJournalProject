//
//  UserSettings.swift
//  PhotoJournalProject
//
//  Created by Amy Alsaydi on 1/25/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation

struct UserSettingKey {
    static let backgroundColor = "BackgroundColor"
    static let direction = "Direction"
    
}

class UserSetting {
    
     private init() {}
    
    static let shared = UserSetting()
    
    func updateDefaults<T> (with item: T, key: String) {
        UserDefaults.standard.set(item, forKey: key)
    }
    
    func getDefaults<T>(key: String) -> T? {
        guard let defaultValue = UserDefaults.standard.object(forKey: key) as? T else {
            return nil
        }
        return defaultValue
    }
    
    func updateColor(with color: Int) {
        UserDefaults.standard.set(color, forKey: UserSettingKey.backgroundColor)
    }
    
    func getColor() -> Int? {
        guard let color = UserDefaults.standard.object(forKey: UserSettingKey.backgroundColor) as? Int else {
            
           return nil
        }
        return color
    }
    
    func updateDirection(with direction: Direction) {
        UserDefaults.standard.set(direction.rawValue, forKey: UserSettingKey.direction)
        
    }
    
    func getDirection() -> String? {
        
        guard let direction = UserDefaults.standard.object(forKey: UserSettingKey.direction) as? String else {
           return nil
        }
        return direction
    }
    
}
