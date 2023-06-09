//
//  PDFView.swift
//  Reservation
//
//  Created by Victor Ayala on 2023-06-09.
//

import SwiftUI
import PDFKit

struct PDFView: View {
    var body: some View {
        VStack {
            PDFKitView(url: getFileURL())
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationBarTitle("PDF")
    }
    
    private func getFileURL() -> URL? {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent("archivo.pdf")
        return fileURL
    }
}

struct PDFKitView: UIViewRepresentable {
    var url: URL?
    
    func makeUIView(context: Context) -> PDFKit.PDFView {
        let pdfView = PDFKit.PDFView()
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFKit.PDFView, context: Context) {
        if let url = url {
            let pdfDocument = PDFDocument(url: url)
            uiView.document = pdfDocument
        }
    }
}

struct PDFView_Previews: PreviewProvider {
    static var previews: some View {
        PDFView()
    }
}
