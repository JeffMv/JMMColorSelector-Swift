//
//  UIColor+JMMColor.swift
//  JMMColorSelector
//
//  Created by jeffrey.mvutu@gmail.com on 29.10.15.
//  Copyright © 2015 Jeffrey Mvutu Mabilama. All rights reserved.
//

import Foundation
import UIKit


public extension UIColor {
    
    // MARK: - Deriving a Color for a single component -
    
    // MARK: Deriving a RGB color
    
    public func colorWithRedComponent(red: CGFloat) -> UIColor {
        var g = CGFloat(0), b = CGFloat(0), a = CGFloat(0)
        self.getRed(nil, green: &g, blue: &b, alpha: &a)
        return UIColor(red: red, green: g, blue: b, alpha: a)
    }
    
    public func colorWithGreenComponent(green: CGFloat) -> UIColor {
        var r = CGFloat(0), b = CGFloat(0), a = CGFloat(0)
        self.getRed(&r, green: nil, blue: &b, alpha: &a)
        return UIColor(red: r, green: green, blue: b, alpha: a)
    }
    
    public func colorWithBlueComponent(blue: CGFloat) -> UIColor {
        var r = CGFloat(0), g = CGFloat(0), a = CGFloat(0)
        self.getRed(&r, green: &g, blue: nil, alpha: &a)
        return UIColor(red: r, green: g, blue: blue, alpha: a)
    }
    
    // MARK: Deriving a HSB color
    
    public func colorWithHueComponent(hue: CGFloat) -> UIColor {
        var s = CGFloat(0), b = CGFloat(0), a = CGFloat(0)
        self.getHue(nil, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: hue, saturation: s, brightness: b, alpha: a)
    }
    
    public func colorWithSaturationComponent(saturation: CGFloat) -> UIColor {
        var h = CGFloat(0), b = CGFloat(0), a = CGFloat(0)
        self.getHue(&h, saturation: nil, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: saturation, brightness: b, alpha: a)
    }
    
    public func colorWithBrightnessComponent(brightness: CGFloat) -> UIColor {
        var h = CGFloat(0), s = CGFloat(0), a = CGFloat(0)
        self.getHue(&h, saturation: &s, brightness: nil, alpha: &a)
        return UIColor(hue: h, saturation: s, brightness: brightness, alpha: a)
    }
    
    // MARK: - Getting a component's value -
    
    public func getAlphaComponent() -> CGFloat {
        var a = CGFloat(-1)
        self.getRed(nil, green: nil, blue: nil, alpha: &a)
        checkColorComponent(a)
        return a
    }

    // MARK: RGB Component Getters
    
    public func getRedComponent() -> CGFloat {
        var r = CGFloat(0)
        self.getRed(&r, green: nil, blue: nil, alpha: nil)
        checkColorComponent(r)
        return r
    }

    public func getGreenComponent() -> CGFloat {
        var g = CGFloat(-1)
        self.getRed(nil, green: &g, blue: nil, alpha: nil)
        checkColorComponent(g)
        return g
    }

    public func getBlueComponent() -> CGFloat {
        var b = CGFloat(-1)
        self.getRed(nil, green: nil, blue: &b, alpha: nil)
        checkColorComponent(b)
        return b
    }
    
    // MARK: HSB Component Getters
    
    public func getHueComponent() -> CGFloat {
        var h = CGFloat(-1)
        self.getHue(&h, saturation: nil, brightness: nil, alpha: nil)
        checkColorComponent(h)
        return h
    }
    
    public func getSaturationComponent() -> CGFloat {
        var s = CGFloat(-1)
        self.getHue(nil, saturation: &s, brightness: nil, alpha: nil)
        checkColorComponent(s)
        return s
    }
    
    public func getBrightnessComponent() -> CGFloat {
        var b = CGFloat(-1)
        self.getHue(nil, saturation: nil, brightness: &b, alpha: nil)
        checkColorComponent(b)
        return b
    }
    
    
    // MARK: - Exception handling -
    
