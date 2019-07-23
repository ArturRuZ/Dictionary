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
  private var isDefault = false
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
    configureUI()
  }

  // MARK: - Private methods

  private func configureUI() {
    self.navigationController?.navigationBar.isTranslucent = true
    self.navigationItem.titleView = changeLanguageDirectionButton
    let rightSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
    rightSpacer.width = 80
    let leftSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
    leftSpacer.width = 80
    self.navigationItem.leftBarButtonItems = [leftSpacer, UIBarButtonItem(customView: selectFromLanguageButton)]
    self.navigationItem.rightBarButtonItems = [rightSpacer, UIBarButtonItem(customView: selectToLanguageButton)]
    textForTranslate.layer.cornerRadius = 5
    textForTranslate.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
    textForTranslate.layer.borderWidth = 0.5
    textForTranslate.clipsToBounds = true
    translatedText.layer.cornerRadius = 5
    translatedText.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
    translatedText.layer.borderWidth = 0.5
    translatedText.clipsToBounds = true
  }

  // MARK: - @objc methods

  @objc func showChangeLanguageWindow( _ sender: UIButton) {
    output.changelanguageButtonPressed(withTag: sender.tag)
    self.textForTranslate.endEditing(true)
  }
  @objc func changeLanguageDirection(_ sender: UIButton) {
    self.output.changelanguageDitrectionButtonPressed()
    self.textForTranslate.endEditing(true)
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
    self.isDefault = dictionaryObject.isDefault()
    textForTranslate.text = dictionaryObject.textForTranslate
    translatedText.text = dictionaryObject.translatedText
    let supportedLanguages = dictionaryObject.getSupportedLanguages()
    selectFromLanguageButton.setTitle(supportedLanguages[dictionaryObject.languageFrom], for: .normal)
    selectToLanguageButton.setTitle(supportedLanguages[dictionaryObject.languageTo], for: .normal)
  }
  func show(alert: UIAlertController) {
    self.present(alert, animated: true)
  }
}

// MARK: - UITextViewDelegate implementation

extension TranslateModuleViewController: UITextViewDelegate {
  func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
    if isDefault {
    textForTranslate.text = ""
    translatedText.text = ""
    }
    return true
  }
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    if text == "\n" {
      textView.resignFirstResponder()
      self.textForTranslate.text != "" ? self.output.endEditing(text: self.textForTranslate.text) : ()
      return true
    }
    return true
  }
  func textViewDidEndEditing(_ textView: UITextView) {
  }
}
