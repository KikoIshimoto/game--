//
//  GameScene.swift
//  game
//
//  Created by IshimotoKiko on 2016/01/11.
//  Copyright (c) 2016年 IshimotoKiko. All rights reserved.
//

import SpriteKit
class BattleScene: SKScene  , SKPhysicsContactDelegate
{
    enum GAMESTATE
    {
        case start
        case gameover
        case clear
    }
    var gamestate = GAMESTATE.start
    let player = Player()

    let Main = Paramate()
    
    var gameOverFlag:Bool = false
    var gameClearFlag = false
    var enemyGroup = EnemyGroupSetup(WAVEID: 0)
    let bac = BackButton()
    override func didMove(to view: SKView)
    {
        bac.position = CGGamePoint(180, 200)
        self.name = "BattleScean"
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = CollisionType.Field//８ビット目がフィールド
        self.physicsBody?.contactTestBitMask = CollisionType.playerBullet
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -0.6)
        self.physicsWorld.contactDelegate = self
        
        FileManager.enemyWaveRead(0)
        
        let flame0 = SKSpriteNode(color: UIColor.clear, size: CGGameSize(400, 10))
        let flame1 = SKSpriteNode(color: UIColor.clear, size: CGGameSize(10, 700))
        let flame2 = SKSpriteNode(color: UIColor.clear, size: CGGameSize(400, 10))
        let flame3 = SKSpriteNode(color: UIColor.clear, size: CGGameSize(10, 700))
        flame0.position = CGGamePoint(160, 690)
        flame1.position = CGGamePoint(-10, 320)
        flame2.position = CGGamePoint(160, -10)
        flame3.position = CGGamePoint(400, 320)
        flame0.physicsBody = SKPhysicsBody(rectangleOf: flame0.size)
        flame1.physicsBody = SKPhysicsBody(rectangleOf: flame1.size)
        flame2.physicsBody = SKPhysicsBody(rectangleOf: flame2.size)
        flame3.physicsBody = SKPhysicsBody(rectangleOf: flame3.size)
        flame0.physicsBody?.contactTestBitMask = CollisionType.enemyBullet | CollisionType.playerBullet
        flame1.physicsBody?.contactTestBitMask = CollisionType.enemyBullet | CollisionType.playerBullet
        flame2.physicsBody?.contactTestBitMask = CollisionType.enemyBullet | CollisionType.playerBullet
        flame3.physicsBody?.contactTestBitMask = CollisionType.enemyBullet | CollisionType.playerBullet
        flame0.physicsBody?.isDynamic = false
        flame1.physicsBody?.isDynamic = false
        flame2.physicsBody?.isDynamic = false
        flame3.physicsBody?.isDynamic = false
        flame0.name = "field"
        flame1.name = "field"
        flame2.name = "field"
        flame3.name = "field"
        addChild(flame0)
        addChild(flame1)
        addChild(flame2)
        addChild(flame3)
        

        Main.setScene(self)
        enemyGroup.setScene(self)
        player.setScene(self)
        
        //self.addChild(enemyGroup)
        self.addChild(player)
        self.addChild(enemyGroup)
        enemyGroup.run()
        self.addChild(Main)
        
