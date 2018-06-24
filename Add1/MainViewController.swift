//
//  MainViewController.swift
//  Add1
//
//  Created by Bowei Han on 2018-06-24.
//  Copyright © 2018 LearnAppMaking. All rights reserved.
//

import UIKit
import MBProgressHUD

class MainViewController: UIViewController {

    @IBOutlet weak var numbersLabel: UILabel?
    @IBOutlet weak var scoreLabel: UILabel?
    @IBOutlet weak var inputField: UITextField?
    @IBOutlet weak var timeLabel: UILabel?
    
    var score: Int = 0
    var hud:MBProgressHUD?
    var timer:Timer?
    var seconds:Int = 60

    override func viewDidLoad() {
        super.viewDidLoad()

        hud = MBProgressHUD(view:self.view)
        if (hud != nil) {
            self.view.addSubview(hud!)
        }

        setRandomNumberLabel()
        updateScoreLabel()
        
        inputField?.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showHUDWithAnswer(isRight:Bool) {
        var imageView:UIImageView?
        
        if isRight {
            imageView = UIImageView(image: UIImage(named:"thumbs-up"))
        }
        else {
            imageView = UIImageView(image: UIImage(named:"thumbs-down"))
        }
        
        if(imageView != nil) {
            hud?.mode = MBProgressHUDMode.customView
            hud?.customView = imageView
            
            hud?.show(animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                self.hud?.hide(animated: true)
                self.inputField?.text = ""
            }
        }
    }
    
    @objc func textFieldDidChange(textField:UITextField)
    {
        if inputField?.text?.characters.count ?? 0 < 4 {
            return
        }
        
        if  let numbers_text    = numbersLabel?.text,
            let input_text      = inputField?.text,
            let numbers = Int(numbers_text),
            let input   = Int(input_text)
        {
            print("Comparing: \(input_text) minus \(numbers_text) == \(input - numbers)")
            
            if(input - numbers == 1111)
            {
                print("Correct!")
                showHUDWithAnswer(isRight: true)
                score += 1
            }
            else
            {
                print("Incorrect!")
                showHUDWithAnswer(isRight: false)
                if(score > 0) {
                    score -= 1
                }
            }
        }
        
        setRandomNumberLabel()
        updateScoreLabel()
        if(timer == nil) {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector:#selector(onUpdateTimer), userInfo:nil, repeats:true)
        }
    }
    
    @objc func onUpdateTimer() -> Void
    {
        if(seconds > 0 && seconds <= 60)
        {
            seconds -= 1
            
            updateTimeLabel()
        }
        else if(seconds == 0)
        {
            if(timer != nil)
            {
                timer!.invalidate()
                timer = nil
                
                let alertController = UIAlertController(title: "Time Up!", message: "Your time is up! You got a score of: \(score) points. Very good!", preferredStyle: .alert)
                let restartAction = UIAlertAction(title: "Restart", style: .default, handler: nil)
                alertController.addAction(restartAction)
                
                self.present(alertController, animated: true, completion: nil)
                
                score = 0
                seconds = 60
                
                updateTimeLabel()
                updateScoreLabel()
                setRandomNumberLabel()
            }
        }
    }
    
    func updateTimeLabel()
    {
        if(timeLabel != nil)
        {
            let min:Int = (seconds / 60) % 60
            let sec:Int = seconds % 60
            
            let min_p:String = String(format: "%02d", min)
            let sec_p:String = String(format: "%02d", sec)

            timeLabel!.text = "\(min_p):\(sec_p)"
        }
    }
    
    func updateScoreLabel() {
        scoreLabel?.text = "\(score)"
    }
    
    func setRandomNumberLabel() {
        numbersLabel?.text = generateRandomString()
    }
    
    func generateRandomString() -> String {
        var result: String = ""
        for _ in 1...4 {
            let digit: Int = Int(arc4random_uniform(8) + 1)
            result += "\(digit)"
        }
        return result
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
