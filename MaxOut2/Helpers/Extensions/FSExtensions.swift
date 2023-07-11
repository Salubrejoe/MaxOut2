

import Combine
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


// MARK: - Query
extension Query {
  func getDocuments<T: Decodable>(as type: T.Type) async throws -> [T] {
    return try await getDocumentsWithSnapshot(as: type).result
  }
  
  func getDocumentsWithSnapshot<T: Decodable>(as: T.Type) async throws -> (result: [T], lastDocument: DocumentSnapshot?) {
    let snapshot = try await self.getDocuments()
    let arrayOfType = try snapshot.documents.map { document in
      try document.data(as: T.self)
    }
    return (arrayOfType, snapshot.documents.last)
  }
  
  func startIf(lastDocument: DocumentSnapshot?) -> Query {
    guard let lastDocument else { return self }
    return self.start(afterDocument: lastDocument)
  }
  
  func aggregateCount() async throws -> Int {
    let snapshot = try await self.count.getAggregation(source: .server)
    return Int(truncating: snapshot.count)
  }
  
  func addSnaphotListener<T: Decodable>(as type: T.Type) -> (AnyPublisher<[T], Error>, ListenerRegistration)  {
    let publisher = PassthroughSubject<[T], Error>()
    
    let listener = self
      .addSnapshotListener { querySnapshot, error in // anything inside this closure happens async so............
        
        guard let documents = querySnapshot?.documents else { return }
        
        // compactMap meand we are going to return documents transformed to type but not going to care if any fails
        let arrayOfType: [T] = documents.compactMap { try? $0.data(as: T.self) }
        publisher.send(arrayOfType)
      }
    
    // ......this line is executed right away after the very first one
    return (publisher.eraseToAnyPublisher(), listener) // easier to handle if we return AnyPublisher
  }
}
