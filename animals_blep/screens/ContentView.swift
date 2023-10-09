//
//  ContentView.swift
//  animals_blep
//
//  Created by Rodrigo Silva on 08/10/23.
//

import SwiftUI

struct ContentView: View {
    @State private var items: [String] = []
    @State private var isLoading = false
    
    
    var body: some View {
        NavigationView{
            VStack{
                if isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                }
                else {
                    List(items, id: \.self){
                        item in Text(item)
                    }
                }
            }
            
            .navigationBarTitle("Animals List")
            .onAppear{
                fetchDataFromApi()
            }
            
        }
    }
    
    func fetchDataFromApi() {
        guard let apiUrl = URL(string: "https://mlemapi.p.rapidapi.com/tags") else {
            return
        }
        
        isLoading = true
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        request.setValue("06d95a898bmsh8edf3592d0a6228p181091jsnb533835452e0", forHTTPHeaderField: "X-RapidAPI-Key")
        request.setValue("mlemapi.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
        
        URLSession.shared.dataTask(with: request){(data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                isLoading = false
                return
            }
            
            if let responseData = data {
                do {
                    let decodeData = try JSONDecoder().decode([String].self, from: responseData)
                    
                    DispatchQueue.main.async {
                        self.items = decodeData
                        isLoading = false
                    }
                } catch {
                    print("Error in decodification JSON: \(error.localizedDescription)")
                    isLoading = false
                }
            }
        }.resume()
    }
}


#Preview {
    ContentView()
}
