//
//  JMMColorSelectorView.swift
//  JMMColorSelector
//
//  Created by jeffrey.mvutu@gmail.com on 26.10.15.
//  Copyright (c) 2015 Jeffrey Mvutu Mabilama. All rights reserved.
//

import Foundation
import UIKit


// MARK: - Color selection delegation protocol

/**
 *  Protocol to adopt in order to receive a otification when the user is done chosing a color.
 */
public protocol JMMColorSelectorViewDelegate : NSObjectProtocol {
    func colorSelectorView(colorSelectorView: JMMColorSelectorView, userChoseColor color: UIColor);
    func colorSelectorView(colorSelectorView: JMMColorSelectorView, userDidDiscardColor lastColor: UIColor);
}


// MARK: Color selector view

/**
 *  The view that ...
 */
public class JMMColorSelectorView : UIView {
    
    // MARK: - Initialisation
    
    private func customInit() {
        self.hueSlider?.minimumValue = 0.0;
        self.saturationSlider?.minimumValue = 0.0;
        self.brightnessSlider?.minimumValue = 0.0;
        self.hueSlider?.maximumValue = 1.0;
        self.saturationSlider?.maximumValue = 1.0;
        self.brightnessSlider?.maximumValue = 1.0;
        
        if let previewView = self.colorPreviewView {
            let height: CGFloat = previewView.frame.size.height ; // frame is Zero
            previewView.layer.cornerRadius = height/2.0; // no effect
        }
        
        self.configureGradientViews();
        
        //    [self updateUIForCurrentColor];

    }
    
    public override func layoutSubviews() {
        super.layoutSubviews();
        
        self.customInit()
        
        // redraw layers (gradients)
//        if layoutSubviewsCount > 2 { // magic number, because it seems to be alreight when
//            self.colorCompositionChanged()
//        }
//        ++layoutSubviewsCount
    }
//    private var layoutSubviewsCount: Int = 0

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.customInit()
    }

    // required public init?(coder aDecoder: NSCoder) {
    required public init?(coder aDecoder: NSCoder) {
        // fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        self.customInit();
    }
    
    // MARK: Setups

    public var colorMode: JMMColorSelectorColorMode = .HSB
    
    
    private func setupCollectionView() -> Void {
        // Setup item size
        //    UICollectionViewFlowLayout * flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
        
        //    CGFloat itemWidth = self.collectionView.bounds.size.width / 2.0 - 10;
        //    CGFloat itemWidth = 50;
        //    flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth);
        //    flowLayout.minimumInteritemSpacing = 5;
        //    flowLayout.lineSpacing = 10;
        //    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5 , 5);
        //    flowLayout.sectionInset = UIEdgeInsetsMake(5,8,0,0);
    }
    
    private func configureGradientViews() -> Void {
        self.hueGradientView?.layer.cornerRadius = (self.hueGradientView?.frame.size.height)! / 2.0;
        self.saturationGradientView?.layer.cornerRadius = (self.saturationGradientView?.frame.size.height)! / 2.0;
        self.brightnessGradientView?.layer.cornerRadius = (self.brightnessGradientView?.frame.size.height)! / 2.0;
        
//        let bgColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
        let bgColor = UIColor.clear;
        self.hueGradientView?.backgroundColor = bgColor;
        self.saturationGradientView?.backgroundColor = bgColor;
        self.brightnessGradientView?.backgroundColor = bgColor;
    }
    

    
    
    // MARK: - Public API -
    
    
    // MARK: Color selection validation - delegate
    
    public var delegate: JMMColorSelectorViewDelegate?
    

    // MARK: Sample colors external management
    
