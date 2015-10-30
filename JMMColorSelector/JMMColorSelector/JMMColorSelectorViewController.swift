//
//  JMMColorSelectorViewController.swift
//  JMMColorSelector
//
//  Created by jeffrey.mvutu@gmail.com on 26.10.15.
//  Copyright (c) 2015 Jeffrey Mvutu Mabilama. All rights reserved.
//

import Foundation
import UIKit




public enum JMMColorSelectorColorMode {
    case HSB
    case RGB
    case HSBA, RGBA
}




/*

#import "../../Global_Modules/JMSCColor.h"
#import "ColorSelectorView.h"

@class ColorSelectorViewController;
@protocol ColorSelectorViewControllerDelegate <NSObject>

- (void)colorSelectorVC:(ColorSelectorViewController *)csViewController
colorHasBeenChosen:(JMSCColor *)color;

@end

/**
* VC tout fait qui permet de séléctionner des couleurs
*/
@interface ColorSelectorViewController : UIViewController
@property (strong, nonatomic) IBOutlet ColorSelectorView *view;

// overrides...
- (void)setCursorPositionsForColor:(UIColor *)color;

@property (nonatomic, readonly) UIColor     *chosenColor;
@property (nonatomic, readonly)         JMSCColor   *chosenColorJMSC;

@property (retain) id<ColorSelectorViewControllerDelegate> delegate;

@end

*/

public protocol JMMColorSelectorViewControllerDelegate : NSObjectProtocol {
}


/*

#import "ColorSelectorView.h"
//#import "../../Views/"
#import <QuartzCore/QuartzCore.h>


@interface ColorSelectorViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) ColorSelectorView *colorSelectorView;

@property (nonatomic) CGFloat teinte;
@property (nonatomic) CGFloat saturation;
@property (nonatomic) CGFloat luminosite;


#pragma mark UI Components
@property (weak, nonatomic) IBOutlet UIView *colorPreviewView;


@property (weak, nonatomic) IBOutlet UISlider *hueSlider;
@property (weak, nonatomic) IBOutlet UISlider *saturationSlider;
@property (weak, nonatomic) IBOutlet UISlider *brightnessSlider;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, readonly) UICollectionView *colorPreviewsCollectionView;

#pragma mark View Contraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *brightnessSliderLeadingConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *brightnessSliderTrailingConstraint;


@end
*/


public class JMMColorSelectorViewController : UIViewController , UICollectionViewDataSource, UICollectionViewDelegate, JMMColorSelectorViewDelegate {

