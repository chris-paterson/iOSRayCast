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
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.location(in: view)
        canvasView.point = point
    }
}

