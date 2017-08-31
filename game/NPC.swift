//
//  item.swift
//  game
//
//  Created by IshimotoKiko on 2016/01/15.
//  Copyright © 2016年 IshimotoKiko. All rights reserved.
//

import SpriteKit
struct CollisionType
{
    static let Field:UInt32 = 0x01 << 0
    static let Player:UInt32 = 0x01 << 1
    static let Enemy:UInt32 = 0x01 << 2
    static let playerBullet:UInt32 = 0x01 << 3
    static let enemyBullet:UInt32 = 0x01 << 4
}
struct PCParameters {

    var HP = 10000.0
    var FireRate = 0.5
    var Power = 10.0
    var Diffence = 0.0
    var PlayerOrEnemy = true
    var BOSS:Bool = false
    var Name:String = ""
    var WeaponEquip:[Int] =
    [
        //Bullet(pos: CGPointZero, rot: 0, Whose: true, Option: [Skill()])
        //spreadBullet(pos: CGPointZero, rot: 0, Whose: true, Option: [Skill()])
    ]
    init(Name: String = "Chara",
        HP: Double = 10000,
        Power:Double = 10,
        Diffence:Double = 10,
        WeaponEquip:[Int] = [0,0,0])
    {
        self.Name = Name
        self.HP = HP
        self.Diffence = Diffence
        self.Power = Power
        self.WeaponEquip = WeaponEquip
    }
    //var wea = Bullet(pos: CGPointZero, rot: 0, Whose: true, Option: [Skill()])
}
struct weaponParameters
{
    var weaponName:String? = nil
    var WeaponID:Int = 0
    var TypeName:String? = nil
    var TypeID:Int = 0
    var Power:Double = 1
    var Time:Double = 1
    var FireRate:Double
    var Baund:Bool = false
    var Whose:Bool = true
    var Penetration:Bool = false
    var Speed:Double = 300
    var Group:[String:AnyObject] = ["Count":1, "RandamSeed":10 , "Angle":180]
    var Sequence:[String:AnyObject] = ["Count":1 , "intervalTime":0.1]
    init(Name:String = "noName",typeIDName:String = "なし",typeID:Int = 0,ID:Int = 0,power:Double = 10,time:Double = 1 , firerate:Double = 0.5,Speed:Double = 300 , group:[String:AnyObject] = ["Count":1,"RandamSeed":10 , "Angle":180 ] ,sequence:[String:AnyObject] = ["Count":1 , "intervalTime":0.1])
    {
        weaponName = Name
        WeaponID = ID
        TypeName = typeIDName
        TypeID = typeID
        Power = power
        Time = time
        FireRate = firerate
        Baund = false
        Penetration = false
        self.Speed = Speed
        Group = group
        Sequence = sequence
    }
}

class CharaBase:SKSpriteNode
{
   
    var Statas = PCParameters()
    var Timer  = Foundation.Timer()
    init()
    {
        super.init(texture: nil, color: UIColor.blue, size: CGGameSquareX(15))
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func update()
    {
        
    }
    func remove()
    {
        self.removeFromParent()
        self.Timer.invalidate()
    }
    func move()
    {
        
    }

}

struct PlayerOther
{
    static var Coordinate = CGPoint()
}
class Player:CharaBase
{
    var gameScene: SKScene!
    func setScene(_ scene: SKScene)
    {
        self.gameScene = scene
    }
    //var timer = NSTimer()
    //var shot = Bullet(pos: CGPointMake(10, 10),rot:0)
    var EquipWeapon:[Weapon!]
    var FireTime:[Double] = [0.0,0.0,0.0]
    var SequenceTime:[Double] = [0.0,0.0,0.0]
    var SequenceFlag:[Bool] = [false,false,false]
    var angle:[Double] = [0.0,0.0,0.0]
    
