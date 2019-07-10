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
    selectFromLanguageButton.addTarget(self, action: #selector(showChangeLanguageFromWindow), for: .touchUpInside)
    
    return selectFromLanguageButton
  }()
  private lazy var selectToLanguageButton: UIButton = {
    let selectToLanguageButton = UIButton(type: .system)
    selectToLanguageButton.frame = CGRect(x: 0, y: 0, width: 60, height: 34)
    selectToLanguageButton.addTarget(self, action: #selector(showChangeLanguageToWindow), for: .touchUpInside)
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
    selectFromLanguageButton.setTitle(languagesDictionary[(object.languageFrom.rawValue)], for: .normal)
    selectToLanguageButton.setTitle(languagesDictionary[(object.languageTo.rawValue)], for: .normal)
  }
  @objc func showChangeLanguageFromWindow(_ sender: UIButton){
    let alert = UIAlertController(title: "Select language", message: "You can change language for translate", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Русский", style: .default, handler: { action in
      self.dictionaryObject?.languageFrom = TranslationLanguages.ru
      self.updateUI()
    }))
    alert.addAction(UIAlertAction(title: "English", style: .default, handler: { action in
      self.dictionaryObject?.languageFrom = TranslationLanguages.en
      self.updateUI()
    }))
    alert.addAction(UIAlertAction(title: "French", style: .default, handler: { action in
      self.dictionaryObject?.languageFrom = TranslationLanguages.fr
      self.updateUI()
    }))
    alert.addAction(UIAlertAction(title: "Spanish", style: .default, handler: { action in
      self.dictionaryObject?.languageFrom = TranslationLanguages.es
      self.updateUI()
    }))
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    self.present(alert, animated: true)
  }
  @objc func showChangeLanguageToWindow(_ sender: UIButton){
    let alert = UIAlertController(title: "Select language", message: "You can change language for translate", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Русский", style: .default, handler: { action in
      self.dictionaryObject?.languageTo = TranslationLanguages.ru
      self.updateUI()
    }))
    alert.addAction(UIAlertAction(title: "English", style: .default, handler: { action in
      self.dictionaryObject?.languageTo = TranslationLanguages.en
      self.updateUI()
    }))
    alert.addAction(UIAlertAction(title: "French", style: .default, handler: { action in
      self.dictionaryObject?.languageTo = TranslationLanguages.fr
      self.updateUI()
    }))
    alert.addAction(UIAlertAction(title: "Spanish", style: .default, handler: { action in
      self.dictionaryObject?.languageTo = TranslationLanguages.es
      self.updateUI()
    }))
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    self.present(alert, animated: true)
  }
  
  @objc func changeLanguageDirection(_ sender: UIButton) {
    guard  self.dictionaryObject != nil else {return}
    self.dictionaryObject?.changeLanguageDirection()
    updateUI()
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
    if self.dictionaryObject?.time == nil {
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

