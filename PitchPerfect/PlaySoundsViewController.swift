//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Malik Woods on 1/10/15.
//  Copyright (c) 2015 funData. All rights reserved.
//

import UIKit
import AVFoundation


class PlaySoundsViewController: UIViewController {
   
// removed reference to audioPlayer, which is not necessary with audioEngine logic that handles both frequency and rate
//    var audioPlayer: AVAudioPlayer!
    var rcvdAudio: RecordedAudio!
    //creates global for audioengine
    var audioEngine: AVAudioEngine!
    //creates global for audiofile
    var audioFile: AVAudioFile!
    
//    func playAudioAtRate(rate: Float) {
//        audioPlayer.stop()
//        audioPlayer.rate = rate
//        audioPlayer.currentTime = 0.0
//        audioPlayer.play()
//    }
    
    func playAudioWithVariableFrequencyRate(pitch: Float, rate: Float) {
        
        //Stop engine and player
        
        //audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        //create audioplayernode requred to play audio
        var audioPlayerNode = AVAudioPlayerNode()

        //create pitch effect and set pitch
        var pitchEffect = AVAudioUnitTimePitch()
        pitchEffect.pitch = pitch
        pitchEffect.rate = rate

        //Adding audioplayernode
        audioEngine.attachNode(audioPlayerNode)
        
        //addding pitchefect node
        audioEngine.attachNode(pitchEffect)
        
        //Connect audioplayernode >> pitcheffect
        audioEngine.connect(audioPlayerNode, to: pitchEffect, format:nil)
        
        //Connect pitchEffect Node >> speakers(outputNode)
        audioEngine.connect(pitchEffect, to: audioEngine.outputNode, format: nil)
        
        //Attache audiofile to AudioPLayerNode
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        //Start AudioEngine and play AudioPlayer Node
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Use if declaration to handle exceptions where file could not be found
//        if var path = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3"){
//            var fileURL = NSURL(fileURLWithPath: path)
//        }else {
//            println("the File Path is Empty")
//        }
        
        //Initialize AudioEngine
        audioEngine = AVAudioEngine()

        //Initialize Audioplayer object - Deprecated with Audio Engine
        //audioPlayer = AVAudioPlayer(contentsOfURL: rcvdAudio.filePathURL, error: nil)
        //audioPlayer.enableRate = true
        
        //initialize Audioplayer File
        audioFile = AVAudioFile(forReading: rcvdAudio.filePathURL, error: nil)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playBackSlow(sender: UIButton) {
        println("DEBUG: Slow Playback")
        //playAudioAtRate(0.5)
        playAudioWithVariableFrequencyRate(1.0, rate: 0.5)
    }

    
    @IBAction func playBackFast(sender: UIButton) {
        println("DEBUG: Fast Playback")
        playAudioWithVariableFrequencyRate(1.0, rate: 1.5)
    }
    
    @IBAction func stopPlayBack(sender: UIButton) {
        println("Stop Button Clicked")
        //Code to stop Audio Player and Audio Engine
        //audioPlayer.stop()
        audioEngine.stop()
    }
    
    
    @IBAction func playBackChipmunk(sender: UIButton) {
        println("DEBUG: Chipmunk Playback")
        playAudioWithVariableFrequencyRate(1000, rate: 1.0)
    }
    
    @IBAction func playBackVader(sender: UIButton) {
        println("DEBUG: Vader Playback")
        playAudioWithVariableFrequencyRate(-1000, rate: 1.0)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
