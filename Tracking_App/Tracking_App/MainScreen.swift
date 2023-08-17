import SwiftUI

struct MainScreen: View {
    var body: some View {
		MapViewRepresentable()
			.ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		MainScreen()
    }
}
