//
//  ViewController.swift
//  RayCast2D
//
//  Created by Christopher Paterson on 2019-05-11.
//  Copyright © 2019 Christopher Paterson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.location(in: view)
        drawCircle(atPoint: point)
    }
    
    fileprivate func drawCircle(atPoint: CGPoint) {
        self.view.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let circlePath = UIBezierPath(arcCenter: atPoint, radius: CGFloat(8), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 3.0
        
        view.layer.addSublayer(shapeLayer)
    }
}

