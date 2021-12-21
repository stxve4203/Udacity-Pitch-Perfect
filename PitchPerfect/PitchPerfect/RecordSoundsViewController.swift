//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Stefan Weiss on 15.12.21.
//

import UIKit
import AVFAudio

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func recordButtonTapped(_ sender: Any) {
        recordingLabel.text = "Recording in progress"
           stopRecordingButton.isEnabled = true
           recordButton.isEnabled = false

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
    
    
    @IBAction func stopRecordButtonTapped(_ sender: Any) {
        recordButton.isEnabled = true
           stopRecordingButton.isEnabled = false
           recordingLabel.text = "Tap to Record"
           audioRecorder.stop()
           let audioSession = AVAudioSession.sharedInstance()
           try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Couldn´t send audio")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
}

