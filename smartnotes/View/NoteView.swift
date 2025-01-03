//
//  NoteView.swift
//  smartnotes
//
//  Created by admin on 17/12/24.
//

import SwiftUI
import UIKit


struct NoteView: View {
    @Environment(\.modelContext) private var context
    @Bindable var viewModel: NoteViewModel
        
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading) {
                HeaderButtons(isFavorite: viewModel.isFavorite, turnFavorite: viewModel.toggleFavorite)
                
                ZStack(alignment: .topLeading) {
                    if viewModel.title.isEmpty {
                        Text("title")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.lightGray)
                            .allowsHitTesting(false)
                    }
                    
                    TextEditor(text: $viewModel.title)
                        .frame(minHeight: 50)
                        .fixedSize(horizontal: false, vertical: true)
                        .background(Color.clear)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .scrollContentBackground(.hidden)
                        .autocorrectionDisabled()
                }
                .padding(.top, 32)
                
                
                ZStack(alignment: .topLeading) {
                    if viewModel.content.isEmpty {
                        Text("write here your note.")
                            .font(.subheadline)
                            .foregroundStyle(.lightGray)
                            .allowsHitTesting(false)
                    }
                    
                    TextEditor(text: $viewModel.content)
                        .frame(minHeight: 50, maxHeight: .infinity)
                        .background(Color.clear)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .scrollContentBackground(.hidden)
                        .autocorrectionDisabled()
                }
                
                Spacer()
            }

            VStack {
                if(viewModel.content.isEmpty) {
                    HStack {
                        Text("or start writing with AI")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .opacity(0.4)
                        
                        Spacer()
                            .frame(minWidth: 130, maxWidth: 170)
                    }
                }
                HStack {
                    Spacer()
                    if viewModel.content.isEmpty {
                        Image("arrow_right")
                            .resizable()
                            .frame(width: 200, height: 100)
                            .rotationEffect(.degrees(10))
                            .opacity(0.2)
                            .padding(.trailing, 16)
                    }
                    
                    NoteFloatingActionButton {
                        viewModel.isAiSheetPresented.toggle()
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .background(.tertiaryColorApp)
        .navigationBarBackButtonHidden()
        .onDisappear {
            Task { @MainActor in
                viewModel.saveNote(context: context)
            }
        }
        .sheet(isPresented: $viewModel.isAiSheetPresented) {
                    VStack {
                        if viewModel.isLoadingAiResponse {
                            LoadingView()
                        } else {
                            AiTextField(text: $viewModel.aiPrompt)
                            
                            Spacer()
                            
                            Button {
                                viewModel.sendMessage(viewModel.aiPrompt)
                            } label: {
                                Text("Send to AI")
                                    .fontWeight(.bold)
                                    .foregroundColor(.tertiaryColorApp)
                            }
                            .frame(width: 160, height: 50)
                            .background(Color("PrimaryColor"))
                            .cornerRadius(16)
                        }
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 4)
                    .presentationDetents([.fraction(0.45), .medium, .large])
                    .presentationBackground(.black.opacity(0.85))
                }
        
    }
}

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color("PrimaryColor")))
                .scaleEffect(1.5)
            
            Text("Generating response...")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.white)
                .padding(.top, 16)
        }
    }
}

#Preview {
    NoteView(viewModel: NoteViewModel())
}

struct HeaderButtons: View {
    @Environment(\.dismiss) private var dismiss
    var isFavorite: Bool
    var turnFavorite: () -> Void
    
    var body: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image("ic_arrowleft")
            }
            
            Spacer()
            
            Button {
                turnFavorite()
            } label: {
                Image(isFavorite ? "ic_heart_filled" : "ic_heart")
                    .scaledToFill()
                    .background(.tertiaryColorApp)
                    .tint(.white)
            }
        }
    }
}

struct AiTextField: View {
    @Binding var text: String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                HStack {
                    Image("magicpen")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .padding(.trailing, 8)
                    
                    Text("write something with AI...")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                }
                .padding(.top, 16)
            }
            
            TextEditor(text: $text)
                .padding(.top, 8)
                .frame(height: 240)
                .foregroundStyle(.white)
                .fixedSize(horizontal: false, vertical: true)
                .background(.clear)
                .scrollContentBackground(.hidden)
        }
        .padding(.horizontal, 8)
        .background(.tertiaryColorApp)
        .cornerRadius(16)
    }
}

struct NoteFloatingActionButton: View {
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "lightbulb.min")
                .font(.title2)
                .padding(12)
                .foregroundStyle(.tertiaryColorApp)
                .background(Color("PrimaryColor"))
                .clipShape(Circle())
        }
    }
}
