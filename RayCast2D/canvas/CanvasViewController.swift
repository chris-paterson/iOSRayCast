//
//  CanvasViewController.swift
//  RayCast2D
//
//  Created by Christopher Paterson on 2019-05-11.
//  Copyright © 2019 Christopher Paterson. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {
    var canvasView: CanvasView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white // Need to set or touchesBegan won't work.
        
        canvasView = CanvasView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height / 2, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2))
        self.view.addSubview(canvasView)
        
        drawLines()
    }
    
    
    
    func drawLines() {
        canvasView.walls = (0..<6).map { _ in
            let x1 = CGFloat.random(in: 0..<canvasView.frame.width)
            let x2 = CGFloat.random(in: 0..<canvasView.frame.width)
            let y1 = CGFloat.random(in: 0..<canvasView.frame.height)
            let y2 = CGFloat.random(in: 0..<canvasView.frame.height)
            return Line(x1: x1, y1: y1, x2: x2, y2: y2)
        }
    }
}

