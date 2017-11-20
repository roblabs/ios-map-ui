/**
 * Copyright (c) 2017 Razeware LLC
 https://www.raywenderlich.com/157864/uisearchcontroller-tutorial-getting-started
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import Mapbox

// protocol used for sending data back
protocol DataEnteredDelegate: class {
    func userDidEnterInformation(info: String)
}

class MasterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    weak var delegate: DataEnteredDelegate? = nil
    
    // MARK: - Properties
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchFooter: SearchFooter!
    
    var detailViewController: DetailViewController? = nil
    var candies = [Candy]()
    var filteredCandies = [Candy]()
    let searchController = UISearchController(searchResultsController: nil)
    
    var mapView = MGLMapView()
    
    // MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK:- UIBarButtonItem
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleLeftBarButton))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(handleRightBarButton))
        
        // MARK:- MGLMapView
        let url = URL(string: "mapbox://styles/mapbox/streets-v10")
        mapView = MGLMapView(frame: view.bounds, styleURL: url)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: 32.5, longitude: -116.9), zoomLevel: 5, animated: false)
        view.addSubview(mapView)
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "See raywenderlich.com/157864"
        //    searchController.searchBar.showsSearchResultsButton = true
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            // Fallback on earlier versions
            navigationItem.titleView = searchController.searchBar
        }
        
        definesPresentationContext = true
        
        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = ["All", "Chocolate", "Hard", "Other"]
        searchController.searchBar.delegate = self
        
        // Setup the search footer
        tableView.tableFooterView = searchFooter
        
        candies = [
            Candy(category:"Chocolate", name:"Chocolate Bar"),
            Candy(category:"Chocolate", name:"Chocolate Chip"),
            Candy(category:"Chocolate", name:"Dark Chocolate"),
            Candy(category:"Hard", name:"Lollipop"),
            Candy(category:"Hard", name:"Candy Cane"),
            Candy(category:"Hard", name:"Jaw Breaker"),
            Candy(category:"Other", name:"Caramel"),
            Candy(category:"Other", name:"Sour Chew"),
            Candy(category:"Other", name:"Gummi Bear"),
            Candy(category:"Other", name:"Candy Floss"),
            Candy(category:"Chocolate", name:"Chocolate Coin"),
            Candy(category:"Chocolate", name:"Chocolate Egg"),
            Candy(category:"Other", name:"Jelly Beans"),
            Candy(category:"Other", name:"Liquorice"),
            Candy(category:"Hard", name:"Toffee Apple")]
        
        if let splitViewController = splitViewController {
            let controllers = splitViewController.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if splitViewController!.isCollapsed {
            if let selectionIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectionIndexPath, animated: animated)
            }
        }
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- Action Handlers
    @objc func handleRightBarButton() {
        toggleMap(isHidden: false)
    }
    
    
    @objc func handleLeftBarButton() {
        toggleMap(isHidden: true)
    }
    
    func toggleMap(isHidden: Bool) {
        mapView.isHidden = isHidden
        searchController.isActive = isHidden    }
    
    // MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    // https://stackoverflow.com/questions/31182847/how-to-detect-tableview-cell-touched-or-clicked-in-swift#31182935
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let candy: Candy
        if isFiltering() {
            candy = filteredCandies[indexPath.row]
        } else {
            candy = candies[indexPath.row]
        }

        print("File: \(#file), Line: \(#line), Function: \(#function), \(candy)")
        
        toggleMap(isHidden: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            searchFooter.setIsFilteringToShow(filteredItemCount: filteredCandies.count, of: candies.count)
            return filteredCandies.count
        }
        
        searchFooter.setNotFiltering()
        return candies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let candy: Candy
        if isFiltering() {
            candy = filteredCandies[indexPath.row]
            //        print("tableView filteredCandies[indexPath.row] \(candy.category)  \(candy.name)")
        } else {
            //        print("File: \(#file), Line: \(#line), Function: \(#function)")
            candy = candies[indexPath.row]
            //        print("tableView candies[indexPath.row] \(candy.category)  \(candy.name)")
        }
        
        //    print("MasterViewController what shows in table view \(candy.category)  \(candy.name)")
        
        cell.textLabel!.text = candy.name
        cell.detailTextLabel!.text = candy.category
        return cell
    }
    
    // MARK: - Segues
    // Disabled, please see the original demo from RayWenderlich.com
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showDetail" {
//            if let indexPath = tableView.indexPathForSelectedRow {
//                let candy: Candy
//                if isFiltering() {
//                    candy = filteredCandies[indexPath.row]
//                } else {
//                    candy = candies[indexPath.row]
//                }
//                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
//                controller.detailCandy = candy
//                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
//                controller.navigationItem.leftItemsSupplementBackButton = true
//            }
//        }
//    }
    
    // MARK: - Private instance methods
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredCandies = candies.filter({( candy : Candy) -> Bool in
            let doesCategoryMatch = (scope == "All") || (candy.category == scope)
            
            if searchBarIsEmpty() {
                return doesCategoryMatch
            } else {
                return doesCategoryMatch && candy.name.lowercased().contains(searchText.lowercased())
            }
        })
        tableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
}


extension MasterViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        print("File: \(#file), Line: \(#line), Function: \(#function)")
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("File: \(#file), Line: \(#line), Function: \(#function)")
        
        toggleMap(isHidden: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("File: \(#file), Line: \(#line), Function: \(#function)")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        print("File: \(#file), Line: \(#line), Function: \(#function)")
        
        toggleMap(isHidden: false)
    }
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar){
        print("File: \(#file), Line: \(#line), Function: \(#function)")
    }
}

extension MasterViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}

