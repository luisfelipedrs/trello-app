//
//  WorkspaceViewModel.swift
//  trello-app1
//
//  Created by Luis Felipe on 06/02/23.
//

import Foundation

public final class WorkspaceViewModel {
    
    var boards: [Board] = []
    
    public func getBoards() {
        boards = MockApi.getBoads()
    }
}
