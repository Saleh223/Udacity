//
//  RecordSoundViewController.swift
//  Pitch Perfect
//
//  Created by Saleh on 20/03/2019.
//  Copyright © 2019 Saleh. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
    
    // MARK: Variables
    var audioRecorder: AVAudioRecorder!
    
    // MARK: Outlet
    @IBOutlet weak var stopRecordButton: UIButton!
    @IBOutlet weak var startRecordButton: UIButton!
    @IBOutlet weak var progressLabel: UILabel!
   
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        changeMode(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func changeMode(_ status: Bool) {  // function to change mode if true is recordeing else is not
        if status {
            progressLabel.text = "Recording..."
            startRecordButton.isEnabled = false
            stopRecordButton.isEnabled = true
        }
        else
        {
            progressLabel.text = "Tap To Record"
            startRecordButton.isEnabled = true
            stopRecordButton.isEnabled = false
        }
        
    }
//    func configureUI(isRecording: Bool) {
//        stopRecordingButton.isEnabled = isRecording // to disable the button
//        recordButton.isEnabled = !isRecording // to enable the button
//        recordingLabel.text = !isRecording ? "Tap to Record" : "Recording in Progress"
//
//    }
    
    // MARK: Actions
    @IBAction func startRecordButton(_ sender: Any) {
        changeMode(true)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecordButton(_ sender: Any) {
        changeMode(false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    // MARK: Audio Recorder Delegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
       if flag {
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
       }
       else {
        let alert = UIAlertController(title: "Warning", message: "Recording Failed.", preferredStyle: UIAlertController.Style.alert)  // create the alert
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))   // add an action (button)
        self.present(alert, animated: true, completion: nil) // show the alert
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundVC = segue.destination as! PlaySoundViewController
            let recordedAudioURL = sender as! URL
            playSoundVC.recordedAudioURL = recordedAudioURL
        }
    }
    
}

