//
//  UIImage+Extension.swift
//  PartakeChallenge
//
//  Created by Dave on 10/21/18.
//  Copyright © 2018 High Tree Development. All rights reserved.
//

import UIKit

extension UIImage {
    
    func scaleImage(toSize size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
//    func imageWithImage(scaledToMaxWidth: CGFloat, scaledToMaxHeight: CGFloat) {
//        let oldWidth = self.size.width
//        let oldHeight = self.size.height
//        
//        let scaleFactor = (oldWidth > oldHeight) ? wi
//    }
//    
//    
//    
//    + (UIImage *)imageWithImage:(UIImage *)image scaledToMaxWidth:(CGFloat)width maxHeight:(CGFloat)height {
//    CGFloat oldWidth = image.size.width;
//    CGFloat oldHeight = image.size.height;
//    
//    CGFloat scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;
//    
//    CGFloat newHeight = oldHeight * scaleFactor;
//    CGFloat newWidth = oldWidth * scaleFactor;
//    CGSize newSize = CGSizeMake(newWidth, newHeight);
//    
//    return [ImageUtilities imageWithImage:image scaledToSize:newSize];
//    }
    
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    public func resize(height: CGFloat) -> UIImage? {
        let scale = height / self.size.height
        let width = self.size.width * scale
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        self.draw(in: CGRect(x:0, y:0, width:width, height:height))
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage
    }
    
    func resize(width: CGFloat) -> UIImage {
        let oldWidth = self.size.width
        let scaleFactor = width / oldWidth
        
        let newHeight = self.size.height * scaleFactor
        let newWidth = oldWidth * scaleFactor
        
        UIGraphicsBeginImageContext(CGSize(width:newWidth, height:newHeight))
        self.draw(in: CGRect(x:0, y:0, width:newWidth, height:newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
