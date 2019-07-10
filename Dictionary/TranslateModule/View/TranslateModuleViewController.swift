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
  private var dictionaryObject: DictionaryObjectProtocol?
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
    
    return selectFromLanguageButton
  }()
  private lazy var selectToLanguageButton: UIButton = {
    let selectToLanguageButton = UIButton(type: .system)
    selectToLanguageButton.frame = CGRect(x: 0, y: 0, width: 60, height: 34)
    selectToLanguageButton.addTarget(self, action: #selector(showChangeLanguageWindow), for: .touchUpInside)
    return selectToLanguageButton
  }()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    output.viewDidLoad()
    textForTranslate.delegate = self
    translatedText.delegate = self
    configureNavigationBar()
  }
  
  
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
  private func updateUI() {
    guard let object = self.dictionaryObject else {return}
    textForTranslate.text = object.textForTranslate
    translatedText.text = object.translatedText
    selectFromLanguageButton.setTitle(languagesDictionary[object.languageFrom], for: .normal)
    selectToLanguageButton.setTitle(languagesDictionary[object.languageTo], for: .normal)
  }
  
  @objc func showChangeLanguageWindow(_ sender: UIButton) {
    var selectLanguage: TranslationLanguages?
    let alertController = UIAlertController(title: "Select language", message: "You can change language for translate", preferredStyle: .alert)
    for (key, value) in languagesDictionary {
      alertController.addAction(UIAlertAction(title: "\(value)", style: .default, handler: { [weak self] _ in
        guard let self = self else {return}
        selectLanguage = key
        guard let selectedLanguage = selectLanguage else {return}
        guard self.dictionaryObject != nil else {return}
        switch sender {
        case self.selectFromLanguageButton: self.dictionaryObject?.languageFrom = selectedLanguage
        case self.selectToLanguageButton: self.dictionaryObject?.languageTo = selectedLanguage
        default:
          break
        }
        self.updateUI()
      }))
    }
    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    self.present(alertController, animated: true)
  }
  
  @objc func changeLanguageDirection(_ sender: UIButton) {
    guard  self.dictionaryObject != nil else {return}
    self.dictionaryObject?.changeLanguageDirection()
    self.updateUI()
  }
}

// MARK: - TranslateModuleViewInputProtocol implementation

extension TranslateModuleViewController: TranslateModuleViewInputProtocol {
  
  // MARK: - TranslateModuleViewInputProtocol properties
  
  var output: TranslateModuleViewOutputProtocol {
    get {
      return viewOutput
    }
    set {
      viewOutput = newValue
    }
  }
  
  // MARK: - TranslateModuleViewInputProtocol methods
  
  func show(dictionaryObject: DictionaryObjectProtocol) {
    self.dictionaryObject = dictionaryObject
    updateUI()
  }
}

extension TranslateModuleViewController: UITextViewDelegate {
  func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
    if self.dictionaryObject?.isDefault() ?? false {
      textForTranslate.text = ""
      translatedText.text = ""
    }
    return true
  }
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    if(text == "\n") {
      textView.resignFirstResponder()
      return true
    }
    return true
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    guard let object = self.dictionaryObject else {return}
    object.textForTranslate = textView.text
    output.endEditing(dictionaryObject: object)
  }
}

