//
//  Player.swift
//  RayCast2D
//
//  Created by Christopher Paterson on 2019-05-11.
//  Copyright © 2019 Christopher Paterson. All rights reserved.
//

import UIKit

struct Player {
    let x: CGFloat
    let y: CGFloat
    let rays: [Ray]
    let radius: CGFloat = 8
    let orientationDeg: Int
    
    var cgPoint: CGPoint {
        get {
            return CGPoint(x: x, y: y)
        }
    }
    
    init(x: CGFloat, y: CGFloat, orientationDeg: Int) {
        self.x = x
        self.y = y
        self.orientationDeg = orientationDeg
        
        let start = orientationDeg + (-World.fieldOfView / 2)
        let end = orientationDeg + (World.fieldOfView / 2)
        self.rays = (start..<end).map { i in
            return Ray(position: CGPoint(x: x, y: y), angleInDegrees: CGFloat(i))
        }
    }
}

extension Player {
    func draw(on ctx: CGContext) {
        ctx.setFillColor(UIColor.magenta.cgColor)
        ctx.fillEllipse(in: CGRect(x: x - radius / 2, y: y - radius / 2, width: radius, height: radius))
        ctx.strokePath()
    }
    
    func lookAt(walls: [Line], context: CGContext?) -> [CGFloat] {
        let scene = rays.map { r -> CGFloat in
            var ray = r
            var closestWall = CGPoint(x: UIScreen.main.bounds.width*2, y: UIScreen.main.bounds.height*2) // inifinity for all intents and purposes.
            var record = CGFloat.infinity
            
            for w in walls {
                guard let pt = ray.cast(at: w) else { continue }
                
                let dist = cgPoint.distance(toPoint: pt)
                if dist < record {
                    record = dist
                    closestWall = pt
                }
            }
            if let c = context {
                ray.draw(toPoint: closestWall, on: c)
            }
            return record
        }
        
        return scene
    }
}
