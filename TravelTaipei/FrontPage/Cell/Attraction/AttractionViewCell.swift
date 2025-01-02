//
//  CustomTableViewCell.swift
//  TravelTaipei
//
//  Created by user on 2024/12/27.
//

import UIKit
import Kingfisher

protocol CellType {
    /// 用於註冊和復用的 Identifier
    var cellIdentifier: String { get }
    
    /// 配置 Cell 的邏輯
    func configure(cell: UITableViewCell)
}

struct AttractionCellType: CellType {
    let model: AttractionCellModel  // 此 Cell 對應的資料模型
    
    var cellIdentifier: String {
        return "AttractionViewCell"
    }
    
    func configure(cell: UITableViewCell) {
        guard let cell = cell as? AttractionViewCell else { return }
        cell.configure(with: model)  // 呼叫具體的配置方法
    }
}

class AttractionViewCell: UITableViewCell {
    private lazy var viewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .gray
        return imageView
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(viewImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(arrowImageView)
        
        viewImageView.snp.makeConstraints { make in
            make.size.equalTo(50) // 寬高 50
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalTo(viewImageView.snp.right).offset(16)
            make.right.lessThanOrEqualTo(arrowImageView.snp.left).offset(-8)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.equalTo(titleLabel)
            make.right.equalTo(titleLabel)
            make.bottom.equalToSuperview().offset(-8)
        }
         
        arrowImageView.snp.makeConstraints { make in
            make.size.equalTo(16)
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
    
    // 配置 cell 的方法
    public func configure(with model: AttractionCellModel) {
        if let urlStr = model.imageUrl,
           let imageUrl = URL(string: urlStr) {
            viewImageView.kf.setImage(with: imageUrl)
        }
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
