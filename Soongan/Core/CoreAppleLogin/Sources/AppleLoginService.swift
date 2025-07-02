//
//  AppleLoginService.swift
//  Core
//
//  Created by ParkJunHyuk on 5/25/25.
//

import AuthenticationServices

public final class AppleLoginService: NSObject, AppleLoginServiceProtocol {
    public static let shared = AppleLoginService()
    
    private override init() {}
    
    private var continuation: CheckedContinuation<String, Error>?

    public func login() async throws -> (String) {
       return try await withCheckedThrowingContinuation { continuation in
           self.continuation = continuation
           let provider = ASAuthorizationAppleIDProvider()
           let request = provider.createRequest()
           request.requestedScopes = []
           
           let controller = ASAuthorizationController(authorizationRequests: [request])
           controller.delegate = self
           controller.presentationContextProvider = self
           controller.performRequests()
       }
   }
}

extension AppleLoginService: ASAuthorizationControllerDelegate {
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            continuation?.resume(throwing: AppleLoginError.noCredential)
            return
        }
        
        guard let identityTokenData = credential.identityToken,
              let identityToken = String(data: identityTokenData, encoding: .utf8) else {
            continuation?.resume(throwing: AppleLoginError.noCredential)
            return
        }

        print("애플로그인 결과 반환", identityToken)

        continuation?.resume(returning: identityToken)
   }

   public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
       continuation?.resume(throwing: error)
   }
}

extension AppleLoginService: ASAuthorizationControllerPresentationContextProviding {
   public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
       return UIApplication.shared.connectedScenes
           .compactMap { $0 as? UIWindowScene }
           .flatMap { $0.windows }
           .first { $0.isKeyWindow } ?? UIWindow()
   }
}