    enum ColorException {
        case IncompatibleColorSpace
        case UnknownException
        func description() -> String {
            switch self {
            case .IncompatibleColorSpace:
                return "IncompatibleColorSpace"
            case .UnknownException:
                return "UnknownException"
            }
        }
    }
    
    //    public static var shareSettingsWithICloud: Bool {
    //        set
    //    }
    
    //    public static var logErrors: Bool {
    //        set { }
    //        get { }
    //    }
    
    func checkColorComponent(_ value: CGFloat) -> Void {
        if value < 0.0 || value > 1.0 {
            NSLog("[WARNING] UIColor+JMMColor | An exception occured : %s", ColorException.IncompatibleColorSpace.description())
        }
    }
}


    //  HEADER
/*
//#define RECODING_Operation_Code_Color

typedef enum : NSUInteger {
    /** Pas de couleur.
    *  Pour les leds : signifie que la LED est éteinte
    */
    JMSCColorNone = 0,
    
    // Couleur personnalisée
    JMSCColorCustom,
    
} JMSCColoris;

#define JMSCColorBlue [JMSCColor colorWithUIColor:[UIColor blueColor]]
#define JMSCColorOrange [JMSCColor colorWithUIColor:[UIColor orangeColor]]


#pragma mark - JMSCColor -

#define JMSCColor_choice_Immutable

/** Class de représentation interne des couleurs
*  Cette classe est mutable
*
*  @note Note d'utilisation :
*          Par convention, stocker les couleurs qui destinées à être
*          sauvegardées (dans CoreData, NSUserDefaults, ou encore
*          dans un NSDictionary/NSArray/property qui lui est stocké)
*          en utilisant des NSKeyedArchiver/-Unarchiver, ou, avec
*          les méthodes -[asData] et +[colorWithData:].
*
*			Pour de l'économie d'espace de stockage,
*			utiliser la paire de méthodes -[asDictionary] et +[colorWithDictionary:].
*/
@interface JMSCColor : NSObject <NSCoding>

#pragma mark Transparence

+ (CGFloat)standardAlphaComponentForAppearanceColors;
+ (CGFloat)standardAlphaComponentForAppearanceColor:(JMSCColor *)color;

+ (CGFloat)standardSaturationForPastelColor;

#pragma mark Color components

#ifndef JMSCColor_choice_Immutable
@property (nonatomic) JMSCColoris coloris;
#else
@property (nonatomic, readonly) JMSCColoris coloris;
#endif // JMSCColor_choice_Immutable

@property (nonatomic, readonly) CGFloat red;
@property (nonatomic, readonly) CGFloat blue;
@property (nonatomic, readonly) CGFloat green;

- (void)getHue:(CGFloat *)hue saturation:(CGFloat *)saturation brightness:(CGFloat *)brightness alpha:(CGFloat *)alpha;

#ifndef JMSCColor_choice_Immutable
- (void)setR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b;
#endif



#pragma mark - Couleurs de modules

@property (readonly) UIColor *uiColor;


- (JMSCColor *)colorWithHue:(CGFloat)newHue;
- (JMSCColor *)colorWithBrightness:(CGFloat)newBrightness;
- (JMSCColor *)colorWithSaturation:(CGFloat)newSaturation;
@property (readonly) UIColor *pastelLikeUIColor;
@property (readonly) UIColor *pastelLikeUIColorUsingAlpha;


#pragma mark - Comparing instances

- (BOOL)isEqualToColor:(JMSCColor *)color;
// - (BOOL)isEqualToUIColor:(UIColor *)color;




#pragma mark - Managing Instances -

+ (instancetype)colorForColoris:(JMSCColoris)coloris;

/**
*  @note
*          vérifier si la couleur est: -clear/totalement transparent, -noire(toute noire)
*/
+ (instancetype)colorWithUIColor:(UIColor *)uiColor; //

