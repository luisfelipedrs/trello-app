//
//  BoardViewModel.swift
//  trello-app1
//
//  Created by Luis Felipe on 10/02/23.
//

import Foundation

protocol ListViewModelDelegate: AnyObject {
    func loadBackgroundImage()
}

public final class ListViewModel {
    
    weak var delegate: DataReloadDelegate?
    weak var viewModelDelegate: ListViewModelDelegate?
    
    var api: PhotoApi?
    
    var board: Board?
    
    func getLists() {
        guard let boardLists = board?.lists else { return }
        board?.lists = boardLists
    }
    
    func addList(_ list: List) {
        self.board?.addList(list)
        self.delegate?.reload()
    }
    
    func getBackgroudImageUrl() {
        if board?.backgroundImageUrl == nil {
            api?.getPhoto { [weak self] result in
                
                switch result {
                case .success(let photo):
                    if photo.media_type == "image" {
                        self?.board?.backgroundImageUrl = photo.url
                        self?.viewModelDelegate?.loadBackgroundImage()
                    } else {
                        self?.getBackgroudImageUrl()
                    }
                    
                case .failure(let error):
                    print("erro na api: \(error)")
                }
            }
        } else {
            self.viewModelDelegate?.loadBackgroundImage()
        }
    }
}
