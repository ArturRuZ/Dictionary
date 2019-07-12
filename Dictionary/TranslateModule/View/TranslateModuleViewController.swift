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
  private lazy var changeLanguageDirectionButton: UIButton = {
    let changeLanguageDirectionButton = UIButton(type: .system)
    changeLanguageDirectionButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
    changeLanguageDirectionButton.addTarget(self, action: #selector(changeLanguageDirection), for: .touchUpInside)
    changeLanguageDirectionButton.setImage(UIImage(named: "baseline_compare_arrows_black_36pt_1x.png"), for: .normal)
    return changeLanguageDirectionButton
  }()
  private lazy var selectFromLanguageButton: UIButton = {
    let selectFromLanguageButton = UIButton(type: .system)
    selectFromLanguageButton.frame = CGRect(x: 0, y: 0, width: 60, height: 34)
    selectFromLanguageButton.addTarget(self, action: #selector(showChangeLanguageWindow), for: .touchUpInside)
    selectFromLanguageButton.tag = 1
    return selectFromLanguageButton
  }()
  private lazy var selectToLanguageButton: UIButton = {
    let selectToLanguageButton = UIButton(type: .system)
    selectToLanguageButton.frame = CGRect(x: 0, y: 0, width: 60, height: 34)
    selectToLanguageButton.addTarget(self, action: #selector(showChangeLanguageWindow), for: .touchUpInside)
    selectToLanguageButton.tag = 2
    return selectToLanguageButton
  }()
  
  // MARK: - BuildIn methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    output.viewDidLoad()
    textForTranslate.delegate = self
    translatedText.delegate = self
    configureNavigationBar()
  }
  
  // MARK: - Private methods
  
  private func configureNavigationBar() {
    self.navigationController?.navigationBar.isTranslucent = true
    self.navigationItem.titleView = changeLanguageDirectionButton
    let rightSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
    rightSpacer.width = 80
    let leftSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
    leftSpacer.width = 80
    self.navigationItem.leftBarButtonItems = [leftSpacer, UIBarButtonItem(customView: selectFromLanguageButton)]
    self.navigationItem.rightBarButtonItems = [rightSpacer, UIBarButtonItem(customView: selectToLanguageButton)]
  }
  
  // MARK: - @objc methods
  
  @objc func showChangeLanguageWindow( _ sender: UIButton) {
    output.changelanguageButtonPressed(withTag: sender.tag)
  }
  @objc func changeLanguageDirection(_ sender: UIButton) {
    self.output.changelanguageDitrectionButtonPressed()
  }
}

// MARK: - TranslateModuleViewInputProtocol implementation

extension TranslateModuleViewController: TranslateModuleViewInputProtocol {
  var output: TranslateModuleViewOutputProtocol {
    get {
      return viewOutput
    }
    set {
      viewOutput = newValue
    }
  }
  func show(dictionaryObject: DictionaryObjectProtocol) {
    textForTranslate.text = dictionaryObject.textForTranslate
    translatedText.text = dictionaryObject.translatedText
    let supportedLanguages = dictionaryObject.getSupportedLanguages()
    selectFromLanguageButton.setTitle(supportedLanguages[dictionaryObject.languageFrom], for: .normal)
    selectToLanguageButton.setTitle(supportedLanguages[dictionaryObject.languageTo], for: .normal)
  }
  func showChangeLanguage(window: UIAlertController) {
    self.present(window, animated: true)
  }
}

// MARK: - UITextViewDelegate implementation

extension TranslateModuleViewController: UITextViewDelegate {
  func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
    textForTranslate.text = ""
    translatedText.text = ""
    return true
  }
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    if (text == "\n") {
      textView.resignFirstResponder()
      return true
    }
    return true
  }
  func textViewDidEndEditing(_ textView: UITextView) {
    output.endEditing(text: textView.text)
  }
}
