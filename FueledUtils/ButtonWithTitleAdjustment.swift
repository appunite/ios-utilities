/*
Copyright 2017 Fueled Digital Media, LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
import UIKit

open class ButtonWithTitleAdjustment: UIButton {
	@IBInspectable public var adjustmentLineSpacing: CGFloat = 0 {
		didSet {
			self.updateAdjustedTitles()
		}
	}

	@IBInspectable public var adjustmentKerning: CGFloat = 0 {
		didSet {
			self.updateAdjustedTitles()
		}
	}

	override public init(frame: CGRect) {
		super.init(frame: frame)
		self.updateAdjustedTitles()
	}

	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.updateAdjustedTitles()
	}

	override open func setTitleColor(_ color: UIColor?, for state: UIControlState) {
		super.setTitleColor(color, for: state)
		self.updateAdjustedTitles()
	}

	override open func setTitle(_ title: String?, for state: UIControlState) {
		super.setTitle(title, for: state)
		self.updateAdjustedTitles()
	}

	private func updateAdjustedTitles() {
		let states: [UIControlState] = [.normal, .highlighted, .selected, .disabled, [.selected, .highlighted], [.selected, .disabled]]
		for state in states {
			self.setAdjustedTitle(self.title(for: state), for: state)
		}
	}

	private func setAdjustedTitle(_ title: String?, for state: UIControlState) {
		let adjustedString = title.map { title -> NSAttributedString in
			let paragraphStyle = NSMutableParagraphStyle()
			paragraphStyle.lineSpacing = self.adjustmentLineSpacing
			var attributes: [String : Any] = [
				NSParagraphStyleAttributeName: paragraphStyle,
				NSKernAttributeName: self.adjustmentKerning,
			]
			if let titleColor = self.titleColor(for: state) {
				attributes[NSForegroundColorAttributeName] = titleColor
			}
			return NSAttributedString(string: title, attributes: attributes)
		}
		self.setAttributedTitle(adjustedString, for: state)
	}
}
