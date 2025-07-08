//
//  DetailContestFeature.swift
//  AllTimeContestFeature
//
//  Created by ParkJunHyuk on 6/12/25.
//

import SwiftUI

import CoreNetwork
import DesignSystem
import Shared

import ComposableArchitecture

@Reducer
public struct DetailContestFeature {
    
    // MARK: - State
    
    @ObservableState
    public struct State: Equatable {
        var contestInfoData: DetailContestInfoModel
        
        var contestCount: Int?
        var firstPostData: DetailHistoryFirstPostModel?
        var otherPostData: [DetailHistoryOtherPostModel]?
    }
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Action
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case onAppear
        case detailHistoryContestSuccessResponse(SearchDetailAwardContestResponseDTO)
        
        case backButtonTapped
    }
    
    // MARK: - Body
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
     
            case .onAppear:
                let contestId = state.contestInfoData.id
                
                return .run { send in
                    let result: Result<SearchDetailAwardContestResponseDTO, NetworkError> = await NetworkManager.shared.request(AwardEndpoint.getDetailAwardContest(contestId: contestId))
                    
                    switch result {
                    case .success(let responseResult):
                        return await send(.detailHistoryContestSuccessResponse(responseResult))
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                
            case .detailHistoryContestSuccessResponse(let response):
                state.contestCount = response.postsCount
                state.firstPostData = convertFirstModel(response.firstPrizePost)
                state.otherPostData = convertOtherModel(response.otherTop7Posts)
                
                return .none
                
            default:
                return .none
            }
        }
    }
}

// MARK: - Private function Extension

private extension DetailContestFeature {
    func convertFirstModel(_ data: FirstPostInfo) -> DetailHistoryFirstPostModel {
        return DetailHistoryFirstPostModel(
            id: data.postId,
            nickName: data.nickname,
            postTitle: data.title,
            likeCount: data.score,
            imageUrl: data.imageUrl
        )
    }
    
    func convertOtherModel(_ data: [OtherPosts]) -> [DetailHistoryOtherPostModel]  {
        return data.map {
            DetailHistoryOtherPostModel(
                id: $0.postId,
                nickName: $0.nickname,
                likeCount: $0.score,
                imageUrl: $0.imageUrl,
                ranking: $0.ranking
            )
        }
    }
}
