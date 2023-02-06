//
//  ViewController.swift
//  trello-app1
//
//  Created by Luis Felipe on 06/02/23.
//

import UIKit

class WorkspaceViewController: UIViewController {
    
    var viewModel: WorkspaceViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        applyTheme()
    }


}

