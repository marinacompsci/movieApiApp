//
//  DetailViewController.swift
//  movieApi
//
//  Created by Marina Beatriz Santana de Aguiar on 15.07.20.
//  Copyright © 2020 Marina Beatriz Santana de Aguiar. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    let imageURL: String?
    let mediaTitle: String
    let year: String?
    let plot: String?
    
    var imageView = UIImageView()
    let titleLabel = UILabel()
    let yearLabel = UILabel()
    let plotLabel = UITextView()
    let backButton = UIButton(type: .close)
    
    init(mediaTitle: String, year: String, plot: String?, imageURL: String?, nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.mediaTitle = mediaTitle
        self.year = year
        self.plot = plot
        self.imageURL = imageURL
        super.init(nibName: nil, bundle: nil)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        plotLabel.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(dismissDetailVC), for: .touchUpInside)
        
        view.addSubview(titleLabel)
        view.addSubview(yearLabel)
        view.addSubview(plotLabel)
        view.addSubview(backButton)
      
        configureImageView()
        configureMediaTitle()
        configureYearLabel()
        configurePlotLabel()
        configureBackButton()
        
        layoutImageView()
        layoutTitleLabel()
        layoutYearLabel()
        layoutPlotLabel()
    }
    
    private func configureYearLabel() {
        if let year = self.year {
            yearLabel.text = year
            yearLabel.font = UIFont.preferredFont(forTextStyle: .title2)
            yearLabel.textColor = .label
        }
    }
    
    private func configurePlotLabel() {
      if let plot = self.plot {
            plotLabel.text = plot
            plotLabel.adjustsFontForContentSizeCategory = true
            plotLabel.isScrollEnabled = true
            plotLabel.showsVerticalScrollIndicator = true
            plotLabel.font = UIFont.preferredFont(forTextStyle: .title3)
            plotLabel.textColor = .label
        }
    }
    
    private func configureImageView() {
        if let _ = URL(string: imageURL!) {
            setImage()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.clipsToBounds = true
            imageView.contentMode = .center
            imageView.layer.masksToBounds = true
            imageView.backgroundColor = .secondarySystemBackground
            
            let alphaLayer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.5))
            alphaLayer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15)
            imageView.addSubview(alphaLayer)
            view.addSubview(imageView)
        }
    }
    
    private func configureMediaTitle() {
        titleLabel.text = mediaTitle
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        titleLabel.textColor = .label
    }
    
    private func configureBackButton() {
        backButton.titleLabel?.text = "Results"
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        backButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
    }
    
    private func layoutImageView() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
    }
    
    private func layoutTitleLabel() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
    
    private func layoutYearLabel() {
        NSLayoutConstraint.activate([
            yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            yearLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            yearLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
    
    private func layoutPlotLabel() {
        NSLayoutConstraint.activate([
            plotLabel.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 20),
            plotLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            plotLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            plotLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setImage() {
        if let passedURL = imageURL {
            if let cachedImage = SearchController.imageCache.object(forKey: NSString(string: passedURL)) {
                // image already cached -- get it from the cache
                imageView.image = cachedImage
                return
            }
            // image not cached -- cache it
            if let imageURL = URL(string: passedURL) {
                do {
                    let data = try Data(contentsOf: imageURL)
                    if let compressedImageData = UIImage(data: data)?.jpegData(compressionQuality: 0.5), let compressedImage = UIImage(data: compressedImageData) {
                        SearchController.imageCache.setObject(compressedImage, forKey: NSString(string: passedURL))
                        imageView.image = UIImage(data: compressedImageData)
                        return
                    }
                } catch {
                    print("Cannot get image from url. Error: \(error.localizedDescription)")
                    imageView.image = UIImage(systemName: Images.placeholder.rawValue)
                    imageView.tintColor = .label
                }
            }
        }
        imageView.image = UIImage(systemName: Images.placeholder.rawValue)
        imageView.tintColor = .label
    }
    
    
    @objc private func dismissDetailVC() {
        dismiss(animated: true)
    }
}