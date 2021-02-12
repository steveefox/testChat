
import Foundation
import FirebaseAuth
import FirebaseStorage


class FirebaseStorageService {
    
    static let shared = FirebaseStorageService()
    private init() {}
    
    private let storageRef = Storage.storage().reference()
    
    private var avatarsRef: StorageReference {
        storageRef.child("avatars")
    }
    
    private var currentUserId: String {
        Auth.auth().currentUser!.uid
    }
    
    func upload(photo: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        
        guard let scaledImage = photo.scaledToSafeUploadSize,
              let imageData = scaledImage.jpegData(compressionQuality: 0.4)
        else { return }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        avatarsRef.child(currentUserId).putData(imageData, metadata: metaData) { metada , error in
            guard let _ = metada else {
                completion(.failure(error!))
                return
            }
            
            self.avatarsRef.child(self.currentUserId).downloadURL { url , error  in
                guard let downloadUrl = url else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(downloadUrl))
            }
            
        }
        
    }
    
    
}
