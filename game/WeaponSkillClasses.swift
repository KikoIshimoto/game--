//
//  Skills.swift
//  game
//
//  Created by IshimotoKiko on 2016/03/29.
//  Copyright © 2016年 IshimotoKiko. All rights reserved.
//

import SpriteKit

class Skill
{
    func skillVariable(_ WeaponPropaty:inout weaponParameters)
    {
    }
}
class PowerUp:Skill
{
    override func skillVariable(_ WeaponPropaty: inout weaponParameters)
    {
        WeaponPropaty.Power += 20
    }
}
