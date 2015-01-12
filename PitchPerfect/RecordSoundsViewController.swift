//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Malik Woods on 1/7/15.
//  Copyright (c) 2015 funData. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    //Define Record Sounds View Controller as the mixin between UIViewController and AVAudioRecorderDelegate.
    
    var audioRecorder : AVAudioRecorder!
    var recordedAudio : RecordedAudio!
    
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        recordButton.enabled = true
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        println("DEBUG: recorded Audio Clicked")
        recordingInProgress.hidden = false
        stopButton.hidden = false
        recordButton.enabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDatetime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        
        let recordingName = formatter.stringFromDate(currentDatetime)+".wav"
        let pathArray = [dirPath, recordingName]
        
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        //Sets the Current Class RecordSoundVC(which is sub-classed fro AVAudioRecorderDelegate) to the delegate for the instance of AVAudioRecorder
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        println("DEBUG: Hit audio Recording Delegate")
        if flag {
            
            recordedAudio = RecordedAudio()
            recordedAudio.filePathURL = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
        
            println("DEBUG: Recorded Audio Set. Executing performSegueWithIdentifier")
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
            
            println("DEBUG: Audio Recording Delegate Successfully completed")
            
        } else {
            println("DEBUG: Recording Failed")
            recordButton.enabled = true
            stopButton.hidden = true
            
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording"){
            
            println("Called Prepare for Segue")
            
            let playVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            
            playVC.rcvdAudio = data
            
        }
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        println("DEBUG: stopAudio Clicked")
        recordingInProgress.hidden = true
        audioRecorder.stop()
        var session = AVAudioSession.sharedInstance()
        session.setActive(false, error: nil)

    }

}

