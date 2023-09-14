//
//  ViewController.swift
//  LatteLarry
//
//  Created by Jacob Harrington on 8/4/23.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tap outside of a textfield to close editing
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
         target: self,
         action: #selector(dismissMyKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    
    @IBAction func doneEditing(_ sender: UITextField) {
        print("-------------DONE EDITING------------------------")
    }
    
    // close TextFields by tap outside
    @objc func dismissMyKeyboard() {
        self.view.endEditing(true)
    }
    
    // close TextFields by return pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        textField.resignFirstResponder()
        return false
    }
}
