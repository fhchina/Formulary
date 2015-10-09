//
//  TextEntry.swift
//  Formulary
//
//  Created by Fabian Canas on 1/17/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import Foundation

//MARK: Sub-Types

public enum TextEntryType: String {
    case Plain     = "Formulary.Plain"
    case Number    = "Formulary.Number"
    case Decimal   = "Formulary.Decimal"
    case Email     = "Formulary.Email"
    case Twitter   = "Formulary.Twitter"
    case URL       = "Formulary.URL"
    case WebSearch = "Formulary.WebSearch"
    case Phone     = "Formulary.Phone"
    case NamePhone = "Formulary.PhoneName"
}

private let KeyMap :[TextEntryType : UIKeyboardType] = [
    TextEntryType.Plain     : UIKeyboardType.Default,
    TextEntryType.Number    : UIKeyboardType.NumberPad,
    TextEntryType.Decimal   : UIKeyboardType.DecimalPad,
    TextEntryType.Email     : UIKeyboardType.EmailAddress,
    TextEntryType.Twitter   : UIKeyboardType.Twitter,
    TextEntryType.URL       : UIKeyboardType.URL,
    TextEntryType.WebSearch : UIKeyboardType.WebSearch,
    TextEntryType.Phone     : UIKeyboardType.PhonePad,
    TextEntryType.NamePhone : UIKeyboardType.NamePhonePad,
]

//MARK: Form Row

public class TextEntryFormRow : FormRow, FormularyComponent {
    public let textType: TextEntryType
    public let formatter: NSFormatter?
    
    override public var cellIdentifier :String {
        get {
            return textType.rawValue
        }
    }
    
    static var registrationToken :Int = 0
    
    public init(name: String, tag: String, textType: TextEntryType = .Plain, value: AnyObject? = nil, validation: Validation = PermissiveValidation, formatter: NSFormatter? = nil, action: Action? = nil) {
        
        dispatch_once(&TextEntryFormRow.registrationToken, { () -> Void in
            registerFormularyComponent(TextEntryFormRow.self)
        })
        
        self.textType = textType
        self.formatter = formatter
        super.init(name: name, tag: tag, type: .Specialized, value: value, validation: validation, action: action)
    }
    
    public static func cellRegistration() -> [String : AnyClass] {
        return [
            TextEntryType.Plain.rawValue : TextEntryCell.self,
            TextEntryType.Number.rawValue : TextEntryCell.self,
            TextEntryType.Decimal.rawValue : TextEntryCell.self,
            TextEntryType.Email.rawValue : TextEntryCell.self,
            TextEntryType.Twitter.rawValue : TextEntryCell.self,
            TextEntryType.URL.rawValue : TextEntryCell.self,
            TextEntryType.WebSearch.rawValue : TextEntryCell.self,
            TextEntryType.Phone.rawValue : TextEntryCell.self,
            TextEntryType.NamePhone.rawValue : TextEntryCell.self,
        ]
    }
}

//MARK: Cell

class TextEntryCell: UITableViewCell, FormTableViewCell {
    
    var configured: Bool = false
    var action :Action?
    
    var textField :NamedTextField?
    var formatterAdapter : FormatterAdapter?
    
    var formRow :FormRow? {
        didSet {
            if var formRow = formRow as? TextEntryFormRow {
                configureTextField(&formRow).keyboardType = KeyMap[formRow.textType]!
            }
            selectionStyle = .None
        }
    }
    
    func configureTextField(inout row: TextEntryFormRow) -> UITextField {
        if (textField == nil) {
            let newTextField = NamedTextField(frame: contentView.bounds)
            newTextField.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(newTextField)
            textField = newTextField
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[textField]-|", options: [], metrics: nil, views: ["textField":newTextField]))
            textField = newTextField
        }
        formatterAdapter = row.formatter.map { FormatterAdapter(formatter: $0) }
        
        textField?.text = row.value as? String
        textField?.placeholder = row.name
        textField?.validation = row.validation
        textField?.delegate = formatterAdapter
        textField?.enabled = row.enabled
        
        if let field = textField {
            clear(field, controlEvents: .EditingChanged)
            bind(field, controlEvents: .EditingChanged, action: { _ in
                row.value = field.text
            })
        }
        
        configured = true
        return textField!
    }
}