    // MARK: Initializers & VC Lifecycle
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        shareSettingsAccrossDevices = false
        super.init(nibName:nibNameOrNil, bundle:nibBundleOrNil);
    }
    
    public required init?(coder aDecoder: NSCoder) {
        shareSettingsAccrossDevices = false
        super.init(coder: aDecoder);
    }
    
    func customSetup(){
        self.colorSelectorView?.delegate = self;
        self.colorSelectorView?.colorCollectionDataSource = self;
        self.colorSelectorView?.colorCollectionDelegate = self
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    
//        self.colorSelectorView?.hueSlider.alpha = 0.0f;
//        self.colorSelectorView?.saturationSlider.alpha = 0.0f;
//        self.colorSelectorView?.brightnessSlider.alpha = 0.0f;
        
        // [self setupCollectionView];
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
        self.customSetup()
        
        //    [self loadLastStateAnimated:NO];
        
        self.colorPreviewView?.alpha = CGFloat(0);
        
        /*
        NSLayoutConstraint *leftConstraint = self.colorSelectorView?.brightnessSlider?.LeadingConstraint;
        NSLayoutConstraint *rightConstraint = self.colorSelectorView?.brightnessSlider?.TrailingConstraint;
        
        UIImage *lowBrightnessImage = [UIImage imageNamed:@"brightness-low"];
        UIImage *highBrightnessImage = [UIImage imageNamed:@"brightness-high"];
        if (lowBrightnessImage && highBrightnessImage) {
        //        self.colorSelectorView?.brightnessSlider?.minimumValueImage = lowBrightnessImage;
        //        self.colorSelectorView?.brightnessSlider?.maximumValueImage = highBrightnessImage;
        
        //        CGFloat decalage = self.colorSelectorView?.brightnessSlider?.minimumValueImage.size.width;
        //        leftConstraint.constant = decalage;
        //        rightConstraint.constant = - decalage;
        } else {
        leftConstraint.constant = 0;
        rightConstraint.constant = 0;
        NSLog(@"Images : 'low' is %@, 'high' is %@\n%s",(lowBrightnessImage?@"set":@"nil"),(highBrightnessImage?@"set":@"nil"),__PRETTY_FUNCTION__);
        }
        
        
        self.view.frame = self.parentViewController.view.bounds;
        [self loadLastStateAnimated:NO];
        
        self.colorPreviewView.layer.cornerRadius = self.colorPreviewView.frame.size.width/2.0;
        */
    } // -- end viewWill Appear
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.loadLastStateAnimated(true) // ou bien on pourrait juste tout recharger off-screen
        
        
        
        let revealUIBlock = {
            () -> Void in
            self.colorSelectorView?.hueSlider?.alpha = CGFloat(1.0)
            self.colorSelectorView?.saturationSlider?.alpha = 1.0
            self.colorSelectorView?.brightnessSlider?.alpha = 1.0
            
            self.colorSelectorView?.colorPreviewView?.alpha = 1.0
        }
        if (animated){
            let animDuration = 0.3, delay = 0.1
            UIView.animateWithDuration(animDuration, delay: delay, options: .TransitionNone, animations:revealUIBlock , completion: nil)
        } else {
            revealUIBlock()
        }
    }

    override public func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //
        self.savePrefs()
    }
    
    
    
    
    override public func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration duration:NSTimeInterval) {
        super.willRotateToInterfaceOrientation(toInterfaceOrientation, duration:duration);
        
        var bounds = self.view!.frame
        swap(&bounds.size.height, &bounds.size.width)
        
        let gradientViews: [UIView] = [self.colorSelectorView!.hueGradientView!, self.colorSelectorView!.saturationGradientView!, self.colorSelectorView!.brightnessGradientView!]
//        let resizeView: UIView -> Void = {(aView: UIView)->Void in aView.layer.bounds = bounds; }
        
        CATransaction.begin();
        CATransaction.setValue(NSNumber(double: duration), forKey:kCATransactionAnimationDuration);
        for someView in gradientViews {
//            resizeView(someView)
            someView.layer.bounds = bounds
        }
        CATransaction.commit();
    }
    
    
    override public func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