//    public var selectionDelegate: ColorSelectorViewDelegate?
    
    public var colorCollectionDataSource: UICollectionViewDataSource? {
        set {
            if let dataSource = colorCollectionDataSource {
                self.colorCollectionView?.dataSource = dataSource
            }
        }
        get {
            return self.colorCollectionView?.dataSource
        }
    }
    public var colorCollectionDelegate: UICollectionViewDelegate? {
        set {
            if let delegate = colorCollectionDelegate {
                self.colorCollectionView?.delegate = delegate
            }
        }
        get {
            return self.colorCollectionView?.delegate
        }
    }
    
    
    public var selectedColor: UIColor { /* code required */
        /**
        *  It is up to the controller to retrieve saved settings.
        *  (When viewDidLoad() occurs, the controller can use the setter to restore last state for instance).
        *
        *  Three main steps occur when one changes this property :
        *  1) update UISlider's values
        *  2) update color preview
        *  3) update slider gradients
        */
        set {
            // 0) assigning the new value
            // 1) Updating slider's values
            self.currentColor = newValue
            
            // 2) updating color preview
            // 3) updating slider's gradients
            self.colorCompositionChanged()
        }
        get {
            let defaultColor = UIColor.black
            if (currentColor==nil){
                return defaultColor
            }
            return self.currentColor!
        }
    }
    
    // MARK: HSB Color Properties
    
    public var hueComponent: Float? {
        get { return Float(self.selectedColor.getHueComponent()) }
        set { self.selectedColor = self.selectedColor.colorWithHueComponent(hue: CGFloat(newValue!)) }
    }
    
    public var saturationComponent: Float? {
        get { return Float(self.selectedColor.getSaturationComponent()) }
        set { self.selectedColor = self.selectedColor.colorWithSaturationComponent(saturation: CGFloat(newValue!)) }
    }
    
    public var brightnessComponent: Float? {
        get { return Float(self.selectedColor.getBrightnessComponent()) }
        set { self.selectedColor = self.selectedColor.colorWithBrightnessComponent(brightness: CGFloat(newValue!)) }
    }
    
    // MARK: RGB Color Properties
    
    public var redComponent: Float? {
        get { return Float(self.selectedColor.getRedComponent()) }
        set { self.selectedColor = self.selectedColor.colorWithRedComponent(red: CGFloat(newValue!)) }
    }
    
    public var greenComponent: Float? {
        get { return Float(self.selectedColor.getGreenComponent()) }
        set { self.selectedColor = self.selectedColor.colorWithGreenComponent(green: CGFloat(newValue!)) }
    }
    
    public var blueComponent: Float? {
        get { return Float(self.selectedColor.getBlueComponent()) }
        set { self.selectedColor = self.selectedColor.colorWithBlueComponent(blue: CGFloat(newValue!)) }
    }
    
    public var alphaComponent: Float? /* {
    set {  }
    get {  }
    } */
    


    // MARK: - UI Components (tweaking them more)
    
    @IBOutlet weak var firstSlider: UISlider?
    @IBOutlet weak var secondSlider: UISlider?
    @IBOutlet weak var thirdSlider: UISlider?
    @IBOutlet weak var forthSlider: UISlider?
    
    
    public weak var hueSlider: UISlider? {
        get { return firstSlider }
        set { firstSlider = newValue }
    }
    public weak var saturationSlider: UISlider? {
        get { return secondSlider }
        set { secondSlider = newValue }
    }
    public weak var brightnessSlider: UISlider? {
        get { return thirdSlider }
        set { thirdSlider = newValue }
    }
    
    @IBOutlet public weak var colorPreviewView: UIView?

    
    @IBOutlet weak var hueGradientView: UIView?
    @IBOutlet weak var saturationGradientView: UIView?
    @IBOutlet weak var brightnessGradientView: UIView?
    
    @IBOutlet private weak var colorCollectionView: UICollectionView?
    
    
    
    // MARK: - Private API -
    
    /** Stockage de la couleur courante dans une variable
     *  Cela permet de jongler facilement entre les différents espaces de couleur.
     */
    private var currentColor: UIColor? {
        didSet {
            // Update slider's values
            
            if colorMode == .RGB || colorMode == .RGBA {
                var r = CGFloat(0), g = CGFloat(0), b = CGFloat(0), a = CGFloat(0)
                currentColor?.getRed(&r, green: &g, blue: &b, alpha: &a
                )
                
                self.sliderAtIndex(0)?.value = Float(r)
                self.sliderAtIndex(1)?.value = Float(g)
                self.sliderAtIndex(2)?.value = Float(b)
                
                if colorMode == .RGBA {
                    self.sliderAtIndex(3)?.value = Float(a)
                }
            }
            else if colorMode == .HSB || colorMode == .HSBA {
                var h = CGFloat(0), s = CGFloat(0), b = CGFloat(0), a = CGFloat(0)
                currentColor?.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
                
                self.sliderAtIndex(0)?.value = Float(h)
                self.sliderAtIndex(1)?.value = Float(s)
                self.sliderAtIndex(2)?.value = Float(b)
                
                if colorMode == .HSBA {
                    self.sliderAtIndex(3)?.value = Float(a)
                }
            }
        }
    }
    
    private func sliderAtIndex(_ index: Int) -> UISlider? {
        switch index {
        case 0:
            return self.firstSlider
        case 1:
            return secondSlider
        case 2:
            return thirdSlider
        case 3:
            return forthSlider
        default:
            return firstSlider
        }
    }
    
    // MARK: View components
    
        //