        Main.runPlayer(Int(player.Statas.HP))
        //Main.runEnemy(Int(enemy.Statas.HP))
    }
    
    //var GameOver = ButtonGroup()
    var touchedP:CGPoint = CGPoint(x: 0, y: 0)
    var touchedPrevP:CGPoint = CGPoint(x: 0, y: 0)
    var b:SKSpriteNode? = nil
    var touched:Bool = false
    var buttonName:String! = "button0"
        var touchFlag:Bool = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        if(gameOverFlag == true)
        {

        }
        if(gameClearFlag == true)
        {
            
            print(clearTouchFlag)
            if(clearTouchFlag)
            {
                let scean = MenuScean(size: globalData.gameSize)
                scean.scaleMode = SKSceneScaleMode.aspectFill
                self.view?.presentScene(scean)
            }
        }
        else
        {
            let touchEvent = touches.first
            let location = touchEvent!.location(in: self)
            
            touchedPrevP = location
            touchFlag = true
        }

    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        // タッチイベントを取得
        
        if(gameClearFlag == true)
        {

        }
        else if(gameOverFlag == true)
        {
        }
        else
        {
            
            let touchEvent = touches.first
            if(touchFlag == true)
            {
                touchedP = touchEvent!.location(in: self)
                let vect = CGVector(dx: touchedP.x - touchedPrevP.x, dy: touchedP.y - touchedPrevP.y)
                player.move(vect)
                self.run(SKAction.move(by: vect, duration: 0.1))
                touchedPrevP = touchedP
            }
        }
    }
    
    override    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if(gameClearFlag == true)
        {
            
        }
        else if(gameOverFlag == true)
        {
        }
        else
        {
            touched = false
            let touchEvent = touches.first
            let location = touchEvent!.location(in: self)
            let node:SKNode? = self.atPoint(location)//タッチ座標からノードを見つける
        }
    }
    let ClearLog = SKSpriteNode(imageNamed: "Clear.png")
    let GameOverLog = SKSpriteNode(imageNamed: "GameOver.png")
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        if(bac.selected)
        {
            let scean = MenuScean(size: globalData.gameSize)
            scean.scaleMode = SKSceneScaleMode.aspectFill
            self.view?.presentScene(scean)
        }
        if gamestate == .start
        {
            if(enemyGroup.clear == true)
            {
                var apper = false
                for node in children
                {
                    if (node.name == "enemy")
                    {
                        apper = true
                    }
                }
                if(apper == false)
                {
                    
                    enemyGroup.clear = false
                    player.Timer.invalidate()
                    ClearLog.position = CGGamePoint(180, 700)
                    ClearLog.size = CGGameSize(180, 50)
                    addChild(ClearLog)
                    ClearLog.run(SKAction.move(by: CGGameVector(0, -350), duration: 3),completion:
                        {
                            self.clearTouchFlag = true
                            
                            self.addChild(self.bac)
                    })
                    gameClearFlag = true
                    gamestate = .clear
                }
            }
            if (gameOverFlag)
            {
                enemyGroup.Timer.invalidate()
                GameOverLog.position = CGGamePoint(180, 700)
                GameOverLog.size = CGGameSize(200, 50)
                addChild(GameOverLog)
                GameOverLog.run(SKAction.move(by: CGGameVector(0, -350), duration: 3),completion:
                    {
                        self.clearTouchFlag = true
                        
                        self.addChild(self.bac)
                })
                gameOverFlag = false
                gamestate = .gameover
            }
        }
        for node in children
        {
            if(node.name == "Pweapon")
            {
                let weapon = node as! Weapon
                let p = weapon.position
                let nodes = self.nodes(at: p)
                for enemy in nodes
                {
                    let b = (enemy as? Enemy)
                    if (b != nil )
                    {
                        if weapon.Status.Penetration
                        {
                            let damage = weapon.Status.Power// + player.shot.States.Power
                            let sound = SKAction.playSoundFileNamed("Attack.mp3", waitForCompletion: true)
                            let node = SKNode()
                            node.run(sound, completion: {node.removeFromParent()})
                            self.addChild(damageDiplay(damage: Int(damage), crit: false, pos: p))
                            self.addChild(node)
                            
                            b!.Statas.HP -= damage
                            if(b!.Statas.BOSS == true)
                            {
                                Main.EnemyHP = Int(b!.Statas.HP)
                            }
                            if(b!.Statas.HP<=0)
                            {
                                b!.remove()
                                
                                if(b!.Statas.BOSS)
                                {
                                    Main.enemyBassBar.removeFromParent()
                                }
                            }
                        }
                    }
                }
            }
            if(node.name == "Eweapon")
            {
                let weapon = node as! Weapon
                let p = weapon.position
                let nodes = self.nodes(at: p)
                for player in nodes
                {
                    let b = (player as? Player)
                    if (b != nil )
                    {
                        if weapon.Status.Penetration
                        {
                            let damage = weapon.Status.Power// + player.shot.States.Power
                            let sound = SKAction.playSoundFileNamed("Attack.mp3", waitForCompletion: true)
                            let node = SKNode()
                            node.run(sound, completion: {node.removeFromParent()})
                            self.addChild(damageDiplay(damage: Int(damage), crit: false, pos: p))
                            self.addChild(node)
                            b!.Statas.HP -= damage
                            if(b!.Statas.HP<=0)
                            {
                                b!.remove()
                                gameOverFlag = true
                            }
                        }
                    }
                }
            }
        }
    }
    var clearTouchFlag = false

    func didBegin(_ contact: SKPhysicsContact) {
        let Player_Enemy = CollisionType.Player | CollisionType.Enemy //playerとenemy
        let Player_enemyBullet = CollisionType.Player | CollisionType.enemyBullet //playerとenemyの弾
        let Enemy_playerBullet = CollisionType.Enemy | CollisionType.playerBullet //enemyとplayerの弾
   
        //衝突ノードの和
        let check = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        let nodeA:SKNode! = contact.bodyA.node
        let nodeB:SKNode! = contact.bodyB.node
        //判定
        if (Player_Enemy == check)
        {
            //enemyと自分が衝突した場合の処理
            var sknodeA :Player? = nil
            var sknodeB :Enemy? = nil
            if ((check & CollisionType.Player) == contact.bodyA.categoryBitMask)
            {
                sknodeA = (nodeA as? Player)
                sknodeB = (nodeB as? Enemy)
            }
            else if ((check & CollisionType.Player) == contact.bodyB.categoryBitMask)
            {
                sknodeA = (nodeB as? Player)
                sknodeB = (nodeA as? Enemy)
            }
            
            if (sknodeB == nil || sknodeA == nil)
            {
                return
            }
            var damage = sknodeA!.Statas.Power
            sknodeB!.Statas.HP = sknodeB!.Statas.HP - damage
            Main.PlayerHP = Int(sknodeA!.Statas.HP)
            damage = sknodeB!.Statas.Power
            sknodeA!.Statas.HP = sknodeA!.Statas.HP - damage
            self.addChild(damageDiplay(damage: Int(damage), crit: true, pos: contact.contactPoint))
            if(sknodeB!.Statas.BOSS)
            {
                Main.EnemyHP = Int(sknodeA!.Statas.HP)
            }

            if(sknodeA!.Statas.HP<=0)
            {
                sknodeA!.Statas.HP = 0
                sknodeA!.remove()
                Main.PlayerHP = Int(sknodeA!.Statas.HP)
                
                gameOverFlag = true
            }
            if(sknodeB!.Statas.HP<=0)
            {
                sknodeB!.remove()
                if(sknodeB!.Statas.BOSS)
                {
                    Main.enemyBassBar.removeFromParent()
                }
            }
        }
        else if (Player_enemyBullet == check)
        {
            var sknodeA :Player? = nil
            var sknodeB :Bullet? = nil
            if ((check & CollisionType.Player) == contact.bodyA.categoryBitMask)
            {
                sknodeA = (nodeA as? Player)
                sknodeB = (nodeB as? Bullet)
            }
            else if ((check & CollisionType.Player) == contact.bodyB.categoryBitMask)
            {
                sknodeA = (nodeB as? Player)
                sknodeB = (nodeA as? Bullet)
            }
            if (sknodeB == nil || sknodeA == nil)
            {
                return
            }
            let damage = sknodeB!.Status.Power
            sknodeA!.Statas.HP = sknodeA!.Statas.HP - damage
            
            self.addChild(damageDiplay(damage: Int(damage), crit: true, pos: contact.contactPoint))
            Main.PlayerHP = Int(sknodeA!.Statas.HP)
            if(sknodeA!.Statas.HP<=0)
            {
                sknodeA!.Statas.HP = 0
                sknodeA!.remove()
                Main.PlayerHP = Int(sknodeA!.Statas.HP)
                gameOverFlag = true
                //self.addChild(GameOver)
            }
            if(sknodeB!.Status.Penetration == false)
            {
                //sknodeB!.remove()
            }
        }
        else if (Enemy_playerBullet == check)
        {
            var sknodeA :Enemy? = nil
            var sknodeB :Bullet? = nil
            if ((check & CollisionType.Enemy) == contact.bodyA.categoryBitMask)
            {
                sknodeA = (nodeA as? Enemy)
                sknodeB = (nodeB as? Bullet)
            }
            else if ((check & CollisionType.Enemy) == contact.bodyB.categoryBitMask)
            {
                sknodeA = (nodeB as? Enemy)
                sknodeB = (nodeA as? Bullet)
            }
            
            if (sknodeB == nil || sknodeA == nil)
            {
                return
            }
            let damage = sknodeB!.Status.Power// + player.shot.States.Power
            let sound = SKAction.playSoundFileNamed("Attack.mp3", waitForCompletion: true)
            let node = SKNode()
            node.run(sound, completion: {node.removeFromParent()})
            self.addChild(damageDiplay(damage: Int(damage), crit: false, pos: contact.contactPoint))
            self.addChild(node)
            sknodeA!.Statas.HP = sknodeA!.Statas.HP - damage
            if(sknodeA!.Statas.BOSS == true)
            {
                Main.EnemyHP = Int(sknodeA!.Statas.HP)
            }
            if(sknodeA!.Statas.HP<=0)
            {
                sknodeA!.remove()
                
                if(sknodeA!.Statas.BOSS)
                {
                    Main.enemyBassBar.removeFromParent()
                }
            }
            
            if(sknodeB!.Status.Penetration == false)
            {
                sknodeB!.remove()
            }
        }
        else
        {
            if nodeA!.name == "field" {
                nodeB?.removeFromParent()
                //print("del")
            }
            
            else if nodeB!.name == "field" {
                nodeA?.removeFromParent()
                //print("del")
            }
        }
    }
    class Back : BackButton
    {
        override init()
        {
            super.init()
            Tag.text = "次へ"
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        override func touchUpInside() {
            selected = true
        }
    }
    override func willMove(from view: SKView) {
        player.Timer.invalidate()
        for child in self.children
        {
            
            let ene = child as? CharaBase
            if(ene != nil)
            {
                ene?.Timer.invalidate()
            }
            
            child.removeFromParent()
        }
        enemyGroup.Timer.invalidate()
        enemyGroup.removeFromParent()
    }
}
