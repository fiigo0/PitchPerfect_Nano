//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Diaz Orona, Jesus A. on 5/7/15.
//  Copyright (c) 2015 JADO. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    //Declared Globally
    var audioPlayer = AVAudioPlayer()
    var audioPlayerNode = AVAudioPlayerNode()
    var recordedAudio:RecordedAudio!
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
            audioEngine = AVAudioEngine()
            audioPlayer = AVAudioPlayer(contentsOfURL: recordedAudio.filePathUrl, error: nil)
            audioPlayer.prepareToPlay()
            audioPlayer.enableRate = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 

    @IBAction func playSlow(sender: UIButton) {
        stopAllAudio()
        audioPlayer.rate = 0.5
        audioPlayer.play()
    }

    @IBAction func playFast(sender: UIButton) {
        stopAllAudio()
        audioPlayer.rate = 2.0
        audioPlayer.play()
    }
    @IBAction func stopSounds(sender: UIButton) {
        stopAllAudio()
    }

    @IBAction func playDarthvaderAudio(sender: UIButton) {
        stopAllAudio()
        playSoundWithPitch(-1000)
    }
    @IBAction func playChipmunkAudio(sender: UIButton) {
        stopAllAudio()
        playSoundWithPitch(1000)
    }
    
    @IBAction func playWithDistortionAudio(sender: UIButton) {
        stopAllAudio()
        audioEngine.attachNode(audioPlayerNode)
        
        var reverb = AVAudioUnitDistortion()
        reverb.preGain = 20
        reverb.wetDryMix = 90
        audioEngine.attachNode(reverb)
        
        audioEngine.connect(audioPlayerNode, to: reverb, format: nil)
        audioEngine.connect(reverb, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(AVAudioFile(forReading: recordedAudio.filePathUrl, error: nil), atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
        
    }
    func playSoundWithPitch(pitch:Float){
        stopAllAudio()

        //Attach player node to Engine
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(AVAudioFile(forReading: recordedAudio.filePathUrl, error: nil), atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()

    }    
    
    func stopAllAudio() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
}
