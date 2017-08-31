//
//  WaveSetup.swift
//  game
//
//  Created by IshimotoKiko on 2016/03/09.
//  Copyright © 2016年 IshimotoKiko. All rights reserved.
//

import SpriteKit

class EnemyGroupSetup :SKNode
{
    
    var gameScene: SKScene!
    func setScene(_ scene: SKScene)
    {
        gameScene = scene
    }
    
    
    var enemyArray:[enemyAction] = []
    var Timer = Foundation.Timer()
    //let p = FileManager.getEnemyGroup(0)
    let ID:Int
    let Wave:EnemyWaveStruct
    var GloupFlag:[Bool] = []
    var clear = false
    init(WAVEID:Int)
    {
        ID = WAVEID
        Wave = FileManager.enemyWaveRead(ID)
        for x in 0..<Wave.EnemyGroups.count
        {
            GloupFlag.append(false)
            enemyCount.append(0)
            gloupIntervalTime.append(0)
        }
        super.init()
    }
    
    func  run()
    {
        Timer = Foundation.Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: "update", userInfo: nil, repeats: true)
    }
    
    var time:Double = 0
    var enemyCount:[Int] = []
    var gloupIntervalTime:[Double] = []
    func update()
    {
        
        if((gameScene) != nil)
        {
            for x in 0..<Wave.EnemyGroups.count
            {
                if Wave.AppaerTime[x] < time && GloupFlag[x] == false
                {
                    let gloup = Wave.EnemyGroups[x]
                    if(gloup.EnemyInterval == nil)
                    {
                        for ID_ in 0 ..< gloup.EnemyIDs.count
                        {
                            let enemy = EnemyController.makeEnemy(gloup.EnemyIDs[ID_],CGFloat(gloup.position[ID_]),gloup.enemyActionIDs[ID_])
                        
                            enemy.setScene(gameScene)
                    
                            enemy.run()
                        }
                        GloupFlag[x] = true
                    }
                    else
                    {
                        var IntervalTime = 0.0
                        for ID_ in 0 ..< gloup.EnemyIDs.count
                        {
                            IntervalTime += gloup.EnemyInterval![ID_]
                            if time > IntervalTime + Wave.AppaerTime[x] && enemyCount[x] == ID_
                            {
                                let enemy = EnemyController.makeEnemy(gloup.EnemyIDs[ID_],CGFloat(gloup.position[ID_]),gloup.enemyActionIDs[ID_])
                                
                                enemy.setScene(gameScene)
                                
                                enemy.run()
                                enemyCount[x] += 1
                            }
                            
                            if (enemyCount[x] == gloup.EnemyIDs.count - 1)
                            {
                                GloupFlag[x] = true
                            }
                        }
                    }
                }
            }
        }
        var f = 0
        for cl in 0 ..< Wave.EnemyGroups.count
        {
            if(GloupFlag[cl] == true)
            {
                f += 1
            }
            if(f == Wave.EnemyGroups.count)
            {
                clear = true
                Timer.invalidate()
            }
        }
        time += 0.1
        //print(clear)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
