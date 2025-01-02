//
//  AttractionViewController.swift
//  TravelTaipei
//
//  Created by user on 2025/1/1.
//

import UIKit
import SnapKit
import Combine
import Kingfisher

class AttractionViewController: UIViewController {
    // UI Components
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var businessHoursLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var addressButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(openMap), for: .touchUpInside)
        return button
    }()
    
    private lazy var phoneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(callPhone), for: .touchUpInside)
        return button
    }()
    
    private lazy var websiteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(openWebsite), for: .touchUpInside)
        return button
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isEditable = false
        textView.isScrollEnabled = true
        return textView
    }()
    
    private let cellModel: AttractionCellModel
    
    private var cancellables = Set<AnyCancellable>()
    
    init(cellModel: AttractionCellModel) {
        self.cellModel = cellModel
        super.init(nibName: nil, bundle: nil)
        
        self.title = cellModel.title
        
        if let urlStr = cellModel.imageUrl,
           let url = URL(string: urlStr) {
            imageView.kf.setImage(with: url)
        }
        
        businessHoursLabel.text = cellModel.openTiem
        addressButton.setTitle(cellModel.address, for: .normal)
        phoneButton.setTitle(cellModel.displayTel, for: .normal)
        websiteButton.setTitle(cellModel.url, for: .normal)
        descriptionTextView.text = cellModel.subtitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        // Add Subviews
        view.addSubview(imageView)
        view.addSubview(businessHoursLabel)
        view.addSubview(addressButton)
        view.addSubview(phoneButton)
        view.addSubview(websiteButton)
        view.addSubview(descriptionTextView)
        
        // Layout with SnapKit
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(200)
        }
        
        businessHoursLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        addressButton.snp.makeConstraints { make in
            make.top.equalTo(businessHoursLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        phoneButton.snp.makeConstraints { make in
            make.top.equalTo(addressButton.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        websiteButton.snp.makeConstraints { make in
            make.top.equalTo(phoneButton.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(websiteButton.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
    }
    
    @objc private func openMap() {
        guard let address = cellModel.address,
              let url = URL(string: "https://maps.apple.com/?q=\(address)")
        else { return }
        UIApplication.shared.open(url)
    }
    
    @objc private func callPhone() {
        guard let tel = cellModel.tel,
              let url = URL(string: "tel:\(tel)") else
        { return }
        UIApplication.shared.open(url)
    }
    
    @objc private func openWebsite() {
        guard let urlStr = cellModel.url,
              let url = URL(string: urlStr)
        else { return }
        
        let alert = UIAlertController.displayURLSelectionAlert { [weak self] openOption in
            switch openOption {
            case .internal:
                let vc = WebViewController(url: url)
                self?.navigationController?.pushViewController(vc, animated: true)
            case .external:
                UIApplication.shared.open(url)
            }
        }
        
        present(alert, animated: true)
    }
}
