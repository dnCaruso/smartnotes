//
//  HomeView.swift
//  smartnotes
//
//  Created by admin on 14/12/24.
//

import SwiftUI
import SwiftData

enum Category {
    case all
    case favorites
}

struct HomeView: View {
    @Environment(\.modelContext) private var context
    @Bindable private var viewModel: HomeViewModel
    
    @Namespace private var animation
    
    @Query(sort: \Note.createdAt, order: .reverse) var notes: [Note]
    
    var filteredNotes: [Note] {
            viewModel.filterNotes(notes)
        }
    
    init(context: ModelContext) {
        self._viewModel = Bindable(wrappedValue: HomeViewModel())
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                AppLogo(color: Color("PrimaryColor"))
                
                SearchBar(searchText: $viewModel.searchText)
                
                HStack {
                    CategoryButton(selectedCategory: $viewModel.selectedCategory, buttonCategory: .all) {
                        viewModel.selectedCategory = .all
                    }
                    
                    Spacer()
                    
                    CategoryButton(selectedCategory: $viewModel.selectedCategory, buttonCategory: .favorites) {
                        viewModel.selectedCategory = .favorites
                    }
                }
                .padding(.vertical, 16)
                
                if !filteredNotes.isEmpty {
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.fixed(175), spacing: 20, alignment: .top),
                            GridItem(.fixed(175), spacing: 20, alignment: .bottom)
                        ],
                                  spacing: 16
                        ) {
                            ForEach(Array(filteredNotes.enumerated()), id: \.element.id) { index, note in
                                NoteCard(note: note, index: index)
                                    .offset(y: index % 2 != 0 ? 25 : 0)
                            }
                            
                        }
                    }
                } else {
                    Spacer()
                    Text("empty.")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color("PrimaryColor"))
                        .opacity(0.4)
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .background(.black)
            
            NavigationLink(destination: NoteView(viewModel: NoteViewModel())) {
                HomeFloatingActionButton()
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct SearchBar: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color("PrimaryColor"))
                .padding(.leading, 8)
            
            TextField("",
                      text: $searchText,
                      prompt:
                        Text("Search")
                .foregroundStyle(.lightGray)
            )
            .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
            .foregroundStyle(.lightGray)
    
        }
        .background(.tertiaryColorApp)
        .cornerRadius(16)
    }
}

struct CategoryButton: View {
    @Binding var selectedCategory: Category
    let buttonCategory: Category
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(buttonCategory == .all ? "all" : "favorites")
                .fontWeight(.bold)
                .foregroundColor(selectedCategory == buttonCategory ? Color.black : Color("PrimaryColor"))
        }
        .frame(width: 160, height: 50)
        .background(selectedCategory == buttonCategory ? Color("PrimaryColor") : .tertiaryColorApp)
        .cornerRadius(16)
    }
}

struct NoteCard: View {
    @Environment(\.modelContext) private var context
    var note: Note
    var index: Int
    @State private var isVisible: Bool = false
    @State private var showDeleteAlert: Bool = false
    
    var body: some View {
        NavigationLink(destination: NoteView(viewModel: NoteViewModel(note: note))) {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 16)
                    .frame(width: 175, height: 240)
                    .foregroundStyle(.tertiaryColorApp)
                
                VStack(alignment: .leading) {
                    Text(note.title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color("PrimaryColor"))
                        .padding(.bottom, 4)
                    
                    Text(note.content.count > 100 ? String(note.content.prefix(100)) + "..." : note.content)
                        .font(.caption)
                        .foregroundColor(Color("PrimaryColor"))
                    
                    Spacer()
                    
                    Text(note.createdAt.formatted())
                        .font(.custom("SFProText-Light", size: 10))
                        .fontWeight(.light)
                        .foregroundStyle(Color("PrimaryColor"))
                        .padding(.bottom, 8)
                    
                }
                .padding(.horizontal, 12)
                .padding(.top, 8)
                .scaleEffect(isVisible ? 1 : 0.85)
                .opacity(isVisible ? 1 : 0)
                .animation(
                    .spring(response: 0.4, dampingFraction: 0.6)
                        .delay(Double(index) * 0.09),
                    value: isVisible
                )
                .onAppear {
                    isVisible = true
                }
                
            }
        }
        .buttonStyle(.plain)
        .contextMenu {
                    Button(role: .destructive) {
                        showDeleteAlert = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
                .alert("Delete Note", isPresented: $showDeleteAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        deleteNote()
                    }
                } message: {
                    Text("Are you sure you want to delete this note? This action cannot be undone.")
                }
        
    }
    
    private func deleteNote() {
            withAnimation {
                context.delete(note)
                do {
                    try context.save()
                } catch {
                    print("Error deleting note: \(error)")
                }
            }
        }
}


struct HomeFloatingActionButton: View {
    var body: some View {
        Image(systemName: "plus")
            .font(.title3.weight(.light))
            .padding(16)
            .foregroundStyle(.tertiaryColorApp)
            .background(Color("PrimaryColor"))
            .clipShape(Circle())
            .padding()
    }
}

#Preview {
    let container = try! ModelContainer(for: Note.self)
    let context: ModelContext = ModelContext(container)

    let sampleNotes = [
        Note(title: "Sample Note 1", content: "Content 1", isFavorite: false),
        Note(title: "Sample Note 2", content: "Content 2", isFavorite: false)
    ]
    sampleNotes.forEach { context.insert($0) }

    return HomeView(context: context)
}

