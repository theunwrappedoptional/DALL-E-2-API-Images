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
                    AsyncImage(url: viewModel.imageURL) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        VStack{
                            if !viewModel.isLoading {
                                Image(systemName: "photo.on.rectangle.angled")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                            } else {
                                ProgressView()
                                    .padding(.bottom, 12)
                                Text("Generating image...")
                                    .multilineTextAlignment(.center)
                            }
                        }
                    }
                    .frame(width:300, height:300, alignment: .center)
                    Spacer()
                }
                
                VStack(alignment: .leading) {
                    Text("Desribe the image that you want to generate")
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
                            Task{
                                await viewModel.generateImage(withText: text)
                            }
                        }
                            previousPrompt = text
                        } label: {
                            Text("🪄 Generate Image")
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(viewModel.isLoading || text.isEmpty)
                        .padding(.vertical)
                    
                    Button{
                        viewModel.saveImageGallery()
                        saveAlert = !saveAlert
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
                    .disabled(viewModel.isLoading)
                    .padding(.vertical, 12)
                }
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        .alert("Now you can find this image in the galley", isPresented: $saveAlert) {
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
