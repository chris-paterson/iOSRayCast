//
//  Simple.swift
//  RayCast2D
//
//  Created by Christopher Paterson on 2019-05-12.
//  Copyright © 2019 Christopher Paterson. All rights reserved.
//

class SimpleMap {
    static func walls() -> [Line] {
//        let width = UIScreen.main.bounds.width
//        let height = UIScreen.main.bounds.height
        
        return [
            Line(x1: 64, y1: 64, x2: 64, y2: 256), // left
            Line(x1: 64, y1: 64, x2: 256, y2: 64), // top
            Line(x1: 64, y1: 256, x2: 128, y2: 256), // bottom left
            Line(x1: 192, y1: 256, x2: 256, y2: 256), // bottom right
            Line(x1: 256, y1: 64, x2: 256, y2: 256), // right
        ]
    }
}