//        if #available(iOS, 7.0)
        if super.respondsToSelector(Selector.init("didRotateFromInterfaceOrientation")){
            super.didRotateFromInterfaceOrientation(fromInterfaceOrientation);
        }
    
        self.colorSelectorView?.selectedColor = self.selectedColor!
        self.loadLastStateAnimated(true);
    }

    
    
    // MARK: - Public API -
    
    public var delegate: JMMColorSelectorViewControllerDelegate?
    
    /** Whether you want the settings (like last used color) to be saved in iCloud or offline.
     */
    public var shareSettingsAccrossDevices: Bool
    
    public var selectedColor: UIColor? {
        get {
            if let color = self.colorSelectorView?.selectedColor {
                return color
            } else {
                return self.lastSavedColor(nil)
            }
        }
        set {
            self.colorSelectorView?.selectedColor = newValue!
        }
    }
    
    
    
    
    // MARK: Providing colors
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.numberOfSections() == 1
        {
            return self.colorsAtDisposal().count
        }
        else
        {
            if section==0 {
                return JMMColorSelectorViewController.defaultColors().count
            } else {
                return self.colorsAtDisposal().count
            }
        }
    }
    
    private var cellRegistrationToken: dispatch_once_t = 0
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellIdentifier = "__JMM_CVCell_defaultCell"
        dispatch_once(&cellRegistrationToken) { () -> Void in
            collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        }
        
        let cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath)
        cell.backgroundColor = self.colorsAtDisposal()[indexPath.row]
        
        let squareConstraint = NSLayoutConstraint.init(item: cell, attribute: .Width, relatedBy: .Equal, toItem: cell, attribute: .Height, multiplier: 1.0, constant: 0)
        cell.addConstraint(squareConstraint);
        cell.layer.cornerRadius = cell.frame.size.height/2.0;
        
        return cell
    }
    
    
    private static func defaultColors() -> [UIColor] {
        let cocoaColors = [UIColor.magentaColor(),UIColor.cyanColor(),
            UIColor.yellowColor(),UIColor.greenColor(),
            UIColor.redColor(), UIColor.orangeColor(),
            UIColor.blueColor(),UIColor.purpleColor(),
            UIColor.brownColor(), UIColor.lightGrayColor()];
        
        
        // Adding pastel colors
        func pastelColorForColor(color: UIColor) -> UIColor {
            var h: CGFloat = 0.0, b: CGFloat = 0.0
            color.getHue(&h, saturation: nil, brightness: &b, alpha: nil)
            let pastelSaturation: CGFloat = 0.5;
            return UIColor.init(hue: h, saturation: pastelSaturation, brightness: b, alpha: 1.0)
        }
        
        var allColors = [UIColor](cocoaColors)
        for color in cocoaColors {
            allColors.append(pastelColorForColor(color))
        }
        
        return cocoaColors;
    }
    
    private func colorsAtDisposal() -> [UIColor] {
        // guarding ourselves from regenerating colors if it has already been done
        // if colorsForSession.isEmpty
        guard colorsForSession.isEmpty
            else {
                return colorsForSession
        }
        
        // a set of default colors
        colorsForSession += JMMColorSelectorViewController.defaultColors()
        
        // completed by random colors (until the VC is regenerated)
        let nbRandomColors = 20
        let colorRange = 256;
        for ( var i=0; i < nbRandomColors; ++i){
            let r = CGFloat(Int(arc4random()) % colorRange) / CGFloat(colorRange);
            let g = CGFloat(random() % colorRange) / CGFloat(colorRange);
            let b = CGFloat(random() % colorRange) / CGFloat(colorRange);
            let randomColor = UIColor(red:r, green: g, blue: b, alpha: 1.0);
            colorsForSession.append(randomColor);
        }
        
        return colorsForSession
    }
    

    // MARK: - PRIVATE -
    
    private var colorSelectorView: JMMColorSelectorView? {
        get {
            return (self.view! as! JMMColorSelectorView)
        }
    }
    
    // MARK: Actions
    
    @IBAction private func notifyAndDismiss() -> Void {
//        self.delegate.colorSelectorVC(self, chosenColor:self.chosenColor)
        self.presentingViewController?.dismissViewControllerAnimated(true) {
            () -> Void in
            self.savePrefs()
        }
    }
    
    @IBAction private func silentDismiss() {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion:nil)
    }
    
    
    
    
    // MARK: Preferences
    
    
    
