//
//  UIColor+SohoXiColor.m
//
//  Created by Lin Zhou on 7/7/15.
//  Copyright (c) 2015 Hook & Loop, Infor Global Solutions. All rights reserved.
//

#import "UIColor+SohoXiColor.h"

#define DEFAULT_SOHO_COLOR_DARKNESS     6
#define LIGHT_SOHO_COLOR_DARKNESS       DEFAULT_SOHO_COLOR_DARKNESS
#define DARK_SOHO_COLOR_DARKNESS        4

@implementation UIColor (SohoXiColor)

// Azuer Color
+ (UIColor *)azureColor {
    return [UIColor azureColor:DEFAULT_SOHO_COLOR_DARKNESS];
}

+ (UIColor *)azureColor:(NSInteger)darkness {
    if (darkness<=0 || darkness>10) {
        return [UIColor azureColor];
    }
    
    switch (darkness) {
        case 1:
            return [UIColor colorWithRed:0.796f green:0.922f blue:0.957f alpha:1];
        case 2:
            return [UIColor colorWithRed:0.678f green:0.847f blue:0.922f alpha:1];
        case 3:
            return [UIColor colorWithRed:0.553f green:0.788f blue:0.902f alpha:1];
        case 4:
            return [UIColor colorWithRed:0.412f green:0.71f blue:0.867f alpha:1];
        case 5:
            return [UIColor colorWithRed:0.329f green:0.631f blue:0.827f alpha:1];
        case 6:
            return [UIColor colorWithRed:0.212f green:0.541f blue:0.753f alpha:1];
        case 7:
            return [UIColor colorWithRed:0.145f green:0.471f blue:0.663f alpha:1];
        case 8:
            return [UIColor colorWithRed:0.114f green:0.373f blue:0.541f alpha:1];
        case 9:
            return [UIColor colorWithRed:0.075f green:0.302f blue:0.443f alpha:1];
        case 10:
            return [UIColor colorWithRed:0.075f green:0.235f blue:0.349f alpha:1];
        
        default:
            return [UIColor azureColor];
    }
}

+ (UIColor *)azureColorForTheme:(SOHOXITheme)theme {
    switch (theme) {
        case SOHOXIThemeLight:
            return [UIColor azureColor:LIGHT_SOHO_COLOR_DARKNESS];
        case SOHOXIThemeDark:
            return [UIColor azureColor:DARK_SOHO_COLOR_DARKNESS];
        default:
            return [UIColor azureColor];
    }
}

// Amber Color
+ (UIColor *)amberColor {
    return [UIColor amberColor:DEFAULT_SOHO_COLOR_DARKNESS];
}

+ (UIColor *)amberColor:(NSInteger)darkness {
    if (darkness<=0 || darkness>10) {
        return [UIColor amberColor];
    }
    switch (darkness) {
        case 1:
            return [UIColor colorWithRed:0.984f green:0.914f blue:0.749f alpha:1];
        case 2:
            return [UIColor colorWithRed:0.973f green:0.878f blue:0.612f alpha:1];
        case 3:
            return [UIColor colorWithRed:0.965f green:0.839f blue:0.482f alpha:1];
        case 4:
            return [UIColor colorWithRed:0.957f green:0.788f blue:0.318f alpha:1];
        case 5:
            return [UIColor colorWithRed:0.949f green:0.737f blue:0.255f alpha:1];
        case 6:
            return [UIColor colorWithRed:0.937f green:0.659f blue:0.212f alpha:1];
        case 7:
            return [UIColor colorWithRed:0.933f green:0.604f blue:0.212f alpha:1];
        case 8:
            return [UIColor colorWithRed:0.894f green:0.533f blue:0.169f alpha:1];
        case 9:
            return [UIColor colorWithRed:0.859f green:0.467f blue:0.149f alpha:1];
        case 10:
            return [UIColor colorWithRed:0.839f green:0.384f blue:0.129f alpha:1];
            
        default:
            return [UIColor amberColor];
    }
}

