

import SwiftUI

private enum DMSans {
    static let regular  = "DMSans18pt-Regular"
    static let medium   = "DMSans18pt-Medium"
    static let semiBold = "DMSans18pt-SemiBold"
    static let bold     = "DMSans18pt-Bold"
}

extension Font {

    
    static let dmSansStatValue   = Font.custom(DMSans.semiBold, size: 24)

    
    static let dmSansSectionHead = Font.custom(DMSans.semiBold, size: 20)
    
    static let dmSansNavigationHead = Font.custom(DMSans.bold, size: 22)

    
    static let dmSansStatLabel   = Font.custom(DMSans.regular,  size: 18)

    
    static let dmSansCardSub     = Font.custom(DMSans.medium,   size: 16)

    
    static let dmSansBody        = Font.custom(DMSans.regular,  size: 16)

    
    static let dmSansSmall       = Font.custom(DMSans.regular,  size: 14)

    
    static let dmSansToggleSel   = Font.custom(DMSans.medium,   size: 12)

    
    static let dmSansToggle      = Font.custom(DMSans.regular,  size: 12)

    
    static let dmSansAxis        = Font.custom(DMSans.regular,  size: 10)

    static let dmSansBoldLarge   = Font.custom(DMSans.bold, size: 24)
    static let dmSansBoldBody    = Font.custom(DMSans.bold, size: 16)
    static let dmSansBoldSmall   = Font.custom(DMSans.bold, size: 14)
}
