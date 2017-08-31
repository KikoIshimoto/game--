//
//  Parameter.swift
//  game
//
//  Created by IshimotoKiko on 2016/03/03.
//  Copyright © 2016年 IshimotoKiko. All rights reserved.
//

import SpriteKit
class Paramate:SKNode
{
    var gameScene: SKScene!
    func setScene(_ scene: SKScene)
    {
        self.gameScene = scene
    }
    override init()
    {
        super.init()
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: "update", userInfo: nil, repeats: true)
    }
    var timer = Timer()
    let bar = Bar()
    let enemyBassBar = EnemyBassBar()
    
    var PlayerHP = 10000
    var EnemyHP = 10000
    var EnemyFlag = false
    var PlayerFlag = false
    func runPlayer(_ MaxHP : Int)
    {
        PlayerHP = MaxHP
        bar.MaxHP = PlayerHP
        bar.HP = PlayerHP
        gameScene.addChild(bar)
        PlayerFlag = true
    }
    func runEnemy(_ MaxHP : Int)
    {
        EnemyHP = MaxHP
        enemyBassBar.MaxHP = EnemyHP
        enemyBassBar.HP = enemyBassBar.MaxHP
        gameScene.addChild(enemyBassBar)
        EnemyFlag = true
    }
    func update()
    {
        if(PlayerFlag)
        {
            if(PlayerHP <= 0)
            {
                PlayerFlag = false
            }
            bar.update(PlayerHP)
        }
        if(EnemyFlag)
        {
            if(EnemyHP <= 0)
            {
                EnemyFlag = false
            }
            if(EnemyFlag == true)
            {
                enemyBassBar.update(EnemyHP)
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
};
class EnemyBassBar:Bar
{
    override init() {
        super.init()

        
    }
    override func update(_ HP_: Int) {
        
        HP = HP_
        if(firstF == false){
            firstF = true
            
            prevHP = HP
            HPBarColor = HP / HPBarPar
            if(HPBarColor - 1 == -1)
            {
                backHPBar = UIColor.white
            }
            else
            {
                backHPBar = barColors[HPBarColor - 1]
            }
            base1.removeAllActions()
            base1.removeFromParent()
            
            gauge1.removeFromParent()
            
            HPLabel.removeFromParent()
            
            HPBaseBarSize  = CGGameSize(300, 10)
            HPGaugeBarSize = CGGameSize(300, 10)
            
            base1 = SKSpriteNode(color: backHPBar, size: HPBaseBarSize)
            gauge1 = SKSpriteNode(color: barColors[HPBarColor], size: HPGaugeBarSize)
            
            
            
            base1.position = CGGamePoint(175, 650)
            gauge1.position = CGGamePoint(175, 650)
            
            /*
            let action = SKAction.moveTo(CGPointMake(175 ,620) , duration: 0.5)
            let s = CGFloat( HP % 10000 ) / CGFloat(HPBarPar)
            let action2 = SKAction.scaleXTo(s , y:1.0, duration: 0.5)
            let sumaction = SKAction.group([action,action2])*/
            let action = SKAction.sequence([SKAction.move(to: CGGamePoint(175,620) , duration: 3)
                ])
            action.timingMode = SKActionTimingMode.easeInEaseOut
            self.addChild(base1)
            self.addChild(gauge1)
            
            gauge1.run(action)
            base1.run(action , completion: {self.completeActionF = true})
            
        }
    
        if(completeActionF == true)
        {
            HPBarColor = HP / HPBarPar
            
            
            //let Tcount = HPBarColor - count
            
            if(HPBarColor - 1 == -1)
            {
                backHPBar = UIColor.white
            }
            else if(HPBarColor >= 0)
            {
                backHPBar = barColors[HPBarColor - 1]
            }
            else
            {
                HPBarColor = 0
            }
            
            
            if(HP / 10000 < prevHP / 10000)
            {
                
                base = SKSpriteNode(color: backHPBar, size: HPBaseBarSize)
                gauge = SKSpriteNode(color: barColors[HPBarColor], size: HPGaugeBarSize)
                base.position = CGGamePoint(175, 620)
                gauge.position = CGGamePoint(175, 620)
                self.addChild(base)
                self.addChild(gauge)
            }
            
            
            
            base1.color = backHPBar
            gauge1.color = barColors[HPBarColor]
            
            if(HP<=0)
            {
                HP = 0
            }
            
            prevHP = HP
            let action = SKAction.move(to: CGGamePoint(CGFloat(175 - (300.0 * (Double(HPBarPar) - Double(HP % 10000)) / Double(HPBarPar)) / 2) ,620) , duration: 0.5)
            let s = CGFloat( HP % 10000 ) / CGFloat(HPBarPar)
            let action2 = SKAction.scaleX(to: s, y: 1.0, duration: 0.5)
            let sumaction = SKAction.group([action,action2])
            
            
            
            
            gauge.run(sumaction)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class Bar:SKNode
{
    var HPBarColor:Int = 0
    let HPBarPar:Int = 10000
    var HPBaseBarSize:CGSize = CGGameSize(10, 500)
    var HPGaugeBarSize:CGSize = CGGameSize(10, 500)
    var HPBar:Int = 0
    var HP:Int = 0
    var MaxHP:Int = 0
    var prevHP:Int = 10000
    
    var completeActionF = false
    
    func pasent(_ HP : Int , MaHP: Int) -> Double
    {
        let HPparMaxHPExam = [0.1,0.3,0.5,0.8,1.0]
        let pas = Double(HP) / Double(MaxHP)
        for count in HPparMaxHPExam
        {
            if(pas < count)
            {
                return count
            }
        }
        return 1.0
    }
    
    let HPFontColors = [
        1.0:UIColor.cyan,
        0.8:UIColor.green,
        0.5:UIColor.yellow,
        0.3:UIColor.brown,
        0.1:UIColor.red
    ]
    let barColors = [
        UIColor.blue,
        UIColor.brown,
        UIColor.yellow,
        UIColor.cyan,
        UIColor.magenta
    ]
    var backHPBar = UIColor.white
    
    var base = SKSpriteNode()
    var gauge = SKSpriteNode()
    var base1 = SKSpriteNode()
    var gauge1 = SKSpriteNode()
    var decriGauge = SKSpriteNode()
    let HPLabel = SKLabelNode()
    var L:String = "¥0"
    
    override init() {
        super.init()
        
    }
    
    var firstF = false
    func update(_ HP_ : Int)
    {
        
        HP = HP_
        HPBarColor = HP / HPBarPar
        
        if(firstF == false){
            firstF = true
            MaxHP = HP
            L = String(HP) + "/" + String(MaxHP)
            HPLabel.fontColor = HPFontColors[pasent(HP, MaHP: MaxHP)]
            
            
            HPGaugeBarSize = CGGameSize(10, 500)
            
            base1 = SKSpriteNode(color: backHPBar, size: HPBaseBarSize)
            gauge1 = SKSpriteNode(color: barColors[HPBarColor], size: HPGaugeBarSize)
            decriGauge = SKSpriteNode(color: UIColor.orange, size: HPGaugeBarSize)
            
            
            backHPBar = UIColor.white
            gauge1.color = HPFontColors[pasent(HP, MaHP: MaxHP)]!
            base1.color = backHPBar
            
            
            base1.position = CGGamePoint(350, -300)
            gauge1.position = CGGamePoint(350, -300)
            HPLabel.position = CGGamePoint(350, -310)
            decriGauge.position = CGGamePoint(350, -300)
            
            HPLabel.fontSize = 15
            HPLabel.fontName = "Qarmic_sans_Abridged.ttf"
            HPLabel.text = L
            HPLabel.horizontalAlignmentMode = .right
            
            let action = SKAction.move(to: CGGamePoint(350, 280), duration: 3)
            
            self.addChild(base1)
            self.addChild(decriGauge)
            self.addChild(gauge1)
            self.addChild(HPLabel)
            
            action.timingMode = SKActionTimingMode.easeOut
            gauge1.run(action)
            decriGauge.run(action)
            base1.run(action , completion: {self.completeActionF = true})

            
            HPLabel.run(SKAction.move(to: CGGamePoint(350, 10), duration: 3))
            

        }
        if(completeActionF == true)
        {
            backHPBar = UIColor.white
            gauge1.color = HPFontColors[pasent(HP, MaHP: MaxHP)]!
            base1.color = backHPBar
            if(HP<=0)
            {
                HP = 0
            }
        
            L = String(HP) + "/" + String(MaxHP)
            HPLabel.fontColor = HPFontColors[pasent(HP, MaHP: MaxHP)]
            HPLabel.text = L
        
            var action = SKAction.move(to: CGGamePoint(350, CGFloat(280 - (500.0 * (Double(MaxHP) - Double(HP)) / Double(MaxHP)) / 2)), duration: 0.5)
            var s = CGFloat( HP ) / CGFloat(MaxHP)
            var action2 = SKAction.scaleX(to: 1, y: s, duration: 0.5)
            
            gauge1.run(SKAction.group([action,action2]))
        
            let wait = SKAction.wait(forDuration: 1.0)
            action = SKAction.move(to: CGGamePoint(350, CGFloat(280 - (500.0 * (Double(MaxHP) - Double(HP)) / Double(MaxHP)) / 2)), duration: 0.5)
            s = CGFloat( HP ) / CGFloat(MaxHP)
            action2 = SKAction.scaleX(to: 1, y: s, duration: 0.5)
            let sumAction = SKAction.sequence(
                [wait , SKAction.group([action,action2])])
            
            decriGauge.run(sumAction)
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}



class enemyHPBar : Bar
{
    
    var enemySize = CGSize(width: 0,height: 0)
    override init()
    {
        super.init()
    }
    override func update(_ HP_ : Int)
    {
        
        HP = HP_
        HPBarColor = HP / HPBarPar
        
        if(firstF == false){
            firstF = true
            MaxHP = HP
            L = String(HP) + "/" + String(MaxHP)
            HPLabel.fontColor = HPFontColors[pasent(HP, MaHP: MaxHP)]
            
            
            HPBaseBarSize = CGSize( width: enemySize.width,  height: 4)
            HPGaugeBarSize = CGSize( width: enemySize.width,  height: 2)
            
            base1 = SKSpriteNode(color: backHPBar, size: HPBaseBarSize)
            gauge1 = SKSpriteNode(color: barColors[HPBarColor], size: HPGaugeBarSize)
            
            backHPBar = UIColor.white
            gauge1.color = HPFontColors[pasent(HP, MaHP: MaxHP)]!
            base1.color = backHPBar
            
            
            base1.position = CGPoint(x: 0, y: 10 + enemySize.height / 2)
            gauge1.position = CGPoint(x: 0, y: 10 + enemySize.height / 2)
            HPLabel.fontSize = 15
            HPLabel.fontName = "Qarmic_sans_Abridged.ttf"
            HPLabel.text = L
            HPLabel.horizontalAlignmentMode = .right
            
            let action = SKAction.move(to: CGPoint(x: 0, y: 10 + enemySize.height / 2), duration: 0.5)
            
            self.addChild(base1)
            self.addChild(gauge1)
            
            action.timingMode = SKActionTimingMode.easeOut
            gauge1.run(action)
            base1.run(action , completion: {self.completeActionF = true})
            
            
            HPLabel.run(SKAction.move(to: CGGamePoint(10, 10 + enemySize.height / 2), duration: 3))
            
            
        }
        if(completeActionF == true)
        {
            backHPBar = UIColor.white
            gauge1.color = HPFontColors[pasent(HP, MaHP: MaxHP)]!
            base1.color = backHPBar
            if(HP<=0)
            {
                HP = 0
            }
            
            L = String(HP) + "/" + String(MaxHP)
            HPLabel.fontColor = HPFontColors[pasent(HP, MaHP: MaxHP)]
            HPLabel.text = L
            let action = SKAction.move(
                to: CGPoint( x: -enemySize.width * CGFloat(MaxHP - HP) / CGFloat(MaxHP) / 2.0 ,y: 10 + enemySize.height / 2),
                duration: 0.5)
            let s = CGFloat( HP ) / CGFloat(MaxHP)
            let action2 = SKAction.scaleX(to: s, y: 1, duration: 0.5)
            let sumaction = SKAction.group([action,action2])
            
            
            gauge1.run(sumaction)
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




