import Foundation
import UIKit

public extension UIColor {
	public convenience init(hex: UInt32, alpha: CGFloat = 1) {
		func byteColor(x: UInt32) -> CGFloat {
			return CGFloat(x & 0xFF) / 255
		}
		let red = byteColor(hex >> 16)
		let green = byteColor(hex >> 8)
		let blue = byteColor(hex)
		self.init(red: red, green: green, blue: blue, alpha: alpha)
	}
	public convenience init?(hexString: String, alpha: CGFloat = 1) {
		let regex = try! NSRegularExpression(pattern: "\\A#?([0-9a-f][0-9a-f])([0-9a-f][0-9a-f])([0-9a-f][0-9a-f])\\Z", options: [.CaseInsensitive])
		guard let match = regex.firstMatchInString(hexString, options: [], range: hexString.fullRange) where match.numberOfRanges == 4 else {
			return nil
		}
		let redString = (hexString as NSString).substringWithRange(match.rangeAtIndex(1))
		let greenString = (hexString as NSString).substringWithRange(match.rangeAtIndex(2))
		let blueString = (hexString as NSString).substringWithRange(match.rangeAtIndex(3))
		guard let red = Int(redString, radix: 16), green = Int(greenString, radix: 16), blue = Int(blueString, radix: 16) else {
			return nil
		}
		self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: alpha)
	}
}

public extension UILabel {
	public func useMonospacedNumbers() {
		let fontDescriptor = self.font.fontDescriptor()
		let newFontDescriptor = fontDescriptor.fontDescriptorByAddingAttributes([
			UIFontDescriptorFeatureSettingsAttribute: [[
				UIFontFeatureTypeIdentifierKey: kNumberSpacingType,
				UIFontFeatureSelectorIdentifierKey: kMonospacedNumbersSelector
			]]
		])
		self.font = UIFont(descriptor: newFontDescriptor, size: self.font.pointSize)
	}
}

public extension UIActivityIndicatorView {
	public var animating: Bool {
		get {
			return self.isAnimating()
		}
		set {
			if newValue {
				self.startAnimating()
			} else {
				self.stopAnimating()
			}
		}
	}
}

public extension UITextField {
	@IBInspectable public var placeholderColor: UIColor? {
		get {
			fatalError("Getter for UITextField.placeholderColor is not implemented")
		}
		set {
			if let color = newValue, placeholder = self.placeholder {
				let placeholderAttributes = [NSForegroundColorAttributeName: color]
				attributedPlaceholder = NSAttributedString(string: placeholder, attributes: placeholderAttributes)
			}
		}
	}
}

public extension UIView {
	public func addAndFitSubview(view: UIView) {
		view.translatesAutoresizingMaskIntoConstraints = false
		view.frame = self.bounds
		self.addSubview(view)
		let views = ["view": view]
		self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: [], metrics: nil, views: views))
		self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: [], metrics: nil, views: views))
	}
}

public extension UITableView {
	public func deselectAllRows(animated: Bool) {
		if let indexPaths = self.indexPathsForSelectedRows {
			for indexPath in indexPaths {
				self.deselectRowAtIndexPath(indexPath, animated: animated)
			}
		}
	}
}

public extension UICollectionView {
	public func deselectAllRows(animated: Bool) {
		if let indexPaths = self.indexPathsForSelectedItems() {
			for indexPath in indexPaths {
				self.deselectItemAtIndexPath(indexPath, animated: animated)
			}
		}
	}
}

public extension UIImage {
	public static func draw(size size: CGSize, opaque: Bool = false, scale: CGFloat = 0, graphics: CGContextRef -> Void) -> UIImage {
		var image: UIImage?
		autoreleasepool {
			UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
			graphics(UIGraphicsGetCurrentContext()!)
			image = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
		}
		return image!
	}

	public func imageWithAlpha(alpha: CGFloat) -> UIImage {
		let rect = CGRect(origin: .zero, size: self.size)
		let image = UIImage.draw(size: self.size, opaque: false, scale: self.scale) { _ in
			self.drawInRect(rect, blendMode: .Normal, alpha: alpha)
		}
		return image.resizableImageWithCapInsets(self.capInsets, resizingMode: self.resizingMode).imageWithRenderingMode(self.renderingMode)
	}

	public func imageTintedWithColor(color: UIColor) -> UIImage {
		let image = UIImage.draw(size: self.size, scale: self.scale) { _ in
			color.setFill()
			UIRectFill(CGRect(origin: .zero, size: self.size))
			self.drawAtPoint(.zero, blendMode: .DestinationIn, alpha: 1)
		}
		return image.resizableImageWithCapInsets(self.capInsets, resizingMode: self.resizingMode).imageWithRenderingMode(self.renderingMode)
	}
}