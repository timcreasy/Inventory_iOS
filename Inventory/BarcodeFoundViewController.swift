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
    
    @IBOutlet var barcodeLabel: UILabel!
    @IBOutlet var promptLabel: UILabel!
    
    @IBOutlet var quantityTextField: UITextField!
    @IBAction func inventoryButton(sender: AnyObject) {
        
        
    }
    @IBOutlet var addUpdateButton: UIButton!
    
    
    var contents:String = ""
    var barcodeExists:Bool = false;

    var inventoryArray: [String] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        barcodeLabel.text = contents;
        
        // Create a reference to a Firebase location
        let rootRef = FIRDatabase.database().reference()
        // Write data to Firebase
        // self.ref.child("users").child(user!.uid).setValue(["username": username])
        //rootRef.updateChildValues(["barcode": contents])
//        let key = rootRef.child("inventory").childByAutoId().key
//        let newBarcode = ["barcode": contents]
//        let childUpdates = ["/inventory/\(key)": newBarcode]
//        rootRef.updateChildValues(childUpdates)
        
        rootRef.observeSingleEventOfType(FIRDataEventType.Value, withBlock: { (snapshot) in
        //rootRef.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            let inventory = JSON(snapshot.value!)
            for (key, subJson) in inventory["inventory"] {
                if let barcode = subJson["barcode"].string {
                    print("barcode", barcode);
                    print("self.contents", self.contents);
                    // Barcode exists
                    if (barcode == self.contents) {

                        let barcodeUpdateString = "Product " + self.contents + " exists!";
                        self.barcodeLabel.text = barcodeUpdateString;
                        self.promptLabel.text = "Update quantity below";
                        self.quantityTextField.placeholder = "Update quantity";
                        self.addUpdateButton.setTitle("Update", forState: .Normal)
                        self.barcodeExists = true;
                    }
//                    print(barcode)
//                    print(key);
//                    self.inventoryArray.append(barcode);
                }
            }
            
            // Barcode does not exist yet
            if (self.barcodeExists == false) {
                let newBarcodeString = "New product - " + self.contents;
                self.barcodeLabel.text = newBarcodeString;
                self.promptLabel.text = "Set quantity";
                self.quantityTextField.placeholder = "Set quantity";
                self.addUpdateButton.setTitle("Set", forState: .Normal)
                let key = rootRef.child("inventory").childByAutoId().key
                let newBarcode = ["barcode": self.contents]
                let childUpdates = ["/inventory/\(key)": newBarcode]
                rootRef.updateChildValues(childUpdates)
            }

        })


        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}