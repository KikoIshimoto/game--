//
//  StringMyself.swift
//  game
//
//  Created by IshimotoKiko on 2016/03/25.
//  Copyright © 2016年 IshimotoKiko. All rights reserved.
//

import SpriteKit

extension CGSize
{
    mutating func covert()
    {
        width = width / globalData.size.width * globalData.gameSize.width
        
        height = height / globalData.size.height * globalData.gameSize.height

    }
}
func CGGameSize(_ width:CGFloat,_ height:CGFloat) -> CGSize {
    let widthA = width / globalData.size.width * globalData.gameSize.width
    
    let heightA = height / globalData.size.height * globalData.gameSize.height
    
    return CGSize(width: widthA, height: heightA)
}
func CGGamePoint(_ x:CGFloat,_ y:CGFloat) -> CGPoint {
    let xA = x / globalData.size.width * globalData.gameSize.width
    
    let yA = y / globalData.size.height * globalData.gameSize.height
    
    return CGPoint(x: xA, y: yA)
}
func CGGameRect(_ x:CGFloat, _ y:CGFloat ,_ width:CGFloat ,_ height:CGFloat) -> CGRect
{
    let size = CGGameSize(width, height)
    let point = CGGamePoint(x, y)
    return CGRect(x: point.x, y: point.y, width: size.width, height: size.height)
}
func CGGameVector(_ x:CGFloat,_ y:CGFloat) -> CGVector
{
    
    let xA = x / globalData.size.width * globalData.gameSize.width
    
    let yA = y / globalData.size.height * globalData.gameSize.height
    
    return CGVector(dx: xA, dy: yA)
}
func CGGameSquareX(_ width:CGFloat) -> CGSize
{
    let x = width / globalData.size.width * globalData.gameSize.width
    return CGSize(width: x, height: x)
}
func CGGameSquareY(_ height:CGFloat) -> CGSize
{
    let x = height / globalData.size.height * globalData.gameSize.height
    return CGSize(width: x, height: x)
}
func CGPitagoras(_ Power : CGFloat) -> CGFloat
{
    return Power / CGFloat( sqrt(Double(globalData.size.width * globalData.size.width + globalData.size.height * globalData.size.height))) *
        CGFloat(sqrt(Double(globalData.gameSize.width * globalData.gameSize.width + globalData.gameSize.height * globalData.gameSize.height)))
    
}
func CGCos(_ ang:Double) -> CGFloat
{
    return CGFloat(cos(ang))
}
func CGSin(_ ang:Double) -> CGFloat
{
    return CGFloat(sin(ang))
}