+ (UIColor *)amberColorForTheme:(SOHOXITheme)theme {
    switch (theme) {
        case SOHOXIThemeLight:
            return [UIColor amberColor:LIGHT_SOHO_COLOR_DARKNESS];
        case SOHOXIThemeDark:
            return [UIColor amberColor:DARK_SOHO_COLOR_DARKNESS];
        default:
            return [UIColor amberColor];
    }
}

// Amethyst Color
+ (UIColor *)amethystColor {
    return [UIColor amethystColor:DEFAULT_SOHO_COLOR_DARKNESS];
}

+ (UIColor *)amethystColor:(NSInteger)darkness {
    if (darkness<=0 || darkness>10) {
        return [UIColor amberColor];
    }
    switch (darkness) {
        case 1:
            return [UIColor colorWithRed:0.929f green:0.89f blue:0.988f alpha:1];
        case 2:
            return [UIColor colorWithRed:0.855f green:0.8f blue:0.925f alpha:1];
        case 3:
            return [UIColor colorWithRed:0.78f green:0.706f blue:0.859f alpha:1];
        case 4:
            return [UIColor colorWithRed:0.71f green:0.631f blue:0.788f alpha:1];
        case 5:
            return [UIColor colorWithRed:0.639f green:0.553f blue:0.718f alpha:1];
        case 6:
            return [UIColor colorWithRed:0.573f green:0.475f blue:0.651f alpha:1];
        case 7:
            return [UIColor colorWithRed:0.502f green:0.396f blue:0.58f alpha:1];
        case 8:
            return [UIColor colorWithRed:0.431f green:0.322f blue:0.51f alpha:1];
        case 9:
            return [UIColor colorWithRed:0.365f green:0.243f blue:0.439f alpha:1];
        case 10:
            return [UIColor colorWithRed:0.294f green:0.165f blue:0.369f alpha:1];
            
        default:
            return [UIColor amberColor];
    }
}

+ (UIColor *)amethystColorForTheme:(SOHOXITheme)theme {
    switch (theme) {
        case SOHOXIThemeLight:
            return [UIColor amethystColor:LIGHT_SOHO_COLOR_DARKNESS];
        case SOHOXIThemeDark:
            return [UIColor amethystColor:DARK_SOHO_COLOR_DARKNESS];
        default:
            return [UIColor amethystColor];
    }
}

//Turquoise Color
+ (UIColor *)turquoiseColor {
    return [UIColor turquoiseColor:DEFAULT_SOHO_COLOR_DARKNESS];
}

+ (UIColor *)turquoiseColor:(NSInteger)darkness {
    if (darkness<=0 || darkness>10) {
        return [UIColor turquoiseColor];
    }
    switch (darkness) {
        case 1:
            return [UIColor colorWithRed:0.753f green:0.929f blue:0.89f alpha:1];
        case 2:
            return [UIColor colorWithRed:0.663f green:0.882f blue:0.839f alpha:1];
        case 3:
            return [UIColor colorWithRed:0.557f green:0.82f blue:0.776f alpha:1];
        case 4:
            return [UIColor colorWithRed:0.486f green:0.753f blue:0.71f alpha:1];
        case 5:
            return [UIColor colorWithRed:0.412f green:0.678f blue:0.639f alpha:1];
        case 6:
            return [UIColor colorWithRed:0.341f green:0.62f blue:0.584f alpha:1];
        case 7:
            return [UIColor colorWithRed:0.267f green:0.553f blue:0.514f alpha:1];
        case 8:
            return [UIColor colorWithRed:0.192f green:0.486f blue:0.451f alpha:1];
        case 9:
            return [UIColor colorWithRed:0.125f green:0.42f blue:0.384f alpha:1];
        case 10:
            return [UIColor colorWithRed:0.055f green:0.357f blue:0.322f alpha:1];
            
        default:
            return [UIColor turquoiseColor];
    }
}

+ (UIColor *)turquoiseColorForTheme:(SOHOXITheme)theme {
    switch (theme) {
        case SOHOXIThemeLight:
            return [UIColor turquoiseColor:LIGHT_SOHO_COLOR_DARKNESS];
        case SOHOXIThemeDark:
            return [UIColor turquoiseColor:DARK_SOHO_COLOR_DARKNESS];
        default:
            return [UIColor turquoiseColor];
    }
}

