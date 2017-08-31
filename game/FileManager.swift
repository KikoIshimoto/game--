//
//  FileManager.swift
//  game
//
//  Created by IshimotoKiko on 2016/03/31.
//  Copyright © 2016年 IshimotoKiko. All rights reserved.
//

import SpriteKit
struct EnemyGroupStruct
{
    let EnemyIDs:[Int]
    let EnemyInterval:[Double]?
    let position:[Double]
    let enemyActionIDs:[Int]
}
struct EnemyWaveStruct
{
    let EnemyGroups:[EnemyGroupStruct]
    let AppaerTime:[Double]
}
class FileManager {
    class func initDataRead()
    {
        let defaults = UserDefaults.standard
        defaults.register(
            defaults: [
                "WeaponItem": [["ID":0,"Skill":[0]],["ID":1,"Skill":[0]]],
                "Player" :[
                    "HaveItemCount":0,
                    "LV":1,
                    "HP":300,
                    "Power":10,
                    "Diffence":0,
                    "Equipments":[1,0,0,0]
                ]
            ]
        )
        
    }
    class func ButtleDictionaryGet() -> NSDictionary
    {
        let directory = NSSearchPathForDirectoriesInDomains(
            .libraryDirectory,
            .userDomainMask, true)[0]
        let path = directory + "/" + "EnemyGroup.plist"
        
        
        // rootがDictionaryなのでNSDictionaryに取り込み
        let dict = NSDictionary(contentsOfFile: path)
        return dict!
    }
    class func PlayerEquipmentsRead() -> NSArray
    {
        
        let userDefault = UserDefaults.standard
        let userDefaultGet = userDefault.dictionary(forKey: "Player")
        let PlayerP:NSArray = userDefaultGet!["Equipments"] as! NSArray
        return PlayerP
        
    }
    class func PlayerEquipmentsWrite(_ weaponID:Int , equipNumber:Int)
    {
        
        let userDefault = UserDefaults.standard
        var userDefaultGet = userDefault.dictionary(forKey: "Player")
        
        var PlayerP = userDefaultGet!["Equipments"] as! [Int]
        PlayerP[equipNumber] = weaponID
        userDefaultGet!["Equipments"] = PlayerP
                print(userDefaultGet)
        userDefault.set(userDefaultGet, forKey: "Player")
        
    }
    class func readPlayerStatus() -> PCParameters
    {
        let path = Bundle.main.path(forResource: "Player", ofType: "plist")
        let dict = NSMutableDictionary(contentsOfFile: path!)
        
        let p = PCParameters(Name: "Player",
                             HP: dict!["HP"] as! Double,
                             Power: dict!["Power"] as! Double,
                             Diffence: dict!["Diffence"] as! Double,
                             WeaponEquip: dict!["Equipments"] as! [Int])
        return p
    }
    class func readWeaponStatus(_ i:Int)// -> weaponParameters
    {
        let p = weaponParameters(Name: "weapon" + String(i) , ID: i , power: Double(i * 10))
        var paramate:Dictionary<String,AnyObject> =
            [
                "weaponID" + String(p.WeaponID):
                    [
                        "Name":p.weaponName!,
                        "Power":p.Power,
                        "FireRate":p.Time
                ]
        ]
        let userDefault = UserDefaults.standard
        userDefault.set(paramate, forKey: "Weapon")
        let registar = UserDefaults.register(defaults: userDefault)
        userDefault.synchronize()
        var userDefaultGet = userDefault.dictionary(forKey: "Weapon")
        print(userDefaultGet)
        
    }
    class func weaponItemRead() -> [AnyObject]
    {
        let userDefault = UserDefaults.standard
        let userDefaultGet = userDefault.array(forKey: "WeaponItem")
        print(userDefaultGet)
        return userDefaultGet! as [AnyObject]
    }
    class func weaponItemSet(_ ID:Int,Skill:[Int])
    {
        let defaults = UserDefaults.standard
        //defaults.registerDefaults(["WeaponItem": [["ID":ID,"Skill":Skill]]])
        
