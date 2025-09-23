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
        
        // 특수문자가 존재하는 경우
        let regex = "^[가-힣a-zA-Z0-9]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        if !predicate.evaluate(with: self) {
            return .invalidCharacters
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
        
        return .valid
    }
    
    /// ISO 8601 형식의 문자열을 지정된 형식의 날짜 문자열로 변환합니다.
    ///
    /// - Parameter showTime: `true`이면 시간(HH:mm:ss)까지, `false`이면 날짜(yyyy.MM.dd)까지만 표시합니다. (기본값: `true`)
    /// - Returns: 변환된 날짜 문자열 또는 변환 실패 시 "알수없음".
    func toFormattedDateString(showTime: Bool = true) -> String {
        let isoFormatter = DateFormatter()
        isoFormatter.locale = Locale(identifier: "en_US_POSIX")
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "ko_KR")
        outputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        // showTime 값에 따라 날짜 포맷을 다르게 설정합니다.
        outputFormatter.dateFormat = showTime ? "yyyy.MM.dd HH:mm:ss" : "yyyy.MM.dd"
        
        guard let date = isoFormatter.date(from: self) else {
            return "알수없음"
        }
        
        return outputFormatter.string(from: date)
    }
}
