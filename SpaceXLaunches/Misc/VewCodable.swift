//
//  VewCodable.swift
//  SpaceXLaunches
//
//  Created by Fábio Maciel de Sousa on 07.10.2024.
//

import Foundation
import UIKit

// Programmatic view protocol
protocol ViewCodable {
    func setupViews()
    func setupHierarchyViews()
    func setupConstraints()
    func setupAdditionalConfiguration()
}

extension ViewCodable {
    func setupViews() {
        setupHierarchyViews()
        setupConstraints()
        setupAdditionalConfiguration()
    }
    
    func setupAdditionalConfiguration() {}
}
