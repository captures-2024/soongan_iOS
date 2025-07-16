//
//  MultipartFormDataFile.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 7/4/25.
//

import Foundation

public struct MultipartFormDataFile {
    /// 파일의 실제 데이터
    let data: Data
    /// 서버에 전송될 파일의 이름
    let filename: String
    /// 파일의 MIME 타입 (예: "image/jpeg")
    let mimeType: String
}
