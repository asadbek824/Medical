//
//  Int.swift
//  Core
//
//  Created by Ismatillokhon on 01/07/24.
//

import UIKit

public extension Int {
    func dpWidth(_ width: CGFloat = Metrics.designScreenWidth, needsLimit: Bool = true) -> CGFloat {
        return CGFloat(self).dpWidth(width, needsLimit: needsLimit)
    }

    func dpHeight(_ height: CGFloat = Metrics.designScreenHeight, needsLimit: Bool = true) -> CGFloat {
        return CGFloat(self).dpHeight(height, needsLimit: needsLimit)
    }
}

public extension CGFloat {
    func dpWidth(_ width: CGFloat = Metrics.designScreenWidth, needsLimit: Bool = true) -> CGFloat {
        let calculatedWidht = self / width * UIApplication.shared.screenSize.width
        return calculatedWidht.limitTop(needsLimit ? self : calculatedWidht).limitBottom(0)
    }

    func dpHeight(_ height: CGFloat = Metrics.designScreenHeight, needsLimit: Bool = true) -> CGFloat {
        let calculatedHeight = (self / height) * UIApplication.shared.screenSize.height
        return calculatedHeight.limitTop(needsLimit ? self : calculatedHeight).limitBottom(0)
    }
}

public enum Metrics {
    public static let designScreenWidth: CGFloat = 375
    public static let designScreenHeight: CGFloat = 812
}


public protocol NumberProtocol where Self: BinaryInteger {
    var cgFloat: CGFloat { get }
}

public protocol FloatProtocol where Self: BinaryFloatingPoint {
    var cgFloat: CGFloat { get }
}

extension NumberProtocol {
    public var cgFloat: CGFloat {
        CGFloat(self)
    }
}

extension FloatProtocol {
    public var cgFloat: CGFloat {
        CGFloat(self)
    }
}

extension Int: NumberProtocol {
    public var double: Double {
        Double(self)
    }
    
    /// Converts to String if number is less than 10 start it with 0
    public var twoDigitString: String {
        if self < 10 {
            return "0\(self)"
        }
        return "\(self)"
    }
}

extension Float: FloatProtocol {
    var double: Double {
        Double(self)
    }
}

extension Double: FloatProtocol {
}


public extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let value = Int(self * 100)
        return Double(value) / 100
    }
}

public extension Double {
    func limitTop(_ num: Double) -> Double {
        return (self > num) ? num : self
    }

    func limitBottom(_ num: Double) -> Double {
        return (self < num) ? num : self
    }

    func twoDecimals() -> Double {
        Double(Int(self * 100)) / 100
    }
}

public extension Int {
    func limitTop(_ num: Int) -> Int {
        return (self > num) ? num : self
    }

    func limitBottom(_ num: Int) -> Int {
        return (self < num) ? num : self
    }
}

public extension Int64 {
    func limitTop(_ num: Int64) -> Int64 {
        return (self > num) ? num : self
    }

    func limitBottom(_ num: Int64) -> Int64 {
        return (self < num) ? num : self
    }
}

public extension CGFloat {
    func limitTop(_ num: CGFloat) -> CGFloat {
        return (self > num) ? num : self
    }

    func limitBottom(_ num: CGFloat) -> CGFloat {
        return (self < num) ? num : self
    }
}

extension NumberFormatter {
    public static var money: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = ""
        formatter.currencySymbol = ""
        formatter.positiveSuffix = ""
        formatter.positivePrefix = ""
        formatter.negativeSuffix = ""
        formatter.negativePrefix = ""
        formatter.currencyDecimalSeparator = ","
        formatter.groupingSeparator = " "
        formatter.locale = .init(identifier: "uz_Latn")
        return formatter
    }

    public static var decimal: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.currencyCode = ""
        formatter.currencySymbol = ""
        formatter.positiveSuffix = ""
        formatter.positivePrefix = ""
        formatter.negativeSuffix = ""
        formatter.negativePrefix = ""
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = nil
        formatter.locale = .init(identifier: "uz_Latn")
        return formatter
    }
}
