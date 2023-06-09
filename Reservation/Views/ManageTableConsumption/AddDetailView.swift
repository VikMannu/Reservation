//
//  AddDetailView.swift
//  Reservation
//
//  Created by Victor Ayala on 2023-06-09.
//

import SwiftUI

struct AddDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: AddDetailViewModel
    
    @State var quantity: String = ""
    
    let placeholderTitle = "Quantity"
    
    init(table: TableModel) {
        self._viewModel = StateObject(wrappedValue: AddDetailViewModel(table: table))
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 30) {
                NavigationLink(
                    destination: { ProductsView(selectedProduct: $viewModel.selectedProduct) },
                    label: {
                        HStack {
                            Text(viewModel.selectedProduct.description)
                                .padding(.leading)
                            Spacer()
                            Image(systemName: "arrow.right")
                                .padding(.trailing)
                        }
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
                
                VStack(alignment: .leading) {
                    Text(placeholderTitle)
                        .font(.title3)
                        .foregroundColor(.blue)
                        .padding(.leading)
                    
                    TextField(placeholderTitle, text: $quantity)
                        .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                        .foregroundColor(.secondary)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10.0)
                        .padding(.horizontal, 5)
                        .keyboardType(.numberPad)
                }.padding(.horizontal)
            }
            
            Spacer()
            
            Button(
                action: { self.addDetail() },
                label: {
                    Text("Confirm")
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
        .navigationTitle("Add Detail")
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
    }
    
    private func addDetail() {
        if let _ = viewModel.selectedProduct.id, !quantity.isEmpty {
            if let quantity = Int(self.quantity) {
                viewModel.addDetail(quantity: quantity) { status in
                    if status == .success {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            } else {
                Utils.showBarnner(title: "Attention!", subtitle: "Please only enter numbers")
            }
        } else {
            Utils.showBarnner(title: "Attention!", subtitle: "Please fill in all required fields")
        }
    }
}

struct AddDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AddDetailView(table: TableModel())
    }
}
