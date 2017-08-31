//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

class weapon
{
    init(a:Int = 20)
    {
        print("weapon")
        print(a)
    }
    convenience init()
    {
        print("convinience")
        self.init(a:10)
    }
    convenience init(a:Int,b:Int)
    {
        print("convinience")
        self.init(a:a + b)
    }
    func attack()
    {
        fatalError("error")
    }
    var ID = 0
    let Type = 0
    let LV = 0
    var Name:String = ""
    var Power = 0
    let FireRate = 0
    let EXP = 0
    let EXPType = 0
}

class cannon : weapon
{
    override init(a:Int)
    {
        super.init(a: a)
        
        print("cannon")
    }
    convenience init()
    {
        self.init(a:30)
        print("convinience")
    }
    override func attack() {
        print("cannon")
    }
    
    func cannon()
    {
        print("bcannon")
    }
}
class beamClass: cannon {
    override init(a:Int)
    {
        super.init(a:a)
        
        print("beam")
    }

    
    override func attack() {
        super.attack()
        print("beam")
    }
    func beam()
    {
        print("beam")
    }
}
let w1 = weapon(a: 10, b: 10)
let w = cannon()
let w2 = beamClass()


let enemy =
[
    "player":"Name",
    "HP":10
]
let enemys =
[
    0 : enemy,
    1 : enemy
]

//print(enemys[0]!["player"]!)

func yomikomi1() {
    // プロパティファイルをバインド
    let path = NSBundle.mainBundle().pathForResource("Property List", ofType: "plist")
    
    // rootがDictionaryなのでNSDictionaryに取り込み
    let dict = NSDictionary(contentsOfFile: path!)
    
    // キー"AAA"の中身はarrayなのでNSArrayで取得
    let arr:NSArray = dict!.objectForKey("AAA") as! NSArray
    
    // arrayで取れた分だけループ
    for value in arr {
        // またNSDictionaryなので、キーを指定してデータを取得
        let i:Int = value.objectForKey("data1") as! Int
        let j:Int = value.objectForKey("data2") as! Int
        print("\(i) + \(j) = \(i + j)")
        
    }
}
var arr:NSArray = [0,5]
//arr.setValue(0, forKey: "pla")

print("3" + String(arr))
//yomikomi1()

