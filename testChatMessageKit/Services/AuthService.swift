

import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn

class AuthService {
    
    static let shared = AuthService()
    private init() {}
    
    private let auth = Auth.auth()
    
    func login(email: String?, password: String?, competion: @escaping (Result<User, Error>) -> Void) {
        
        guard let email = email, let password = password else {
            competion(.failure(AuthError.notFilled))
            return
        }
         
        
        auth.signIn(withEmail: email, password: password) { result, error in
            guard let result = result else {
                competion(.failure(error!))
                return
            }
            competion(.success(result.user))
        }
    }
    
    func googleLogin(user: GIDGoogleUser!, error: Error!, completion: @escaping (Result<User, Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let auth = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        
        Auth.auth().signIn(with: credential) { result , error in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }
    
    
    func register(email: String?, password: String?, confirmPassword: String?, competion: @escaping (Result<User, Error>) -> Void) {
        
        guard Validator.isFilled(email: email, password: password, confirmPassword: confirmPassword)
        else {
            competion(.failure(AuthError.notFilled))
            return
        }
        
        guard password!.lowercased() == confirmPassword!.lowercased() else {
            competion(.failure(AuthError.passwordNotMatched))
            return
        }
        
        guard Validator.isSimpleEmail(email!) else {
            competion(.failure(AuthError.invalidEmail))
            return
        }
        
        auth.createUser(withEmail: email!, password: password!) { result , error  in
            guard let result = result else {
                competion(.failure(error!))
                return
            }
            competion(.success(result.user))
            
        }
    }
    
}

