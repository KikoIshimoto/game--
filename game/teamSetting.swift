//
//  teamSetting.swift
//  game
//
//  Created by IshimotoKiko on 2016/03/18.
//  Copyright © 2016年 IshimotoKiko. All rights reserved.
//

import SpriteKit



var itemnum = 0
class StatusSettingScean : SKScene
{
    let ButtonWeapon =
    [
        WeaponButton(tag: FileManager.weaponParamateRead(FileManager.PlayerEquipmentsRead()[0] as! Int).weaponName!),
        WeaponButton(tag: FileManager.weaponParamateRead(FileManager.PlayerEquipmentsRead()[1] as! Int).weaponName!),
        WeaponButton(tag: FileManager.weaponParamateRead(FileManager.PlayerEquipmentsRead()[2] as! Int).weaponName!),
        BackButton2()
    ]
    var timer = Timer()
    func Title() -> SKSpriteNode
    {
        
        let Tile = SKSpriteNode(texture: SKTexture(imageNamed: "teamSettingTitle.gif"))
        Tile.position = CGGamePoint(180, 600)
        Tile.size = CGGameSize(200, 60)
        let Label = SKLabelNode(text: "装備")
        Label.fontName = "font_1_kokumr_1.00_rls.ttf"
        Label.fontColor = UIColor.black
        Label.fontSize = 30
        Tile.addChild(Label)
        return Tile
    }
    
