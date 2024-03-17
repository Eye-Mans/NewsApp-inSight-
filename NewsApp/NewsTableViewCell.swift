//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Lalu Iman Abdullah on 14/03/24.
//

import UIKit

class NewsTableViewCellViewModel{
    let title: String
    let subtitle: String
    let imageURL: URL?
    var imageData: Data? = nil
    
    init(
        title: String,
        subtitle: String,
        imageURL: URL?
    ){
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
    }
}

class NewsTableViewCell: UITableViewCell {

   static let identifier = "NewsTableViewCell"
    
    private let newsTitleLabel: UILabel = {
      let label = UILabel()
      label.numberOfLines = 0
      label.font = .systemFont(ofSize: 20, weight: .bold)
      return label
    }()

    private let subtitleLabel: UILabel = {
      let label = UILabel()
      label.numberOfLines = 0
      label.font = .systemFont(ofSize: 17, weight: .light)
      return label
    }()

    private let newsImageView: UIImageView = {
      let imageView = UIImageView()
      imageView.layer.cornerRadius = 7
      imageView.layer.masksToBounds = true
      imageView.clipsToBounds = true
      imageView.backgroundColor = .secondarySystemBackground
      imageView.contentMode = .scaleAspectFill
      return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(newsImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        newsImageView.frame = CGRect(x: 5, y: 0, width: contentView.frame.width - 20, height: 150)
        newsTitleLabel.frame = CGRect(x: 10, y: 150, width: contentView.frame.width - 20, height: 70)
        subtitleLabel.frame = CGRect(x: 10, y: 120, width: contentView.frame.width - 20, height: contentView.frame.size.height - 70)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsTitleLabel.text = nil
        subtitleLabel.text = nil
        newsImageView.image = nil
    }
    
    func configure(with viewModel: NewsTableViewCellViewModel){
        newsTitleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        
        // Image
        if let data = viewModel.imageData{
            newsImageView.image = UIImage(data: data)
        }else if let url = viewModel.imageURL{
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else{
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async{
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
    

}