//    func loadLastState(animated animated: Bool){
//    }
    
    
    func loadLastStateAnimated(animated: Bool) {
        let color: UIColor! = self.lastSavedColor(JMMColorSelectorViewController._defaultColor)
        
        var teinte = CGFloat(0), saturation = CGFloat(0), luminosite = CGFloat(0)
        color.getHue(&teinte, saturation: &saturation, brightness: &luminosite, alpha: nil)
        
        self.colorSelectorView?.hueComponent = Float(teinte)
        self.colorSelectorView?.saturationComponent = Float(saturation)
        self.colorSelectorView?.brightnessComponent = Float(luminosite)
    }
    

    func loadPrefs() {
        let lastColor = lastSavedColor(UIColor.redColor())
        if let color = lastColor {
            self.colorSelectorView?.selectedColor = color
        }
    }
    
    private func savePrefs() {
        self.saveSelectedColor()
    }
    
    //
    private static let _defaultColor = UIColor.redColor()
    
    func saveSelectedColor(){
        var h = CGFloat(0), s = CGFloat(0), b = CGFloat(0), a = CGFloat(0)
        self.selectedColor!.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        let colorRange = 2^8-1
        let iH = Int(h * CGFloat(colorRange)) << 8 * 3
        let iS = Int(s * CGFloat(colorRange)) << 8 * 2
        let iB = Int(b * CGFloat(colorRange)) << 8 * 1
        let iA = Int(a * CGFloat(colorRange))
        let hsba: Int = iH | iS | iB | iA
        
        self.saveObject(hsba, forKey: kLastHSBAColorAsIntKey)
    }
    
    private func lastSavedColor(defaultValue: UIColor?) -> UIColor? {
        var color: UIColor? = defaultValue
        
        if let hsba = (self.loadObjectForKey(kLastHSBAColorAsIntKey) as! Int?){
            let range = CGFloat(2^8 - 1)
            
            let a = CGFloat( hsba & 0xFF) / range
            let b = CGFloat((hsba & 0xFF00) >>  8 ) / range
            let s = CGFloat((hsba >> 8 * 2) & 0xFF) / range
            let h = CGFloat((hsba >> 8 * 3) & 0xFF) / range
            
            color = UIColor.init(hue: h, saturation: s, brightness: b, alpha: a)
        }
        else if let colorDict = self.loadObjectForKey(kLastHSBAColorKey) {
            let h: CGFloat = CGFloat( colorDict.floatForKey(kHueValueKey) )
            let s = CGFloat( colorDict.floatForKey(kSaturationValueKey) )
            let b = CGFloat( colorDict.floatForKey(kBrightnessValueKey) )
            let a = CGFloat( colorDict.floatForKey(kAlphaValueKey))
            color = UIColor.init(hue: h, saturation: s, brightness: b, alpha: a)
        }
        return color
    }

    
    let kHueValueKey = "h"
    let kSaturationValueKey = "s"
    let kBrightnessValueKey = "b"
    let kAlphaValueKey = "a"
    let kLastHSBAColorKey = "__jmmcsvc-last-hsba"
    let kLastHSBAColorAsIntKey = "__jmmcsvc_last-hsba_int"
    
    
    private func saveObject(object: AnyObject?, forKey key: String){
        guard let object = object else {
            return
        }
        
        if self.shareSettingsAccrossDevices {
            NSUbiquitousKeyValueStore.defaultStore().setObject(object, forKey: key)
        } else {
            NSUserDefaults.standardUserDefaults().setObject(object, forKey: key)
        }
    }
    
    private func loadObjectForKey(key: String) -> AnyObject? {
        if self.shareSettingsAccrossDevices {
            return NSUbiquitousKeyValueStore.defaultStore().objectForKey(key);
        } else {
            return NSUserDefaults.standardUserDefaults().objectForKey(key);
        }
    }
    
    
    // MARK: Instance variables & Properties
    
    public var hue: Float? {
        set { self.colorSelectorView?.hueComponent = newValue! }
        get { return self.colorSelectorView?.hueComponent }
    }
    public var saturation: Float? {
        set { self.colorSelectorView?.saturationComponent = newValue! }
        get { return self.colorSelectorView?.saturationComponent }
    }
    public var brightness: Float? {
        set { self.colorSelectorView?.brightnessComponent = newValue! }
        get { return self.colorSelectorView?.brightnessComponent }
    }
    
        // View components
    @IBOutlet private weak var colorPreviewView: UIView?
    @IBOutlet private weak var hueSlider: UISlider?
    @IBOutlet private weak var saturationSlider: UISlider?
    @IBOutlet private weak var brightnessSlider: UISlider?
    
    @IBOutlet private weak var brightnessSliderLeadingConstraint: NSLayoutConstraint?
    @IBOutlet private weak var brightnessSliderTrailingConstraint: NSLayoutConstraint?
    
    @IBOutlet private weak var availableColorsCollectionView: UICollectionView?
    //    private let colorPreviewsCollectionView: UICollectionView // whut ?
    
        //
    private var colorsInitializationDone = false
    private var colorsForSession = [UIColor]() {
        didSet {
            if let colorsPreviewCV = self.availableColorsCollectionView {
                colorsPreviewCV.reloadData()
            }
        }
    }
    
    
    // MARK: Conforming to protocols
    
    public func colorSelectorView(colorSelectorView: JMMColorSelectorView, userChoseColor color: UIColor) {
        
    }
    
    public func colorSelectorView(colorSelectorView: JMMColorSelectorView, userDidDiscardColor lastColor: UIColor) {
        
    }
}


