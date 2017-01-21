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
        super.awakeFromNib()
        // Init YandexSpeechService
        speechService = YandexSpeechService(with: .general)
        speechService?.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.tintColor = UIColor.blue
        
    }
    
    @IBAction func recordButtonTap(_ sender: UIButton) {
        
        speechService?.startRecord()
        startAnimateButton()
        
    }
    
    fileprivate func startAnimateButton() {
        // Animate button
        UIView.animate(withDuration: 0.7, delay: 0.0,
                       options: [.repeat, .autoreverse, .allowUserInteraction, .beginFromCurrentState],
                       animations: {[weak self] in
                        self?.button.layer.opacity = 0.5
        }, completion: {[weak self] sussecc in
            self?.button.layer.opacity = 1.0
        })
    }
    
    fileprivate func stopAnimateButton() {
        self.button.layer.removeAllAnimations()
    }
}

// MARK : SpeechServiceDelegate
extension RecognizerViewController: SpeechServiceDelegate {
    
    internal func didFinishRecording() {
        self.stopAnimateButton()
    }
    
    internal func didStartRecording() {
        self.text = ""
    }
    
    internal func didReceivePartialResults(results: YSKRecognition!) {
        let bestResult = results.bestResultText! == "" ? "none" : results.bestResultText!
        text = "Best result: " + bestResult
    }
    
    internal func didCompleteWithResults(results: YSKRecognition!) {
        let array = results.hypotheses.map {($0 as! YSKRecognitionHypothesis).normalized!}
        
        let optionals = array.count == 0 ? "none" : array.joined(separator: "; ")
        let bestResult = results.bestResultText! == "" ? "none" : results.bestResultText!
        text = "Best result: " + bestResult + "\n\nOptions: "  + optionals
    }
    
}


