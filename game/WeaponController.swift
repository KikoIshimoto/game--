//
//  WeaponController.swift
//  game
//
//  Created by IshimotoKiko on 2016/03/26.
//  Copyright © 2016年 IshimotoKiko. All rights reserved.
//

import SpriteKit

class WeaponContollore{
    
    class func getWeapon(_ Whose:Bool , WeaponID:Int) -> Weapon!
    {
        var weapon:Weapon = Weapon(Whose: true)
        let weaponParamate = FileManager.weaponParamateRead(WeaponID)
        let skill:[Skill] = []
        switch WeaponID {
        case 1:
            weapon = Bullet(Whose: Whose, Option: skill)
        case 2:
            weapon = spreadBullet(Whose: Whose, Option: skill)
        case 3:
            weapon = diffusionBullet(Whose: Whose, Option: skill)
        default: return nil
        }
        weapon.Status = weaponParamate
        weapon.Status.Whose = Whose
        return weapon
    }
}
