//
//  UIViewControllerStoryboardID.swift
//  Dictionary
//
//  Created by Артур on 06/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import UIKit

extension UIViewController {

  // MARK: - Helper method for UIViewController

  static func instantiateFromStoryboard(with storyboardName: StoryboardName, storyboardID: String? = nil) -> Self? {
    let storyboard = UIStoryboard(name: storyboardName.rawValue, bundle: nil)
    return instantiate(from: storyboard, withIdentifier: storyboardID ?? String(describing: self))
  }
  private static func instantiate<T>(from storyboard: UIStoryboard, withIdentifier identifier: String) -> T? {
    return storyboard.instantiateViewController(withIdentifier: identifier) as? T
  }
}
