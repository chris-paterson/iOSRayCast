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
}

class CanvasView: UIImageView {
    let pointRadius: CGFloat = 16
    var point: CGPoint? {
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
            
            // Draw point.
            if let p = point {
                UIColor.white.setFill()
                ctx.cgContext.fillEllipse(in: CGRect(x: p.x - pointRadius / 2, y: p.y - pointRadius / 2, width: pointRadius, height: pointRadius))
            }
            
            
            // Lines
            for l in self.walls {
                ctx.cgContext.setLineWidth(2.0)
                ctx.cgContext.setStrokeColor(UIColor.red.cgColor)
                ctx.cgContext.move(to: CGPoint(x: l.x1, y: l.y1))
                ctx.cgContext.addLine(to: CGPoint(x: l.x2, y: l.y2))
                ctx.cgContext.strokePath()
            }
        }
        
        self.image = img
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
