//
//  BusyTableViewModel.swift
//  Reservation
//
//  Created by Victor Ayala on 2023-06-08.
//

import SwiftUI
import Alamofire
import AlamofireActivityLogger

enum StatusClosedTable {
    case success
    case failed
}

class BusyTableViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var consumptionHeader: ConsumptionHeaderModel = ConsumptionHeaderModel()
    @Published var consumptionDetails: [ConsumptionDetailModel] = [ConsumptionDetailModel]()
    let table: TableModel
    
    @Published var selectedClient: ClientModel = ClientModel()
    
    init(table: TableModel) {
        self.table = table
    }
    
    func getConsumptions() {
        self.getConsumptionHeader()
    }
    
    private func getConsumptionHeader() {
        self.isLoading = true
        APIClient.apiRequest(
            api: .consumptionHeader("\(self.table.id ?? 0)"),
            successHandler: { (consumptionHeader: ConsumptionHeaderModel) in
                self.consumptionHeader = consumptionHeader
                self.getConsumptionDetails(consumptionHeader: consumptionHeader)
            },
            errorHandler: { (error: ErrorModel) in
                self.isLoading = false
                return false // Unknown error, use default error handler.
            }
        )
    }
    
    private func getConsumptionDetails(consumptionHeader: ConsumptionHeaderModel) {
        APIClient.apiRequest(
            api: .consumptionDetails("\(consumptionHeader.id ?? 0)"),
            successHandler: { (consumptionDetails: [ConsumptionDetailModel]) in
                self.consumptionDetails = consumptionDetails
                self.isLoading = false
            },
            errorHandler: { (error: ErrorModel) in
                self.isLoading = false
                return false // Unknown error, use default error handler.
            }
        )
    }
    
    func changeClient() {
        if let id = selectedClient.id {
            let parms: JSONObject = [
                "consumoHeaderId": consumptionHeader.id ?? "",
                "clienteId": id
            ]
            self.isLoading = true
            APIClient.apiRequest(
                method: .put,
                api: .consumptionHeader("cambiar-cliente"),
                parameters: parms,
                successHandler: { (consumptionHeader: ConsumptionHeaderModel) in
                    self.consumptionHeader = consumptionHeader
                    self.getConsumptions()
                    Utils.showBarnner(title: "Successful client change", subtitle: "The client for table \(self.table.name ?? "") was successfully changed")
                    self.isLoading = false
                },
                errorHandler: { (error: ErrorModel) in
                    self.isLoading = false
                    return false // Unknown error, use default error handler.
                }
            )
        }
    }
    
    func downloadPDF(completation: @escaping (StatusClosedTable) -> ()) {
        let destinationURL = getDestinationURL()
        self.isLoading = true
        Alamofire.request("http://localhost:9090/api/services/cerrar-mesa/\(table.id ?? 0)", method: .put).log()
            .responseData { response in
                self.isLoading = false
                switch response.result {
                case let .success(data):
                    do {
                        try data.write(to: destinationURL)
                        print("Archivo descargado correctamente")
                        completation(.success)
                    } catch {
                        print("Error al guardar el archivo descargado: \(error)")
                        completation(.failed)
                    }
                case let .failure(error):
                    completation(.failed)
                    print("Error al descargar el archivo: \(error)")
                }
            }
    }
    
    private func getDestinationURL() -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent("archivo.pdf")
        return fileURL
    }
}
