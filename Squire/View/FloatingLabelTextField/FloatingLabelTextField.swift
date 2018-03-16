//
//  FloatingLabelTextField.swift
//  Parkit
//
//  Created by INX on 7/13/17.
//  Copyright © 2017 Ionixx. All rights reserved.
//

import SkyFloatingLabelTextField

@IBDesignable class FloatingLabelTextField: SkyFloatingLabelTextField , UITextFieldDelegate {

    
    private var textChangeHandler : ((String)->Bool)?
    private var textEndEditingHandler : ((String)->Bool)?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
     }
    
    /**mm
     Intialzies the control by deserializing it
     - parameter coder the object to deserialize the control from
     */
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        self.expression = "[a-zA-Z]"
        self.delegate = self
     }
    
    public func textDidChange(_ handler:  @escaping (String)->Bool) {
        self.textChangeHandler = handler
    }
    public func textEndEditing(_ handler:  @escaping (String)->Bool) {
        self.textEndEditingHandler = handler
    }
    public func invokeValidation()->Bool{
        if let handler = self.textChangeHandler {
           return handler(self.text ?? "")
        }
        fatalError("textChangeHandler is not implemented")
    }
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let result = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string

        if let handler = self.textChangeHandler {
            return handler(result)
        }
        
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let handler = self.textEndEditingHandler {
            return handler(textField.text ?? "")
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         textField.resignFirstResponder()
        return true
    }
    

}


