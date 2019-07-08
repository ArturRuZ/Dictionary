//
//  TranslatedListModuleViewController.swift
//  Dictionary
//
//  Created by Артур on 06/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//

import UIKit


final class TranslatedListModuleViewController: UIViewController {
  
  //MARK: - Properties
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var translatedListTableView: UITableView!
  private let kTranslatedListCellNib = UINib(nibName: "TranslatedListCell", bundle: nil)
  private let kTranslatedListCellIdentifier = "kTranslatedListCellReuseIdentifier"
  private var translatedWords: [TranslatedListCellModel] = []
  private var viewOutput: TranslatedListModuleViewOutputProtocol!
  private lazy var deleteButton: UIButton = {
    let deletButton = UIButton(type: .system)
    deletButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
    deletButton.setImage(UIImage(named: "baseline_delete_forever_black_36pt_1x.png"), for: .normal)
    deletButton.addTarget(self, action: #selector(clearDctionary), for: .touchUpInside)
    return deletButton
  }()
  
  //MARK: - Implementatin table config func
  
  private func setUpUI() {
    translatedListTableView.register(kTranslatedListCellNib, forCellReuseIdentifier: kTranslatedListCellIdentifier)
    translatedListTableView.rowHeight = UITableView.automaticDimension
    translatedListTableView.estimatedRowHeight = 80
    translatedListTableView.dataSource = self
    translatedListTableView.delegate = self
    translatedListTableView.tableFooterView = UIView(frame: CGRect.zero)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpUI()
    setupSearchBar()
    
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    output.viewWillAppear()
    configureNavigationBar()
  }
  private func configureNavigationBar() {
    self.navigationItem.title = "Dictionary"
    self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: deleteButton)]
    
  }
  
  @objc func clearDctionary() {
    viewOutput.deleteButtonPressed()
  }
}


//MARK: - Implementatin UITableViewDataSource

extension TranslatedListModuleViewController: UITableViewDataSource {
  
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return translatedWords.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: kTranslatedListCellIdentifier,
                                                   for: indexPath) as? TranslatedListCellView else {
                                                    return UITableViewCell()
    }
    cell.translatedListCellModel = translatedWords[indexPath.row]
    return cell
  }
}

//MARK: - Implementation UITableViewDelegate

extension TranslatedListModuleViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    viewOutput.rowSelected(with: translatedWords[indexPath.row])
  }
}


//MARK: - Implementation Search

extension TranslatedListModuleViewController: UISearchBarDelegate {
  private func setupSearchBar(){
    searchBar.delegate = self
  }
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    searchBar.showsCancelButton = true
  }
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.showsCancelButton = false
    translatedListTableView.reloadData()
    searchBar.text = ""
    viewOutput.searchingEnding()
    searchBar.endEditing(true)
  }
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    viewOutput.textInputInSearchBar(text: searchText)
  }
}



extension TranslatedListModuleViewController: TranslatedListModuleViewInputProtocol {
  var output: TranslatedListModuleViewOutputProtocol {
    get {
      return viewOutput
    }
    set {
      viewOutput = newValue
    }
  }
  func show(dictionary: [TranslatedListCellModel]) {
    self.translatedWords = dictionary
    translatedListTableView.reloadData()
  }
}
