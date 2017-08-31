//
//  CharactorSettingScean.swift
//  game
//
//  Created by IshimotoKiko on 2016/03/22.
//  Copyright © 2016年 IshimotoKiko. All rights reserved.
//

import SpriteKit

let width:CGFloat = 360
let height:CGFloat = 640
class CharactorSettingSelectSean : SKScene
{
    var firstSelect:Int
    init(item:Int) {
        //FileManager.removeAll()
        FileManager.initDataRead()
        FileManager.weaponItemSet(2, Skill: [0,0,0,0,0])
        scroll = SKScroll(size: CGGameSize(width - width / 3,30 + 100 * CGFloat(FileManager.weaponItemRead().count) / 2 )
            , range: CGGameSize(width - width / 3, height / 3), rangePoint: CGGamePoint(width / 2 - width / 2 / 3, height / 3 / 2))
        let x = FileManager.PlayerEquipmentsRead()[item] as! Int
        firstSelect = item
        itemnum = x
        print(itemnum)
        print(item)
        prevItemnum = itemnum
        Equip = MakeEquipName()
        Equip.position = CGGamePoint(width / 2,height * 0.859375)
        super.init(size: globalData.gameSize)
        //print("num" + String(FileManager.weaponItemRead().count))
        
    }
    
    var button:[EquipButton] = []
    let scroll:SKScroll
    let Equip:MakeEquipName
    
    let WeaponExplanatory: UILabel = UILabel(frame: CGGameRect(width - width / 3 - width / 100 ,height - height / 3 + height / 100 ,width / 3, height / 3))
    
