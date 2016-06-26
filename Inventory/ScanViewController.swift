//
//  ScanViewController.swift
//  Inventory
//
//  Created by Tim Creasy on 6/26/16.
//  Copyright © 2016 TC3. All rights reserved.
//

import UIKit
import RSBarcodes_Swift

class ScanViewController: RSCodeReaderViewController {
    
    var barcode: String = ""
    var dispatched: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.focusMarkLayer.strokeColor = UIColor.redColor().CGColor
        
        self.cornersLayer.strokeColor = UIColor.yellowColor().CGColor
        
        self.tapHandler = { point in
            print(point)
        }
        
        //isCrazyMode = true;
        //isCrazyModeStarted = true;
        
        self.barcodesHandler = { barcodes in
            if !self.dispatched { // triggers for only once
                self.dispatched = true
                for barcode in barcodes {
                    self.barcode = barcode.stringValue
                    print("Barcode found: type=" + barcode.type + " value=" + barcode.stringValue)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.performSegueWithIdentifier("barcodeView", sender: self)
                        
                        // MARK: NOTE: Perform UI related actions here.
                    })
                }
            }
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        self.dispatched = false // reset the flag so user can do another scan
        
        super.viewWillAppear(animated);
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //        self.navigationController?.navigationBarHidden = false
        //
        if segue.identifier == "barcodeView" {
            let destinationVC = segue.destinationViewController as! BarcodeFoundViewController
            destinationVC.contents = self.barcode
            
        }
    }
}