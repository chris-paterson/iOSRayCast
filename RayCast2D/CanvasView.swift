//
//  CanvasView.swift
//  RayCast2D
//
//  Created by Christopher Paterson on 2019-05-11.
//  Copyright © 2019 Christopher Paterson. All rights reserved.
//

import UIKit

struct Line {
    let x1: CGFloat
    let y1: CGFloat
    let x2: CGFloat
    let y2: CGFloat
    
    func draw(on ctx: CGContext) {
        ctx.setLineWidth(2.0)
        ctx.setStrokeColor(UIColor.red.cgColor)
        ctx.move(to: CGPoint(x: x1, y: y1))
        ctx.addLine(to: CGPoint(x: x2, y: y2))
        ctx.strokePath()
    }
}

struct Point {
    let x: CGFloat
    let y: CGFloat
    let radius: CGFloat = 8
    
    var cgPoint: CGPoint {
        get {
            return CGPoint(x: x, y: y)
        }
    }
    
    func draw(on ctx: CGContext) {
        UIColor.white.setFill()
        ctx.fillEllipse(in: CGRect(x: x - radius / 2, y: y - radius / 2, width: radius, height: radius))
    }
}

struct Ray {
    let position: CGPoint
    
    private var length = UIScreen.main.bounds.height // Ensure the ray fill the screen.
    private var angleInRadians: CGFloat
    
    init(position: CGPoint, angleInDegrees: CGFloat) {
        self.position = position
        self.angleInRadians = angleInDegrees * .pi / 180
    }
    
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
        let x4 = position.x + sin(angleInRadians) * length // May be
        let y4 = position.y + cos(angleInRadians) * length // May be
        
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

class CanvasView: UIImageView {
    var point: Point? {
        didSet {
            draw(self.frame)
        }
    }
    
    var walls = [Line]() {
        didSet {
            draw(self.frame)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
    }
    
    override func draw(_ rect: CGRect) {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: frame.width, height: frame.height))
        let img = renderer.image { ctx in
            let cgContext = ctx.cgContext
            
            // Lines
            for w in self.walls {
                w.draw(on: cgContext)
            }
            
            // Point
            if let p = point {
                p.draw(on: cgContext)
                
                // Rays
                for i in 0..<360 {
                    var ray = Ray(position: p.cgPoint, angleInDegrees: CGFloat(i))
                    var closest = CGPoint(x: UIScreen.main.bounds.width*2, y: UIScreen.main.bounds.height*2) // inifinity for all intents and purposes.
                    var furthest = CGFloat.infinity
                    
                    for w in self.walls {
                        guard let pt = ray.cast(at: w),
                            let origin = point?.cgPoint
                            else { continue }
                        
                        let dist = origin.distance(toPoint: pt)
                        if dist < furthest {
                            furthest = dist
                            closest = pt
                        }
                    }
                    
                    ray.draw(toPoint: closest, on: cgContext)
                }
            }
        }
        
        self.image = img
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CGPoint {
    func distance(toPoint p: CGPoint) -> CGFloat {
        return sqrt(pow(x - p.x, 2) + pow(y - p.y, 2))
    }
}
