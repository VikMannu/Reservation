//
//  BusyTableView.swift
//  Reservation
//
//  Created by Victor Ayala on 2023-06-08.
//

import SwiftUI

struct BusyTableView: View {
    @StateObject var viewModel: BusyTableViewModel
    @State private var showingAddDetail = false
    @State private var showingChangeClient = false
    
    init(table: TableModel) {
        self._viewModel = StateObject(wrappedValue: BusyTableViewModel(table: table))
    }
    
    var body: some View {
        ZStack {
            VStack {
                List {
                    Section(header: Text("Header").font(.title).foregroundColor(.blue)) {
                        NavigationLink(
                            destination: {
                                ClientsView(viewModelFilter: viewModel)
                                    .onDisappear {
                                        viewModel.changeClient()
                                    }
                            },
                            label: {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("Client: ")
                                        Text(viewModel.consumptionHeader.client?.description ?? "")
                                    }
                                    HStack {
                                        Text("Total: ")
                                        Text("\(viewModel.consumptionHeader.total ?? 0)")
                                    }
                                }
                            }
                        )
                    }
                    
                    Section(header: Text("Details").font(.title).foregroundColor(.blue)) {
                        ForEach(viewModel.consumptionDetails, id: \.id) { consumptionDetail in
                            RowProductView(consumptionDetail: consumptionDetail)
                        }
                    }
                }
                
                Button(
                    action: { self.releaseTable() },
                    label: {
                        Text("Release table")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: 36)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 2)
                            )
                            .padding(.all)
                    }
                )
            }
            
            FloatingActionButton(nameImage: "plus", action: { self.showingAddDetail = true })
                .padding(.bottom, 60)
            
            NavigationLink(
                destination: AddDetailView(table: viewModel.table),
                isActive: $showingAddDetail,
                label: {}
            )
        }
        .navigationBarTitle("Consumption")
        .overlay(
            ZStack {
                if viewModel.isLoading {
                    Color.gray.opacity(0.7)
                        .ignoresSafeArea()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
            }
        )
        .onAppear {
            viewModel.getConsumptions()
        }
    }
    
    private func releaseTable() {
        
    }
}

struct RowProductView: View {
    let consumptionDetail: ConsumptionDetailModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("Product: ")
                Text(consumptionDetail.product?.name ?? "")
            }
            
            HStack {
                Text("Category: ")
                Text(consumptionDetail.product?.category?.name ?? "")
            }
            
            HStack {
                Text("Total: ")
                Text("\(consumptionDetail.quantity ?? 0)")
            }
        }
    }
}

struct BusyTableView_Previews: PreviewProvider {
    static var previews: some View {
        BusyTableView(table: TableModel())
    }
}
