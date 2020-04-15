//
//  AndesTextField.swift
//  AndesUI
//
//  Created by Martin Damico on 10/03/2020.
//

import UIKit

@objc public class AndesTextField: UIView {
    internal var contentView: AndesTextFieldView!

    /// The state of an AndesTextfield defines its behaviours an colours.
    @objc public var state: AndesTextFieldState = .idle {
        didSet {
            self.updateContentView()
        }
    }

    /// Text for the label of the textfield
    @IBInspectable public var label: String? {
        didSet {
            self.updateContentView()
        }
    }

    /// Sets the helper label text
    @IBInspectable public var helper: String? {
        didSet {
            self.updateContentView()
        }
    }

    /// if 0, its unlimited, anything else its the limit of chars the user can input.
    @IBInspectable public var counter: UInt16 = 0 {
        didSet {
            self.updateContentView()
        }
    }

    /// sets the placeholder label text.
    @IBInspectable public var placeholder: String? {
        didSet {
            self.updateContentView()
        }
    }

    /// sets the left component, only supperted for simple TextField
    @objc public var leftContent: AndesTextFieldLeftComponent? {
        didSet {
            self.updateContentView()
        }
    }

    /// sets the right component, only supperted for simple TextField
    @objc public var rightContent: AndesTextFieldRightComponent? {
        didSet {
            self.updateContentView()
        }
    }

    /// Use the predefined text input traits, if you need more customization, use setCustomInputTraits
    @objc public var textInputTraits: AndesTextFieldInputTraits = .custom {
        didSet {
            guard textInputTraits != .custom else {
                return
            }
            inputTraits = AndesTextInputTraitsFactory.getTraits(for: textInputTraits)
        }
    }

    /// returns the current text
    @IBInspectable public var text: String {
        get { return contentView.text }
        set { contentView.text = newValue }
    }

    @objc public weak var delegate: AndesTextFieldDelegate?

    internal private(set) var inputTraits: UITextInputTraits? {
        didSet {
            self.updateContentView()
        }
    }

    internal private(set) var isEditing: Bool = false

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @objc public init(state: AndesTextFieldState, labelText: String?, helperText: String?, counter: UInt16, placeholderText: String?) {
        super.init(frame: .zero)
        self.label = labelText
        self.helper = helperText
        self.placeholder = placeholderText
        self.counter = counter
        self.state = state
        setup()
    }

    private func drawContentView(with newView: AndesTextFieldAbstractView) {
        self.contentView = newView
        contentView.delegate = self
        addSubview(contentView)
        leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }

    /// Check if view needs to be redrawn, and then update it. This method should be called on all modifiers that may need to change which internal view should be rendered
    private func reDrawContentViewIfNeededThenUpdate() {
        let newView = provideView()
        if Swift.type(of: newView) !== Swift.type(of: contentView) {
            contentView.removeFromSuperview()
            drawContentView(with: newView)
        }
        updateContentView()
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        drawContentView(with: provideView())
    }

    private func updateContentView() {
        let config = AndesTextFieldViewConfigFactory.provideInternalConfig(from: self)
        contentView.update(withConfig: config)
    }

    @objc public func setCustomInputTraits(_ traits: UITextInputTraits) {
        self.inputTraits = traits
        self.textInputTraits = .custom
    }

    /// Should return a view depending on which textfield variant is selected
    private func provideView() -> AndesTextFieldAbstractView {
        let config = AndesTextFieldViewConfigFactory.provideInternalConfig(from: self)
        return AndesTextFieldDefaultView(withConfig: config)
    }
}

extension AndesTextField: AndesTextFieldViewDelegate {
    func shouldBeginEditing() -> Bool {
        return delegate?.andesTextFieldShouldBeginEditing?(self) != false
    }

    func shouldEndEditing() -> Bool {
        return delegate?.andesTextFieldShouldEndEditing?(self) != false
    }

    func textField(shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return delegate?.andesTextField?(self, shouldChangeCharactersIn: range, replacementString: string)  != false
    }

    func didChangeSelection(selectedRange range: UITextRange?) {
        delegate?.andesTextFieldDidChangeSelection?(self, selectedRange: range)
    }

    func didBeginEditing() {
        isEditing = true
        updateContentView()
        delegate?.andesTextFieldDidBeginEditing?(self)
    }

    func didEndEditing(text: String) {
        isEditing = false
        updateContentView()
        delegate?.andesTextFieldDidEndEditing?(self)
    }

    func didChange() {
        delegate?.andesTextFieldDidChange?(self)
    }

    func didTapRightAction() {
        delegate?.andesTextFieldDidTapRightAction?(self)
    }
}

// MARK: - IB Enum Adapters
public extension AndesTextField {
    @available(*, unavailable, message: "This property is reserved for Interface Builder. Use 'state' instead.")
    @IBInspectable var ibState: String {
        set(val) {
            self.state = AndesTextFieldState.checkValidEnum(property: "IB State", key: val)
        }
        get {
            return ""
        }
    }
}
