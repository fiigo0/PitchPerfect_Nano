//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Diaz Orona, Jesus A. on 5/6/15.
//  Copyright (c) 2015 JADO. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    //Global variables
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    var isNewAudio:Bool = true
    var isPaused:Bool = false
    
    @IBOutlet weak var tapToPauseLabel: UILabel!
    @IBOutlet weak var recordingStatusLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var startRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        //Set original state to elements when showing the view
        stopRecordingButton.hidden = true
        tapToPauseLabel.hidden = true
        recordingStatusLabel.text = "Tap to record"
        var image = (UIImage(named: "microphone-iphone") as UIImage?)!
        startRecordingButton.setImage(image, forState: UIControlState.Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        //Function to start recording audio
        stopRecordingButton.hidden = false
        var image:UIImage
        
        //Record new audio
        //Pause recording
        //Continue recording
        
        if isNewAudio {
            println("Start Recording")
            setupAudioFile()
            isNewAudio = false
            recordingStatusLabel.text = "recording in progress"
            tapToPauseLabel.hidden = false
            image = (UIImage(named: "pause") as UIImage?)!
            startRecordingButton.setImage(image, forState: UIControlState.Normal)
            
            startRecordingButton.frame = CGRectMake(
                startRecordingButton.frame.origin.x,
                startRecordingButton.frame.origin.y,
                400,
                400)
            audioRecorder.record()
            
        }else if (!isNewAudio && !isPaused) {
            println("Pause Recording")
            isPaused = true
            tapToPauseLabel.hidden = true
            recordingStatusLabel.text = "recording paused"
            image = (UIImage(named: "microphone-iphone") as UIImage?)!
            startRecordingButton.setImage(image, forState: UIControlState.Normal)
            audioRecorder.pause()
        } else if (!isNewAudio && isPaused){
            println("continue Recording")
            isPaused = false
            recordingStatusLabel.text = "recording in progress"
            tapToPauseLabel.hidden = false
            image = (UIImage(named: "pause") as UIImage?)!
            startRecordingButton.setImage(image, forState: UIControlState.Normal)

            audioRecorder.record()
        } else {
            println("Unexpected scenario")
        }
        
        
   
        
    }
    
    
    func setupAudioFile(){
        //Set the path where the fill will be saved
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        //Name format
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()

    }

    @IBAction func stopRecording(sender: UIButton) {
        stopRecordingButton.hidden = true
        startRecordingButton.enabled = true
        audioRecorder.stop()
        isNewAudio = true;
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecordingSegue" {
            let playSoudsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoudsVC.recordedAudio = data
        }
    }
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if flag {
            recordedAudio = RecordedAudio(title: recorder.url.lastPathComponent!, andFilePathURL: recorder.url)
            self.performSegueWithIdentifier("stopRecordingSegue", sender: recordedAudio)
        } else {
            println("Recording was not successfull")
            startRecordingButton.enabled = true
            stopRecordingButton.hidden = true
        }
    }
    

}

