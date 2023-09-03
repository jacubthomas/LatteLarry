//
//  ViewController.swift
//  LatteLarry
//
//  Created by Jacob Harrington on 8/4/23.
//

import UIKit

class ViewController: UIViewController {

    let resetTime = "00:00"
    
    var started = false
    
    var timer = Timer()
    
    var startTime = Date()
    
    @objc func fireTimer() {
        txtTimer.text = "\(convertSecondsToMinSecs())"
    }

    @IBOutlet var actualStartBtn: UIButton!
    @IBAction func btnStart(_ sender: UIButton) {
        if (started == false) {
            
            // mark started so next button press leverages reset logic
            started = true
            
            // update start button to reset
            actualStartBtn.setTitle("Reset",
                                    for: UIControl.State())
            
            // mark time of start - to be referenced for running clock
            startTime = Date()
            
            // kick off timer which updates clock and data points every second
            timer = Timer.scheduledTimer(timeInterval: 1.0,
                                         target: self,
                                         selector: #selector(ViewController.fireTimer),
                                         userInfo: nil,
                                         repeats: true)
        } else {
            started = false
            actualStartBtn.setTitle("Start",
                                    for: UIControl.State())
            txtTimer.text = resetTime
            timer.invalidate()
        }
    }
    
    @IBAction func btnWeightLoss(_ sender: UIButton) {
        print ("HI")
    }
    @IBAction func btnFirstCrack(_ sender: UIButton) {
        print ("HEY")
    }
    
    @IBOutlet var txtTimer: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func convertSecondsToMinSecs() -> String {
        
        // get diff in time since start
        let timeDiff = floor(startTime.distance(to: Date()))
        
        let mins = Int(floor(timeDiff / 60))
        let seconds = Int(timeDiff) % 60
        
        var minString = ""
        if (mins == 0) {
            minString = "00"
        }
        else if (mins < 10) {
            minString = "0\(mins)"
        } else {
            minString = "\(mins)"
        }
        
        var secString = ""
        if (seconds == 0) {
            secString = "00"
        }
        if (seconds < 10) {
            secString = "0\(seconds)"
        } else {
            secString = "\(seconds)"
        }
        
        return "\(minString):\(secString)"
    }

    @IBAction func doneEditing(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}



/*
 ~~~ OLD FIRE TIMER ~~~
 //        // Handle rollover into new minute
 //        if (seconds == 59) {
 //            seconds = 0
 //            mins = mins + 1
 //        } else {
 //            seconds = seconds + 1
 //        }
 //
 //        var minuteString = "00"
 //        var secondString = "00"
 //        if (mins < 10) {
 //            minuteString = "0\(mins)"
 //        } else {
 //            minuteString = "\(mins)"
 //        }
 //        if (seconds < 10) {
 //            secondString = "0\(seconds)"
 //        } else {
 //            secondString = "\(seconds)"
 //        }
 //
 //        // Update timer
 //        txtTimer.text = "\(minuteString):\(secondString)"
 */
