//
//  Enemys.swift
//  game
//
//  Created by IshimotoKiko on 2016/03/31.
//  Copyright © 2016年 IshimotoKiko. All rights reserved.
//

import SpriteKit

class EnemyController
{
    class func makeEnemy(_ ID:Int,_ positionX:CGFloat,_ actionID:Int) -> Enemy
    {
        let paramate = FileManager.enemyParamateRead(ID)
        let enemy = Enemy(STATAS: paramate)
        enemy.position = CGGamePoint(positionX, 640)
        enemy.run(EnemyMoves.moveHorizontal(20))
        return enemy
    }
}
class enemyAction//IDを返す
{
    let enemys:[enemyAction]
    let interval:Double
    var Timer:Foundation.Timer = Foundation.Timer()
    var gloupOrSequence:Bool = false
    init(ene:[enemyAction],inter:Double,gloupOrSequence:Bool)
    {
        enemys = ene
        interval = inter
        self.gloupOrSequence = gloupOrSequence
    }
    func Recursion(_ enemy:enemyAction)
    {
        
    }
    class func sequrnce(_ ene:[enemyAction],inter:Double) -> enemyAction
    {
        return enemyAction(ene: ene, inter: inter, gloupOrSequence: false)
    }
    class func group(_ ene:[enemyAction]) -> enemyAction
    {
        return enemyAction(ene: ene, inter: 0, gloupOrSequence: true)
    }
}
