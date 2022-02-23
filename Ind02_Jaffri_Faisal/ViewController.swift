//  Sliding Puzzle
//  ViewController.swift
//  Ind02_Jaffri_Faisal
//
//  Created by Faisal Jaffri on 2/21/22.
//

import UIKit

class ViewController: UIViewController {
    //array to hold all the imageviews loaded initially
    var imageViews: [UIImageView] = []
    //array to hold all the imageviews when they switch positions
    var imageViewsCurrentState: [UIImageView] = []
    //array to hold Initial position of all the images
    var initial_position: [CGPoint] = []
    //array to hold updated position of all the images
    var cuurent_state: [CGPoint] = []
    //Imageview of the emptyTile
    var blankImage:UIImageView!
    // boolean variable to block user clicking on Images tiles when they click show answer button
    var lockScreen:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Additional setup after loading the view.
        ///
        /// Loads all the imageviews at once programmatically
        ///
        /// Store the center of the imageviews in sepearte array
        /// Store all the imageviews in the sepearte array
        var xMid = 67
        var yMid = 200
        var x = 1
        for _ in 0...4{
            for _ in 0...3{
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction))
                let imageview = UIImageView(frame: CGRect(x: xMid, y: yMid, width: 93, height: 93))
                imageview.image = UIImage(named: String(x)+".png")
                let centrePoint: CGPoint = CGPoint(x: xMid, y: yMid)
                initial_position.append(centrePoint)
                imageview.center = centrePoint
                imageview.addGestureRecognizer(tapRecognizer)
                imageview.isUserInteractionEnabled = true
                imageViews.append(imageview)
                view.addSubview(imageview)
                xMid += 93
                x = x+1
            }
            xMid = 67
            yMid += 93
            
            
        }
        imageViewsCurrentState = imageViews
        blankImage = imageViews[0]
    }
    /// Handles the tap functionality for each of the imageview
    ///
    /// Validates that the puzzle is solved or not
    ///
    /// Creates UIAlert when the puzzle is solved
    @objc func tapAction(_ sender: UITapGestureRecognizer){
        if (sender.view != blankImage && lockScreen){
            let result:Cordinates = get_image_coordinates(sender.view as! UIImageView)
            //let currImage = sender.view?.frame.origin
            if (result.IsValid){
                // swap empty image with the image touched by user in its right,left,up or down location
                swap_images(curr_Image: sender.view as! UIImageView)
                
                if(is_puzzle_solved()){
                    
                    // Create new Alert
                    let dialogMessage = UIAlertController(title: "Solved", message: "You are a genius", preferredStyle: .alert)
                    
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
    /// Returns the location of the image which user has tapped
    ///
    /// Use this method to fetch the coordinates of the tapped image next to blank image
    func get_image_coordinates(_ view: UIImageView) -> Cordinates{
        //gets the origin of the blank image
        let currentTile_xPosition = view.frame.origin.x
        let currentTile_yPosition = view.frame.origin.y
        
        // Calcultes the position of the left,right,up and down image
        let leftTile_xPosition = currentTile_xPosition-93
        let leftTile_yPosition = currentTile_yPosition
        
        let rightTile_xPosition = currentTile_xPosition+93
        let rightTile_yPosition = currentTile_yPosition
        
        let upTile_xPosition = currentTile_xPosition
        let upTile_yPosition = currentTile_yPosition-93
        
        let downTile_xPosition = currentTile_xPosition
        let downTile_yPosition = currentTile_yPosition+93
        
        // checks at which direction of the tapped image is blank image and return that position

        if (leftTile_xPosition == blankImage.frame.origin.x && leftTile_yPosition == blankImage.frame.origin.y){
            return Cordinates(x: leftTile_xPosition, y: leftTile_yPosition, IsValid: true)
        }
        if (rightTile_xPosition == blankImage.frame.origin.x && rightTile_yPosition == blankImage.frame.origin.y){
            return Cordinates(x: rightTile_xPosition, y: rightTile_yPosition, IsValid: true)
        }
        if (upTile_xPosition == blankImage.frame.origin.x && upTile_yPosition == blankImage.frame.origin.y){
            return Cordinates(x: upTile_xPosition, y: upTile_yPosition, IsValid: true)
        }
        if (downTile_xPosition == blankImage.frame.origin.x && downTile_yPosition == blankImage.frame.origin.y){
            return Cordinates(x: downTile_xPosition, y: downTile_yPosition, IsValid: true)
        }
        return Cordinates(x: downTile_xPosition, y: downTile_yPosition, IsValid: false)
        
        
    }
    /// Returns a random imageview next to the blank image
    ///
    /// Use this method to generate valid shuffles for the puzzle
    func do_valid_shuffle() -> UIImageView{
        
        var validTiles:[UIImageView] = []
        let emptyTile_xPosition = blankImage.frame.origin.x
        let emptyTile_yPosition = blankImage.frame.origin.y
        
        //checks the location of the tiles adjacent to blank tile
        let leftTile_Position = CGPoint(x: emptyTile_xPosition-93, y: emptyTile_yPosition)
        let rightTile_Position = CGPoint(x: emptyTile_xPosition+93, y: emptyTile_yPosition)
        let upTile_Position = CGPoint(x: emptyTile_xPosition, y: emptyTile_yPosition-93)
        let downTile_Position = CGPoint(x: emptyTile_xPosition, y: emptyTile_yPosition+93)
        //adds the location of the tiles adjacent to blank tile and add it in an array
        for index in 0...imageViews.count-1{
            
            if (imageViews[index].frame.origin == leftTile_Position || imageViews[index].frame.origin == rightTile_Position ||
                imageViews[index].frame.origin == upTile_Position || imageViews[index].frame.origin == downTile_Position)
            {
                validTiles.append(imageViews[index])
                
            }
        }
        //return any random tile adjacent to blank tile
        return  validTiles.randomElement()!
        
        
    }
    /// Displays all the images randomly shuffled in the display
    ///
    /// Use this method when user taps on the shuffle button
    
    @IBAction func do_shuffle(_ sender: Any) {
        var randomShuffleCount = Int.random(in: 30..<40)
        while(randomShuffleCount>0){
            let curr_tile = do_valid_shuffle()
            swap_images(curr_Image: curr_tile)
            randomShuffleCount -= 1
        }
        
    }
    /// Save current state of the puzzle where user have reached
    ///
    /// Use this method to save all the progress which user has reached so far
    
    func save_current_state(){
        for i in 0...imageViewsCurrentState.count-1{
            cuurent_state.append(imageViewsCurrentState[i].center)
        }
        
    }
    /// When user clicks on the Show Answer button, the solved image is displayed
    ///
    /// When user clicks on the Hide button, the image is loaded on that point where user left
    ///
    /// Use this method when user taps on the Show Answer and Hide button
    
    @IBAction func show_answer(_ sender: UIButton) {
        if (sender.titleLabel?.text == "Show Answer"){
            lockScreen = false
            //saves the current state of all the images
            save_current_state()
            
            //loops to imagevies and display it according to the initial position
            for i in 0...imageViews.count-1{
                imageViews[i].center = initial_position[i]
            }
            sender.setTitle("Hide", for: .normal)
        }
        else if(sender.titleLabel?.text == "Hide"){
            //loops to imagevies and display it according to the updated position
            for i in 0...imageViews.count-1{
                imageViewsCurrentState[i].center = cuurent_state[i]
            }
            sender.setTitle("Show Answer", for: .normal)
            lockScreen = true
            cuurent_state = []
           
        }

    }
    
    /// Returns a boolean value that tells user has solved the puzzle or not
    ///
    /// Use this method to check if the puzzle is soved or not
    
    func is_puzzle_solved() -> Bool {
        for i in 0...imageViews.count - 1 {
            if imageViewsCurrentState[i] != imageViews[i] {
                    return false
                }
            }
            return true
    }
    
    /// Swaps the blank image with the image next to blank image which user tapped
    ///
    /// Use this method to swap images
    
    func swap_images(curr_Image:UIImageView){
        let i:Int = imageViewsCurrentState.firstIndex(of: blankImage)!
        let j:Int = imageViewsCurrentState.firstIndex(of: curr_Image)!
        let temp = blankImage.frame.origin
        blankImage.frame.origin = curr_Image.frame.origin
        curr_Image.frame.origin = temp
        imageViewsCurrentState.swapAt(i, j)
        UIView.transition(with: curr_Image, duration: 0.25, options: .transitionFlipFromRight, animations: {}, completion: nil)
        
    }
}

/// Struct to save mid position of image along with a boolean value which keeps track of the blank image

struct Cordinates{
    
    var x:CGFloat
    var y:CGFloat
    var IsValid:Bool
    
    
}
