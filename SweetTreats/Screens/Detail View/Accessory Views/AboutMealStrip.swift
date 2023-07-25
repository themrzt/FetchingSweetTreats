//
//  AboutMealStrip.swift
//  SweetTreats
//
//  Created by Zach Tarvin on 7/1/23.
//

import SwiftUI

enum CulturalOriginLabel: String, RawRepresentable{
    case american = "American"
    case british = "British"
    case canadian = "Canadian"
    case chinese = "Chinese"
    case croatian = "Croatian"
    case dutch = "Dutch"
    case egyptian = "Egyptian"
    case filipino = "Filipino"
    case french = "French"
    case greek = "Greek"
    case indian = "Indian"
    case irish = "Irish"
    case italian = "Italian"
    case jamaican = "Jamaican"
    case japanese = "Japanese"
    case kenyan = "Kenyan"
    case malaysian = "Malaysian"
    case mexican = "Mexican"
    case moroccan = "Moroccan"
    case polish = "Polish"
    case portugese = "Portugese"
    case russian = "Russian"
    case spanish = "Spanish"
    case thai = "Thai"
    case tunisian = "Tunisian"
    case turkish = "Turkish"
    case unknown = "Unknown"
    case vietnamese = "Vietnamese"
    
    func textFlag() -> String{
        switch self{
        case .american:
            return rawValue + " 🇺🇸"
        case .british:
            return rawValue + " 🇬🇧"
            
        case .canadian:
            return rawValue + " 🇨🇦"
        case .chinese:
            return rawValue + " 🇨🇳"
        case .croatian:
            return rawValue + " 🇭🇷"
        case .dutch:
            return rawValue + " 🇳🇱"
        case .egyptian:
            return rawValue + " 🇪🇬"
        case .filipino:
            return rawValue + " 🇵🇭"
        case .french:
            return rawValue + " 🇫🇷"
        case .greek:
            return rawValue + " 🇬🇷"
        case .indian:
            return rawValue + " 🇮🇳"
        case .irish:
            return rawValue + " 🇮🇪"
        case .italian:
            return rawValue + " 🇮🇹"
        case .jamaican:
            return rawValue + " 🇯🇲"
        case .japanese:
            return rawValue + " 🇯🇵"
        case .kenyan:
            return rawValue + " 🇰🇪"
        case .malaysian:
            return rawValue + " 🇲🇾"
        case .mexican:
            return rawValue + " 🇲🇽"
        case .moroccan:
            return rawValue + " 🇲🇦"
        case .polish:
            return rawValue + " 🇵🇱"
        case .portugese:
            return rawValue + " 🇵🇹"
        case .russian:
            return rawValue + " 🇷🇺"
        case .spanish:
            return rawValue + " 🇪🇸"
        case .thai:
            return rawValue + " 🇹🇭"
        case .tunisian:
            return rawValue + " 🇹🇳"
        case .turkish:
            return rawValue + " 🇹🇷"
        case .unknown:
            return rawValue + " 🕵️"
        case .vietnamese:
            return rawValue + " 🇻🇳"
        }
    }
    
    init(culture: String){
        self = CulturalOriginLabel(rawValue: culture) ?? .unknown
    }
    
    
}

struct AboutMealStrip: View {
    @EnvironmentObject var meal: MealViewModel
    @ObservedObject var viewModel: MenuViewModel
    
    var body: some View {
        VStack {
            HStack{
                VStack(alignment: .leading){
                    Text("Category".uppercased())
                        .bold()
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(meal.category)
                        .bold()
                }
                Spacer()
                if let origin = meal.area{
                    Divider()
                    Spacer()
                
                    VStack(alignment: .trailing){
                        Text("Cuisine".uppercased())
                            .bold()
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        NavigationLink(value: origin){
                            Text(CulturalOriginLabel(culture: origin).textFlag())
                                .bold()
                        }
                    }
                }
            }
            if let youTube = meal.youtubeLink(){
                Link(destination: youTube) {
                    Label("Watch on YouTube", systemImage: "play.tv.fill")
                }
            }
        }.padding(.horizontal)
        Divider()
    }
}

struct AboutMealStrip_Previews: PreviewProvider {
    
    static func dish() -> MealViewModel{
        let meal = Meal.preview
        let model = MealViewModel(meal: meal)
        model.area = "British"
        return model
    }
    static var previews: some View {
        AboutMealStrip(viewModel: MenuViewModel())
            .environmentObject(dish())
    }
}
