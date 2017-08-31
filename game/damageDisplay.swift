//
//  damageDisplay.swift
//  game
//
//  Created by IshimotoKiko on 2016/03/11.
//  Copyright © 2016年 IshimotoKiko. All rights reserved.
//

import SpriteKit

class damageDiplay : SKLabelNode
{
    let Color =
    [
        SKColor.white,
        SKColor.red
    ]
    init(damage:Int , crit:Bool , pos:CGPoint)
    {
        super.init()
        //super.init(text: String(damage))
        self.fontSize = 20 / globalData.size.width * globalData.gameSize.width
        if(crit)
        {
            
            self.fontName = "Qarmic_sans_Abridged.ttf"
            self.alpha = 0.5
            self.fontColor = Color[1]
            
        }
        else
        {
            self.fontName = "Qarmic_sans_Abridged.ttf"
            self.alpha = 0.5
            self.fontColor = Color[0]
        }
        self.position = pos
        self.text = String(damage)
        self.run(
            SKAction.group(
                [
                SKAction.move(by: CGGameVector(0,  30), duration: 0.6),
                SKAction.scale(by: 1, duration: 1)
            ]),
            completion:
            {
                self.removeFromParent()
            })
    }
    deinit
    {
        //print("damagedisplayを削除しました")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