    var VectorR:CGFloat = CGPitagoras(100)
    override init() {
        EquipWeapon = [WeaponContollore.getWeapon(true,WeaponID:(FileManager.PlayerEquipmentsRead()[0] as! Int))]
        EquipWeapon.append(WeaponContollore.getWeapon(true,WeaponID:(FileManager.PlayerEquipmentsRead()[1] as! Int)))
        EquipWeapon.append(WeaponContollore.getWeapon(true,WeaponID:(FileManager.PlayerEquipmentsRead()[2] as! Int)))
        
        super.init()
        
        self.Statas = FileManager.readPlayerStatus()
        self.position = CGPoint(x: 200, y: 300)
        self.zPosition = 1
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.restitution = 0.5
        self.physicsBody?.linearDamping = 0.0
        self.physicsBody?.friction = 0.5
        self.physicsBody?.density = 100
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.collisionBitMask = CollisionType.Field
        self.physicsBody?.categoryBitMask = CollisionType.Player
        self.physicsBody?.contactTestBitMask = CollisionType.Enemy | CollisionType.enemyBullet//Bulletと接触
        self.name = "player"
        for weapon in EquipWeapon
        {
            if(weapon != nil)
            {
                weapon.Status.Power += Statas.Power
            }
        }
        print(Statas.Power)
        for var x = 0;x < angle.count ;x += 1
        {
            if(EquipWeapon[x] != nil)
            {
                let an = EquipWeapon[x].Status.Group["Angle"] as! Double
                angle[x] = M_PI / an / Double(EquipWeapon[x].Status.Group["Count"] as! Double)
            }
        }
        self.Timer = Foundation.Timer.scheduledTimer(timeInterval: intevalTime, target: self, selector: "update", userInfo: nil, repeats: true)
    }
    func move(_ point:CGVector)
    {
        self.run(SKAction.move(by: point, duration: 0.1))
        PlayerOther.Coordinate = position
    }
    var SequenceCount:[Int] = [0,0,0]
    let intevalTime = 0.01
    func shot(_ x:Int)
    {
        let sound = SKAction.playSoundFileNamed("shot.mp3", waitForCompletion: true)
        let node = SKNode()
        node.run(sound, completion: {node.removeFromParent()})
        self.addChild(node)
        let n = EquipWeapon[x].Status.Group["Angle"] as! Double
        for var count = 0 ; count < EquipWeapon[x].Status.Group["Count"] as! Int ;count += 1
        {
            let angleg = angle[x] * Double(count) + Double(M_PI / 2) - Double(M_PI / n / 2) + angle[x] / 2 //- offset
            let weapon =  EquipWeapon[x].makeClone()
            let vector = CGVector(dx: CGFloat(weapon.Status.Speed) * CGCos(angleg), dy: CGFloat(weapon.Status.Speed) * CGSin(angleg))
            weapon.position = position
            weapon.zRotation = CGFloat(angleg - M_PI / 2 )
            weapon.physicsBody?.velocity = vector
            weapon.setScene(gameScene)
            gameScene.addChild(weapon)
        }
    }
    override func update() {
        var x = 0
        for  Equip in EquipWeapon
        {
            FireTime[x] += intevalTime
            if (Equip != nil)
            {
                if(SequenceFlag[x])
                {
                    if((Equip.Status.Sequence["intervalTime"] as! Double) < SequenceTime[x])
                    {
                        if(SequenceCount[x] == Equip.Status.Sequence["Count"] as! Int - 1)
                        {
                            SequenceCount[x] = 0
                            SequenceFlag[x] = false
                            break
                        }
                        SequenceCount[x] += 1
                        shot(x)
                        SequenceTime[x] = 0.0

                    }
                    SequenceTime[x] += intevalTime
                }
                else
                {
                    if(Equip.Status.FireRate < FireTime[x] )
                    {
                        shot(x)
                        FireTime[x] = 0
                        
                        SequenceTime[x] = 0.0
                        SequenceFlag[x] = true
                    }
                }
            }
            x += 1
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit
    {
        print("CharaBaseは削除されました")
    }

}
class Enemy:CharaBase
{
    var gameScene: SKScene!
    func setScene(_ scene: SKScene)
    {
        self.gameScene = scene
    }
    var appeared:Bool = false
    var HPBarTimer = Foundation.Timer()
    
    var EquipWeapon:[Weapon!]
    
    var FireTime:[Double] = [0.0,0.0,0.0]
    var SequenceTime:[Double] = [0.0,0.0,0.0]
    var SequenceFlag:[Bool] = [false,false,false]
    var angle:[Double] = [0.0,0.0,0.0]
    //(pos: CGPointMake(0, 10),rot:0,
    let HPBar = enemyHPBar()
    init(STATAS:PCParameters) {
        EquipWeapon = [WeaponContollore.getWeapon(false,WeaponID:STATAS.WeaponEquip[0])]
        EquipWeapon.append(WeaponContollore.getWeapon(false,WeaponID:STATAS.WeaponEquip[1]))
        EquipWeapon.append(WeaponContollore.getWeapon(false,WeaponID:STATAS.WeaponEquip[2]))
        
        super.init()
        self.size = CGGameSize(200, 200)
        self.texture = SKTexture(imageNamed: "charon.png")
        self.Statas = STATAS
        Statas.PlayerOrEnemy = false
        // 敵の設定を適当に書いておきます。
        HPBar.enemySize = self.size
        self.zRotation = CGFloat(180  / 180.0 * M_PI)
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.restitution = 0.5
        self.physicsBody?.linearDamping = 0.0
        self.physicsBody?.friction = 0.5
        self.physicsBody?.density = 10000
        self.physicsBody?.usesPreciseCollisionDetection = false
        self.physicsBody?.categoryBitMask = CollisionType.Enemy
        self.physicsBody?.contactTestBitMask = CollisionType.Player | CollisionType.playerBullet//Bulletと接触
        //self.physicsBody?.collisionBitMask = CollisionType.Field// | CollisionType.playerBullet
        self.name = "enemy"
        for weapon in EquipWeapon
        {
            if(weapon != nil)
            {
                weapon.Status.Power += Statas.Power
            }
        }
        
        for var x = 0;x < angle.count ;x += 1
        {
            if(EquipWeapon[x] != nil)
            {
                let an = EquipWeapon[x].Status.Group["Angle"] as! Double
                angle[x] = M_PI / an / Double(EquipWeapon[x].Status.Group["Count"] as! Double)
            }
        }

    }
    func run()
    {
        appeared = true
        gameScene.addChild(self)
        // タイマーを起動します。
        self.addChild(HPBar)
        self.Timer = Foundation.Timer.scheduledTimer(timeInterval: intevalTime, target: self, selector: "update", userInfo: nil, repeats: true)
        if(Statas.BOSS == false)
        {
            self.HPBarTimer = Foundation.Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: "HPBarUpdate", userInfo: nil, repeats: true)
        }
        else
        {
            HPBar.removeFromParent()
            HPBarTimer.invalidate()
        }
    }
    func move(_ point:CGPoint)
    {
        self.run(SKAction.move(to: point, duration: 0.01))
    }
    func HPBarUpdate()
    {
        HPBar.update(Int(self.Statas.HP))
    }
    
    var SequenceCount:[Int] = [0,0,0]
    let intevalTime = 0.01
    func shot(_ x:Int)
    {
        let n = EquipWeapon[x].Status.Group["Angle"] as! Double
        for var count = 0 ; count < EquipWeapon[x].Status.Group["Count"] as! Int ;count += 1
        {
            let angleg = angle[x] * Double(count) + Double(M_PI / 2) - Double(M_PI / n / 2) + angle[x] / 2 + Double(self.zRotation)//- offset
            let weapon =  EquipWeapon[x].makeClone()
            let vector = CGVector(dx: CGFloat(weapon.Status.Speed) * CGCos(angleg), dy: CGFloat(weapon.Status.Speed) * CGSin(angleg))
            weapon.position = position
            weapon.zRotation = CGFloat(angleg - M_PI / 2  )
            weapon.physicsBody?.velocity = vector
            weapon.setScene(gameScene)
            gameScene.addChild(weapon)
        }
    }
    override func update() {
        var x = 0
        for  Equip in EquipWeapon
        {
            FireTime[x] += intevalTime
            if (Equip != nil)
            {
                if(SequenceFlag[x])
                {
                    if((Equip.Status.Sequence["intervalTime"] as! Double) < SequenceTime[x])
                    {
                        if(SequenceCount[x] == Equip.Status.Sequence["Count"] as! Int - 1)
                        {
                            SequenceCount[x] = 0
                            SequenceFlag[x] = false
                            break
                        }
                        SequenceCount[x] += 1
                        shot(x)
                        SequenceTime[x] = 0.0
                        
                    }
                    SequenceTime[x] += intevalTime
                }
                else
                {
                    if(Equip.Status.FireRate < FireTime[x] )
                    {
                        shot(x)
                        FireTime[x] = 0
                        
                        SequenceTime[x] = 0.0
                        SequenceFlag[x] = true
                    }
                }
            }
            x += 1
        }
        if position.y < 0
        {
            remove()
        }
    }

    override func remove()
    {
        HPBarTimer.invalidate()    
        self.Timer.invalidate()
        self.removeAllChildren()
        self.removeFromParent()

        
        print("////////////////////CharaBaseは削除されました")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit
    {
        print("CharaBaseは削除されました")
    }
}



class CreateRandomInt {
    // 最小値と最大値の間で乱数を作成する
    class func minMaxDesignation(min _min: Int, max _max: Int) -> Int {
        if _min < _max {
            let diff = _max - _min + 1
            let random : Int = Int(arc4random_uniform(UInt32(diff)))
            return random + _min
        }else {
            fatalError("error")
        }
    }
    
    // 最小値から指定の範囲までの乱数を作成する
    class func minRange(min _min: Int, range _range: Int) -> Int {
        let random : Int = Int(arc4random_uniform(UInt32(_range)))
        return _min + random
    }
    
    // 最大値から指定の範囲までの乱数を作成する
    class func maxRange(max _max: Int,range _range: Int) -> Int {
        let random : Int = Int(arc4random_uniform(UInt32(_range)))
        let min = _max - _range + 1
        return min + random
    }
}


