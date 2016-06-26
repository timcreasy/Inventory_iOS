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

class BarcodeFoundViewController: UIViewController {
    
    @IBOutlet var barcodeLabel: UILabel!
    var contents:String = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        barcodeLabel.text = contents;
        
        // Create a reference to a Firebase location
        let rootRef = FIRDatabase.database().reference()
        // Write data to Firebase
        // self.ref.child("users").child(user!.uid).setValue(["username": username])
        //rootRef.updateChildValues(["barcode": contents])
        let key = rootRef.child("inventory").childByAutoId().key
        let newBarcode = ["barcode": contents]
        let childUpdates = ["/inventory/\(key)": newBarcode]
        rootRef.updateChildValues(childUpdates)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}