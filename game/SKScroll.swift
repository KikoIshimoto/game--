//
//  SKScroll.swift
//  game
//
//  Created by IshimotoKiko on 2016/03/11.
//  Copyright © 2016年 IshimotoKiko. All rights reserved.
//

import SpriteKit
import UIKit

class SKScroll : ButtonGroup
{
    var rangeLeftX:CGFloat = 0
    var rangeRigthX:CGFloat = 0
    var rangeUpY:CGFloat = 0
    var rangeDownY:CGFloat = 0
    var xScrollFlag = false
    var yScrollFlag = true
    var xMax = false
    var xMin = false
    var yMax = false
    var yMin = false
    init(size:CGSize , range:CGSize, rangePoint:CGPoint,  backGround:String! = nil ,backGroundColor:UIColor = UIColor.clear)
    {
        
        rangeLeftX = -range.width / 2 + rangePoint.x
        rangeRigthX = range.width / 2 + rangePoint.x
        rangeDownY = -range.height / 2 + rangePoint.y
        rangeUpY = range.height / 2 + rangePoint.y
        super.init(size: size)
        self.position = rangePoint
        self.position.y = rangePoint.y - (size.height - range.height) / 2
        self.isUserInteractionEnabled = true
        self.name = "Scroll"
    }
    func setRange(_ range:CGSize )
    {
    }
    
    
    var prevTouchPoint = CGPoint(x: 0,y: 0)
    var TouchPoint = CGPoint(x: 0, y: 0)
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touchEvent = touches.first
        let location = touchEvent!.location(in: self.parent!)
        prevTouchPoint = location
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touchEvent = touches.first
        let location = touchEvent!.location(in: self.parent!)
        TouchPoint = location
        
        let xDelta =
        (xMax == true && TouchPoint.x - prevTouchPoint.x > 0) ? 0 : (xMin == true && TouchPoint.x - prevTouchPoint.x < 0) ? 0 : TouchPoint.x - prevTouchPoint.x
        let yDelta =
        (yMax == true && TouchPoint.y - prevTouchPoint.y > 0) ? 0 : (yMin == true && TouchPoint.y - prevTouchPoint.y < 0) ? 0 : TouchPoint.y - prevTouchPoint.y

        if(yScrollFlag == true)
        {
            
            let deltaPoint = CGPoint(x: xDelta, y: yDelta)
            self.position = CGPoint( x: self.position.x + (xScrollFlag == true ? deltaPoint.x : 0) , y: self.position.y + (yScrollFlag == true ? deltaPoint.y : 0))
            
            let LeftX:CGFloat = self.position.x - self.backGroundNode.size.width / 2
            let RigthX:CGFloat = self.position.x + self.backGroundNode.size.width / 2
            let UpY:CGFloat = self.position.y + self.backGroundNode.size.height / 2
            let DownY:CGFloat = self.position.y - self.backGroundNode.size.height / 2
            
            print(DownY)
            print(rangeDownY)
            if(DownY > rangeDownY)
            {
                
                self.position.y = self.position.y - (DownY - rangeDownY)
                yMin = true
            }
            else
            {
                yMin = false
            }
            if(UpY < rangeUpY)
            {
                
                self.position.y = self.position.y - (UpY - rangeUpY)
                yMax = true
            }
            else
            {
                yMax = false
            }
            if(RigthX > rangeRigthX)
            {
                
                self.position.y = self.position.y - (RigthX - rangeRigthX)
                xMax = true
            }
            else
            {
                
                xMax = false
            }
            if(LeftX < rangeLeftX)
            {
                
                self.position.y = self.position.y - (LeftX - rangeLeftX)
                xMin = true
            }
            else
            {
                
                xMin = false
            }
            /*
            self.runAction(SKAction.moveByX(
                xScrollFlag == true ? xDelta : 0,
                y: yScrollFlag == true ? yDelta: 0,
                duration: 0.1))*/
        }
        

        

        prevTouchPoint = location
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let LeftX:CGFloat = self.position.x - self.backGroundNode.size.width / 2
        let RigthX:CGFloat = self.position.x + self.backGroundNode.size.width / 2
        let UpY:CGFloat = self.position.y + self.backGroundNode.size.height / 2
        let DownY:CGFloat = self.position.y - self.backGroundNode.size.height / 2
        if(yScrollFlag == true)
        {
            if(DownY > rangeDownY)
            {
                self.position.y = self.position.y - (DownY - rangeDownY)
            }
            if(UpY < rangeUpY)
            {
                
                
                self.position.y = self.position.y - (UpY - rangeUpY)
            }
            if(RigthX > rangeRigthX)
            {
                
                self.position.y = self.position.y - (RigthX - rangeRigthX)
            }
            if(LeftX < rangeLeftX)
            {
                
                self.position.y = self.position.y - (LeftX - rangeLeftX)
            }

        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        let LeftX:CGFloat = self.position.x - self.backGroundNode.size.width / 2
        let RigthX:CGFloat = self.position.x + self.backGroundNode.size.width / 2
        let UpY:CGFloat = self.position.y + self.backGroundNode.size.height / 2
        let DownY:CGFloat = self.position.y - self.backGroundNode.size.height / 2
        if(yScrollFlag == true)
        {
            if(DownY > rangeDownY)
            {
                self.position.y = self.position.y - (DownY - rangeDownY)
            }
            if(UpY < rangeUpY)
            {
                self.position.y = self.position.y - (UpY - rangeUpY)
                
            }
            if(RigthX > rangeRigthX)
            {
                
                self.position.y = self.position.y - (RigthX - rangeRigthX)
            }
            if(LeftX < rangeLeftX)
            {
                
                self.position.y = self.position.y - (LeftX - rangeLeftX)
            }

        }
    }
    deinit
    {
        print("SKScroll Delete")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
