//
//  CanvasView.swift
//  RayCast2D
//
//  Created by Christopher Paterson on 2019-05-11.
//  Copyright © 2019 Christopher Paterson. All rights reserved.
//

import UIKit

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
