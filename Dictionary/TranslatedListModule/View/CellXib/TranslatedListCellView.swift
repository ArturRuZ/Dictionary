//
//  TranslatedListCellView.swift
//  Dictionary
//
//  Created by Артур on 07/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import Foundation
import UIKit

class TranslatedListCellView: UITableViewCell {

  @IBOutlet weak var textForTranslate: UILabel!
  @IBOutlet weak var translatedText: UILabel!

  var translatedListCellModel: TranslatedListCellModel? {
    didSet {
      guard let translatedListCellModel = translatedListCellModel else {return}
      textForTranslate.lineBreakMode = .byWordWrapping
      textForTranslate.numberOfLines = translatedListCellModel.textForTranslate.components(separatedBy: "\n").count + 10
      translatedText.lineBreakMode = .byWordWrapping
      translatedText.numberOfLines = translatedListCellModel.translatedText.components(separatedBy: "\n").count + 10
      textForTranslate.text = translatedListCellModel.textForTranslate
      translatedText.text = translatedListCellModel.translatedText
    }
  }
}
