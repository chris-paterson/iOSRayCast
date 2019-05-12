//
//  Ray.swift
//  RayCast2D
//
//  Created by Christopher Paterson on 2019-05-11.
//  Copyright © 2019 Christopher Paterson. All rights reserved.
//

import UIKit

struct Ray {
    let position: CGPoint
    
    private var length = UIScreen.main.bounds.height // Ensure the ray fill the screen.
    var angleInRadians: CGFloat
    
    init(position: CGPoint, angleInDegrees: CGFloat) {
        self.position = position
        self.angleInRadians = angleInDegrees * .pi / 180
    }
}

extension Ray {
    mutating func draw(toPoint p: CGPoint, on ctx: CGContext) {
        length = position.distance(toPoint: p)
        draw(on: ctx)
    }
    
    func draw(on ctx: CGContext) {
        ctx.setLineWidth(0.5)
        ctx.setStrokeColor(UIColor.white.cgColor)
        ctx.move(to: position)
        ctx.addLine(to: CGPoint(x: position.x + sin(angleInRadians) * length,
                                y: position.y + cos(angleInRadians) * length))
        ctx.strokePath()
    }
    
    func cast(at line: Line) -> CGPoint? {
        let x1 = line.x1
        let y1 = line.y1
        let x2 = line.x2
        let y2 = line.y2
        
        let x3 = position.x
        let y3 = position.y
        let x4 = position.x + sin(angleInRadians) * length
        let y4 = position.y + cos(angleInRadians) * length
        
        let denom = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
        if denom == 0 { // Parallel so will never intersect.
            return nil
        }
        
        let t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / denom
        let u = -((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)) / denom
        
        guard (t > 0) && (t < 1) && (u > 0) else { return nil }
        
        return CGPoint(x: x1 + t * (x2 - x1),
                       y: y1 + t * (y2 - y1))
    }
}
