//
//  ProductsView.swift
//  Reservation
//
//  Created by Victor Ayala on 2023-06-09.
//

import SwiftUI

struct ProductsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = ProductsViewModel()
    
    @State private var searchText = ""
    @State private var showCancelButton: Bool = false
    
    @Binding var selectedProduct: ProductModel
    
    var filteredProducts: [ProductModel] {
        if searchText.isEmpty {
            return viewModel.products
        }
        return viewModel.products.filter { $0.name?.localizedCaseInsensitiveContains(searchText) ?? false }
    }
    
    var body: some View {
        VStack {
            // Search view
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    
                    TextField(
                        "Search",
                        text: $searchText,
                        onEditingChanged: { isEditing in
                            self.showCancelButton = true
                        }
                    ).foregroundColor(.primary)
                    
                    Button(
                        action: { self.searchText = "" },
                        label: { Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1) }
                    )
                }
                .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                .foregroundColor(.secondary)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10.0)
                
                if showCancelButton  {
                    Button("Cancel") {
                        UIApplication.shared.endEditing(true)
                        self.searchText = ""
                        self.showCancelButton = false
                    }
                    .foregroundColor(Color(.systemBlue))
                }
            }
            .padding(.horizontal)
            .navigationBarHidden(showCancelButton)
            
            // List View
            List(filteredProducts, id: \.id) { product in
                Text(product.name ?? "")
                    .onTapGesture {
                        self.selectedProduct = product
                        presentationMode.wrappedValue.dismiss()
                    }
            }
            
        }.navigationBarTitle(Text("Products"))
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
                viewModel.getProducts()
            }
    }
}

struct ProductsView_Previews: PreviewProvider {
    static var previews: some View {
        ProductsView(selectedProduct: .constant(ProductModel()))
    }
}