    let OK = OKButton()
    override func didMove(to view: SKView) {
        SceanS.selfScean = self
        let Main  = SKScroll(size: CGGameSize(180, 320), range:CGGameSize(180, 160), rangePoint: CGGamePoint(70,320))
        Main.position = CGGamePoint(70,320)
        Main.setButtonGroup(ButtonWeapon)
        Main.paramateSet(0, btIntervalY: 20, frIntervalLeft: 50, frIntervalRight: 0, frIntervalUp: 0, frIntervalDown: 0, buttonFrameVaticalOrHorizontal: 70, HorizontalOrVerticalFlag: true, lineButton: 1)
        Main.set()
        
        let back = BackButton()
        back.position = CGGamePoint(180, 100)
        self.addChild(back)
        
        OK.position = CGGamePoint(200, 180)
        OK.setScene(self)
        addChild(OK)
        addChild(Title())
        addChild(Main)
    }
    final var prev = 0
    override func update(_ currentTime: TimeInterval) {
        var ans = 0
        for x in 0 ..< ButtonWeapon.count - 1
        {
            if(ButtonWeapon[x].selected == true)
            {
                ans = ans | 1 << x
            }
        }
        let ANS = ans ^ prev
        if(ANS != 0)
        {
            for x in 0 ..< ButtonWeapon.count - 1
            {
                if(ANS & 1 << x != 0)
                {
                    ButtonWeapon[x].selected = true
                    OK.flag = false
                    OK.imageNode.texture = OK.unpressImage
                }
                else
                {
                    ButtonWeapon[x].selected = false
                    ButtonWeapon[x].texture = ButtonWeapon[x].unpressImage
                }
            }
            prev = ANS
        }
        if(ans == 0)
        {
            OK.flag = true
            OK.imageNode.texture = OK.pressImage
        }
        if(ButtonWeapon[ButtonWeapon.count - 1].selected == true)
        {
            for x in 0 ..< ButtonWeapon.count - 1 
            {

                ButtonWeapon[x].selected = false
                ButtonWeapon[x].texture = ButtonWeapon[x].unpressImage
            }
            prev = 0
            ButtonWeapon[ButtonWeapon.count - 1].selected = false
        }
        
        if(OK.selected == true)
        {
        }
        for itemnum  = 0 ; itemnum < ButtonWeapon.count - 1 ; itemnum += 1
        {
            if(ButtonWeapon[itemnum].selected == true)
            {
                break;
            }
        }
        if(itemnum == ButtonWeapon.count - 1)
        {
            itemnum = 0
        }
    }
    class WeaponButton : Button
    {
        let Node = SKSpriteNode()
        let CharNode = SKSpriteNode()
        init(tag:String)
        {
            super.init(tag:tag)
            self.texture = SKTexture(imageNamed: "CharaSamNail.gif")
            unpressImage = self.texture!
            pressImage = SKTexture(imageNamed: "CharaSamNailP.gif")
            self.addChild(CharNode)
            Timer = Foundation.Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(WeaponButton.reset), userInfo: nil, repeats: false)
            
        }
        func reset()
        {
            Node.size = self.size
            CharNode.size = self.size
        }
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
        {
            flag = true
            self.texture = pressImage
            CharNode.alpha = 0.5
            touchDownBegin()
        }
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            
            let touchEvent = touches.first
            let location = touchEvent!.location(in: self)
            CharNode.alpha = 1
            var rect = CGRect()
            rect.origin = CGPoint(x: self.size.width / 2 + self.position.x,y: self.size.height / 2 + self.position.y )
            rect.size = self.size
            let node:SKNode? = self.atPoint(location)//タッチ座標からノードを見つける
            let b = (node as? Button)//そのノードはボタンか？
            if(self != b)
            {
                touchUpInside()
            }
            if(self == b)
            {
                touchUpOutside()
            }
            flag = false
            
        }
        override func touchUpInside()
        {
            selected = true

        }
        override func touchUpOutside() {
            if(selected == false)
            {
                self.texture = unpressImage
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
            size = CGSize(width: 50, height: 50)
            imageNode.size = size
            self.pressImage = SKTexture(imageNamed: "BackButton.gif")
            self.unpressImage = SKTexture(imageNamed: "BackButtonP.gif")
            self.imageNode.texture = unpressImage
            self.name = "BackButton"
        }
        
        override func touchUpInside() {
            let scene = MenuScean(size: globalData.gameSize)
            //呼び出すSceneをJumpScene classにしただけ
            scene.scaleMode = SKSceneScaleMode.aspectFill
            SceanS.selfScean.view?.presentScene(scene, transition: SKTransition.push(with: SKTransitionDirection.left, duration: 1))
        }

        deinit
        {
            print(" BackButton Delete")
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    class BackButton2 : Button
    {
        init()
        {
            super.init()
            Tag.text = "キャンセル"
            size = CGGameSize(50, 50)
            imageNode.size = size
            self.pressImage = SKTexture(imageNamed: "BackButton.gif")
            self.unpressImage = SKTexture(imageNamed: "BackButtonP.gif")
            self.imageNode.texture = unpressImage
            self.name = "BackButton"
        }
        
        override func touchUpInside() {
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
    class OKButton: Button {
        init()
        {
            super.init(tag: "変更", pos: CGPoint(x: 0, y: 0), size: CGGameSize(100, 100), unpressedImageName: "OKButton.gif", pressedImageName: "OKButtonP.gif")
            self.imageNode.texture = pressImage
            flag = true
        }
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
        {
            if(flag == false)
            {
                self.imageNode.texture = pressImage
                touchDownBegin()
            }
        }
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            
            if(flag == true)
            {
                return
            }
            let touchEvent = touches.first
            let location = touchEvent!.location(in: self)
            var rect = CGRect()
            rect.origin = CGPoint(x: self.size.width / 2 + self.position.x,y: self.size.height / 2 + self.position.y )
            rect.size = self.size
            let node:SKNode? = self.atPoint(location)//タッチ座標からノードを見つける
            let b = (node as? Button)//そのノードはボタンか？
            if(self != b)
            {
                touchUpInside()
                let scene = CharactorSettingSelectSean(item: itemnum)
                //呼び出すSceneをJumpScene classにしただけ
                scene.scaleMode = SKSceneScaleMode.aspectFill
                self.gameScene.view?.presentScene(scene)

                self.selected = true
            }
            if(self == b)
            {
                touchUpOutside()
            }
            flag = false
            
        }
        func Resize(_ size:CGSize)
        {
            self.size = size
            self.imageNode.size = size
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