    let back  = BackButton()
    let back2 = BackButton()
    override func didMove(to view: SKView) {
        
        let SkillTitle = SKLabelNode(text: "スキル")
        SkillTitle.fontName = "Qarmic_sans_Abridged.ttf"
        SkillTitle.position = CGGamePoint(-70, 80)
        SkillTitle.fontSize = CGGameSquareX(20).width
        
        let path = Bundle.main.path(forResource: "Player", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        let backBW = width / 6
        let backBH = height / 15
        
        
        back.position = CGGamePoint(width - backBW  + backBW / 2, backBH / 2)
        back2.position = CGGamePoint(width - backBW  - backBW / 2, backBH / 2)
        back.zPosition = 5
        back2.zPosition = 5
        back.size = CGGameSize(backBW,backBH)
        back2.size = CGGameSize(backBW,backBH)
        back.imageNode.size = CGGameSize(backBW,backBH)
        back2.imageNode.size = CGGameSize(backBW,backBH)
        back.Tag.fontSize = back.size.height/4.4
        back2.Tag.fontSize = back2.size.height/4.4
        back.Tag.text = "配置"
        back.setScene(self)
        back2.setScene(self)
        
        
        SetWeaponExplanatory("")
        WeaponExplanatory.textColor = UIColor.lightText
        WeaponExplanatory.backgroundColor = UIColor.brown
        WeaponExplanatory.font = UIFont.systemFont(ofSize: 18 / globalData.size.width * globalData.gameSize.width)
        let weaponP = FileManager.weaponItemRead()//dict!.objectForKey("HaveItemCount") as! Int + 1
        
        for x  in weaponP
        {
            let dict = x as! Dictionary<String, AnyObject>
            let i = dict["ID"] as! Int
            button.append(EquipButton(ID: i))
        }
        
        button[itemnum].selected = true
        button[itemnum].texture = button[itemnum].pressImage
        print(weaponP)
        
        scroll.setButtonGroup(button)

        scroll.paramateSet(15.0, btIntervalY: 20, frIntervalLeft: 15, frIntervalRight: 15, frIntervalUp: 10, frIntervalDown: 10, buttonFrameVaticalOrHorizontal:70, HorizontalOrVerticalFlag: true, lineButton: 2)
        scroll.set()
        self.addChild(scroll)
        
        let paramateView = SKSpriteNode(texture: nil, color: UIColor.gray, size: CGGameSize(width + 15,height - height / 3 + 15))
        
        paramateView.position = CGGamePoint(width / 2, height - height / 3)
        let UP = SKSpriteNode(imageNamed: "f00132.png")
        UP.size = paramateView.size
        UP.zPosition = 3.1
        paramateView.zPosition = 3
        paramateView.addChild(UP)
        var x = 0
        for label in paramateLabel
        {
            label.position = CGGamePoint(10, -CGFloat(x) * 70 + 80)
            
            paramateView.addChild(label)
            x += 1
        }
        paramateView.addChild(SkillTitle)
        
        self.addChild(paramateView)
        self.addChild(Equip)
        FileManager.weaponParamateRead(0)
        FileManager.weaponParamateRead(1)
        
        
        let paramateStruct:weaponParameters = FileManager.weaponParamateRead(itemnum)
        ViewEquipLabel(paramateStruct)
        paramateLabel[0].paramate.text = paramateStruct.TypeName!
        paramateLabel[1].paramate.text = String(paramateStruct.Power)
        paramateLabel[2].paramate.text = String(paramateStruct.FireRate)
        paramateLabel[3].paramate.text = String(paramateStruct.Speed)
        
        
        SetWeaponExplanatory(FileManager.getWeaponExplanatory(itemnum))
        
        self.view!.addSubview(WeaponExplanatory)
        self.addChild(back)
        self.addChild(back2)
    }
    let paramateLabel =
    [
            ParamateLabel(text:"タイプ　"),
            ParamateLabel(text:"攻撃力　"),
            ParamateLabel(text:"攻撃速度"),
            ParamateLabel(text:"弾速　　")
    ]
    func ViewEquipLabel(_ weapon:weaponParameters)
    {
        Equip.ID.text = Equip.IDText + String(weapon.WeaponID)
        Equip.Name.text = weapon.weaponName
    }
    func SetWeaponExplanatory(_ text:String)
    {
        WeaponExplanatory.frame = CGGameRect(width - width / 3 - width / 100 ,height - height / 3 + height / 100 ,width / 3, height / 3)
        WeaponExplanatory.text = text
        WeaponExplanatory.numberOfLines = 0
        WeaponExplanatory.sizeToFit()
        WeaponExplanatory.lineBreakMode = NSLineBreakMode.byCharWrapping
    }
    final var prev = 0
    override func willMove(from view: SKView) {
        
        removeAllChildren()
        
    }
    var itemnum = 0
    override func update(_ currentTime: TimeInterval) {
        var ans = 0
        for x in 0 ..< button.count
        {
            if(button[x].selected == true)
            {
                ans = ans | 1 << x
            }
        }
        let ANS = ans ^ prev
        if(ANS != 0)
        {
            for x in 0 ..< button.count
            {
                if(ANS & 1 << x != 0)
                {
                    button[x].selected = true
                }
                else
                {
                    button[x].selected = false
                    button[x].texture = button[x].unpressImage
                }
            }
            prev = ANS
        }
        for itemnum  = 0 ; itemnum < button.count ; itemnum += 1
        {
            if(button[itemnum].selected == true)
            {
                
                break;
            }
        }
        if(back.selected)
        {
            //ここを解決
            let ID = (FileManager.weaponItemRead()[itemnum] as! Dictionary<String,AnyObject>)["ID"] as! Int
            FileManager.PlayerEquipmentsWrite(ID, equipNumber: firstSelect)
            print(ID)
            for v in self.view!.subviews
            {
                v.removeFromSuperview()
            }
            back2.moveScean(self, toScean: StatusSettingScean(size: self.size))
        }
        if(back2.selected)
        {
            for v in self.view!.subviews
            {
                v.removeFromSuperview()
            }
            back2.moveScean(self, toScean: StatusSettingScean(size: self.size))
        }
        if(itemnum != prevItemnum)
        {
            let ID = (FileManager.weaponItemRead()[itemnum] as! Dictionary<String,AnyObject>)["ID"] as! Int
            let paramateStruct:weaponParameters =
                FileManager.weaponParamateRead(ID)
            ViewEquipLabel(paramateStruct)
            paramateLabel[0].paramate.text = paramateStruct.TypeName!
            paramateLabel[1].paramate.text = String(paramateStruct.Power)
            paramateLabel[2].paramate.text = String(paramateStruct.FireRate)
            paramateLabel[3].paramate.text = String(paramateStruct.Speed)
            SetWeaponExplanatory(FileManager.getWeaponExplanatory(ID))
            prevItemnum = itemnum
        }
    }
    var prevItemnum = 0;
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    class ParamateLabel : SKLabelNode
    {
        var paramate = SKLabelNode(fontNamed: "Qarmic_sans_Abridged.ttf")
        init(text: String)
        {
            
            
            super.init()
            self.fontName = "Qarmic_sans_Abridged.ttf"
            self.text = text + ":"
            self.fontSize = 15 / globalData.size.width * globalData.gameSize.width
            self.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
            self.paramate.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
            
            paramate.fontSize = 14 / globalData.size.width * globalData.gameSize.width
            paramate.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
            paramate.position = CGGamePoint((60 + 10), 0)
            
            //paramate.addChild(ArrowTexture)
            self.addChild(paramate)
            //self.addChild(paramateAftar)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    class EquipButton : Button
    {
        open let WeaponName:String
        init(ID:Int)
        {
            WeaponName = FileManager.weaponParamateRead(ID).weaponName!
            super.init(tag: WeaponName, pos: CGPoint.zero, size: CGSize.zero)
            
        }
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
        {
            flag = true
            self.texture = pressImage
            touchDownBegin()
        }
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            
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
    class MakeEquipName : SKSpriteNode
    {
        let Name:SKLabelNode
        let ID:SKLabelNode
        let IDText = "No."
        init()
        {
            Name = SKLabelNode()
            ID = SKLabelNode()
            super.init(texture: nil, color: UIColor.brown, size: CGGameSize(240 , 50))
            self.zPosition = 3.2
            Name.position = CGPoint(x: -0, y: 0)
            Name.zPosition = 3.3
            Name.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
            Name.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
            Name.fontSize = 20 / globalData.size.width * globalData.gameSize.width
            Name.fontName = "Qarmic_sans_Abridged.ttf"
            ID.fontSize = 13 / globalData.size.width * globalData.gameSize.width
            ID.position = CGGamePoint(-115 / globalData.size.width * width, 0)
            ID.zPosition = 3.3
            ID.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
            ID.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
            ID.fontName = "Qarmic_sans_Abridged.ttf"
            Name.text = "null"
            ID.text = IDText
            self.addChild(Name)
            self.addChild(ID)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    class Back : BackButton
    {
        override init()
        {
            super.init()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

}

/*
class ParamateLabel : SKLabelNode
{
    let paramate = SKLabelNode(fontNamed: "Qarmic_sans_Abridged.ttf")
    let paramateAftar = SKLabelNode(fontNamed: "Qarmic_sans_Abridged.ttf")
    let imageUP = SKTexture(imageNamed: "UP.png")
    let imageDown = SKTexture(imageNamed: "DOWN.png")
    let imageDrow = SKTexture(imageNamed: "DROW.png")
    let action:SKAction
    let ArrowTexture:SKSpriteNode
    init(text: String)
    {
        let action1 = SKAction.moveByX(0, y: 10, duration: 0.3)
        let action2 = SKAction.moveByX(0, y: -10, duration: 0.3)
        let wait = SKAction.waitForDuration(1.0)
        ArrowTexture = SKSpriteNode(texture: imageDrow)
        action = SKAction.repeatActionForever(SKAction.sequence([action1,action2,action1,action2,wait]))
        
        
        super.init()
        
        self.fontName = "Qarmic_sans_Abridged.ttf"
        self.text = text
        self.fontSize = 15
        self.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        self.paramate.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        
        ArrowTexture.size = CGSizeMake(18, 10)
        ArrowTexture.zRotation = CGFloat(-90 * M_PI / 180)
        
        paramate.fontSize = 14
        paramate.position = CGPointMake(30, -20)
        paramateAftar.fontSize = 14
        paramateAftar.position = CGPointMake(30, -50)
        
        
        ArrowTexture.position = CGPointMake(0, -10)
        //paramate.addChild(ArrowTexture)
        //self.addChild(paramate)
        //self.addChild(paramateAftar)
        
    }
    
    func set(befor:Int , aftor:Int)
    {
        paramate.text = String(befor)
        paramateAftar.text = String(aftor)
        if(befor < aftor)
        {
            ArrowTexture.texture = imageUP
            paramateAftar.fontColor = UIColor.orangeColor()
            ArrowTexture.runAction(action)
        }
        else if(befor > aftor)
        {
            
            ArrowTexture.texture = imageDown
            paramateAftar.fontColor = UIColor.cyanColor()
            ArrowTexture.removeAllActions()
        }
        else
        {
            
            ArrowTexture.texture = imageDrow
            paramateAftar.fontColor = UIColor.whiteColor()
            ArrowTexture.removeAllActions()
            
        }
    }
    func set(str:String = "")
    {
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}*/
