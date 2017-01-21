//
//  RecognizerViewController.swift
//  YandexSpeechKit
//
//  Created by Eugene Kurilenko on 1/20/17.
//  Copyright © 2017 Eugene Kurilenko. All rights reserved.
//

import UIKit

class RecognizerViewController: UIViewController {
    
    // Dependency
    var speechService: YandexSpeechService?
    
    // MARK: Outlets
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var button: UIButton!
    
    var text: String {
        set {
            textView.text = newValue
        }
        get {
            return textView.text
        }
    }
    
    override func awakeFromNib() {
        speechService = YandexSpeechService(with: .general)
        speechService?.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        

    }

    @IBAction func recordButtonTap(_ sender: UIButton) {
        button.isEnabled = false
        spinner.startAnimating()
        speechService?.startRecord()
    }

}

// MARK : SpeechServiceDelegate
extension RecognizerViewController: SpeechServiceDelegate {
    internal func didFinishRecording() {
        spinner.stopAnimating()
        button.isEnabled = true
    }

    internal func didStartRecording() {
        self.text = ""
    }
    
    internal func didReceivePartialResults(results: YSKRecognition!) {
        text = results.bestResultText
    }

    internal func didCompleteWithResults(results: YSKRecognition!) {
        let array = results.hypotheses.map {($0 as! YSKRecognitionHypothesis).normalized!}
        text = array.joined(separator: "; ")
        
    }
    
}


