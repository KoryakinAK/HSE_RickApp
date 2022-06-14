import SwiftUI
import Kingfisher

struct CharData: Identifiable {
    let id: UUID = UUID()
    var title: String = "Status:"
    var subtitle: String = "Alive"

    init(from tuple: (String, String)) {
        self.title = tuple.0
        self.subtitle = tuple.1
    }
}

class CharacterUIInfo: ObservableObject {
    @Published var characterName: String = ""
    @Published var image: String = ""
    @Published var characterDescriptions = [CharData]()
    init(with characterModel: CharacterModel) {
        self.characterName = characterModel.name
        self.image = characterModel.image
        self.characterDescriptions = characterModel.asDictOfDescriptions().map {
            CharData(from: $0)
        }
    }
}

struct CharacterPageUI: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @EnvironmentObject private var characterInfo: CharacterUIInfo

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    if let imageURL = URL(string: characterInfo.image) {
                        KFImage(imageURL)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(.black, lineWidth: (colorScheme == .light) ? 1 : 0)
                            )
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 35)
                .padding([.leading, .trailing], 37)
                HStack {
                    Text(characterInfo.characterName)
                        .font(Font.custom(CustomFonts.SFdisplayBold.rawValue, size: 34))
                    Spacer()
                    Button {
                        print("fav/unfav action…")
                    } label: {
                        Image(systemName: "heart.fill")
                            .frame(width: 17, height: 17)
                            .foregroundColor(Color.gray)
                    }
                    .frame(width: 48, height: 48)
                    .background(Color(cgColor: CGColor(red: 0.946, green: 0.946, blue: 0.946, alpha: 1)))
                    .clipShape(Circle())
                }
                .frame(height: 41)
                .padding([.trailing, .leading], 16)
                .padding(.bottom, 20)

                ForEach(characterInfo.characterDescriptions) { dataValue in
                    HStack {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(dataValue.title)
                                .font(Font.custom(CustomFonts.SFtextBold.rawValue, size: 22))
                                .foregroundColor(Color.mainTheme.secondaryLabelColor)
                            Text(dataValue.subtitle)
                                .font(Font.custom(CustomFonts.SFtextBold.rawValue, size: 22))
                                .frame(alignment: .leading)
                            Rectangle()
                                .fill(Color.mainTheme.mainLabelColor)
                                .frame(height: 1 / UIScreen.main.scale)
                                .edgesIgnoringSafeArea(.horizontal)
                                .padding(.top, 8)
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                        Spacer()
                    }
                }
            }
        }
    }
}

struct PreviewsCharacterUIPreviews: PreviewProvider {
    static var previews: some View {
        CharacterPageUI()
            .environmentObject(CharacterUIInfo(with: CharacterModel.exampleCharacter))
            .previewDevice("iPhone 13 mini")
    }
}
