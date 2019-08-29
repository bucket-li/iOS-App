//
//  AppearanceHelper.swift
//  LambdaBucketList
//
//  Created by Michael Stoffer on 8/28/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import UIKit

enum AppearanceHelper {
    static func SourceSansProFont(with textStyle: UIFont.TextStyle, pointSize: CGFloat) -> UIFont {
        let font = UIFont(name: "Source Sans Pro", size: pointSize)!
        return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: font)
    }
}
