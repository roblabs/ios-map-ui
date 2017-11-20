//
//  ViewController.swift
//  Mapbox-UIBarButton
//
//  Created by Rob Labs on 11/19/17.
//  Copyright © 2017 ePi Rational, Inc. All rights reserved.
//
/*
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

import Mapbox

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK:- Mapbox
        let url = URL(string: "mapbox://styles/mapbox/streets-v10")
        let mapView = MGLMapView(frame: view.bounds, styleURL: url)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: 32.5, longitude: -116.9), zoomLevel: 5, animated: false)
        view.addSubview(mapView)
        
        // Set Title and label
        self.navigationItem.title = "Mapbox + UIBarButtonItem(s)"
        
        let label = UILabel()
        label.text = self.navigationItem.title;
        label.textColor = UIColor.blue
        label.adjustsFontSizeToFitWidth = true
        self.navigationItem.titleView = label
        
        // MARK:- UIBarButtonItem
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleLeftBarButton))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(handleRightBarButton))
    }
    
    // MARK:- Action Handlers
    @objc func handleRightBarButton() {
        
    }
    
    @objc func handleLeftBarButton() {
        
    }
}
