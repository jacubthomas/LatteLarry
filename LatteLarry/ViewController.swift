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
    var startTime = Date()
    var pausedTime = Date()
    var sumPausedTime : Int = 0
    var lastSumRunTime : Int = 0
    var sumRunTime : Int = 0
    var runningTimer = Timer()
    var pausedTimer = Timer()
    var pausedTimeArray = [Date]()
    var runningTimeArray = [Date]()
    
    @objc func fireTimer() {
            calculateRuntime()
            txtTimer.text = "\(convertSecondsToMinSecs(dateTime: (startTime)))"
    }
    
    func handlePause() {
        sumPausedTime = 0
        if pausedTimeArray.count % 2 == 0
        {
            for i in 0...pausedTimeArray.count-1 {
                if i % 2 != 0 {
                    continue
                } else {
                    sumPausedTime += Int(floor(pausedTimeArray[i].distance(to: pausedTimeArray[i+1])))
                }
            }
            print ("sumPausedTime = \(sumPausedTime)")
        }
        
    }
    
    func calculateRuntime() {
        sumRunTime = 0
        if (runningTimeArray.count > 1)
        {
            sumRunTime = Int(floor(runningTimeArray[runningTimeArray.count-1].distance(to: Date()))) + lastSumRunTime
        } else if (runningTimeArray.count == 1) {
            sumRunTime = Int(floor(runningTimeArray[0].distance(to: Date())))
        }
        print ("sumRunTime = \(sumRunTime)")
        
    }

    @IBOutlet var txtTimer: UITextField!
    @IBOutlet var btnStart: UIButton!
    @IBOutlet var btnResetEnd: UIButton!
    @IBAction func started(_ sender: UIButton) {
        if (started == false) {
            
            // mark started so next button press leverages reset logic
            started = true
            // update start button to pause
            btnStart.setTitle("Pause Timer",
                                    for: UIControl.State())
            
            // mark time of start - to be referenced for running clock
            startTime = Date()
            runningTimeArray.append(startTime)
            
            if (pausedTimeArray.count > 0) {
                pausedTimeArray.append(startTime)
                handlePause()
            }
            
            // kick off timer which updates clock and data points every second
            runningTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                         target: self,
                                         selector: #selector(ViewController.fireTimer),
                                         userInfo: nil,
                                         repeats: true)
        } else {
            started = false
            runningTimer.invalidate()
            
            // mark time of pause - to be referenced for running clock
            pausedTime = Date()
            pausedTimeArray.append(pausedTime)
            lastSumRunTime = sumRunTime
            btnStart.setTitle("Start Timer",
                                    for: UIControl.State())
        }
    }
    
    @IBAction func reset(_ sender: UIButton) {
        // reset timer to 00:00 and stop clock
        started = false
        txtTimer.text = resetTime
        runningTimer.invalidate()
        
        pausedTimeArray.removeAll()
        runningTimeArray.removeAll()
        
        // update start button to pause
        btnStart.setTitle("Start Timer",
                                for: UIControl.State())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func convertSecondsToMinSecs(dateTime: Date) -> String {
        
        // get diff in time since start
//        var timeDiff = floor(dateTime.distance(to: Date()))
        let timeDiff = Double(sumRunTime)
        print ("timeDiff = \(timeDiff) ; sumPausedTime = \(sumPausedTime)")
//        timeDiff -= Double(sumPausedTime)
        
        
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

    @IBAction func endEditing(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
    }
}
