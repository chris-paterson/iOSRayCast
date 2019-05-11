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
    let angleInDegrees: CGFloat
    
    private let length = UIScreen.main.bounds.height // Ensure the ray fill the screen.
    private var angleInRadians: CGFloat {
        get {
            return angleInDegrees * .pi / 180
        }
    }

    func draw(on ctx: CGContext) {
        ctx.setLineWidth(0.5)
        ctx.setStrokeColor(UIColor.white.cgColor)
        ctx.move(to: position)
        ctx.addLine(to: CGPoint(x: position.x + sin(angleInRadians) * length,
                                y: position.y + cos(angleInRadians) * length))
        ctx.strokePath()
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
            for l in self.walls {
                l.draw(on: cgContext)
            }
            
            // Point
            if let p = point {
                p.draw(on: cgContext)
                
                // Rays
                for i in 0..<360 {
                    let ray = Ray(position: p.cgPoint, angleInDegrees: CGFloat(i))
                    ray.draw(on: cgContext)
                }
            }
        }
        
        self.image = img
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
