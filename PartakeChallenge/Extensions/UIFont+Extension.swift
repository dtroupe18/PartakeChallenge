//
//  UIFont+Extension.swift
//  PartakeChallenge
//
//  Created by Dave on 10/21/18.
//  Copyright © 2018 High Tree Development. All rights reserved.
//

import UIKit

fileprivate enum FontName: String {
    case light = "Roboto-Light"
    case medium = "Roboto-Medium"
}

extension UIFont {
    
    private static func customFont(name: String, size: CGFloat) -> UIFont {
        let font = UIFont(name: name, size: size)
        assert(font != nil, "Can't load font: \(name)")
        return font ?? UIFont.systemFont(ofSize: size)
    }
    
    static func medium(withSize size: CGFloat) -> UIFont {
        return customFont(name: FontName.medium.rawValue, size: size)
    }
    
    static func light(withSize size: CGFloat) -> UIFont {
        return customFont(name: FontName.light.rawValue, size: size)
    }
}