//    @IBOutlet private weak var hueLabel: UILabel?
//    @IBOutlet private weak var saturationLabel: UILabel?
//    @IBOutlet private weak var brightnessLabel: UILabel?


    
    // MARK: Manipulating sliders
    
    //      Schéma d'affectation des couleurs
    //
    // valeur affectée par le VC (depuis l'extérieur)
    //      -> report value in the view :: hsb,rgb,a,selectedColor properties
    //          -> store value properly (HSB, RGB, ..) :: dans le slider
    //          -> update UI (gradients) :: on colorCompositionChanged
    // valeur affectée par le slider (depuis l'intérieur)
    //      -> store value properly (HSB, RGB, ..) :: dans le slider
    //      -> update UI (gradients) ::
    
    
    // Other paradigm
    @IBAction private func firstSliderChangedValue(slider: UISlider){
        if (self.colorMode == .HSB || self.colorMode == .HSBA) {
            self.hueComponent = slider.value
        } else {
            self.redComponent = slider.value
        }
    }
    
    @IBAction private func secondSliderChangedValue(slider: UISlider){
        if (self.colorMode == .HSB || self.colorMode == .HSBA) {
            self.saturationComponent = slider.value
        } else {
            self.greenComponent = slider.value
        }
    }
    
    @IBAction private func thirdSliderChangedValue(slider: UISlider){
        if (self.colorMode == .HSB || self.colorMode == .HSBA) {
            self.brightnessComponent = slider.value
        } else {
            self.blueComponent = slider.value
        }
    }
    
    @IBAction private func forthSliderChangedValue(slider: UISlider){
        // Only if alpha we want to handle alpha
        if self.colorMode == .HSBA || self.colorMode == .RGBA {
            self.alphaComponent = Float(slider.value)
        }
    }
    
    private func switchToColorMode(colorMode: JMMColorSelectorColorMode){
        // Changement du mode de couleur pour les sliders
        self.colorMode = colorMode;
        
        // straight-forward
        self.resetSlidersValue()
        
        // update the color effects and gradients
        self.colorCompositionChanged()
    }
    
    private func resetSlidersValue() {
        let color = self.selectedColor
        
        if self.colorMode == .RGB || colorMode == .RGBA
        {
            self.firstSlider?.value = Float(color.getRedComponent())
            self.secondSlider?.value = Float(color.getGreenComponent())
            self.thirdSlider?.value = Float(color.getBlueComponent())
        }
        else
        {
            self.firstSlider?.value = Float(color.getHueComponent())
            self.secondSlider?.value = Float(color.getSaturationComponent())
            self.thirdSlider?.value = Float(color.getBrightnessComponent())
        }
        self.forthSlider?.value = Float(color.getAlphaComponent())
    }
    
    
    // MARK: - Processing UI Updates
    
    @IBAction private func colorCompositionChanged() {
        self.updateColorPreview();
        self.updateSlidersUI();
    }
    
    private func updateColorPreview() {
        let hue = self.hueComponent!
        let saturation = self.saturationComponent!
        let brightness = self.brightnessComponent!
        var alpha = Float(1.0)
        
        if let alphaComp = self.alphaComponent {
            alpha = alphaComp
        }
        
        self.colorPreviewView?.backgroundColor = UIColor.init(hue: CGFloat(hue), saturation: CGFloat(saturation), brightness: CGFloat(brightness), alpha: CGFloat(alpha))
    }

    
    private func updateSlidersUI() {
        self.hideTrackColorForSlider(self.hueSlider)
        self.hideTrackColorForSlider(self.saturationSlider)
        self.hideTrackColorForSlider(self.brightnessSlider)
        
        self.setGradientWithColors(self.colorScaleForHue(), toView: self.hueGradientView)
        self.setGradientWithColors(self.colorScaleForSaturation(), toView: self.saturationGradientView)
        self.setGradientWithColors(self.colorScaleForBrightness(), toView: self.brightnessGradientView)
    }
    
    
 
    private func hideTrackColorForSlider(_ slider: UISlider?) {
        let imageMin: UIImage? = slider?.minimumValueImage;
        let imageMax: UIImage? = slider?.maximumValueImage;
        
        slider?.minimumTrackTintColor = UIColor.clear
        slider?.maximumTrackTintColor = UIColor.clear
        
        // restore the icons
        slider?.minimumValueImage = imageMin;
        slider?.maximumValueImage = imageMax;
    }
    
    
    // MARK: - Gradients
    
    private func colorScaleForHue() -> [UIColor] {
        let nbSteps = 15
        var colors = [UIColor]()
        for i in 0 ... nbSteps {
            let d = CGFloat( CGFloat(i) / CGFloat(nbSteps) )
            colors.append(UIColor.init(hue: d, saturation: 1.0, brightness: 1.0, alpha: 1.0))
        }
        return colors
    }
    private func colorScaleForSaturation() -> [UIColor] {
        let nbSteps = 15
        var colors = [UIColor]()
        for i in 0 ... nbSteps {
            let d = CGFloat( CGFloat(i) / CGFloat(nbSteps) )
            colors.append(UIColor.init(hue: CGFloat(self.hueComponent!), saturation: d, brightness: 1.0, alpha: 1.0))
        }
        return colors
    }
    private func colorScaleForBrightness() -> [UIColor] {
        let nbSteps = 3
        var colors = [UIColor]()
        for i in 0 ... nbSteps {
            let d = CGFloat( CGFloat(i) / CGFloat(nbSteps) )
            colors.append(UIColor.init(hue: CGFloat(self.hueComponent!), saturation: 1.0, brightness: d, alpha: 1.0))
        }
        return colors
    }
    
    // MARK: Slider's Gradient Layers
    
    
    private func setGradientWithColors(_ colors: [UIColor], toView view:UIView?) {
        guard let view = view  else {
            return
        }
        
        let sublayer: CAGradientLayer = self.gradientLayerForView(view, withColors:colors);
        
        let oldSublayer: CALayer? = view.layer.sublayers?[0];
        if ( oldSublayer == nil ){
            view.layer.addSublayer(sublayer);
        } else {
            view.layer.replaceSublayer(oldSublayer!, with:sublayer);
        }
    }
    
    private func gradientLayerForView(_ view: UIView, withColors colors:[UIColor]) -> CAGradientLayer {
        let layer: CAGradientLayer = CAGradientLayer.init();
        self.updateGradientLayer(layer, withColors:colors, forView:view);
    
        
        var locations = [NSNumber]();
        
        for i in 0...colors.count {
            let val = CGFloat(CGFloat(1.0) / CGFloat(colors.count - 1) * CGFloat(i));
            let value = NSNumber(value:val)
            locations.append(value)
        }
        
        layer.locations = locations;
        
        layer.startPoint = CGPointMake(0.0, 0.5);
        layer.endPoint = CGPointMake(1.0, 0.5);
        layer.cornerRadius = view.frame.size.height / 2.0;
        return layer;
    }
    
    private func updateGradientLayer(_ gradientLayer: CAGradientLayer, withColors colors:[UIColor], forView view:UIView) -> Void {
        let rect: CGRect = view.bounds;
        gradientLayer.frame = rect;
    
        var cgColors = [CGColor]();
        for color in colors {
            cgColors.append(color.CGColor);
        }
        
        gradientLayer.colors = cgColors;
    }
}



