import SwiftUI

struct MainScreen: View {
    @State private var isPresented = false
    @State private var selectedTypeOfData: TypeOfData? = nil
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            MapViewRepresentable()
                .ignoresSafeArea()
            
            VStack {
                Button(action: {
                    selectedTypeOfData = .file
                    isPresented.toggle()
                }) {
                    ButtonView(buttonType: ButtonType.file)
                        .shadow(color: .gray, radius: 4, x: 5, y: 5)
                }
                
                Spacer()
                
                Button(action: {
                    selectedTypeOfData = .algorithm
                    isPresented.toggle()
                }) {
                    ButtonView(buttonType: ButtonType.algorithm)
                        .shadow(color: .gray, radius: 4, x: 5, y: 5)
                }
            }
            .frame(width: 50, height: 150)
            .padding(.trailing, 30)
            .padding(.bottom, 80)
        }
        .sheet(item: $selectedTypeOfData) { typeOfData in
            ModalScreen(typeOfData: typeOfData)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		MainScreen()
    }
}
