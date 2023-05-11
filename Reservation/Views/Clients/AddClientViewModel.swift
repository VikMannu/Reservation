//
//  AddClientViewModel.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-11.
//

import Foundation

class AddClientViewModel: ObservableObject {
    @Published var isLoading = false
    
    func addClient(with client: ClientModel) {
        self.isLoading = true
        APIClient.apiRequest(
            method: .post,
            api: .client(""),
            parameters: client.rsk_dictionary ?? ["": ""],
            successHandler: { (client: ClientModel) in
                self.isLoading = false
            },
            errorHandler: { (error: ErrorModel) in
                self.isLoading = false
                return false // Unknown error, use default error handler.
            }
        )
    }
}
