//
//  FirstPersonView.swift
//  RayCast2D
//
//  Created by Christopher Paterson on 2019-05-11.
//  Copyright © 2019 Christopher Paterson. All rights reserved.
//

import UIKit

protocol FirstPersonViewDelegate {
    func didRotatePlayer(withDegreeRotation rotation: CGFloat)
}

class FirstPersonView: UIImageView {
    var delegate: FirstPersonViewDelegate?
    fileprivate var scene = [CGFloat]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        isUserInteractionEnabled = true
        
        draw(self.frame)
    }
    
    override func draw(_ rect: CGRect) {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: frame.width, height: frame.height))
        let img = renderer.image { ctx in
            let cgContext = ctx.cgContext
            let lineWidth = frame.width / CGFloat(scene.count)
            cgContext.setLineWidth(lineWidth)
            
            for (i, s) in scene.enumerated() {
                var whiteComponent: CGFloat = 0.0
                if s != .infinity {
                    whiteComponent = 1 - sqrt(s / frame.width)
                }
                
                let height = frame.height / min(s, frame.height) * CGFloat(World.fieldOfView / 2)
                
                let color = UIColor(white: whiteComponent, alpha: 1.0)
                
                let start = (frame.height / 2) - (height / 2)
                let end = (frame.height / 2) + (height / 2)
                
                // Ceilings
                cgContext.drawLine(from: CGPoint(x: CGFloat(i) * lineWidth, y: 0),
                                   to: CGPoint(x: CGFloat(i) * lineWidth, y: start),
                                   withColor: UIColor(red:0.17, green:0.24, blue:0.31, alpha:1.0).cgColor)
                // Floors
                cgContext.drawLine(from: CGPoint(x: CGFloat(i) * lineWidth, y: end),
                                   to: CGPoint(x: CGFloat(i) * lineWidth, y: frame.height),
                                   withColor: UIColor(red:0.58, green:0.65, blue:0.65, alpha:1.0).cgColor)
                
                // Walls
                cgContext.drawLine(from: CGPoint(x: CGFloat(i) * lineWidth, y: start),
                                   to: CGPoint(x: CGFloat(i) * lineWidth, y: end),
                                   withColor: color.cgColor)
            }
        }
        
        self.image = img
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let delegate = delegate,
            let touch = touches.first {
            let location = touch.location(in: self)
            let boundedLocation = (360 / UIScreen.main.bounds.width) * location.x
            
            let scaleFactor: CGFloat = 0.05
            let rotationAmount = ((UIScreen.main.bounds.width / 2) - boundedLocation) * scaleFactor
            delegate.didRotatePlayer(withDegreeRotation: rotationAmount)
        }
    }

    func update(_ scene: [CGFloat]) {
        self.scene = scene
        draw(frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CGContext {
    func drawLine(from start: CGPoint, to end: CGPoint, withColor color: CGColor) {
        setStrokeColor(color)
        move(to: start)
        addLine(to: end)
        strokePath()
    }
}
