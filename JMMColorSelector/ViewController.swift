//
//  ViewController.swift
//  JMMColorSelector
//
//  Created by jeffrey.mvutu@gmail.com on 26.10.15.
//  Copyright (c) 2015 Jeffrey Mvutu Mabilama. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showColorSelector() {
        let colorSelectorVC = JMMColorSelectorViewController.init(nibName: "JMMColorSelectorView", bundle: nil)
        self.presentViewController(colorSelectorVC, animated: true, completion: nil)
    }
    
}