// Ruby Color
+ (UIColor *)rubyColor {
    return [UIColor rubyColor:DEFAULT_SOHO_COLOR_DARKNESS];
}

+ (UIColor *)rubyColor:(NSInteger)darkness {
    if (darkness<=0 || darkness>10) {
        return [UIColor rubyColor];
    }
    switch (darkness) {
        case 1:
            return [UIColor colorWithRed:0.957f green:0.737f blue:0.737f alpha:1];
        case 2:
            return [UIColor colorWithRed:0.922f green:0.616f blue:0.616f alpha:1];
        case 3:
            return [UIColor colorWithRed:0.871f green:0.506f blue:0.506f alpha:1];
        case 4:
            return [UIColor colorWithRed:0.824f green:0.427f blue:0.427f alpha:1];
        case 5:
            return [UIColor colorWithRed:0.776f green:0.373f blue:0.373f alpha:1];
        case 6:
            return [UIColor colorWithRed:0.725f green:0.306f blue:0.306f alpha:1];
        case 7:
            return [UIColor colorWithRed:0.678f green:0.259f blue:0.259f alpha:1];
        case 8:
            return [UIColor colorWithRed:0.631f green:0.188f blue:0.188f alpha:1];
        case 9:
            return [UIColor colorWithRed:0.58f green:0.118f blue:0.118f alpha:1];
        case 10:
            return [UIColor colorWithRed:0.533f green:0.055f blue:0.055f alpha:1];
            
        default:
            return [UIColor rubyColor];
    }
}

+ (UIColor *)rubyColorForTheme:(SOHOXITheme)theme {
    switch (theme) {
        case SOHOXIThemeLight:
            return [UIColor rubyColor:LIGHT_SOHO_COLOR_DARKNESS];
        case SOHOXIThemeDark:
            return [UIColor rubyColor:DARK_SOHO_COLOR_DARKNESS];
        default:
            return [UIColor rubyColor];
    }
}

// Emerald Color
+ (UIColor *)emeraldColor {
    return [UIColor emeraldColor:DEFAULT_SOHO_COLOR_DARKNESS];
}

+ (UIColor *)emeraldColor:(NSInteger)darkness {
    if (darkness<=0 || darkness>10) {
        return [UIColor emeraldColor];
    }
    switch (darkness) {
        case 1:
            return [UIColor colorWithRed:0.835f green:0.965f blue:0.753f alpha:1];
        case 2:
            return [UIColor colorWithRed:0.765f green:0.91f blue:0.675f alpha:1];
        case 3:
            return [UIColor colorWithRed:0.686f green:0.863f blue:0.569f alpha:1];
        case 4:
            return [UIColor colorWithRed:0.612f green:0.808f blue:0.486f alpha:1];
        case 5:
            return [UIColor colorWithRed:0.537f green:0.749f blue:0.396f alpha:1];
        case 6:
            return [UIColor colorWithRed:0.463f green:0.69f blue:0.318f alpha:1];
        case 7:
            return [UIColor colorWithRed:0.4f green:0.631f blue:0.251f alpha:1];
        case 8:
            return [UIColor colorWithRed:0.337f green:0.576f blue:0.18f alpha:1];
        case 9:
            return [UIColor colorWithRed:0.282f green:0.518f blue:0.129f alpha:1];
        case 10:
            return [UIColor colorWithRed:0.224f green:0.459f blue:0.078f alpha:1];
            
        default:
            return [UIColor emeraldColor];
    }
}

+ (UIColor *)emeraldColorForTheme:(SOHOXITheme)theme {
    switch (theme) {
        case SOHOXIThemeLight:
            return [UIColor emeraldColor:LIGHT_SOHO_COLOR_DARKNESS];
        case SOHOXIThemeDark:
            return [UIColor emeraldColor:DARK_SOHO_COLOR_DARKNESS];
        default:
            return [UIColor emeraldColor];
    }
}

// Graphite Color
+ (UIColor *)graphiteColor {
    return [UIColor graphiteColor:DEFAULT_SOHO_COLOR_DARKNESS];
}

