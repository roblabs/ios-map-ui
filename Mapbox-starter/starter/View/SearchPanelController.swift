//
//  SearchPanelController.swift
//  Mapbox-starter
//
//  Created by Wilson Desimini on 8/28/19.
//  Copyright © 2019 ePi Rational, Inc. All rights reserved.
//

import Foundation
import UIKit
import FloatingPanel

protocol SearchPanelControllerDelegate: class {
    func didBeginSearching()
    func didSelect(place: Place)
    func didCancelSearch()
}

class SearchPanelController: UIViewController {
    
    // MARK: Data Objects
    
    private let categories = PlaceCategory.allCases
    private let places: Set<Place>
    
    private var categoryFilter: PlaceCategory? {
        didSet { tableView.reloadData() }
    }
    
    private var filteredPlaces: Set<Place> {
        guard let filter = categoryFilter else { return places }
        return places.filter { $0.category == filter }
    }
    
    private var sortedPlaces: [Place] { return filteredPlaces.sorted() }
    
    // MARK: View Objects
    
    weak var delegate: SearchPanelControllerDelegate?
    
    var currentPosition: FloatingPanelPosition = .tip {
        didSet { changeHeaderIfNecessary() }
    }
    
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.barStyle = .black
        bar.barTintColor = view.backgroundColor
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.backgroundImage = UIImage()
        bar.delegate = self
        bar.searchBarStyle = .default
        bar.placeholder = "Search..."
        bar.activateAnchors(for: searchBarSize)
        view.addSubview(bar)
        return bar
    }()
    
    private var collectionView: UICollectionView {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            CategoryCollectionViewCell.self,
            forCellWithReuseIdentifier: categoryReuseId)
        view.addSubview(collectionView)
        return collectionView
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PlaceTableViewCell.self, forCellReuseIdentifier: detailReuseId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = collectionView
        view.addSubview(tableView)
        return tableView
    }()
    
    init(places: Set<Place>) {
        self.places = places
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        NSLayoutConstraint.activate(viewConstraints)
    }
    
    // MARK: Animation methods
    
    func changeHeaderIfNecessary() {
        tableView.performBatchUpdates({ self.animateHeader() })
    }
    
    private func animateHeader() {
        let hView = tableView.tableHeaderView!
        let trgt = hViewHeight
        
        UIView.animate(withDuration: Duration.headerAnimate) {
            hView.frame.size.height = trgt
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchPanelController: UITableViewDataSource, UITableViewDelegate {
    
    private var detailReuseId: String { return "detailsReuseId" }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: detailReuseId,
            for: indexPath) as! PlaceTableViewCell
        
        cell.place = sortedPlaces[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Size.tblCellH
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        delegate?.didSelect(place: sortedPlaces[indexPath.row])
    }
}

extension SearchPanelController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private var categoryReuseId: String { return "categoryReuseId" }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: categoryReuseId,
            for: indexPath) as! CategoryCollectionViewCell
        cell.setCell(with: categories[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let cell = collectionView.cellForItem(at: indexPath)!
        
        // if previously selected, deselect cell
        if cell.isSelected {
            collectionView.deselectItem(at: indexPath, animated: true)
            categoryFilter = nil
            tableView.reloadData()
            return false
        }
        
        // otherwise, can select
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        categoryFilter = categories[indexPath.item]
    }
}

extension SearchPanelController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        delegate?.didBeginSearching()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resetSearchBar()
        delegate?.didCancelSearch()
    }
    
    func resignSearchBar() {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    private func resetSearchBar() {
        searchBar.text = ""
        resignSearchBar()
    }
}

extension SearchPanelController {
    
    private struct Size {
        static let tblCellH: CGFloat = Default.padding * 5
        static let headerH: CGFloat = 116
        static let twoRowHeaderH: CGFloat = headerH * 2
    }
    
    private struct Duration {
        static let headerAnimate: TimeInterval = 0.2
        static let tableFade = headerAnimate
    }
    
    private var searchBarSize: CGSize {
        let w = view.frame.size.width - Default.padding
        let h = Default.searchBarHeight
        return CGSize(width: w, height: h)
    }
    
    private var hViewHeight: CGFloat {
        let twoRows = categories.count > 4
        let h = twoRows ? Size.twoRowHeaderH : Size.headerH
        switch currentPosition {
        case .full: return h
        case .half, .tip, .hidden: return 0
        }
    }
    
    private var collectionViewItemSize: CGSize {
        let totalW = view.frame.size.width
        let dim = totalW / 4
        return CGSize(width: dim, height: dim)
    }
    
    private var collectionViewLayout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = collectionViewItemSize
        return layout
    }
    
    private var viewConstraints: [NSLayoutConstraint] {
        return [
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: Default.grabberInset),
            searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: Default.grabberPadding),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ]
    }
}


