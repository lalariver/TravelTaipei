//
//  ViewModel.swift
//  TravelTaipei
//
//  Created by user on 2024/12/30.
//

import Foundation

class FrontPageViewModel {
    @Published var attractions: [CellType] = []
    @Published var newsList: [CellType] = []
    public let sectionTitle = ["最新消息".localized, "遊憩景點".localized]
    @Published var errorMessage: String? = nil
    
    private var isFetching = false
    private var page = 1
    private var total = 0
    
    init() {
        Task {
            await self.fetchData()
        }
    }
    
    private func fetchData(restart: Bool = false) async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask { [weak self] in
                await self?.fetchAttractions(restart: restart)
            }
            group.addTask { [weak self] in
                await self?.fetchNews(restart: restart)
            }
        }
    }
    
    public func cellType(for indexPath: IndexPath) -> CellType? {
        switch indexPath.section {
        case 0:
            return newsList[indexPath.row]
        case 1:
            return attractions[indexPath.row]
        default:
            return nil
        }
    }
    
    public func attractionNextPage() {
        guard !isFetching else { return }
        page += 1
        Task {
            await self.fetchAttractions()
        }
    }
    
    private func fetchNews(restart: Bool) async {
        NetworkService.shared.request(api: .eventsNews(page: "1"), model: NewsApiModel.self) { [weak self] result in
            Task { @MainActor in
                if restart {
                    self?.newsList = []
                }
                switch result {
                case .success(let news):
                    if let data = news.data {
                        self?.newsList += data.map { newsData in
                            let cellModel = NewsCellModel(newsData: newsData)
                            return NewsCellType(model: cellModel)
                        }
                    } else {
                        self?.errorMessage = "Data Error"
                    }
                case .failure(let error):
                    self?.errorMessage = "Request failed with error: \(error)"
                }
            }
        }
    }
    
    private func fetchAttractions(restart: Bool = false) async {
        guard !isFetching, total == 0 || attractions.count < total else { return }
        isFetching = true
        
        NetworkService.shared.request(api: .attractionsAll(page: "\(page)"), model: AttractionsApiModel.self) { [weak self] result in
            self?.isFetching = false
            
            Task { @MainActor in
                if restart {
                    self?.attractions = []
                }
                switch result {
                case .success(let attraction):
                    self?.total = attraction.total ?? 0
                    if let data = attraction.data {
                        self?.attractions += data.map { attraction in
                            let cellModel = AttractionCellModel(attraction: attraction)
                            return AttractionCellType(model: cellModel)
                        }
                    } else {
                        self?.errorMessage = "Data Error"
                    }
                case .failure(let error):
                    self?.errorMessage = "Request failed with error: \(error)"
                }
            }
        }
    }
}
