//
//  FirstPersonView.swift
//  RayCast2D
//
//  Created by Christopher Paterson on 2019-05-11.
//  Copyright © 2019 Christopher Paterson. All rights reserved.
//

import UIKit

class FirstPersonView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        isUserInteractionEnabled = true
        
        draw(self.frame)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesMoved(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchPoint = touch.location(in: self)
        
        if (touchPoint.x > 0) && (touchPoint.x < frame.width) && (touchPoint.y > 0) && (touchPoint.y < frame.height) {
            print(touchPoint)
        }
    }
    
    override func draw(_ rect: CGRect) {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: frame.width, height: frame.height))
        let img = renderer.image { ctx in
            let lineWidth = frame.width / CGFloat(World.fieldOfView)
            ctx.cgContext.setLineWidth(lineWidth)
            
            for i in 0..<World.fieldOfView {
                ctx.cgContext.setStrokeColor(UIColor.random().cgColor)
                ctx.cgContext.move(to: CGPoint(x: CGFloat(i) * lineWidth, y: 0))
                ctx.cgContext.addLine(to: CGPoint(x: CGFloat(i) * lineWidth, y: frame.height))
                ctx.cgContext.strokePath()
            }
        }
        
        self.image = img
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red: .random(),
                       green: .random(),
                       blue: .random(),
                       alpha: 1.0)
    }
}
