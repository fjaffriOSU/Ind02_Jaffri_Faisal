//
//  ViewController.swift
//  Ind02_Jaffri_Faisal
//
//  Created by Faisal Jaffri on 2/21/22.
//

import UIKit

class ViewController: UIViewController {
    var imageViews: [UIImageView] = []
    var imageViewsCurrentState: [UIImageView] = []
    var originalState: [CGPoint] = []
    var cgPoints: [CGPoint] = []
    var currState: [CGPoint] = []
    var emptyTile:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var xMid = 67
        var yMid = 200
        var x = 1
        for _ in 0...4{
            for _ in 0...3{
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction))
                let imgview = UIImageView(frame: CGRect(x: xMid, y: yMid, width: 93, height: 93))
                imgview.image = UIImage(named: String(x)+".png")
                originalState.append(imgview.center)
                let centrePoint: CGPoint = CGPoint(x: xMid, y: yMid)
                cgPoints.append(centrePoint)
                imgview.center = centrePoint
                imgview.addGestureRecognizer(tapRecognizer)
                imgview.isUserInteractionEnabled = true
                imageViews.append(imgview)
                view.addSubview(imgview)
                xMid += 93
                x = x+1
            }
            xMid = 67
            yMid += 93
            
            
        }
        imageViewsCurrentState = imageViews
        emptyTile = imageViews[0]
    }
    
    @objc func tapAction(_ sender: UITapGestureRecognizer){
        if (sender.view != emptyTile){
            
            let result:Cordinates = getCordinates(sender.view as! UIImageView)
            let currImage = sender.view?.frame.origin
            if (result.IsValid){
                let i:Int = imageViewsCurrentState.firstIndex(of: emptyTile)!
                let j:Int = imageViewsCurrentState.firstIndex(of: sender.view as! UIImageView)!
                let temp = emptyTile.frame.origin
                emptyTile.frame.origin = currImage!
                sender.view?.frame.origin = temp
                UIView.transition(with: sender.view!, duration: 0.25, options: .transitionFlipFromLeft, animations: { [self] in (sender.view! as! UIImageView).image = (sender.view! as! UIImageView).image}, completion: nil)
                imageViewsCurrentState.swapAt(i, j)
                //print(isPuzzleSolved())
                if(is_puzzle_solved()){
                    
                    
                    // Create new Alert
                    var dialogMessage = UIAlertController(title: "Solved", message: "You are a genius", preferredStyle: .alert)
                    
                    // Create OK button with action handler
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                     })
                    
                    //Add OK button to a dialog message
                    dialogMessage.addAction(ok)
                    // Present Alert to
                    self.present(dialogMessage, animated: true, completion: nil)
                }
                 
            }
            
        }
    }
    
    func getCordinates(_ view: UIImageView) -> Cordinates{
        
        print(view.frame)
        print(view.center)
        print(view.frame.origin)
        
        let currentTile_xPosition = view.frame.origin.x
        let currentTile_yPosition = view.frame.origin.y
        
        
        
        let leftTile_xPosition = currentTile_xPosition-93
        let leftTile_yPosition = currentTile_yPosition
        
        let rightTile_xPosition = currentTile_xPosition+93
        let rightTile_yPosition = currentTile_yPosition
        
        let upTile_xPosition = currentTile_xPosition
        let upTile_yPosition = currentTile_yPosition-93
        
        let downTile_xPosition = currentTile_xPosition
        let downTile_yPosition = currentTile_yPosition+93
        
        if (leftTile_xPosition == emptyTile.frame.origin.x && leftTile_yPosition == emptyTile.frame.origin.y){
            return Cordinates(x: leftTile_xPosition, y: leftTile_yPosition, IsValid: true)
        }
        if (rightTile_xPosition == emptyTile.frame.origin.x && rightTile_yPosition == emptyTile.frame.origin.y){
            return Cordinates(x: rightTile_xPosition, y: rightTile_yPosition, IsValid: true)
        }
        if (upTile_xPosition == emptyTile.frame.origin.x && upTile_yPosition == emptyTile.frame.origin.y){
            return Cordinates(x: upTile_xPosition, y: upTile_yPosition, IsValid: true)
        }
        if (downTile_xPosition == emptyTile.frame.origin.x && downTile_yPosition == emptyTile.frame.origin.y){
            return Cordinates(x: downTile_xPosition, y: downTile_yPosition, IsValid: true)
        }
        return Cordinates(x: downTile_xPosition, y: downTile_yPosition, IsValid: false)
        
        
    }
    func do_valid_shuffle() -> UIImageView{
        
        var validTiles:[UIImageView] = []
        let emptyTile_xPosition = emptyTile.frame.origin.x
        let emptyTile_yPosition = emptyTile.frame.origin.y
        
        let leftTile_Position = CGPoint(x: emptyTile_xPosition-93, y: emptyTile_yPosition)
        let rightTile_Position = CGPoint(x: emptyTile_xPosition+93, y: emptyTile_yPosition)
        let upTile_Position = CGPoint(x: emptyTile_xPosition, y: emptyTile_yPosition-93)
        let downTile_Position = CGPoint(x: emptyTile_xPosition, y: emptyTile_yPosition+93)
        for index in 0...imageViews.count-1{
            
            if (imageViews[index].frame.origin == leftTile_Position || imageViews[index].frame.origin == rightTile_Position ||
                imageViews[index].frame.origin == upTile_Position || imageViews[index].frame.origin == downTile_Position)
            {
                validTiles.append(imageViews[index])
                
            }
        }
        let elem = validTiles.randomElement()!
        
        if (elem.frame.origin == leftTile_Position){
            print("left")
        }
        if (elem.frame.origin  == rightTile_Position){
            print("right")
        }
        if (elem.frame.origin  == upTile_Position){
            print("up")
        }
        if (elem.frame.origin  == downTile_Position){
            print("down")
        }
        
        return elem
        
        
    }
    
    @IBAction func doShuffle(_ sender: Any) {
        var randomShuffleCount = Int.random(in: 10..<25)
        print(randomShuffleCount)
        while(randomShuffleCount>0){
            let curr_tile = do_valid_shuffle()
            let i:Int = imageViewsCurrentState.firstIndex(of: emptyTile)!
            let j:Int = imageViewsCurrentState.firstIndex(of: curr_tile)!
            let temp = emptyTile.frame.origin
            emptyTile.frame.origin = curr_tile.frame.origin
            curr_tile.frame.origin = temp
            imageViewsCurrentState.swapAt(i, j)
            randomShuffleCount -= 1

            
        }
        
    }
    
    func saveCurrentState(){
        for i in 0...imageViewsCurrentState.count-1{
            currState.append(imageViewsCurrentState[i].center)
        }
        
    }
    
    @IBAction func showAnswer(_ sender: UIButton) {
        if (sender.titleLabel?.text == "Show Answer"){
            saveCurrentState()
            
            for i in 0...imageViews.count-1{
                imageViews[i].center = cgPoints[i]
            }
            sender.setTitle("Hide", for: .normal)
        }
        else if(sender.titleLabel?.text == "Hide"){
            for i in 0...imageViews.count-1{
                imageViewsCurrentState[i].center = currState[i]
            }
            sender.setTitle("Show Answer", for: .normal)
            currState = []
           
        }
        
        
    }
    func is_puzzle_solved() -> Bool {
        for i in 0...imageViews.count - 1 {
            if imageViewsCurrentState[i] != imageViews[i] {
                    return false
                }
            }
            return true
    }
    
    func swap_images(){
        
    }
}


struct Cordinates{
    
    var x:CGFloat
    var y:CGFloat
    var IsValid:Bool
    
    
}
