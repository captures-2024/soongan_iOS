//
//  CustomSheetView.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 5/14/25.
//

import SwiftUI

import Shared

import ComposableArchitecture

public struct CustomSheetView: View {
    
    // MARK: - Properties
    
    @Environment(\.dismiss) private var dismiss
    private let type: SheetContentType
    
    // MARK: - Init
    
    public init(
        type: SheetContentType
    ) {
        self.type = type
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(spacing: 0) {
            titleSection(type)
            
            contentSection(type)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .presentationDetents(type.height)
        .presentationBackground(Color.white)
        .presentationCornerRadius(20)
    }
}

// MARK: - Private Extension View

private extension CustomSheetView {
    func titleSection(_ type: SheetContentType) -> some View {
        VStack(spacing: 12) {
            Capsule()
                .fill(Color.black100)
                .frame(width: 40, height: 4)
                .padding(.top, 16)
            
            Text(type.title)
                .font(.bold16)
                .foregroundStyle(Color.black100)
            
            Rectangle()
                .fill(Color.init(red: 187/255, green: 187/255, blue: 187/255))
                .frame(maxWidth: .infinity)
                .frame(height: 1)
        }
    }
    
    func contentSection(_ type: SheetContentType) -> some View {
        switch type {
        case .contestInfo:
            return AnyView(
                contestInfoContentSection(action: {})
                    .padding(.top, 40)
            )
        case .postPicture(let name):
            return AnyView(
                postPictureContetnSection(name: name, action: {})
                    .padding(.top, 40)
            )
        }
    }
    
    func contestInfoContentSection(action: @escaping () -> Void) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("규칙")
                .font(.semibold16)
                .padding(.bottom, 2)
            
            Text("작품 총 3개 출품 가능")
                .font(.regualr16)
                .padding(.bottom, 10)
                .padding(.leading, 16)
            
            Text("선정 방식")
                .font(.semibold16)
                .padding(.bottom, 4)
            
            Text("투표: 좋아요 개수로 TOP 7 선정")
                .font(.regualr16)
                .padding(.bottom, 4)
                .padding(.leading, 16)
            
            Text("기간 : 1달")
                .font(.regualr16)
                .padding(.bottom, 4)
                .padding(.leading, 16)
            
            Text("매달 1일 오전 9시 ~ 다음 달 1일 00시")
                .font(.regualr16)
                .padding(.bottom, 8)
                .padding(.leading, 16)
            
            Text("동점자 처리 방식")
                .font(.semibold16)
                .padding(.bottom, 4)
            
            Text("1. 직전 회차 참가자")
                .font(.regualr16)
                .padding(.bottom, 4)
                .padding(.leading, 16)
            
            Text("2. 업로드 시간을 비교해 더 일찍 참가한 작품")
                .font(.regualr16)
                .padding(.bottom, 8)
                .padding(.leading, 16)
            
            Text("리워드")
                .font(.semibold16)
                .padding(.bottom, 4)
            
            Text("최종 1위한 작품은\n앱 접속 시 나오는 화면에 배경 사진으로 사용")
                .font(.regualr16)
                .padding(.bottom, 4)
                .padding(.leading, 16)
            
            Text("(차기 콘테스트 종료 시까지)")
                .font(.regualr16)
                .padding(.leading, 16)
            
            CustomBottomButton(
                type: .comfirm,
                action: {
                    action()
                    dismiss()
                }
            )
            .padding(.top, 40)
            .padding(.horizontal, -2)
        }
        .foregroundStyle(Color.black)
        .padding(.horizontal, 38)
    }
    
    func postPictureContetnSection(name: String, action: @escaping () -> Void) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            
            VStack(alignment: .leading, spacing: 5) {
                Text("<\(name)>")
                Text("(으)로 작품을 제출할까요?")
            }
            .padding(.horizontal, 20)
            
            CustomBottomButton(
                type: .complete,
                action: {
                    action()
                    dismiss()
                }
            )
            .padding(.top, 40)
        }
        .font(.regualr16)
        .foregroundStyle(Color.black)
        .padding(.horizontal, 20)
    }
}

// MARK: - Preview

#Preview {
    CustomSheetView(type: .contestInfo)
}
