//
//  Size.swift
//  Core
//
//  Created by Ismatillokhon on 5/6/24.
//

import SwiftUI

public extension View {
    @inlinable func setSize(_ size: CGFloat) -> some View {
        return self.frame(width: size, height: size)
    }
}
