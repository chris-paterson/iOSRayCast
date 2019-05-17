//
//  CanvasView.swift
//  RayCast2D
//
//  Created by Christopher Paterson on 2019-05-11.
//  Copyright © 2019 Christopher Paterson. All rights reserved.
//

import UIKit

protocol CanvasViewDelegate {
    func didGetNew(scene: [CGFloat])
}

class CanvasView: UIImageView {
    var delegate: CanvasViewDelegate?
    var player: Player? {
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
        isUserInteractionEnabled = true
        isMultipleTouchEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesMoved(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count == 1 {
            guard let touch = touches.first else { return }
            let touchPoint = touch.location(in: self)
            
            if (touchPoint.x > 0) && (touchPoint.x < frame.width) && (touchPoint.y > 0) && (touchPoint.y < frame.height) {
                player = Player(x: touchPoint.x, y: touchPoint.y, orientationDeg: player?.orientationDeg ?? 0)
            }
        }
    }
    
    func didUpdatePlayer(withDegreeRotation rotation: CGFloat) {
        guard let p = player else { return }
        
        player = Player(x: p.x, y: p.y, orientationDeg: p.orientationDeg - Int(rotation))
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
            guard let p = player else { return }
            
            p.draw(on: cgContext)
            let scene = p.lookAt(walls: self.walls, context: cgContext)
            
            delegate?.didGetNew(scene: scene)
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
    
    func angle(to comparisonPoint: CGPoint) -> CGFloat {
        let originX = comparisonPoint.x - self.x
        let originY = comparisonPoint.y - self.y
        let bearingRadians = atan2f(Float(originY), Float(originX))
        var bearingDegrees = CGFloat(bearingRadians) * 180.0 / .pi
        while bearingDegrees < 0 {
            bearingDegrees += 360
        }
        return bearingDegrees
    }
}
