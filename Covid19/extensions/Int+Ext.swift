//
//  Int+Ext.swift
//  Covid19
//
//  Created by Hung Thai Minh on 4/8/20.
//  Copyright © 2020 Hung Thai Minh. All rights reserved.
//

import Foundation

extension Int {
    func getCurrencyFormatting() -> String {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        formatter.usesGroupingSeparator = true
        formatter.maximumFractionDigits = 0
        formatter.locale = Locale.current
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}

