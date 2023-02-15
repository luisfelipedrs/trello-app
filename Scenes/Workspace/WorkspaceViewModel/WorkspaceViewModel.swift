//
//  WorkspaceViewModel.swift
//  trello-app1
//
//  Created by Luis Felipe on 06/02/23.
//

import Foundation

public final class WorkspaceViewModel {
    
    weak var delegate: DataReloadDelegate?
    
    var boards: [Board] = [] {
        didSet {
            self.delegate?.reload()
        }
    }
    
    public func getBoards() {
        boards = MockApi.getBoads()
    }
}
