import SwiftUI

struct ButtonView: View {
    var buttonType: String
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 60, height: 60)
                .foregroundColor(.white)
            Image(systemName: buttonType)
                .resizable()
                .foregroundColor(.black)
                .frame(width: 25, height: 22)
                .scaledToFit()
        }
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(buttonType: ButtonType.algorithm)
    }
}
