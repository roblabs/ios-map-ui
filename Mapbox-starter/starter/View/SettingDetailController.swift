//
//  SettingDetailController.swift
//  Mapbox-starter
//
//  Created by Wilson Desimini on 7/9/20.
//  Copyright © 2020 ePi Rational, Inc. All rights reserved.
//

import UIKit

class SettingDetailController: UIViewController {
    private let setting: Setting
    
    private lazy var titleLbl: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = setting.title
        return l
    }()
    
    private lazy var subtitleLbl: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = setting.subtitle
        return l
    }()
    
    private let infoBtn: UIButton = {
        let b = UIButton(type: .detailDisclosure)
        b.frame = .zero
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(detailTapped), for: .touchUpInside)
        return b
    }()
    
    private let dwnldBtn: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Download Offline Map", for: .normal)
        b.setTitleColor(.systemBlue, for: .normal)
        b.addTarget(self, action: #selector(downloadTapped), for: .touchUpInside)
        return b
    }()
    
    private let offlineLbl: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Offline Mode"
        return l
    }()
    
    private let offlineSubLbl: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Use Offline Mode"
        return l
    }()
    
    private let offlineSwitch: UISwitch = {
        let s = UISwitch(frame: .zero)
        s.translatesAutoresizingMaskIntoConstraints = false
        s.addTarget(self, action: #selector(switchToggled(sender:)), for: .valueChanged)
        return s
    }()
    
    init(setting: Setting) {
        self.setting = setting
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.container
        configureViews()
    }
    
    private func configureViews() {
        let topStk = UIStackView(arrangedSubviews: [titleLbl, subtitleLbl, dwnldBtn])
        topStk.translatesAutoresizingMaskIntoConstraints = false
        topStk.axis = .vertical
        topStk.distribution = .fillEqually
        topStk.alignment = .leading
        
        let btmStk = UIStackView(arrangedSubviews: [offlineLbl, offlineSubLbl])
        btmStk.translatesAutoresizingMaskIntoConstraints = false
        btmStk.axis = .vertical
        btmStk.distribution = .equalSpacing
        btmStk.alignment = .leading
        
        view.addSubview(topStk)
        view.addSubview(infoBtn)
        view.addSubview(btmStk)
        view.addSubview(offlineSwitch)
        
        let p = Default.padding * 2
        
        NSLayoutConstraint.activate([
            topStk.topAnchor.constraint(equalTo: view.topAnchor, constant: p),
            topStk.bottomAnchor.constraint(equalTo: view.centerYAnchor),
            topStk.leftAnchor.constraint(equalTo: view.leftAnchor, constant: p),
            btmStk.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            btmStk.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -p),
            btmStk.leftAnchor.constraint(equalTo: topStk.leftAnchor),
            offlineSwitch.centerYAnchor.constraint(equalTo: offlineSubLbl.centerYAnchor),
            offlineSwitch.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -p),
            infoBtn.centerYAnchor.constraint(equalTo: titleLbl.centerYAnchor),
            infoBtn.centerXAnchor.constraint(equalTo: offlineSwitch.centerXAnchor),
        ])
        
        offlineSwitch.setOn(setting.offlineEnabled, animated: false)
    }
    
    @objc func detailTapped() {
        //
    }
    
    @objc func downloadTapped() {
        //
    }
    
    @objc func switchToggled(sender: UISwitch) {
        setting.setOfflineEnabled(to: sender.isOn)
    }
}
extension SettingDetailController {
    private struct Color {
        static let bg = UIColor.lightText
        static let container = UIColor.lightText
        static let font = UIColor.black
        static let buttonFont = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
    }
}
