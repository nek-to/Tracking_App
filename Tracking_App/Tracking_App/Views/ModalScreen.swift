import SwiftUI

struct ModalScreen: View {
    var typeOfData: TypeOfData
    private let locationManager = LocationManager()
    var body: some View {
        List {
            switch typeOfData {
            case .file:
                ForEach(TrackingFiles.allCases, id: \.self) { caseValue in
                    Button(action: {
                    }) {
                        Text(caseValue.value)
                            .foregroundColor(.black)
                    }
                }
            case .algorithm:
                ForEach(Algorithm.allCases, id: \.self) { caseValue in
                    Button(action: {
                        print("AAAAA")
                    }) {
                        Text(caseValue.name)
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

struct ModalScreen_Previews: PreviewProvider {
    static var previews: some View {
        ModalScreen(typeOfData: .algorithm)
    }
}
