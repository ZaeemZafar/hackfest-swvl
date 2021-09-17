//
//  UIImageExtension.swift
//  Hackfest-swvl
//
//  Created by ZaeemZafar on 23/05/2018.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import Foundation

extension UIImage {
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: (width * 3), height: CGFloat(ceil((width * 3)/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func printSize() {
        print("Origional size of image \((UIImagePNGRepresentation(self)?.count ?? 0) / 1000) KB")
    }
}
