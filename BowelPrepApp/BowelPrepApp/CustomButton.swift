import UIKit
import pop

@IBDesignable

class CustomButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 3.0 {
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var fontColor: UIColor = UIColor.whiteColor() {
        didSet {
            self.tintColor = fontColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.blackColor() {
        didSet {
            self.layer.borderColor = borderColor.CGColor
        }
    }

    @IBInspectable var bottomShadowHeight: CGFloat = 5.0 {
        didSet{
            //set shadow to make it look like a pop-up button
            self.layer.shadowColor = UIColor(red: 67/255, green: 96/225, blue:179/255, alpha: 1).CGColor
            self.layer.shadowOffset =  CGSizeMake(0,bottomShadowHeight)
            self.layer.masksToBounds = false
            self.layer.shadowOpacity = 1.0
            self.layer.shadowRadius = 0
            self.layer.cornerRadius = 3
        }
    }
//    @IBInspectable var shadowColor: UIColor? = UIColor(red: 67/255, green: 96/225, blue:179/255, alpha: 1){
//        didSet{
//            self.layer.shadowColor = shadowColor?.CGColor
//        }
//    }
//    @IBInspectable var shadowOffset: CGSize = CGSizeMake(0, 5.0){
//        didSet{
//            self.layer.shadowOffset = shadowOffset
//        }
//    }
//    @IBInspectable var masksToBounds: Bool = false{
//        didSet{
//            self.layer.masksToBounds = masksToBounds
//        }
//    }
//    @IBInspectable var shadowOpacity: Float = 1.0{
//        didSet{
//            self.layer.shadowOpacity = shadowOpacity
//        }
//    }
//    @IBInspectable var shadowRadius: CGFloat = 0.0{
//        didSet{
//            self.layer.shadowRadius = shadowRadius
//        }
//    }
    
//    @IBInspectable var isPopUpDesign: Bool = false{
//        didSet{
//            if isPopUpDesign == false{
//                //add shadow design to make the pop-up looking button
//                self.layer.shadowColor = shadowColor?.CGColor
//                self.layer.shadowOffset =  shadowOffset
//                self.layer.masksToBounds = masksToBounds
//                self.layer.shadowOpacity = shadowOpacity
//                self.layer.shadowRadius = shadowRadius
//                self.layer.cornerRadius = cornerRadius
//            }
//        }
//    }
    @IBInspectable var ovalShape: Bool = false {
        didSet {
            setShape(ovalShape)
        }
    }
    
    @IBInspectable var centerText: Bool = false {
        didSet {
            setTextAlignment(centerText)
        }
    }
    
    func setShape(ovalShape: Bool) {
        if ovalShape {
            self.layer.cornerRadius = self.layer.bounds.height / 2
        } else {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    func setTextAlignment(centerText: Bool) {
        if centerText {
            self.titleLabel?.textAlignment = .Center
        } else {
            self.titleLabel?.textAlignment = .Left
        }
    }
    
    override func awakeFromNib() {
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    func setupView() {
        self.setShape(ovalShape)
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.CGColor
//        self.isPopUpDesign = false
        //add animations to each control events
        self.addTarget(self, action: #selector(CustomButton.scaleToSmall), forControlEvents: .TouchDown)
        self.addTarget(self, action: #selector(CustomButton.scaleToSmall), forControlEvents: .TouchDragEnter)
        self.addTarget(self, action: #selector(CustomButton.scaleAnimation), forControlEvents: .TouchUpInside)
        self.addTarget(self, action: #selector(CustomButton.scaleToDefault), forControlEvents: .TouchDragExit)
    }
     
    func scaleToSmall() {
        let scaleAnim = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnim.toValue = NSValue(CGSize: CGSizeMake(0.95, 0.95))
        self.layer.pop_addAnimation(scaleAnim, forKey: "layerScaleSmallAnimation")
    }
    
    func scaleAnimation() {
        let scaleAnim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnim.velocity = NSValue(CGSize: CGSizeMake(3.0, 3.0))
        scaleAnim.toValue = NSValue(CGSize: CGSizeMake(1.0, 1.0))
        scaleAnim.springBounciness = 18
        self.layer.pop_addAnimation(scaleAnim, forKey: "layerScaleSpringAnimation")
    }
    
    func scaleToDefault() {
        let scaleAnim = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnim.toValue = NSValue(CGSize: CGSizeMake(1.0, 1.0))
        self.layer.pop_addAnimation(scaleAnim, forKey: "layerScaleDefaultAnimation")
    }
}
