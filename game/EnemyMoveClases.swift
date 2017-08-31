//
//  EnemyMoveClases.swift
//  game
//
//  Created by IshimotoKiko on 2016/03/30.
//  Copyright © 2016年 IshimotoKiko. All rights reserved.
//

import SpriteKit

class EnemyMoves
{
    class func moveHorizontal(_ time:Double) -> SKAction
    {
        let action = SKAction.move(by: CGGameVector(0, -640 - 20), duration: time)
        return action
    }
}