/*
@implementation ColorSelectorViewController {
UIColor *initialColorSetting;

NSMutableArray *colorsForSession;

BOOL colorsInitializationDone;
}

@dynamic view;

#define LAST_HUE @"kColorSelector-Last-Hue"
#define LAST_SATURATION @"kColorSelector-Last-Saturation"
#define LAST_BRIGHTNESS @"kColorSelector-Last-Brightness"

//#define MAX_NBR_SavedColor 5
//- (UIColor *)lastChosenColor;
//- (void)saveColor:(JMSCColor *)color {
//    NSMutableArray *savedColors;
//    [savedColors addObject:color.asDictionary];
//    if (savedColors.count > MAX_NBR_SavedColor) {
//        [savedColors removeLastObject];
//    }
//}



#pragma mark - Preferences

#pragma mark -
#pragma mark Properties

#pragma mark Preparation du VC



- (void)viewWillAppear:(BOOL)animated {
[super viewWillAppear:animated];

//    [self loadLastStateAnimated:NO];

self.colorPreviewView.alpha = 0.0f;

NSLayoutConstraint *leftConstraint = self.colorSelectorView?.brightnessSlider?LeadingConstraint;
NSLayoutConstraint *rightConstraint = self.colorSelectorView?.brightnessSlider?TrailingConstraint;

UIImage *lowBrightnessImage = [UIImage imageNamed:@"brightness-low"];
UIImage *highBrightnessImage = [UIImage imageNamed:@"brightness-high"];
if (lowBrightnessImage && highBrightnessImage) {
//        self.colorSelectorView?.brightnessSlider?.minimumValueImage = lowBrightnessImage;
//        self.colorSelectorView?.brightnessSlider?.maximumValueImage = highBrightnessImage;

//        CGFloat decalage = self.colorSelectorView?.brightnessSlider?.minimumValueImage.size.width;
//        leftConstraint.constant = decalage;
//        rightConstraint.constant = - decalage;
} else {
leftConstraint.constant = 0;
rightConstraint.constant = 0;
NSLog(@"Images : 'low' is %@, 'high' is %@\n%s",(lowBrightnessImage?@"set":@"nil"),(highBrightnessImage?@"set":@"nil"),__PRETTY_FUNCTION__);
}
self.view.frame = self.parentViewController.view.bounds;
[self loadLastStateAnimated:NO];
self.colorPreviewView.layer.cornerRadius = self.colorPreviewView.frame.size.width/2.0;
}

- (void)viewDidAppear:(BOOL)animated {
[super viewDidAppear:animated];

[self loadLastStateAnimated:NO];

[UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionTransitionNone animations:^{
self.colorSelectorView?.hueSlider?.alpha = 1.0f;
self.colorSelectorView?.saturationSlider?.alpha = 1.0f;
self.colorSelectorView?.brightnessSlider?.alpha = 1.0f;

self.colorPreviewView.alpha = 1.0f;
}
completion:nil];
}




#pragma mark - Collection View -

#pragma mark Delegation

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

[self setCursorPositionsForColor:[[self colorsAtDisposal] objectAtIndex:indexPath.row]];

[self loadLastStateAnimated:YES];
}


#pragma mark Data sourcing

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
return [self colorsAtDisposal].count;
}

@end

*/