        var data = defaults.array(forKey: "WeaponItem")
        if data != nil
        {
            data?.append(["ID":ID,"Skill":Skill])
        }
        else
        {
            data? = [["ID":ID,"Skill":Skill]]
        }
        defaults.set(data, forKey: "WeaponItem")
        defaults.synchronize()
        let get = UserDefaults.standard
        
        
        
    }
    class func weaponItemRemove()
    {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "WeaponItem")
    }
    class func removeAll()
    {
        let userDefault = UserDefaults.standard
        var appDomain:String = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
    }
    class func weaponParamateRead(_ ID:Int) -> weaponParameters {
        /*        // プロパティファイルをバインド
         let directory = NSSearchPathForDirectoriesInDomains(
         .LibraryDirectory,
         .UserDomainMask, true)[0]
         let path = directory + "/" + "weapon.plist"
         */
        let path = Bundle.main.path(forResource: "Weapons", ofType: "plist")
        
        
        // rootがDictionaryなのでNSDictionaryに取り込み
        let dict = NSDictionary(contentsOfFile: path!)
        
        let weaponP:NSDictionary = dict!.object(forKey: "WeaponID" + String(ID)) as! NSDictionary
        
        
        let p = weaponParameters(Name: weaponP["Name"]! as! String,
                                 typeIDName: weaponP["TypeName"]! as! String,
                                 typeID: weaponP["TypeID"]! as! Int,
                                 ID: weaponP["WeaponID"] as! Int,
                                 power: weaponP["Power"] as! Double,
                                 time: weaponP["Time"] as! Double,
                                 firerate : weaponP["FireRate"] as! Double,
                                 Speed : weaponP["Speed"] as! Double,
                                 group : weaponP["Group"] as! [String:AnyObject],
                                 sequence : weaponP["Sequence"] as! [String:AnyObject]
        )
        //print(p)
        return p
    }
    class func enemyParamateRead(_ ID:Int) -> PCParameters {
        /*        // プロパティファイルをバインド
         let directory = NSSearchPathForDirectoriesInDomains(
         .LibraryDirectory,
         .UserDomainMask, true)[0]
         let path = directory + "/" + "weapon.plist"
         */
        let path = Bundle.main.path(forResource: "Enemys", ofType: "plist")
        
        
        // rootがDictionaryなのでNSDictionaryに取り込み
        let dict = NSDictionary(contentsOfFile: path!)
        
        let weaponP:NSDictionary = dict!.object(forKey: "Enemy" + String(ID)) as! NSDictionary
        
        
        let p = PCParameters(Name: weaponP["EnemyName"]! as! String,
                             HP: weaponP["HP"]! as! Double,
                             Power: weaponP["Power"] as! Double,
                             Diffence: weaponP["Diffence"] as! Double,
                             WeaponEquip: weaponP["Equipments"] as! [Int]
        )
        //print(p)
        return p
    }
    class func enemyWaveRead(_ ID:Int) -> EnemyWaveStruct
    {
        let path = Bundle.main.path(forResource: "EnemyWave", ofType: "plist")
        
        
        // rootがDictionaryなのでNSDictionaryに取り込み
        let dict = NSDictionary(contentsOfFile: path!)
        
        let Wave:NSDictionary = dict!.object(forKey: "Wave" + String(ID)) as! NSDictionary
        
        var GroupStructs:[EnemyGroupStruct] = []
        for count in Wave["Groups"] as! [Int]
        {
            GroupStructs.append(enemyGroupRead(count))
        }
        
        let p = EnemyWaveStruct(EnemyGroups: GroupStructs, AppaerTime: Wave["AppaerTime"] as! [Double])
        print(p)
        return p
    }
    
    class func enemyGroupRead(_ ID:Int) -> EnemyGroupStruct
    {
        let path = Bundle.main.path(forResource: "EnemyGroup", ofType: "plist")
        // rootがDictionaryなのでNSDictionaryに取り込み
        let dict = NSDictionary(contentsOfFile: path!)
        
        let Group:NSDictionary = dict!.object(forKey: "EnemyGroup" + String(ID)) as! NSDictionary
        
        let p = EnemyGroupStruct(
                                 EnemyIDs: Group["Enemy"] as! [Int],
                                 EnemyInterval: ((Group["EnemyInterval"] as? [Double]) != nil) ? Group["EnemyInterval"] as! [Double] : nil,
                                 position: Group["Position"] as! [Double],
                                 enemyActionIDs: Group["EnemyAction"] as! [Int])
        return p
    }

    
    class func getWeaponExplanatory(_ ID:Int) -> String
    {
        
        let path = Bundle.main.path(forResource: "Weapons", ofType: "plist")
        
        
        // rootがDictionaryなのでNSDictionaryに取り込み
        let dict = NSDictionary(contentsOfFile: path!)
        
        // キー"AAA"の中身はarrayなのでNSArrayで取得
        let weaponP:NSArray = dict!.object(forKey: "WeaponExplanatory") as! NSArray
        //dec.writeToFile(path, atomically: true)
        
        return weaponP[ID] as! String
    }
    func createFalderOnLiblary(_ folderName:String)
    {
        let directory = NSSearchPathForDirectoriesInDomains(
            .libraryDirectory,
            .userDomainMask, true)[0]
        let createPath = directory + "/" + folderName
        do {
            try Foundation.FileManager.default.createDirectory(atPath: createPath, withIntermediateDirectories: true, attributes: nil)
            
            print(createPath + "のフォルダを作れました")
        } catch {
            print(createPath + "のフォルダを作れませんでした")
            // Faild to wite folder
        }
    }
    func createFileOnLiblaryByArchiver(_ fileName:String , Data:Bullet)
    {
        let directory = NSSearchPathForDirectoriesInDomains(
            .libraryDirectory,
            .userDomainMask, true)[0]
        let createPath = directory + "/" + fileName
        
        let successful = NSKeyedArchiver.archiveRootObject(Data , toFile:createPath);
        if(successful)
        {
            print(createPath + "にファイルに書き込みました")
        }
        else
        {
            
            print(createPath + "にファイルに書き込めませんでした")
        }
    }
    func deleteFileOnLiblary(_ fileName:String)
    {
        let directory = NSSearchPathForDirectoriesInDomains(
            .libraryDirectory,
            .userDomainMask, true)[0]
        let createPath = directory + "/" + fileName
        
        do{
            try
                Foundation.FileManager.default.removeItem(atPath: createPath)
            print(createPath + "を削除しました")
        }catch{
            print(createPath + "を削除できませんでした")
        }
    }
    
}
