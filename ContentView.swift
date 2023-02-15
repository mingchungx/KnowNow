//
//  ContentView.swift
//  ChattyGPT
//

import OpenAISwift
import SwiftUI

final class ViewModel: ObservableObject {
    init() {}
    
    private var client = OpenAISwift(authToken: Bundle.main.infoDictionary?["OPENAI_API_KEY"] as! String)
    
    func send(text: String, completion: @escaping (String) -> Void) {
         client.sendCompletion(with: text, maxTokens: 500, completionHandler: { result in
              switch result {
              case .success(let model):
                   let output = model.choices.first?.text ?? ""
                   completion(output)
              case .failure:
                   break
              }
         })
     }
}

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    @State var text = ""
    @State var userMessage = String()
    @State var aiResponse = String()
    @State private var isLoading = false
     
    var body: some View {
        VStack(alignment: .leading) {
            MainHeader()
            Text(userMessage)
                .foregroundColor(.gray)
                .padding()
            ScrollView {
                Text(aiResponse)
                    .font(.callout)
                    .padding()
            }
            Spacer()
            HStack {
                TextField("Type message here", text: $text)
                    .foregroundColor(.gray)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .shadow(radius: 5)
                
                Button(action: send) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.black)
                }
            }
            .padding()
        }
        .preferredColorScheme(.light)
        .overlay(
            Group {
                if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                }
            })
    }
     
    func send() {
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        self.isLoading = true
        self.userMessage = ""
        self.aiResponse = ""
          
        self.userMessage = text
        viewModel.send(text: "\(text) *** Output specifications: First, give an answer titled 'Answer:'. Then, on a new line, start a numbered list titled 'Sources:' and cite your sources in MLA style. Give between 1 and 3 sources.") { response in
            DispatchQueue.main.async {
                // Await the OpenAI response
                self.aiResponse = response.trimmingCharacters(in: .whitespacesAndNewlines)
                self.text = ""
                self.isLoading = false
                
                // Close the keyboard
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
