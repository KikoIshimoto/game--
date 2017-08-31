//
//  GameViewController.swift
//  game
//
//  Created by IshimotoKiko on 2016/01/11.
//  Copyright (c) 2016年 IshimotoKiko. All rights reserved.
//

import UIKit
import SpriteKit

struct globalData
{
    static var size:CGSize = CGSize(width: 360, height: 640)
    static var gameSize:CGSize = CGSize(width: 360,height: 640)
}
class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = self.view as? SKView
        skView?.showsFPS = true
        skView?.showsNodeCount = true
        globalData.gameSize = self.view.bounds.size
        //let scean = test(size: CGSizeMake(360 * 10,640 * 10))
        let scean = CharactorSettingSelectSean(item: 1)
        scean.scaleMode = SKSceneScaleMode.aspectFit
        skView?.presentScene(scean)
        
    }


    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
}
