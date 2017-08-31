//
//  TileTestScean.swift
//  game
//
//  Created by IshimotoKiko on 2016/04/01.
//  Copyright © 2016年 IshimotoKiko. All rights reserved.
//

import SpriteKit

struct MAPData
{
    let mapSize:CGSize
    let TileSize:CGSize
    let TileCount:[Int]
    let layers:[Layer]
    let imageHeight:[Int]
    let imageWidth:[Int]
    let imagecolumns:[Int]
}
struct Layer {
    let data:[Int]
}
class MapDataRead
{
    class func getMapData() -> MAPData
    {
        let path = Bundle.main.path(forResource: "untitled", ofType: "json")!
        
        let fileHandle = FileHandle(forReadingAtPath: path)
        
        let data = fileHandle?.readDataToEndOfFile()
        
        let json = JSON(data: data!)
        
        var layer:[Layer] = []
        for index in json["layers"].arrayValue {
            // 0,1,2,3...
            layer.append(Layer(data: (index["data"].arrayObject as! [Int])))
            print(0)
        }
        var tilecount:[Int] = []
        var imagewidth:[Int] = []
        var imageheidth:[Int] = []
        var columns:[Int] = []
        for index in json["tilesets"].arrayValue
        {
            tilecount.append(index["tilecount"].intValue )
            imagewidth.append(index["imagewidth"].intValue)
            imageheidth.append(index["imageheigth"].intValue)
            columns.append(index["columns"].intValue)
        }
        let mapsize = CGSize(width: CGFloat(json["height"].floatValue), height: CGFloat(json["width"].floatValue))
        let tileSize = CGSize(width: CGFloat(json["tilewidth"].floatValue), height: CGFloat(json["tileheight"].floatValue))
        let MapData = MAPData(mapSize: mapsize,  TileSize: tileSize, TileCount: tilecount, layers: layer, imageHeight: imageheidth,imageWidth: imagewidth,imagecolumns: columns)
        
        return MapData
    }
}
class test:SKScene
{
    override func didMove(to view: SKView) {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        let cx:CGFloat = self.size.width / 2
        let cy:CGFloat = self.size.height / 2
        let r:CGFloat =   CGFloat(pow(cx * cx + cy * cy , 0.5))
        let A = CGPoint(x: cx - 2 * r, y: cy - pow(3 , 0.5) * r)
        let B = CGPoint(x: cx + 2 * r, y: cy - pow(3 , 0.5) * r)
        let C = CGPoint(x: cx , y: cy + 2 * r)
        let point = [A,B,C]
        let t = Triangle(point: point)
        t.position = CGPoint(x: cx, y: cy)
        self.addChild(t)
        
        points = point
        prevPointCount = points.count
        
        for x in 0...100
        {
            let room = SKSpriteNode(texture: nil, color: UIColor.blue, size: CGSize(width: 4 * CGFloat(CreateRandomInt.minMaxDesignation(min: 20, max: 40)), height: CGFloat(4 * CreateRandomInt.minMaxDesignation(min: 20, max: 40))))
            room.position = getRandomPointInCircle(10, 10)
            let flame = SKSpriteNode(texture: nil, color: UIColor.white, size: CGSize(width: room.size.width - 4, height: room.size.height - 4))
            room.addChild(flame)
            room.physicsBody = SKPhysicsBody(rectangleOf: room.size)
            room.physicsBody?.allowsRotation = false
            room.physicsBody?.linearDamping = 1
            room.physicsBody?.usesPreciseCollisionDetection = false
            room.physicsBody?.restitution = 1
            room.physicsBody?.friction = 1
            room.name = String(0)
            if(room.size > CGSize(width: 30 * 4, height: 30 * 4))
            {
                flame.color = UIColor.red
                room.name = String(1)
            }
            self.addChild(room)
            usleep(1000);
        }

    }
    override func update(_ currentTime: TimeInterval) {
        for child in self.children
        {
            let f = child.physicsBody?.isResting
            if(f != nil && f! == true)
            {
                child.removeFromParent()
            }
        }
    }
    func roundm(_ n:Double, m:Double) -> CGFloat
    {
        return CGFloat(floor(((n + m - 1) / m)) * m)
    }
    func getRandomPointInCircle(_ ellipseX:Int,_ ellipseY:Int) -> CGPoint
    {
        let t = 2 * M_PI * Double(360) / Double(CreateRandomInt.minMaxDesignation(min: 0, max: 360))
        
        let u = Double(360) / Double(CreateRandomInt.minMaxDesignation(min: -360, max: 360)) +
                Double(360) / Double(CreateRandomInt.minMaxDesignation(min: -360, max: 360))
        var r = 0.0
        if u > 1{
            r = 2-u
        }
        else
        {
            r = u
        }
        return CGPoint(x: roundm(Double(ellipseX) * r * cos(t) , m: 4) + self.size.width / 2, y: roundm(Double(ellipseY) * r * sin(t) , m: 4) + self.size.height / 2)
    }
    
