//
//  Restaurant.swift
//  Assignment8
//
//  Created by Kaiya Takahashi on 2022-05-28.
//

import Foundation
import UIKit

struct Restaurant: Hashable {
    
    let country: Country
    let name: String
    let description: String
    let price: String
    let image: UIImage
    
    enum Country {
        case japan, china, korea, indian, british, french, italian, spanish, american, mexican
    }
    
    static func scaleImageToSize(_ img: UIImage, _ size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        img.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()!
        return scaledImage
    }
    
}
