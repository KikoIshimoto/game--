//
//  ButtonClasses.swift
//  game
//
//  Created by IshimotoKiko on 2016/03/11.
//  Copyright © 2016年 IshimotoKiko. All rights reserved.
//

import SpriteKit

class ButtonGroup : SKNode
{
    var ButtonG:[Button]  = [Button()]
    var backGroundNode = SKSpriteNode()
    
    var HorizontalOrVertical = true
    var lineButtonNum:Int = 1
    var origin = CGPoint(x: 0,y: 0)
    var ButtonLineUpSize = CGSize(width: 300, height: 300)
    var upperLeftCorner = CGPoint(x: 300, y: 300)
    
    var buttonIntervalX = 10
    var buttonIntervalY = 10
    var frameIntervalLeft = 2
    var frameIntervalRight = 2
    var frameIntervalUp = 2
    var frameIntervalDown = 2
    var buttonVarticalOrHorizontal = 80
    init(size:CGSize , backGround:String! = nil ,backGroundColor:UIColor = UIColor.clear) {
        super.init()
        self.zPosition = 0.6
        self.position  = CGPoint.zero
        //let BackPicture:SKTexture? = SKTexture(imageNamed: backGround)
        backGroundNode = SKSpriteNode(texture: nil/*BackPicture*/, color: backGroundColor, size: size)
        backGroundNode.position = CGPoint.zero
        backGroundNode.zPosition = 0.7
        backGroundNode.size = size
        backGroundNode.position = CGPoint(x: 0,y: 0)
        upperLeftCorner = CGPoint(x: -self.backGroundNode.size.width / 2, y: self.backGroundNode.size.height / 2)
        ButtonLineUpSize = size
        self.addChild(backGroundNode)
    }
    deinit
    {
        print("ButtonGroup Delete")
    }
    func setButtonGroup(_ button:[Button])
    {
        ButtonG = button
        lineButtonNum = button.count
        set()
        for count in ButtonG
        {
            addChild(count)
        }
    }
    func paramateSet(_ btIntervalX:CGFloat,btIntervalY:CGFloat,frIntervalLeft:CGFloat,frIntervalRight:CGFloat,frIntervalUp:CGFloat,frIntervalDown:CGFloat,buttonFrameVaticalOrHorizontal:CGFloat = 50 , HorizontalOrVerticalFlag:Bool = true , lineButton:Int = 1)
    {
        func convertX(_ pa:CGFloat) -> Int
        {
            let x = pa / globalData.size.width * globalData.gameSize.width
            return Int(x)
        }
        func convertY(_ pa:CGFloat) -> Int
        {
            let x = pa / globalData.size.height * globalData.gameSize.height
            return Int(x)
        }
        buttonIntervalX = convertX(btIntervalX)
        buttonIntervalY = convertY(btIntervalY)
        frameIntervalLeft = convertX(frIntervalLeft)
        frameIntervalRight = convertX(frIntervalRight)
        frameIntervalUp = convertY(frIntervalUp)
        frameIntervalDown = convertY(frIntervalDown)
        buttonVarticalOrHorizontal = HorizontalOrVerticalFlag == true ? convertY(buttonFrameVaticalOrHorizontal) : convertX(buttonFrameVaticalOrHorizontal)
        HorizontalOrVertical = HorizontalOrVerticalFlag
        lineButtonNum = lineButton
    }
    func set()
    {
        ButtonLineUpSize =
            CGSize(
                width: self.backGroundNode.size.width - CGFloat(frameIntervalLeft + frameIntervalRight) ,
                height: self.backGroundNode.size.height - CGFloat(frameIntervalUp + frameIntervalDown))
        let buttonSize = CGSize(
            width: HorizontalOrVertical == true ? (ButtonLineUpSize.width - CGFloat(buttonIntervalX * (lineButtonNum - 1))) / CGFloat(lineButtonNum) : CGFloat(buttonVarticalOrHorizontal),
            height: HorizontalOrVertical == false ? (ButtonLineUpSize.height - CGFloat(buttonIntervalY * (lineButtonNum - 1))) / CGFloat(lineButtonNum) : CGFloat(buttonVarticalOrHorizontal))
        
        var x = 0
        var y = 0
        for button in ButtonG
        {
                let ButtonOrigin = CGPoint(
                    x: -ButtonLineUpSize.width / 2 + ((CGFloat(x) * buttonSize.width) + CGFloat(x * buttonIntervalX) + buttonSize.width / 2 ) ,
                    y: ButtonLineUpSize.height / 2 - ((CGFloat(y) * buttonSize.height) + CGFloat(y * buttonIntervalY) + buttonSize.height / 2)
                )
                button.imageNode.size = buttonSize
                button.position = ButtonOrigin
                button.size = buttonSize
                button.Tag.fontSize = button.size.height / 4.5
            if(HorizontalOrVertical == true)
            {
                x++
                if(x % lineButtonNum == 0)
                {
                    x = 0
                    y++
                }
            }
            else
            {
                y++
                if(y % lineButtonNum == 0)
                {
                    x++
                    y = 0
                }
            }

        }

    }
    
