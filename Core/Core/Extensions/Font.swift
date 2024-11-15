//
//  Font.swift
//  Core
//
//  Created by Ismatillokhon on 5/6/24.
//

import SwiftUI

public extension Font {
    static func sabFont(_ weight: Int, size: CGFloat) -> Font {
        switch weight {
        case 400: return Font.system(size: size, weight: .regular)
        case 500: return Font.system(size: size, weight: .medium)
        case 600: return Font.system(size: size, weight: .bold)
        case 700: return Font.system(size: size, weight: .semibold)
            
        default: return Font.system(size: size, weight: .regular)
        }
    }
}
