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
        font: .systemFont(ofSize: 14, weight: .regular)
    )
    lazy var eventDateLabel: UILabel = buildLabel(
        font: .systemFont(ofSize: 14, weight: .regular)
    )
    
    var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode         = .scaleAspectFill
        imageView.clipsToBounds       = true
        imageView.layer.cornerRadius  = 25
        imageView.layer.masksToBounds = true
        imageView.backgroundColor     = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis         = .vertical
        stackView.spacing      = 4
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis         = .horizontal
        stackView.alignment    = .top
        stackView.spacing      = 8
        stackView.addArrangedSubview(iconView)
        stackView.addArrangedSubview(titleStackView)
        stackView.addArrangedSubview(eventDateLabel)
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
            contentStackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
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
        var cell = LaunchCell()
        cell.nameLabel.text = "Falcon9"
        cell.descriptionLabel.text = "Did a good job landing"
        cell.eventDateLabel.text = "8/16/2004"
        cell.iconView.image = UIImage(systemName: "person")
        return cell
    }
    .frame(height: 200)
}