+ (instancetype)colorForRed:(CGFloat)red blue:(CGFloat)blue green:(CGFloat)green;

@property (readonly) NSDictionary *asDictionary;
+ (instancetype)colorWithDictionary:(NSDictionary *)dict;

@property (readonly) NSData *asData;
+ (instancetype)colorWithData:(NSData *)data;

#pragma mark Storing instance

+ (NSObject *)formatedColorForDBStorage:(NSObject *)jmscColor;
+ (JMSCColor *)unpackedColorFromStorage:(NSObject *)color;


@end

*/


// JMSCColor IMPLEMENTATION
/**
@implementation JMSCColor


#pragma mark - Basic utilities


bool validComponentValue(CGFloat v){
return (0.0f <= (v) && (v) <= 1.0f);
}

bool validRGBAValue(CGFloat r, CGFloat g, CGFloat b, CGFloat a){
return (validComponentValue( r ) && validComponentValue( g ) && validComponentValue( b ) && validComponentValue( a ) );
}


#define UIColorFromHex( rgbValue ) ( [UIColor UIColorFromRGB:rgbValue ] )

#define RGB(r, g, b) [UIColor colorWithRed:(r) green:(g) blue:(b) alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:(r) green:(g) blue:(b) alpha:a]
//#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]



bool equalFloatsEspilon(CGFloat f, CGFloat s, float epsilon){
return ( ABS((f)-(s)) < epsilon );
}

bool equalFloats(CGFloat f, CGFloat s){
return equalFloatsEspilon(f, s, 0.00001f) ;
}


- (BOOL)isEqualToColor:(JMSCColor *)color
{
BOOL sameColoris = self.coloris == color.coloris;
BOOL sameRGB = sameColoris ? YES : (equalFloats(self.red, color.red)&&equalFloats(self.green, color.green)&&equalFloats(self.blue, color.blue));

return sameColoris && sameRGB;
}



#pragma mark - Getting and storing an instance -

#pragma mark Storing & Retrieving


+ (NSObject *)formatedColorForDBStorage:(NSObject *)jmscColor {
NSObject * colorObject = [[JMSCColor colorForColoris:JMSCColorNone] asDictionary];
if ([jmscColor isKindOfClass:[JMSCColor class]]) {
colorObject = ((JMSCColor *)jmscColor).asDictionary;
}
else if ([jmscColor isKindOfClass:[NSDictionary class]]){
colorObject = jmscColor;
} else if ([jmscColor isKindOfClass:[NSData class]]){
JMSCColor *unpacked = [JMSCColor colorWithData:(NSData *)jmscColor];
colorObject = [self formatedColorForDBStorage:unpacked];
}
else {
//    [NSException raise:@"Unsupported color format" format:@"class %@ is not handled for storing JMSCColor into the database\n%s",colorObject.class,__PRETTY_FUNCTION__];
//        NSLog(@"%s : Unsupported color format - class %@\n",  __PRETTY_FUNCTION__ ,jmscColor.class);
//        colorObject = jmscColor;
}
return colorObject;
}

+ (JMSCColor *)unpackedColorFromStorage:(NSObject *)color {
if ([color isKindOfClass:[NSDictionary class]]) {
return [JMSCColor colorWithDictionary:(NSDictionary *)color];
}
else if ([color isKindOfClass:[JMSCColor class]])
return (JMSCColor *)color;
else if ([color isKindOfClass:[NSData class]])
return [JMSCColor colorWithData:(NSData *)color];


NSLog(@"%s : WARNING - the argument does not seem to be from the storage.",__PRETTY_FUNCTION__);
return [JMSCColor colorForColoris:JMSCColorNone];
}




- (NSDictionary *)asDictionary {
return @{
@"c" : @(self.coloris),
@"r" : @(self.red),
@"g" : @(self.green),
@"b" : @(self.blue)
};
}

#define containsKey(dict, key) [(dict) objectForKey:(key)]!=nil
+ (instancetype)colorWithDictionary:(NSDictionary *)dict {
if ( !
(containsKey(dict, @"c") && containsKey(dict, @"r") && containsKey(dict, @"g") && containsKey(dict, @"b")) ) {
return nil;
}

JMSCColoris coloris = [[dict objectForKey:@"c"] integerValue];

if (coloris==JMSCColorNone) {
return [self.class colorForColoris:JMSCColorNone];
} else {
CGFloat red    =   [[dict objectForKey:@"r"] floatValue];
CGFloat green  =   [[dict objectForKey:@"g"] floatValue];
CGFloat blue   =   [[dict objectForKey:@"b"] floatValue];

UIColor *uic = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
return [self colorWithUIColor:uic];
}
}


- (void)encodeWithCoder:(NSCoder *)aCoder {
//    [aCoder encodeObject:[NSNumber numberWithInteger:self.coloris] forKey:@"coloris"];
//    [aCoder encodeObject:[NSNumber numberWithFloat:self.red]    forKey:@"redV"];
//    [aCoder encodeObject:[NSNumber numberWithFloat:self.green]  forKey:@"greenV"];
//    [aCoder encodeObject:[NSNumber numberWithFloat:self.blue]   forKey:@"blueV"];

[aCoder encodeObject:self.asDictionary forKey:@"instance-as-dict"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
if ([aDecoder containsValueForKey:@"instance-as-dict"]) {
return [self.class colorWithDictionary:[aDecoder decodeObjectForKey:@"instance-as-dict"]];
}

JMSCColoris coloris = [[aDecoder decodeObjectForKey:@"coloris"] integerValue];

if (coloris==JMSCColorNone) {
return [self.class colorForColoris:JMSCColorNone];
} else {
CGFloat red    =   [[aDecoder decodeObjectForKey:@"redV"] floatValue];
CGFloat green  =   [[aDecoder decodeObjectForKey:@"greenV"] floatValue];
CGFloat blue   =   [[aDecoder decodeObjectForKey:@"blueV"] floatValue];

UIColor *uic = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
return [self initWithUIColor:uic];
}
}


- (NSData *)asData {
return [NSKeyedArchiver archivedDataWithRootObject:self];
}

+ (instancetype)colorWithData:(NSData *)data {
if ([data isKindOfClass:[NSData class]]) {
return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}
else if ([data isKindOfClass:[JMSCColor class]]){
NSLog(@"%s : WARNING Color considered as DATA, but is already a COLOR", __PRETTY_FUNCTION__);
return (JMSCColor *)data;
}
return nil;
}


#pragma mark Préférences pour UI


+ (CGFloat)standardAlphaComponentForAppearanceColors
{
return 0.85;
}
+ (CGFloat)standardAlphaComponentForAppearanceColor:(JMSCColor *)color {
return [self standardAlphaComponentForAppearanceColors];
}

+ (CGFloat)standardSaturationForPastelColor {
return 0.5;
}



#pragma mark Properties

- (UIColor *)pastelLikeColor{
UIColor *rawColor = self.uiColor;
CGFloat h=-1, s=-1, b=-1, a=-1;
[rawColor getHue: &h saturation: &s  brightness: &b alpha: &a];

s = [self.class standardSaturationForPastelColor];
CGFloat brightnessToFullyBright = 1.0 - b; // bit brighter
CGFloat newBrightness = (b + (brightnessToFullyBright*3.0/4.0));

return [UIColor colorWithHue:h saturation:s brightness:newBrightness alpha:1.0];
}


- (UIColor *)pastelLikeColorUsingAlpha
{
return [self.uiColor colorWithAlphaComponent:[JMSCColor standardAlphaComponentForAppearanceColors]];
}



@end

*/

