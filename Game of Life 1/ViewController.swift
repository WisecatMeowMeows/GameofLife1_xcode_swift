//
//  ViewController.swift
//  Game of Life 1
//
//  Created by John Doe on 9/25/14.
//  Copyright (c) 2014 John Doe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var buttonStart: UIButton!
    @IBOutlet weak var viewBox: RenderingViewClass!

    var lastCell: CGPoint? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onButtonPress(sender: AnyObject) {
        //begin cell activity
        viewBox.toggleSimulation()
        
    }

    @IBAction func onTap(sender: UITapGestureRecognizer) {
        let newCell = viewBox.getCell(sender.locationInView(viewBox) )
        
        if (newCell == nil) { return }
        
        viewBox.toggleCell(newCell!)
        
    }
    
    @IBAction func onPan(sender: UIPanGestureRecognizer) {
        
        let newCell = viewBox.getCell(sender.locationInView(viewBox) )
        
        if (newCell == nil) { return }
        
        if (lastCell == nil || lastCell!.x != newCell!.x || lastCell!.y != newCell!.y)
        {
            lastCell = newCell
            viewBox.toggleCell(newCell!)
        }
    }
    
}


