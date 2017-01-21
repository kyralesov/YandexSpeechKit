//
//  YandexSpeechService.swift
//  YandexSpeechKit
//
//  Created by Eugene Kurilenko on 1/20/17.
//  Copyright © 2017 Eugene Kurilenko. All rights reserved.
//

import Foundation

// Protocols
protocol SpeechServiceProtocol {
    func startRecord()
    func stopRecord()
}

protocol SpeechServiceDelegate: class{
    func didCompleteWithResults(results: YSKRecognition!)
    func didReceivePartialResults(results: YSKRecognition!)
    func didStartRecording()
    func didFinishRecording()
}

class YandexSpeechService: NSObject {
    //Generate your own app key
    static let apiKey = "bcd53af1-6fe0-47d1-b3bc-f7abe8756d31"
    
    fileprivate var recognizer: YSKRecognizer?
    fileprivate var recognition: YSKRecognition?
    var recognizerModel: RecognizerModel?
    
    // Recognizer Language use current locale
    var recognizerLanguage: String {
        let code = Locale.current.languageCode ?? "nil"
        switch code {
        case "ru": return YSKRecognitionLanguageRussian
        case "ua": return YSKRecognitionLanguageUkrainian
        default:   return YSKRecognitionLanguageEnglish
        }
    }
    
    // Delegate
    weak var delegate: SpeechServiceDelegate!
    
    
    // Intit
    convenience init(with model: RecognizerModel) {
        self.init()
        self.recognizerModel = model
        self.configure()
    }
    
    // Configure Speech Kit
    private func configure() {
        YSKSpeechKit.sharedInstance().configure(withAPIKey: YandexSpeechService.apiKey)
        // [OPTIONAL] Set SpeechKit log level
        YSKSpeechKit.sharedInstance().setLogLevel(YSKLogLevel(YSKLogLevelError))
        // [OPTIONAL] Set YSKSpeechKit parameters
        //YSKSpeechKit.sharedInstance().setParameter(YSKEncodingQuality, withValue: "8")
        YSKSpeechKit.sharedInstance().setParameter(YSKDisableAntimat, withValue: "false")
    }
    
}

// MARK: SpeechServiceProtocol
extension YandexSpeechService: SpeechServiceProtocol {
    
    func startRecord() {
        // New recognizer for every request
        recognizer = YSKRecognizer(language: recognizerLanguage, model: recognizerModel?.type)
        recognizer?.delegate = self
        recognizer?.isVADEnabled = true
        
        //Clean previouse result
        recognition = nil
        // Start
        recognizer?.start()
        
    }
    
    func stopRecord() {
        recognizer?.cancel()
        recognition = nil
    }
}

// MARK: - YSKRecognizerDelegate
extension YandexSpeechService: YSKRecognizerDelegate {
    //
    func recognizerDidStartRecording(_ recognizer: YSKRecognizer!) {
        self.delegate.didStartRecording()
    }
    //
    func recognizerDidDetectSpeech(_ recognizer: YSKRecognizer!) {
        
    }
    //
    func recognizerDidDetectSpeechEnd(_ recognizer: YSKRecognizer!) {
        
    }
    //
    func recognizerDidFinishRecording(_ recognizer: YSKRecognizer!) {
        self.delegate.didFinishRecording()
    }
    //
    func recognizer(_ recognizer: YSKRecognizer!, didRecordSound data: Data!) {
        
    }
    //
    func recognizer(_ recognizer: YSKRecognizer!, didUpdatePower power: Float) {
        
    }
    //
    func recognizer(_ recognizer: YSKRecognizer!, didReceivePartialResults results: YSKRecognition!, withEndOfUtterance endOfUtterance: Bool) {
        self.recognition = results
        self.delegate.didReceivePartialResults(results: recognition)
    }
    //
    func recognizer(_ recognizer: YSKRecognizer!, didCompleteWithResults results: YSKRecognition!) {
        self.recognition = results
        self.delegate.didCompleteWithResults(results: recognition)
        
        self.recognizer = nil
    }
    //
    func recognizer(_ recognizer: YSKRecognizer!, didFailWithError error: Error!) {
        // Error handling here
        print(error.localizedDescription)
    }
}

// Language model to be used for recognition
enum RecognizerModel {
    case general, buying, dates, freeform, maps, music, names, notes, numbers, queries
    
    var type: String {
        switch self {
        case .general: return YSKRecognitionModelGeneral
        case .buying: return YSKRecognitionModelBuying
        case .dates: return YSKRecognitionModelDates
        case .freeform: return YSKRecognitionModelFreeform
        case .maps: return YSKRecognitionModelMaps
        case .music: return YSKRecognitionModelMusic
        case .names: return YSKRecognitionModelNames
        case .notes: return YSKRecognitionModelNotes
        case .numbers: return YSKRecognitionModelNumbers
        case .queries: return YSKRecognitionModelQueries
        }
    }
}

