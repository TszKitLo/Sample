import UIKit
import pop


class Card: UITableViewCell {
    
    @IBOutlet weak var insideView: UIView!
    @IBOutlet weak var label: UILabel!
    
    @IBInspectable var cornerRadius: CGFloat = 3.0 {
        didSet {
            self.insideView.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.8 {
        didSet {
            self.insideView.layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 3.0 {
        didSet {
            self.insideView.layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSizeMake(0.0, 2.0) {
        didSet {
            self.insideView.layer.shadowOffset = shadowOffset
        }
    }
    
    @IBInspectable var shadowColor: CGColor = UIColor(red: 157.0/255.0, green: 157.0/255.0, blue: 157.0/255.0, alpha: 1.0).CGColor {
        didSet {
            self.insideView.layer.shadowColor = shadowColor
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
        self.insideView.layer.cornerRadius = cornerRadius
        self.insideView.layer.shadowOpacity = shadowOpacity
        self.insideView.layer.shadowRadius = shadowRadius
        self.insideView.layer.shadowOffset = shadowOffset
        self.insideView.layer.shadowColor = shadowColor
        self.setNeedsLayout()
    }
    
//    override func setSelected(selected: Bool, animated: Bool) {
//        if self.selected {
//            insideView.backgroundColor = UIColor.grayColor()
//        } else {
//            insideView.backgroundColor = UIColor.whiteColor()
//        }
//    }
}
