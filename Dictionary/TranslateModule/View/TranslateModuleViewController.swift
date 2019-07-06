//
//  TranslateModuleViewController.swift
//  Dictionary
//
//  Created by Артур on 06/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import UIKit


final class TranslateModuleViewController: UIViewController {
  
  // MARK: - properties
  
  @IBOutlet weak var textForTranslate: UITextView!
  @IBOutlet weak var translatedText: UITextView!
  private var viewOutput: TranslateModuleViewOutputProtocol!
    private let defaultForTranslateText = "Text for translate"
     private let defaultTranslatedText = "Translated text"
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    
  }
  
  private func setupUI(){
    textForTranslate.delegate = self
    translatedText.delegate = self
    textForTranslate.text = defaultForTranslateText
    translatedText.text = defaultTranslatedText
  }
  
}

extension TranslateModuleViewController: TranslateModuleViewInputProtocol {
  var output: TranslateModuleViewOutputProtocol {
    get {
      return viewOutput
    }
    set {
      viewOutput = newValue
    }
  }
}

extension TranslateModuleViewController: UITextViewDelegate {
  func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
    if textForTranslate.text == defaultForTranslateText {
      textForTranslate.text = ""
      translatedText.text = ""
    }
    return true
  }
  
  func textViewDidChange(_ textView: UITextView) {
    output.textDidChangeTo(text: textView.text)
  }
  
  
}

