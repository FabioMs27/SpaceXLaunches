//
//  LaunchListCell.swift
//  SpaceXLaunches
//
//  Created by Fábio Maciel de Sousa on 07.10.2024.
//

import UIKit
import UIKitNavigation

class LaunchCell: UICollectionViewCell {
    
    static let reusableID = "LaunchCell"
    
    lazy var nameLabel: UILabel = buildLabel(
        font: .systemFont(ofSize: 16, weight: .bold)
    )
    lazy var descriptionLabel: UILabel = buildLabel(
        font: .systemFont(ofSize: 14, weight: .regular),
        lines: 4
    )
    lazy var eventDateLabel: UILabel = buildLabel(
        font: .systemFont(ofSize: 14, weight: .regular)
    )
    
    var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode           = .scaleAspectFit
        imageView.layer.masksToBounds   = false
        imageView.layer.cornerRadius    = 22
        imageView.layer.shouldRasterize = true
        imageView.clipsToBounds         = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis            = .vertical
        stackView.alignment       = .leading
        stackView.spacing         = 4
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis         = .horizontal
        stackView.alignment    = .top
        stackView.distribution = .fill
        stackView.spacing      = 8
        eventDateLabel.setContentHuggingPriority(.required, for: .horizontal)
        stackView.addArrangedSubview(titleStackView)
        stackView.addArrangedSubview(eventDateLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis         = .horizontal
        stackView.distribution = .fill
        stackView.alignment    = .top
        stackView.spacing      = 8
        stackView.addArrangedSubview(iconView)
        stackView.addArrangedSubview(labelsStackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

private extension LaunchCell {
    func buildLabel(
        font: UIFont,
        lines: Int = 0,
        text: String = .init(),
        color: UIColor = .black,
        alignment: NSTextAlignment = .left
    ) -> UILabel {
        let label = UILabel()
        label.numberOfLines = lines
        label.text = text
        label.textAlignment = alignment
        label.font = font
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}

extension LaunchCell: ViewCodable {
    func setupHierarchyViews() {
        contentView.addSubview(contentStackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            
            iconView.heightAnchor.constraint(equalToConstant: 100),
            iconView.widthAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    func setupAdditionalConfiguration() {
        contentView.layoutMargins = .init(
            top: 16,
            left: 16,
            bottom: 16,
            right: 16
        )
        contentView.backgroundColor = .white
    }
}

import SwiftUI
#Preview {
    UIViewRepresenting {
        let cell = LaunchCell()
        cell.nameLabel.text = "Falcon9"
        cell.descriptionLabel.text = "Did a good job landing"
        cell.eventDateLabel.text = "8/16/2004"
        cell.iconView.image = UIImage(named: "launch-icon-test")
        return cell
    }
    .frame(height: 150)
}
