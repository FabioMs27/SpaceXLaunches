//
//  ViewController.swift
//  SpaceXLaunches
//
//  Created by Fábio Maciel de Sousa on 06.10.2024.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the background color or other UI configurations
        view.backgroundColor = .white
        
        // Add UI elements programmatically
        let label = UILabel()
        label.text = "Hello, World!"
        label.textAlignment = .center
        label.frame = view.bounds
        view.addSubview(label)
    }


}

