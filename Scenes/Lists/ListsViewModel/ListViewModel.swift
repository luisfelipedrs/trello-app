//
//  BoardViewModel.swift
//  trello-app1
//
//  Created by Luis Felipe on 10/02/23.
//

import Foundation

protocol ListViewModelDelegate: AnyObject {
    func loadBackgroundImage()
    func reload()
}

public final class ListViewModel {
    
    weak var delegate: ListViewModelDelegate?
    var api: PhotoApi?
    var board: TrelloBoard?
    
    func getBackgroudImageUrl() {
        if board?.backgroundImageUrl == nil {
            api?.getPhoto { [weak self] result in
                
                switch result {
                case .success(let photo):
                    if photo.media_type == "image" {
                        self?.board?.backgroundImageUrl = photo.url
                        self?.delegate?.loadBackgroundImage()
                    } else {
                        self?.getBackgroudImageUrl()
                    }
                    
                case .failure(let error):
                    print("erro na api: \(error)")
                }
            }
        } else {
            self.delegate?.loadBackgroundImage()
        }
    }
}
