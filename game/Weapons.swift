//
//  Weapons.swift
//  game
//
//  Created by IshimotoKiko on 2016/03/26.
//  Copyright © 2016年 IshimotoKiko. All rights reserved.
//

import SpriteKit

class Weapon: SKSpriteNode
{
    var Status = weaponParameters()
    var timer = Timer()
    var attackSequence = Timer()
    var option:[Skill]
    var gameScene: SKScene!
    func setScene(_ scene: SKScene)
    {
        self.gameScene = scene
        
    }

    init(status:weaponParameters ,pos: CGPoint ,rot: CGFloat, Whose:Bool = true , Option:[Skill])
    {
        Status = status
        Status.Whose = Whose
        option = Option
        super.init(texture: nil, color: UIColor.yellow, size: CGGameSquareX(10))
        position = CGPoint(x: pos.x,y: pos.y + 15)
        zRotation = rot
        //print("weaponが作られました")
        for skill in option {
            skill.skillVariable(&Status)
        }
        if(Status.Whose)
        {
            name = "Pweapon"
        }
        else
        {
           name = "Eweapon"
        }
        self.timer = Timer.scheduledTimer(timeInterval: Status.Time, target: self, selector: #selector(CharaBase.update), userInfo: nil, repeats: false)
        
    }
    convenience init(Option:[Skill])
    {
        self.init(status:weaponParameters() , pos: CGPoint.zero, rot: 0, Whose: true, Option: Option)
    }
    init(Whose:Bool , Option:[Skill] = [Skill()])
    {
        Status.Whose = Whose
        option = Option
        super.init(texture: nil, color: UIColor.yellow, size: CGGameSquareX(10))

        //print("weaponが作られました")
    }
    func makeClone()->Weapon{
        return Weapon(status:Status,pos: CGPoint.zero, rot: 0, Whose: self.Status.Whose, Option: option)
    }
    func shot(){}
    func update(){}
    func remove()
    {
        timer.invalidate()
        self.removeFromParent()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class Bullet : Weapon
{
    override init(status: weaponParameters ,pos: CGPoint, rot: CGFloat, Whose: Bool, Option: [Skill]) {
        super.init(status:status , pos: pos, rot: rot, Whose: Whose, Option: Option)
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 10))
        let speed = CGPitagoras(CGFloat(status.Speed))
        self.physicsBody!.velocity = CGGameVector(speed * CGFloat(cos(Double(rot) + 90 / 180 * M_PI)), speed * CGFloat(sin(Double(rot) + 90 / 180 * M_PI)))
        
        self.physicsBody?.friction = 0.0
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.restitution = 1.0
        self.physicsBody?.linearDamping = 0.0
        self.physicsBody?.density=10
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.categoryBitMask = Status.Whose == true ? CollisionType.playerBullet : CollisionType.enemyBullet
        self.physicsBody?.contactTestBitMask = (Status.Baund == true ? 0 : CollisionType.Field) | (Status.Whose == true ? CollisionType.Enemy : CollisionType.Player)//機体に当たったら割り込み
        self.physicsBody?.collisionBitMask = ~(CollisionType.playerBullet | CollisionType.enemyBullet
            | (Status.Baund == false ? CollisionType.Field | CollisionType.Player | CollisionType.Enemy : 0))//弾同士は跳ね返らない また　フィールド内をバウンドするか
        if(Status.Whose == true)
        {
            self.color = UIColor.white
        }
        //print("Bulletが作られました")
    }
    convenience init(Option:[Skill])
    {
        self.init(status:weaponParameters(),pos: CGPoint.zero, rot: 0, Whose: true, Option: Option)
    }
    
    override init(Whose:Bool , Option:[Skill] = [Skill()])
    {
        super.init(Whose : Whose, Option : Option)
    }
    override func makeClone()->Weapon{
        return Bullet(status:Status,pos: CGPoint.zero, rot: 0, Whose: self.Status.Whose, Option: option)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func update() {
        
        self.removeFromParent()
        self.timer.invalidate()
    }
    deinit
    {
        //print("bulletは削除されました")
    }
}

class diffusionBullet : Bullet
{
    
    var spreadNum = 0
    var VectorR:CGFloat = CGPitagoras(100)
    var angle:Double = 0;
    
    let dt = FileManager.weaponParamateRead(1)
    //var Bound_:Bool
    override init(status:weaponParameters ,pos: CGPoint, rot: CGFloat, Whose: Bool, Option: [Skill]) {
        super.init(status:status,pos: pos, rot: rot, Whose: Whose, Option: Option)
        self.Status.Whose = Whose
        spreadNum = 10
        angle = 2 * M_PI / Double(spreadNum)
    }
    
    convenience init(Option:[Skill])
    {
        self.init(status:weaponParameters(),pos: CGPoint.zero, rot: 0, Whose: true, Option: Option)
    }
    
    override init(Whose:Bool , Option:[Skill] = [Skill()])
    {
        super.init(Whose : Whose, Option : Option)
    }
    override func makeClone()->Weapon{
        return diffusionBullet(status:Status,pos: CGPoint.zero, rot: 0, Whose: self.Status.Whose, Option: option)
    }
    override func update() {
        
        Status.Power = Double(spreadNum) * Status.Power
        for (var i = 0; i<spreadNum; i++)
        {
            let angleg = angle * Double(i) + Double(zRotation)
            let vector = CGVector(dx: VectorR * CGCos(angleg), dy: VectorR * CGSin(angleg))
            let sBullet = Bullet(status:dt,pos: self.position,rot:self.zRotation ,Whose: self.Status.Whose,Option: [Skill()])
            //sBullet.color = UIColor.redColor()
            sBullet.physicsBody?.velocity = vector
            sBullet.Status.Power = Status.Power / Double(spreadNum)
            self.gameScene.addChild(sBullet)
        }
        self.removeFromParent()
        self.timer.invalidate()
        
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class spreadBullet : Bullet
{
    var spreadNum = 0
    var VectorR = CGPitagoras(100)
    var angle:Double = 0;
    let dt = FileManager.weaponParamateRead(1)
    override init(status:weaponParameters,pos: CGPoint, rot: CGFloat, Whose: Bool, Option: [Skill])
    {
        super.init(status:status,pos: pos, rot: rot, Whose: Whose, Option: Option)
        self.Status.Whose = Whose
        spreadNum = 10
        angle = M_PI / Double(spreadNum)
        //print(zRotation / CGFloat(M_PI * 180))
        //print("spreadBulletが作られました")
    }
    
    convenience init(Option:[Skill])
    {
        self.init(status:weaponParameters(),pos: CGPoint.zero, rot: 0, Whose: true, Option: Option)
    }
    /*
    convenience init()
    {
        self.init(status:weaponParameters(),pos: CGPointZero, rot: 0, Whose: true, Option: [Skill()])
    }*/
    override init(Whose:Bool , Option:[Skill] = [Skill()])
    {
        super.init(Whose : Whose, Option : Option)
    }
    override func makeClone()->Weapon{
        return spreadBullet(status:Status,pos: CGPoint.zero, rot: 0, Whose: self.Status.Whose, Option: option)
    }
    override func update()
    {
        //Status.Power = Double(spreadNum) * Status.Power
        for (var i = 0; i<spreadNum; i++)
        {
            let angleg = angle * Double(i) + angle / 2 + Double(self.zRotation)
            let vector = CGVector(dx: VectorR * CGCos(angleg), dy: VectorR * CGSin(angleg))
            let sBullet = Bullet(status:dt ,pos: self.position,rot : self.zRotation ,Whose:self.Status.Whose , Option: [Skill()])
            sBullet.physicsBody?.velocity = vector
            sBullet.Status.Power = Status.Power / Double(spreadNum)
            gameScene.addChild(sBullet)
        }
        self.removeFromParent()
        self.timer.invalidate()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
