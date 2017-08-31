//
//  MenuScean.swift
//  game
//
//  Created by IshimotoKiko on 2016/03/10.
//  Copyright © 2016年 IshimotoKiko. All rights reserved.
//

import SpriteKit


class MenuScean : SKScene
{
    let label = SKLabelNode()
    
    let buttonMenu = ButtonMenuGroup()
    override func didMove(to view: SKView)
    {
        buttonMenu.ButtonG[0].setScene(self)
        SceanS.selfScean = self
        let BackGround = SKSpriteNode(imageNamed: "backGroundMenu.jpeg")
        BackGround.position = CGGamePoint(180,320)
        BackGround.size = CGGameSize(360, 640)
        self.addChild(BackGround)
        
        buttonMenu.position = CGGamePoint(180, -100)
        buttonMenu.run(SKAction.move(by: CGGameVector(0,100), duration: 1))
        
        self.addChild(buttonMenu)
        buttonMenu.timerStart()
        
        
        
        backgroundColor = UIColor.white

        
        
    }
    override func update(_ currentTime: TimeInterval)
    {
        if(Int(currentTime*10) % 10 == 0)
        {
            for(var i = 0 ; i < CreateRandomInt.minMaxDesignation(min: 1, max: 5) ; i++)
            {
                let Ball = SKSpriteNode(texture: SKTexture(imageNamed: "RigthBall.png"))
                Ball.size = CGGameSize(30, 30)
                Ball.position = CGGamePoint(CGFloat(CreateRandomInt.minMaxDesignation(min: 0, max: 360)), 700)
                Ball.alpha = CGFloat(Double(CreateRandomInt.minMaxDesignation(min: 0, max: 100)) / 100.0)
                var fade = SKAction.sequence(
                    [SKAction.fadeIn(withDuration: Double(CreateRandomInt.minMaxDesignation(min: 1, max: 2))),
                        SKAction.fadeOut(withDuration: Double(CreateRandomInt.minMaxDesignation(min: 1, max: 2)))
                    ])
                fade = SKAction.repeat(fade,count: 3)
                let move = SKAction.move(by: CGGameVector(0, -800), duration: Double(CreateRandomInt.minMaxDesignation(min: 3, max: 8)))
                addChild(Ball)
                Ball.run(SKAction.group([fade,move]), completion: {Ball.removeFromParent()})
            }
        }
        
    }


    override func willMove(from view: SKView) {
        buttonMenu.timer.invalidate()
        buttonMenu.remove()
        
        self.removeAllChildren()
    }
}
