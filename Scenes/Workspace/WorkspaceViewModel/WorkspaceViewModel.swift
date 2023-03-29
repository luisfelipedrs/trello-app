//
//  WorkspaceViewModel.swift
//  trello-app1
//
//  Created by Luis Felipe on 06/02/23.
//

import Foundation

protocol WorkspaceViewModelDelegate: AnyObject {
    func reload()
}

public final class WorkspaceViewModel {
    
    weak var delegate: WorkspaceViewModelDelegate?
    
    var boards: [TrelloBoard] = [] {
        didSet {
            self.delegate?.reload()
        }
    }
    
//    public func getBoards() {
//        boards = MockApi.getBoads()
//    }
}