/*

@implementation ColorSelectorView

#pragma mark - Updates -

// API method

#pragma mark - Sliders -

+ (void)drawGradientOverContainer:(UIView *)container
{
UIColor *transBgColor = [UIColor colorWithWhite:1.0 alpha:0.0];
UIColor *black = [UIColor blackColor];
CAGradientLayer *maskLayer = [CAGradientLayer layer];
maskLayer.opacity = 0.8;
maskLayer.colors = [NSArray arrayWithObjects:(id)black.CGColor,
(id)transBgColor.CGColor, (id)transBgColor.CGColor, (id)black.CGColor, nil];

// Hoizontal - commenting these two lines will make the gradient veritcal
maskLayer.startPoint = CGPointMake(0.0, 0.5);
maskLayer.endPoint = CGPointMake(1.0, 0.5);

NSNumber *gradTopStart = [NSNumber numberWithFloat:0.0];
NSNumber *gradTopEnd = [NSNumber numberWithFloat:0.4];
NSNumber *gradBottomStart = [NSNumber numberWithFloat:0.6];
NSNumber *gradBottomEnd = [NSNumber numberWithFloat:1.0];
maskLayer.locations = @[gradTopStart, gradTopEnd, gradBottomStart, gradBottomEnd];

maskLayer.bounds = container.bounds;
maskLayer.anchorPoint = CGPointZero;
[container.layer addSublayer:maskLayer];
}


#pragma mark Slider gradients


private func setGradientLayerForHueSlider() {
let sublayer: CAGradientLayer = self.hueGradientLayer();
if(self.hueGradientView?.layer.sublayers.count == 0){
[self.hueGradientView.layer addSublayer:sublayer];
} else {
oldSublayer: CAGradientLayer = self.hueGradientView?.layer.sublayers.firstObject;
[self.hueGradientView.layer replaceSublayer:oldSublayer with:sublayer];
}
}



#pragma mark Gradients



- (CAGradientLayer *)hueGradientLayer {
NSMutableArray *colorSteps = [[NSMutableArray alloc]init];
NSMutableArray *positionSteps = [[NSMutableArray alloc]init];
int nbrOfSampling = 10;
float babyStep = 1.0 / (float)(nbrOfSampling - 1);
for (int i=0; i < nbrOfSampling ; ++i) {
CGFloat currentHue = i * babyStep;
CGFloat currentPos = currentHue;

[colorSteps addObject:(id)[UIColor colorWithHue:currentHue saturation:1.0 brightness:1.0 alpha:1.0].CGColor];
[positionSteps addObject:[NSNumber numberWithFloat:currentPos]];
}
CAGradientLayer *layer = [CAGradientLayer layer];
layer.frame = self.hueGradientView.frame;

layer.colors = colorSteps;
layer.locations = positionSteps;

layer.startPoint = CGPointMake(0.0, 0.5);
layer.endPoint = CGPointMake(1.0, 0.5);

layer.bounds = self.hueGradientView.bounds;
layer.anchorPoint = CGPointZero;

return layer;
}




#pragma mark - Setups -

- (void)awakeFromNib {
[super awakeFromNib];

//    NSLog(@"%s",__PRETTY_FUNCTION__);
//    [self customInit];

}


- (instancetype)initWithFrame:(CGRect)frame {
self = [super initWithFrame:frame];
//    NSLog(@"%s",__PRETTY_FUNCTION__);
if (self) {
//        [self customInit];
}
return self;
}


@end


*/


