//
//  String+.swift
//  Terbuck
//
//  Created by ParkJunHyuk on 5/2/25.
//

import Foundation

public enum NicknameValidationState: Equatable {
    case empty
    case tooShort
    case tooLong
    case invalidCharacters
    case valid
    case onlyConsonantsOrVowels
}

public extension String {
    var nicknameValidationState: NicknameValidationState {
        if self.isEmpty {
            return .empty
        }

        if self.count < 3 {
            return .tooShort
        }

        if self.count > 10 {
            return .tooLong
        }
        
        // 자음/모음만 있는 경우
        let disallowedCharacters = "ㄱㄲㄴㄷㄸㄹㅁㅂㅃㅅㅆㅇㅈㅉㅊㅋㅌㅍㅎㅏㅐㅑㅒㅓㅔㅕㅖㅗㅛㅜㅠㅡㅣ"
        if self.contains(where: { disallowedCharacters.contains($0) }) {
            return .onlyConsonantsOrVowels
        }

        // 특수문자가 존재하는 경우
        let regex = "^[가-힣a-zA-Z0-9]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        if !predicate.evaluate(with: self) {
            return .invalidCharacters
        }

        return .valid
    }
}
