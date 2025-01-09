//
//  Extension.swift
//  FoodDelivery
//
//  Created by PC1562 on 9/1/25.
//

import UIKit

struct Font {
    static func bold(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Sen-Bold", size: size)!
    }
    
    static func semiBold(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Sen-SemiBold", size: size)!
    }
    
    static func medium(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Sen-Medium", size: size)!
    }
    
    static func regular(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Sen-Regular", size: size)!
    }
    
    static func boldSystem(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .bold)
    }
    
    static func semiboldSystem(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .semibold)
    }
    
    static func mediumSystem(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .medium)
    }
    
    static func regularSystem(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .regular)
    }
}

extension NSAttributedString {
    convenience init(string: String, font: UIFont? = nil, textColor: UIColor = UIColor.black, paragraphAlignment: NSTextAlignment? = nil) {
        var attributes: [NSAttributedString.Key: AnyObject] = [:]
        if let font = font {
            attributes[NSAttributedString.Key.font] = font
        }
        attributes[NSAttributedString.Key.foregroundColor] = textColor
        if let paragraphAlignment = paragraphAlignment {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = paragraphAlignment
            attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        }
        self.init(string: string, attributes: attributes)
    }
}

extension UIColor {
    convenience init(rgb: UInt32) {
        self.init(red: CGFloat((rgb >> 16) & 0xff) / 255.0,
                  green: CGFloat((rgb >> 8) & 0xff) / 255.0,
                  blue: CGFloat(rgb & 0xff) / 255.0,
                  alpha: 1.0)
    }
    
    convenience init(rgb: UInt32, alpha: CGFloat) {
        self.init(red: CGFloat((rgb >> 16) & 0xff) / 255.0,
                  green: CGFloat((rgb >> 8) & 0xff) / 255.0,
                  blue: CGFloat(rgb & 0xff) / 255.0,
                  alpha: alpha)
    }
    
    convenience init(argb: UInt32) {
        self.init(red: CGFloat((argb >> 16) & 0xff) / 255.0,
                  green: CGFloat((argb >> 8) & 0xff) / 255.0,
                  blue: CGFloat(argb & 0xff) / 255.0,
                  alpha: CGFloat((argb >> 24) & 0xff) / 255.0)
    }
    
    convenience init?(hexString: String) {
        let scanner = Scanner(string: hexString)
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        var value: UInt32 = 0
        if scanner.scanHexInt32(&value) {
            if hexString.count > 7 {
                self.init(argb: value)
            } else {
                self.init(rgb: value)
            }
        } else {
            return nil
        }
    }
}