    func remove()
    {
        for button in ButtonG
        {
            button.timerDelete()
            button.removeFromParent()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Button : SKSpriteNode
{
    
    var pressImage:SKTexture
    var unpressImage:SKTexture
    var flag:Bool = false
    var Tag:SKLabelNode
    let imageNode = SKSpriteNode()
    var selected = false
    var Timer = Foundation.Timer()
    init( tag:String = "test" , pos: CGPoint = CGPoint(x: 0, y: 0) , size : CGSize =  CGSize(width: 50, height: 50) , unpressedImageName: String! = "button1P.gif" ,pressedImageName:String! = "button1.gif")
    {
        
        Tag = SKLabelNode(text: tag)
        self.pressImage = SKTexture(imageNamed: pressedImageName)
        self.unpressImage = SKTexture(imageNamed: unpressedImageName)
        
        super.init(texture: nil, color: UIColor.clear, size: CGSize(width: 10, height: 10))
        
        self.texture = self.unpressImage
        self.size = size
        self.name = tag
        self.position = pos
        self.zPosition = 1
        self.isUserInteractionEnabled = true
        imageNode.position = CGPoint(x: 0, y: 0)
        imageNode.size = size
        imageNode.zPosition = 0.8
        Tag.fontSize = size.height/4.4
        Tag.fontColor = UIColor.darkText
        Tag.zPosition = 0.9
        Tag.position = CGPoint(x: 0, y: -size.height/4.5 )
        Tag.blendMode = SKBlendMode.subtract
        Tag.fontName = "font_1_kokumr_1.00_rls.ttf"
        self.addChild(Tag)
        self.addChild(imageNode)
        
    }
    
    var gameScene: SKScene!
    func setScene(_ scene: SKScene)
    {
        self.gameScene = scene
        
        isUserInteractionEnabled = true
    }
    func update()
    {
    }
    func timerDelete()
    {
        Timer.invalidate()
    }
    func remove()
    {
    }
    func moveScean(_ nowScean : SKScene,toScean : SKScene , trans : SKTransition = SKTransition.doorway(withDuration: 1) )
    {
        let scene = toScean
        scene.scaleMode = SKSceneScaleMode.aspectFill
        nowScean.view!.presentScene(scene, transition: trans)
    }
    func touchDownBegin()
    {
    }
    func touchUpInside()
    {
    }
    func touchUpOutside()
    {
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        flag = true
        imageNode.texture = pressImage
        touchDownBegin()
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        imageNode.texture = unpressImage
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
        }
        if(self == b)
        {
            touchUpOutside()
        }
        flag = false
        
    }
    func NoPress()
    {
        flag = false
        imageNode.texture = unpressImage
    }
    func OnPress()
    {
        flag = true
        imageNode.texture = pressImage
    }
    func on(_ b : Button! , node:SKNode!) -> Bool
    {
        return b == self || node.parent == self.Tag
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
