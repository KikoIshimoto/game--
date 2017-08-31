//
//  menuButtonClases.swift
//  game
//
//  Created by IshimotoKiko on 2016/03/14.
//  Copyright © 2016年 IshimotoKiko. All rights reserved.
//

import SpriteKit
struct ButtonFlag
{
    static var ButtonState = 0
    static var BackButtonState = false
    static var IsApear = -1
}
struct SceanS {
    static var selfScean = SKScene()
    static let sutatusSettingScean = StatusSettingScean(size: CGGameSize(360, 640))
    
};
class ButtonMenuGroup : ButtonGroup
{
    var scrollmenu = SKScroll(size: CGSize.zero, range: CGSize.zero, rangePoint: CGPoint.zero)
    var ButtonGroup3 =
    [
        MenuDungeonButton(),
        MenuPartyButton(),
        MenuShopButton(),
        MenuDeveloperButton(),
        MenuEmptyButton(),
        MenuEmptyButton(),
        MenuOtherButton()
    ]
    deinit
    {
        print("ButttonMenu Delete")
    }
    var scrollButtonGroup = []
    var timer = Timer()
    init()
    {
        super.init(size:  CGGameSize(360 , 100))
        ButtonFlag.ButtonState = 0
        ButtonFlag.BackButtonState = false
        ButtonFlag.IsApear = -1
        self.ButtonG = ButtonGroup3
        self.position = CGGamePoint(180, 0)
        self.lineButtonNum = ButtonGroup3.count
        self.setButtonGroup(ButtonGroup3)
        self.paramateSet(0, btIntervalY: 0, frIntervalLeft: 0, frIntervalRight: 0, frIntervalUp: 0, frIntervalDown: 10, buttonFrameVaticalOrHorizontal: 50, HorizontalOrVerticalFlag: true ,lineButton: ButtonGroup3.count )
        self.set()
        
    }
    func timerStart()
    {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: "updata", userInfo: nil, repeats: true)
    }
    var firstAct = false
    
    var selectButton:Int = 0
    var prevSelectButton:Int = 0
    func updata()
    {
        //print(ButtonFlag.ButtonState )
        //print(ButtonFlag.IsApear)
        for var x = 0;x < ButtonGroup3.count ; x++
        {
            if(ButtonFlag.ButtonState & (1 << x) == 0)
            {

                ButtonGroup3[x].remove()
            }
            if(ButtonFlag.IsApear == x  && ButtonFlag.BackButtonState == true)
            {
                ButtonGroup3[x].remove()
                ButtonFlag.IsApear = -1
                ButtonFlag.BackButtonState = false
            }
        }

    }
    class MenuDungeonButton : Button
    {
        init()
        {
            super.init()
            Tag.text = "ダンジョン"
        }
        
        
        var touchFlag = false
        override func touchUpInside() {
            let scene = BattleScene(size: self.scene!.size)
            //呼び出すSceneをJumpScene classにしただけ
            scene.scaleMode = SKSceneScaleMode.aspectFill
            self.gameScene.view?.presentScene(scene)
        }
        deinit
        {
            print("MenuDungeonButton Delete")
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }

    class MenuPartyButton : Button
    {
        init()
        {
            super.init()
            
            Tag.text = "チーム"
        }
        var scroll = SKScroll(size: CGGameSize(0,0), range: CGGameSize(200,200) , rangePoint:CGPoint.zero)

        var selectToriger = false
        override func remove() {

                self.scroll.run(SKAction.move(by: CGGameVector(300, 0), duration: 0.2), completion:
                    {
                        self.scroll.remove()
                        self.scroll.removeAllChildren()
                        self.scroll.removeFromParent()
                })

        }

        override func touchUpInside() {
            
            //selected = false
            if( (ButtonFlag.ButtonState & (1 << 1) == 0 && self.childNode(withName: "Scroll") == nil ) || ButtonFlag.IsApear == -1)
            {
                let b = [TeamSet(),MySet(),SkillSet(),BackButton()]
                
                ButtonFlag.ButtonState = ButtonFlag.ButtonState | (1 << 1)
                ButtonFlag.ButtonState = ButtonFlag.ButtonState & (1 << 1)
                ButtonFlag.IsApear = 1
                scroll = SKScroll(size: CGGameSize(200,CGFloat(b.count) * 100 + 500), range: CGGameSize(200,200) , rangePoint:convert(CGGamePoint(180,400), from: self.parent!.parent!))
                scroll.zPosition = -1
                scroll.position = convert(CGGamePoint(-1000,00), from: self.parent!.parent!)
                
                scroll.paramateSet(20, btIntervalY: 2, frIntervalLeft: 20, frIntervalRight: 20, frIntervalUp: 20, frIntervalDown: 20, buttonFrameVaticalOrHorizontal: 80,HorizontalOrVerticalFlag: true)
                scroll.setButtonGroup(b)
                scroll.lineButtonNum = 1
                scroll.set()
                scroll.run(SKAction.move(by: CGGameVector(1180, 0), duration: 0.5))
                self.addChild(scroll)
            }
                
            else
            {
                self.remove()
                ButtonFlag.IsApear = -1
            }
        }
        deinit
        {
            print("MenuPartyButton Delete")
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        class TeamSet: Button {
            init()
            {
                super.init()
                
                Tag.text = "装備変更"
                
            }
            override func touchUpInside() {
                let scene = StatusSettingScean(size: self.scene!.size)
                //呼び出すSceneをJumpScene classにしただけ
                scene.scaleMode = SKSceneScaleMode.aspectFill
                SceanS.selfScean.view?.presentScene(scene, transition: SKTransition.push(with: SKTransitionDirection.right, duration: 1))
            }
            deinit
            {
                print(" TeamSetButton Delete")
            }
            required init?(coder aDecoder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }

        }
        class MySet: Button {
            init()
            {
                super.init()
                
                Tag.text = "チーム選択"
            }
            deinit
            {
                print(" MySetButton Delete")
            }
            required init?(coder aDecoder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
            override func touchUpInside() {
                
            }
        }
        class SkillSet: Button {
            init()
            {
                super.init()
                
                Tag.text = "スキル装備"
            }
            deinit
            {
                print(" SkillSeButton Delete")
            }
            required init?(coder aDecoder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
            override func touchUpInside() {
                
            }
        }
        
    }
    
    
    
    class MenuShopButton : Button
    {
        init()
        {
            super.init()
            Tag.text = "ショップ"
            
        }
        deinit
        {
            print("MenuShopButton Delete")
        }
        var touchFlag = false
        override func touchUpInside() {
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    class MenuOtherButton : Button
    {
        init()
        {
            super.init()
            Tag.text = "その他"
            
        }
        deinit
        {
            print(" MenuOtherButton Delete")
        }
        var touchFlag = false
        override func touchUpInside() {
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    
    class MenuDeveloperButton : Button
    {
        init()
        {
            super.init()
            Tag.text = "開発"
        }
        var touchFlag = false
        var scroll = SKScroll(size: CGSize.zero, range: CGGameSize(200,200) , rangePoint:CGPoint.zero)
        
        var selectToriger = false
        override func remove() {
                self.scroll.run(SKAction.move(by: CGGameVector(300,  0), duration: 0.2), completion:
                    {
                        self.scroll.remove()
                        self.scroll.removeAllChildren()
                        self.scroll.removeFromParent()
                        
                })
        }
        func updata()
        {
        }
        override func touchUpInside() {
            
            //selected = false
            if( (ButtonFlag.ButtonState & (1 << 3) == 0 && self.childNode(withName: "Scroll") == nil)  || ButtonFlag.IsApear == -1)
            {
                let b = [CharactorDevelopButton(),WeaponDevelopButton(),SkillDevelopButton(),BackButton()]
                
                ButtonFlag.ButtonState = ButtonFlag.ButtonState | (1 << 3)
                ButtonFlag.ButtonState = ButtonFlag.ButtonState & (1 << 3)
                ButtonFlag.IsApear = 3
                scroll = SKScroll(size: CGGameSize(200,CGFloat(b.count) * 100 + 500), range: CGGameSize(200,200) , rangePoint:convert(CGGamePoint(180,400), from: self.parent!.parent!))
                scroll.zPosition = -1
                scroll.position = convert(CGGamePoint(-1000,00), from: self.parent!.parent!)
                
                scroll.paramateSet(20, btIntervalY: 2, frIntervalLeft: 20, frIntervalRight: 20, frIntervalUp: 20, frIntervalDown: 20, buttonFrameVaticalOrHorizontal: 80,HorizontalOrVerticalFlag: true)
                scroll.setButtonGroup(b)
                scroll.lineButtonNum = 1
                scroll.set()
                scroll.run(SKAction.move(by: CGGameVector(1180,  0), duration: 0.5))
                self.addChild(scroll)
            }
            else
            {
                self.remove()
                ButtonFlag.IsApear = -1
            }
        }

        deinit
        {
            print(" MenuDeveloperButton Delete")
        }
        class CharactorDevelopButton: Button {
            init()
            {
                super.init()
                
                Tag.text = "ベース強化"
            }
            func updata() {
                
                //print(" CharactorDevelopButton Loop")
            }
            deinit
            {
                print(" CharactorDevelopButton Delete")
            }
            required init?(coder aDecoder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
            override func touchUpInside() {
                
            }
        }
        class WeaponDevelopButton: Button {
            init()
            {
                super.init()
                
                Tag.text = "武器強化"
            }
            deinit
            {
                print(" WeaponDevelopButton Delete")
            }
            required init?(coder aDecoder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
            override func touchUpInside() {
                
            }
        }
        class SkillDevelopButton: Button {
            init()
            {
                super.init()
                
                Tag.text = "スキル強化"
            }
            deinit
            {
                print(" SkillDevelopButton Delete")
            }
            required init?(coder aDecoder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
            override func touchUpInside() {
                
            }
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    class MenuEmptyButton : Button
    {
        init()
        {
            super.init()
            Tag.text = ""
            
        }
        deinit
        {
            print(" MenuEmptyButton Delete")
        }
        var touchFlag = false
        override func touchUpInside() {
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class BackButton : Button
{
    init()
    {
        super.init()
        Tag.text = "戻る"
        self.pressImage = SKTexture(imageNamed: "BackButton.gif")
        self.unpressImage = SKTexture(imageNamed: "BackButtonP.gif")
        self.imageNode.texture = unpressImage
        self.name = "BackButton"
    }
    
    override func touchUpInside() {
        ButtonFlag.BackButtonState = true
        selected = true
    }
    deinit
    {
        print(" BackButton Delete")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
