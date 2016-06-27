//
//  BarcodeFoundViewController.swift
//  Inventory
//
//  Created by Tim Creasy on 6/26/16.
//  Copyright © 2016 TC3. All rights reserved.
//

import UIKit
import RSBarcodes_Swift
import Firebase
import FirebaseDatabase
import SwiftyJSON

class BarcodeFoundViewController: UIViewController {
    
    
    
    @IBOutlet var promptLabel: UILabel!
    @IBOutlet var barcodeLabel: UILabel!
    @IBOutlet var addUpdateButton: UIButton!
    @IBOutlet var quantityTextField: UITextField!
    
    
    var productKey:String = "";
    var contents:String = ""
    var barcodeExists:Bool = false;
    
    @IBAction func addUpdateButtonPressed(sender: AnyObject) {
    
        if (barcodeExists) {
            let productRef = FIRDatabase.database().reference().child("inventory").child(productKey);
            let newQuantity = self.quantityTextField.text;
            let newQuantityUpdate = ["quantity": newQuantity!]
            productRef.updateChildValues(newQuantityUpdate);
            self.quantityTextField.text = "";
        } else {
            let inventoryRef = FIRDatabase.database().reference();
            let key = inventoryRef.child("inventory").childByAutoId().key
            let setQuantity = self.quantityTextField.text;
            let newBarcode = ["barcode": self.contents,
                              "quantity": setQuantity!];
            let childUpdates = ["/inventory/\(key)": newBarcode]
            inventoryRef.updateChildValues(childUpdates)
            self.quantityTextField.text = "";
        }
        
        self.loadData();
        
    
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.loadData();
        
    }
    
    func loadData() {
        
        
        barcodeLabel.text = contents;
        
        // Create a reference to a Firebase location
        let rootRef = FIRDatabase.database().reference()
        
        
        // Search through all values in firebase
        rootRef.observeSingleEventOfType(FIRDataEventType.Value, withBlock: { (snapshot) in
            let inventory = JSON(snapshot.value!)
            for (key, subJson) in inventory["inventory"] {
                if let barcode = subJson["barcode"].string {
                    let quantity = subJson["quantity"].string;
                    // Barcode exists
                    if (barcode == self.contents) {
                        
                        let barcodeUpdateString = "Product " + self.contents + " exists!";
                        self.barcodeLabel.text = barcodeUpdateString;
                        self.promptLabel.text = "Current quantity: " + quantity!;
                        self.quantityTextField.placeholder = "Update quantity";
                        self.addUpdateButton.setTitle("Update", forState: .Normal)
                        self.barcodeExists = true;
                        self.productKey = key;
                    }
                    
                }
            }
            
            // Barcode does not exist yet
            if (self.barcodeExists == false) {
                let newBarcodeString = "New product - " + self.contents;
                self.barcodeLabel.text = newBarcodeString;
                self.promptLabel.text = "Set quantity";
                self.quantityTextField.placeholder = "Set quantity";
                self.addUpdateButton.setTitle("Set", forState: .Normal)
            }
            
        })

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}