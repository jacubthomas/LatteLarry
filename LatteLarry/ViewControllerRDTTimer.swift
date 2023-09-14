import UIKit

class ViewControllerRDTTimer: ViewController {
    
    // local variables
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
    var farenheitOrCelsius = "Farenheit"
    
    // ui components
    @IBOutlet var viewTopBanner: UIView!
    @IBOutlet var btnMenu: UIButton!
    @IBOutlet var btnStart: UIButton!
    @IBOutlet var btnResetEnd: UIButton!
    @IBOutlet var btnYellowPhase: UIButton!
    @IBOutlet var btnFirstCrack: UIButton!
    @IBOutlet var btnSecondCrack: UIButton!
    @IBOutlet var txtTimer: UITextField!
    @IBOutlet var statsScrollView: UIScrollView!
    @IBOutlet var scrollViewStack: UIStackView!
    @IBOutlet var btnFarenheitCelsius: UIButton!
    @IBOutlet var textFarenheitCelsius: UITextField!
    @IBOutlet var viewBottomBanner: UIView!
    @IBOutlet var valYellowPhase: UITextField!
    @IBOutlet var valMallardPhase: UITextField!
    @IBOutlet var valFirstCrack: UITextField!
    @IBOutlet var valSecondCrack: UITextField!
    @IBOutlet var preheatTemp: UITextField!
    @IBOutlet var greenWeight: UITextField!
    @IBOutlet var endWeight: UITextField!
    @IBOutlet var weightLoss: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleDisplay()
        txtTimer.delegate = self
        textFarenheitCelsius.delegate = self
        valYellowPhase.delegate = self
        valMallardPhase.delegate = self
        valFirstCrack.delegate = self
        valSecondCrack.delegate = self
        preheatTemp.delegate = self
        greenWeight.delegate = self
        endWeight.delegate = self
        weightLoss.delegate = self
        
        
    }
    
    // update displayed clock time
    @objc func fireTimer() {
        calculateRuntime()
        txtTimer.text = "\(convertSecondsToMinSecs(dateTime: (startTime)))"
    }
    
    // sum all intervals clock has been paused since start and store for reference
    //
    // logic useful for calculating run time when pause has been pressed at least once
    // run time calculation is complicated due to need for running in background
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
        }
    }
    
    // sum all intervals clock has been actively running with consideration to the sum paused duration
    // since timer start and store for reference
    //
    // logic useful for calculating run time when pause has been pressed at least once
    // run time calculation is complicated due to need for running in background
    func calculateRuntime() {
        
        sumRunTime = 0
        if (runningTimeArray.count > 1)
        {
            sumRunTime = Int(floor(runningTimeArray[runningTimeArray.count-1].distance(to: Date()))) + lastSumRunTime
        } else if (runningTimeArray.count == 1) {
            sumRunTime = Int(floor(runningTimeArray[0].distance(to: Date())))
        }
    }
    
    // convert a date time to formatted string for display mm:ss
    func convertSecondsToMinSecs(dateTime: Date) -> String {

        // get diff in time since start
        let timeDiff = Double(sumRunTime)
        
        // extract & format minutes elapsed
        let mins = Int(floor(timeDiff / 60))
        var minString = ""
        if (mins == 0) {
            minString = "00"
        }
        else if (mins < 10) {
            minString = "0\(mins)"
        } else {
            minString = "\(mins)"
        }
        
        // extract & format seconds elapsed
        let seconds = Int(timeDiff) % 60
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
    
    // dynamically update display depending on device screen width
    func handleDisplay() {
        
        // update scrollview inner Stack View to fill width - cannot be done via storyboard
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        let widthConstraint = NSLayoutConstraint(item: scrollViewStack, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: width)
        scrollViewStack.addConstraint(widthConstraint)
        
//        print ("~~~~~~ WIDTH = \(width) ~~~~~~")
//        print ("~~~~~~ HEIGHT = \(height) ~~~~~~")
//        
//        // iPhone SE (3rd generation)
//        if (width <= 375) {
//            let topHeight = viewTopBanner.frame.height - 10
//            let newTopHeightConstraint = NSLayoutConstraint(item: viewTopBanner!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: topHeight)
//            viewTopBanner.addConstraint(newTopHeightConstraint)
//            let bottomHeight = viewBottomBanner.frame.height - 10
//            let newBottomHeightConstraint = NSLayoutConstraint(item: viewBottomBanner!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: bottomHeight)
//            viewBottomBanner.addConstraint(newBottomHeightConstraint)
//            let scrollViewHeight = statsScrollView.frame.height + 20
//            let newScrollViewHeightConstraint = NSLayoutConstraint(item: statsScrollView!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: scrollViewHeight)
//            statsScrollView.addConstraint(newScrollViewHeightConstraint)
//        }
    }
    
    // logic for start/pause button - kick off and pause displayed timer
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
                                         selector: #selector(ViewControllerRDTTimer.fireTimer),
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
    
    // reset displayed timer to initial state 00:00
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
    
    // Capture milestones when user presses associated button
    @IBAction func yellowPhasePressed(_ sender: UIButton) {
        valYellowPhase.text = txtTimer.text
    }
    @IBAction func firstCrackPressed(_ sender: UIButton) {
        valFirstCrack.text = txtTimer.text
    }
    @IBAction func secondCrackPressed(_ sender: UIButton) {
        valSecondCrack.text = txtTimer.text
    }
    // toggle logic
    @IBAction func farenheitCelsiusPressed(_ sender: UIButton) {
        if (farenheitOrCelsius == "Farenheit")
        {
            farenheitOrCelsius = "Celsius"
        } else {
            farenheitOrCelsius = "Farenheit"
        }
        textFarenheitCelsius.text = farenheitOrCelsius
    }
    
    @IBAction func weightChanged(_ sender: UITextField) {
        let gw = Int(greenWeight.text!) ?? 0
        let ew = Int(endWeight.text!) ?? 0
        
        let wL = gw - ew
        
        weightLoss.text = String(wL)
    }
}

