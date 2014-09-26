//
//  renderingviewclass.swift
//  Game of Life 1
//
//  Created by John Doe on 9/25/14.
//  Copyright (c) 2014 John Doe. All rights reserved.
//

import Foundation
import UIKit

class RenderingViewClass: UIView {
    
    var gridData = [[Bool]]()
    let CELLSIZE = 5
    var ROWSIZE = 0, COLSIZE = 0
    
    var timer =  NSTimer()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        COLSIZE = Int(self.frame.width) / CELLSIZE
        ROWSIZE = Int(self.frame.height) / CELLSIZE
        gridData = createGridArray()

    }
    
    func createGridArray(arrayToClone: ([[Bool]])? = nil ) -> [[Bool]] {
        var tempGridData = [[Bool]]()
        
        for var row=0; row<ROWSIZE; row++ {
            
            tempGridData.append([Bool](count:COLSIZE, repeatedValue: false ) )
            
            if arrayToClone == nil {
                for var col = 0; col<COLSIZE; col++ {
                    tempGridData[row][col] = (row % 2 == 0) ^ (col % 2 == 0)
                }
            } else {
                for var col = 0; col<COLSIZE; col++ {
                tempGridData[row][col] = arrayToClone![row][col]
                }
            }
        }
    return tempGridData
    }
    
    override func drawRect(rect: CGRect) {  //BIG RECT overall view, not the small rectangular cells. AUTOMATICALLY CALLED by OS
        
        let context = UIGraphicsGetCurrentContext()
        
    /*    CGContextSetRGBStrokeColor(context,  1.0, 0, 0, 1.0)
        CGContextMoveToPoint(context, 5.0, 12.0)
        CGContextAddLineToPoint(context, 10.0, 24.0)
        CGContextStrokePath(context) */
        
       CGContextSetRGBFillColor(context, 1.0, 0, 0, 1.0)
       
        for var row=0; row<ROWSIZE; row++ {
            for var col = 0; col<COLSIZE; col++ {
                
                if (gridData[row][col]) {
                let thiscell = CGRect(x: col*CELLSIZE, y: row*CELLSIZE, width:CELLSIZE, height:CELLSIZE)
                
                CGContextFillRect(context, thiscell)
                }
            }
        }
    }
    
    func getCell(currentCoord: CGPoint) -> CGPoint? {
        let x = Int(currentCoord.x)/CELLSIZE
        let y = Int(currentCoord.y)/CELLSIZE
        if x > ROWSIZE - 1 || y > COLSIZE - 1 || x < 0 || y < 0 { return nil}

        return CGPoint(x: x, y: y)
    }
    
    func toggleCell(cell: CGPoint) {
        let row = Int(cell.y)
        let col = Int(cell.x)
        if col > ROWSIZE - 1 || row > COLSIZE - 1 || col < 0 || row < 0 { return}
        
        gridData[row][col] = !gridData[row][col]
        setNeedsDisplay()  //re-renders the viewbox
    }
    
    func getNeighbors(cell: CGPoint) -> [Bool]
    {
        var neighbors = [Bool]()
        
        for rowDelta in -1...1
        {
            for colDelta in -1...1
            {
                if rowDelta == 0 && colDelta == 0 { continue } //skip this iteration
                let row = Int(cell.y) + rowDelta
                let col = Int(cell.x) + colDelta

                if row >= 0 && col >= 0 && row < ROWSIZE && col < COLSIZE
                {
                    neighbors.append(gridData[row][col])
                }
            }
        }
        
        return neighbors
    }
    
    func countNeighbors(cell: CGPoint, alive: Bool = true) -> Int
    {
        return getNeighbors(cell).reduce(0,
          { $0 + (!($1 ^ alive) ? 1 : 0) })
    }
    
    func runSimulationTic()
    {
        var gridTemp = createGridArray(arrayToClone: gridData)
        
        for var row=0; row<ROWSIZE; row++ {
            for var col = 0; col<COLSIZE; col++ {
/*
Any live cell with fewer than two live neighbours dies, as if caused by under-population.
Any live cell with two or three live neighbours lives on to the next generation.
Any live cell with more than three live neighbours dies, as if by overcrowding.
Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
*/
                let numNeighbors = countNeighbors(CGPoint(x: col,y: row) )
             
                if numNeighbors < 2
                {
                    gridTemp[row][col] = false
                }
                else if numNeighbors == 3
                {
                    if gridData[row][col] == false
                    {
                        gridTemp[row][col] = true
                    }
                }
                else if numNeighbors > 3
                {
                    gridTemp[row][col] = false
                }

            }
        }
        
        gridData = gridTemp  //copy over from our clone "buffer"
    }
    
    func runSimulationTicAndRender()
    {
        runSimulationTic()
        setNeedsDisplay()
    }
    
    func toggleSimulation()
    {
        if (timer.valid)
        {
            timer.invalidate()
        }
        else
        {
            timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("runSimulationTicAndRender"), userInfo: nil, repeats: true)
            timer.fire()
        }
    }
}