+ (UIColor *)graphiteColor:(NSInteger)darkness {
    if (darkness<=0 || darkness>10) {
        return [UIColor graphiteColor];
    }
    switch (darkness) {
        case 1:
            return [UIColor colorWithRed:0.941f green:0.941f blue:0.941f alpha:1];
        case 2:
            return [UIColor colorWithRed:0.847f green:0.847f blue:0.847f alpha:1];
        case 3:
            return [UIColor colorWithRed:0.741f green:0.741f blue:0.741f alpha:1];
        case 4:
            return [UIColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1];
        case 5:
            return [UIColor colorWithRed:0.451f green:0.451f blue:0.451f alpha:1];
        case 6:
            return [UIColor colorWithRed:0.361f green:0.361f blue:0.361f alpha:1];
        case 7:
            return [UIColor colorWithRed:0.271f green:0.271f blue:0.271f alpha:1];
        case 8:
            return [UIColor colorWithRed:0.22f green:0.22f blue:0.22f alpha:1];
        case 9:
            return [UIColor colorWithRed:0.161f green:0.161f blue:0.161f alpha:1];
        case 10:
            return [UIColor colorWithRed:0.102f green:0.102f blue:0.102f alpha:1];
            
        default:
            return [UIColor graphiteColor];
    }
}

+ (UIColor *)graphiteColorForTheme:(SOHOXITheme)theme {
    switch (theme) {
        case SOHOXIThemeLight:
            return [UIColor graphiteColor:LIGHT_SOHO_COLOR_DARKNESS];
        case SOHOXIThemeDark:
            return [UIColor graphiteColor:DARK_SOHO_COLOR_DARKNESS];
        default:
            return [UIColor graphiteColor];
    }
}

// Slate Color
+ (UIColor *)slateColor {
    return [UIColor slateColor:DEFAULT_SOHO_COLOR_DARKNESS];
}

+ (UIColor *)slateColor:(NSInteger)darkness {
    if (darkness<=0 || darkness>10) {
        return [UIColor slateColor];
    }
    switch (darkness) {
        case 1:
            return [UIColor colorWithRed:0.871f green:0.882f blue:0.91f alpha:1];
        case 2:
            return [UIColor colorWithRed:0.784f green:0.796f blue:0.831f alpha:1];
        case 3:
            return [UIColor colorWithRed:0.671f green:0.682f blue:0.718f alpha:1];
        case 4:
            return [UIColor colorWithRed:0.533f green:0.545f blue:0.58f alpha:1];
        case 5:
            return [UIColor colorWithRed:0.396f green:0.408f blue:0.443f alpha:1];
        case 6:
            return [UIColor colorWithRed:0.314f green:0.325f blue:0.353f alpha:1];
        case 7:
            return [UIColor colorWithRed:0.255f green:0.259f blue:0.278f alpha:1];
        case 8:
            return [UIColor colorWithRed:0.192f green:0.196f blue:0.212f alpha:1];
        case 9:
            return [UIColor colorWithRed:0.129f green:0.133f blue:0.141f alpha:1];
        case 10:
            return [UIColor colorWithRed:0.11f green:0.094f blue:0.098f alpha:1];
            
        default:
            return [UIColor slateColor];
    }
}

+ (UIColor *)slateColorForTheme:(SOHOXITheme)theme {
    switch (theme) {
        case SOHOXIThemeLight:
            return [UIColor slateColor:LIGHT_SOHO_COLOR_DARKNESS];
        case SOHOXIThemeDark:
            return [UIColor slateColor:DARK_SOHO_COLOR_DARKNESS];
        default:
            return [UIColor slateColor];
    }
}


// Alert Colors
+ (UIColor *)redAlertColor {
    return [UIColor colorWithRed:0.91f green:0.31f blue:0.31f alpha:1];
}

+ (UIColor *)orangeAlertColor {
    return [UIColor colorWithRed:1 green:0.58f blue:0.149f alpha:1];
}

+ (UIColor *)yellowAlertColor {
    return [UIColor colorWithRed:1 green:0.843f blue:0.149f alpha:1];
}

+ (UIColor *)greenAlertColor {
    return [UIColor colorWithRed:0.502f green:0.808f blue:0.302f alpha:1];
}


@end