    var points:[CGPoint] = []
    var prevPointCount = 0
    let node = SKSpriteNode(texture: nil, color: UIColor.red, size: CGSize(width: 360, height: 640))
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let t = touches.first
        let p = t!.location(in: self)
        prev = p
        points.append(p)
        if (points.count != prevPointCount)
        {
            let shape = SKShapeNode(circleOfRadius: 40)
            shape.fillColor = UIColor.red
            shape.position = p
            self.addChild(shape)
            prevPointCount  = points.count
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let t = touches.first
        let p = t!.location(in: self)
        let vector = CGVector(dx: p.x - prev.x, dy: p.y - prev.y)
        node.run(SKAction.move(by: vector, duration: 0.1))
        prev = p
    }
    var prev = CGPoint.zero
    func PRINT(_ data:MAPData)
    {
        let tileSize = data.TileSize
        var count = 0
        for layer in data.layers
        {
            var mapchipNum:Int = 0
            
            let errx =
                CGFloat(data.mapSize.width * tileSize.width)
            let erry =
                CGFloat(data.mapSize.height * tileSize.height)
            for mapchip in layer.data
            {
                //if(mapchip != 0)
                //{
                let mapchipx:CGFloat = CGFloat((mapchip ) % data.imagecolumns[count] )
                let mapchipy:CGFloat = CGFloat((mapchip ) / data.imagecolumns[count] )
                
                let i = clipImage(UIImage(named: "dungyon.png")!, size: tileSize, point: CGPoint(x: mapchipx, y: mapchipy))
                var position = CGPoint(
                    x: tileSize.width * CGFloat((Int(data.mapSize.width * data.mapSize.height) - mapchipNum) % Int(data.mapSize.width)) - errx,
                    y: tileSize.height * CGFloat((Int(data.mapSize.width * data.mapSize.height) - mapchipNum) / Int(data.mapSize.width)) - erry)
                if(position.x < 0)
                {
                    position.x *= -1
                }
                /*if(position.y < 0)
                {
                    position.y *= -1
                }*/
                let texture = SKTexture(image: i)
                let s = SKSpriteNode(texture: texture)
                s.position = position
                node.addChild(s)
                //}
                mapchipNum += 1
            }
            //count += 1
        }
    }
    func sample()
    {
        let tileSize = CGSize(width: 40, height: 40)
        let i = clipImage(UIImage(named: "dungyon.png")!, size: tileSize,
                          point:CGPoint(x: 1, y: 1))
        let texture = SKTexture(image: i)
        let s = SKSpriteNode(texture: texture)
        s.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.addChild(s)
    }
    
    func clipImage(_ image: UIImage, size: CGSize,  point: CGPoint) -> UIImage {
        let imageRef = image.cgImage.cropping(to: CGRect(x: point.x * size.width, y: point.y * size.height,width: size.width, height: size.height))
        let cropImage = UIImage(cgImage: imageRef!)
        return cropImage
    }
}

func > (left:CGSize , rigth:CGSize) -> Bool
{
    return left.width > rigth.width && left.height > rigth.height
}


class Triangle:SKNode
{
    init(point:[CGPoint]) {
        points = point
        super.init()
    // 座標から三角形のSKShapeNodeを生成.
    let Triangle = SKShapeNode(points: UnsafeMutablePointer(points), count: points.count)
    
    // 塗りつぶしの色を赤色に指定.
    Triangle.fillColor = UIColor.brown
    Triangle.alpha = 0.3
    self.addChild(Triangle)
    }
    var points:[CGPoint]
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
/*
func getCentorRadius(p:[CGPoint])
{
    let x1 = p[0].x;
    let y1 = p[0].y;
    let x2 = p[1].x;
    let y2 = p[1].y;
    let x3 = p[2].x;
    let y3 = p[3].y;
    
    let c = 2.0 * ((x2 - x1) * (y3 - y1) - (y2 - y1) * (x3 - x1));
    let x = ((y3 - y1) * (x2 * x2 - x1 * x1 + y2 * y2 - y1 * y1)
        + (y1 - y2) * (x3 * x3 - x1 * x1 + y3 * y3 - y1 * y1))/c;
    let y = ((x1 - x3) * (x2 * x2 - x1 * x1 + y2 * y2 - y1 * y1)
        + (x2 - x1) * (x3 * x3 - x1 * x1 + y3 * y3 - y1 * y1))/c;
    Point center = new Point(x, y);
    
    // 外接円の半径 r は、半径から三角形の任意の頂点までの距離に等しい
    float r = Point.dist(center, t.p1);
}*/
class circle : SKNode
{
    init(centor:CGPoint , radius:CGFloat) {
        Centor = centor
        Radius = radius
        super.init()
        let circle = SKShapeNode(circleOfRadius: radius)
        self.addChild(circle)
        self.position = centor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var Centor:CGPoint
    var Radius:CGFloat
}
