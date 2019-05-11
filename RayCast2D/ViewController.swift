//
//  ViewController.swift
//  RayCast2D
//
//  Created by Christopher Paterson on 2019-05-11.
//  Copyright © 2019 Christopher Paterson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var canvasView: CanvasView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white // Need to set or touchesBegan won't work.
        
        canvasView = CanvasView(frame: view.frame)
        self.view.addSubview(canvasView)
        
        drawLines()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.location(in: view)
        canvasView.point = Point(x: point.x, y: point.y)
    }
    
    func drawLines() {
        var localLines = [Line]()
        for _ in 0..<6 {
            let x1 = CGFloat.random(in: 0..<view.frame.width)
            let x2 = CGFloat.random(in: 0..<view.frame.width)
            let y1 = CGFloat.random(in: 0..<view.frame.height)
            let y2 = CGFloat.random(in: 0..<view.frame.height)
            localLines.append(Line(x1: x1, y1: y1, x2: x2, y2: y2))
        }
        
        canvasView.walls = localLines
    }
}

