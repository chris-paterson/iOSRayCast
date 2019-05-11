//
//  Point.swift
//  RayCast2D
//
//  Created by Christopher Paterson on 2019-05-11.
//  Copyright © 2019 Christopher Paterson. All rights reserved.
//

import UIKit

struct Point {
    let x: CGFloat
    let y: CGFloat
    let radius: CGFloat = 8
    
    var cgPoint: CGPoint {
        get {
            return CGPoint(x: x, y: y)
        }
    }
}

extension Point {
    func draw(on ctx: CGContext) {
        ctx.setFillColor(UIColor.magenta.cgColor)
        ctx.fillEllipse(in: CGRect(x: x - radius / 2, y: y - radius / 2, width: radius, height: radius))
        ctx.strokePath()
    }
}
