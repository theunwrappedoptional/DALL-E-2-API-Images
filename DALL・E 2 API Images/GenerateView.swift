//
//  GenerateView.swift
//  DALL・E 2 API Images
//
//  Created by Manhattan on 12/01/23.
//

import SwiftUI

struct GenerateView: View {
    
    @StateObject var viewModel = ViewModel()
    
    @State private var text = "Two astronauts exploring the dark, cavernous intern of a derelict spacecraft, digital art"
    
    @State private var saveAlert = false
    @State private var promptAlert = false
    @State private var previousPrompt = ""
    
    var body: some View {
        
        VStack {
            Text("DALL・E 2 API Images")
            
            Form{
                HStack{
                    Spacer()
                    
                    AsyncImage(url: viewModel.imageURL,
                               transaction: Transaction(animation: .spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.25))) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFit()
                        } else if phase.error != nil {
                            Color.red
                        } else {
                            VStack{
                                if viewModel.isLoading {
                                    ProgressView()
                                        .padding(.bottom, 12)
                                    Text("Generating image...")
                                        .multilineTextAlignment(.center)
                               } else {
                                   if viewModel.imageURL != nil {
                                       ProgressView()
                                           .padding(.bottom, 12)
                                       Text("Generating image...")
                                           .multilineTextAlignment(.center)
                                   } else {
                                       Image(systemName: "photo.on.rectangle.angled")
                                           .resizable()
                                           .scaledToFill()
                                           .frame(width: 50, height: 50)
                                   }
                               }
                           }
                        }
                    }

                    .frame(width:300, height:300, alignment: .center)
                    
                    Spacer()
                }
                
                VStack(alignment: .leading) {
                    Text("Describe the image that you want to generate")
                        .foregroundColor(.gray)
                        .font(.caption)
                    TextField("A man with a dog in a corn field at dawn", text: $text, axis: .vertical)
                        .lineLimit(10)
                        .lineSpacing(5)
                }
                
                HStack{
                    Button{
                        if previousPrompt == text {
                            promptAlert = true
                        } else {
                            viewModel.imageURL = nil
                            Task{
                                await viewModel.generateImage(withText: text)
                            }
                        }
                            previousPrompt = text
                        } label: {
                            Text("🪄 Generate Image")
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(text.isEmpty || viewModel.isLoading )
                        .padding(.vertical)
                    
                    Button{
                        viewModel.saveImageGallery()
                    } label: {
                        Image(systemName: "square.and.arrow.down")
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.imageURL == nil)
                    .padding(.vertical)
                    
                    Button("Reset") {
                        viewModel.imageURL = nil
                        text = ""
                    }
                    .tint(.red)
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.imageURL == nil)
                    .padding(.vertical, 12)
                }
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        .alert("Now you can find this image in the galley", isPresented: $viewModel.saved) {
            Button("OK", role: .cancel){}
        }
        .alert(isPresented: $promptAlert) {
            Alert(
                title: Text("Spending credits.."),
                message: Text("Do you want to use the same prompt again?"),
                primaryButton: .default(Text("Yes, I'm sure 🥸")) {
                viewModel.imageURL = nil
                viewModel.isLoading = true
                Task{
                    await viewModel.generateImage(withText: text)
                }
            },
            secondaryButton: .cancel()
            )
            }
        }

}

struct GenerateView_Previews: PreviewProvider {
    static var previews: some View {
        GenerateView()
    }
}
