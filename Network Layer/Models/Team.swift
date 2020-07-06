//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import Foundation
import UIKit

struct Team {
    
    //MARK: Internal Properties
    
    let id: String
    let city: String
    let name: String
    let abbreviation: String
    
    //MARK: Init
    
    init(from decoder: Decoder) throws {
        let teamContainer = try decoder.container(keyedBy: TeamCodingKeys.self)
        id = try teamContainer.decode(String.self, forKey: .id)
        city = try teamContainer.decode(String.self, forKey: .city)
        name = try teamContainer.decode(String.self, forKey: .name)
        abbreviation = try teamContainer.decode(String.self, forKey: .abbreviation)
    }
}

extension Team: Decodable {
    
    //MARK: Coding Keys
    
    enum TeamCodingKeys: String, CodingKey {
        case id = "teamId"
        case city = "city"
        case name = "nickname"
        case abbreviation = "tricode"
    }
}

struct TeamApiResponse {
    
    //MARK: Internal Properties
    
    var teams: [Team]
}

extension TeamApiResponse{
    
    //MARK: Init
    
    init?(json: [String:Any]) {
        guard let leagueDictionary = json["league"] as? JSONDictionary else {
            return nil
        }
        
        guard let standardDictionaries = leagueDictionary["standard"] as? [JSONDictionary] else {
            return nil
        }
        
        self.teams = [Team]()
        for teamDictionary in standardDictionaries {
            
            ///non nba data exists in json
            guard let isNBAFranchise = teamDictionary["isNBAFranchise"] as? Bool else {
                return nil
            }
            
            guard isNBAFranchise == true else {
                continue
            }
            
            guard let jsonTeamData = try? JSONSerialization.data(withJSONObject: teamDictionary, options: []) else {
                return nil
            }
            
            do {
                let team = try JSONDecoder().decode(Team.self, from: jsonTeamData)
                self.teams.append(team)
            } catch {
                return nil
            }
        }
    }
}

///All 30 NBA teams shortened to 3 letters to match JSON
enum Teams: String {
    case ATL
    case BOS
    case BKN
    case CHA
    case CHI
    case CLE
    case DAL
    case DEN
    case DET
    case GSW
    case HOU
    case IND
    case LAC
    case LAL
    case MEM
    case MIA
    case MIL
    case MIN
    case NOP
    case NYK
    case OKC
    case ORL
    case PHI
    case PHX
    case POR
    case SAC
    case SAS
    case TOR
    case UTA
    case WAS
    case UNKNOWN
}

//MARK: Typealias

typealias TeamColor = (teamName: Teams, type: TeamColorType, color: UIColor)
typealias TeamColorsArray = Array<TeamColor>

enum TeamColorType: String {
    case background
    case foreground
}

///array of Team Colors
///2 colors defined for each team
struct TeamColors {
    
    //MARK: Internal Properties
    
    static let unknownForegroundColor = TeamColor(teamName: .UNKNOWN, type: .foreground, color: #colorLiteral(red: 0.768627451, green: 0.8078431373, blue: 0.831372549, alpha: 1))
    static let unknownBackgroundColor = TeamColor(teamName: .UNKNOWN, type: .background, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    static let teamColorsArray: TeamColorsArray = [
        (teamName: .ATL, type: .foreground, color: #colorLiteral(red: 0.8666666667, green: 0.06666666667, blue: 0.2039215686, alpha: 1)),
        (teamName: .ATL, type: .background, color: #colorLiteral(red: 0.768627451, green: 0.8392156863, blue: 0, alpha: 1)),
        (teamName: .BOS, type: .foreground, color: #colorLiteral(red: 0, green: 0.5333333333, blue: 0.3254901961, alpha: 1)),
        (teamName: .BOS, type: .background, color: #colorLiteral(red: 0.7333333333, green: 0.5921568627, blue: 0.3873213177, alpha: 0.7957780394)),
        (teamName: .BKN, type: .foreground, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),
        (teamName: .BKN, type: .background, color: #colorLiteral(red: 0.631372549, green: 0.631372549, blue: 0.6431372549, alpha: 1)),
        (teamName: .CHA, type: .foreground, color: #colorLiteral(red: 0.1137254902, green: 0.06666666667, blue: 0.3764705882, alpha: 1)),
        (teamName: .CHA, type: .background, color: #colorLiteral(red: 0.631372549, green: 0.631372549, blue: 0.6431372549, alpha: 1)),
        (teamName: .CHI, type: .foreground, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),
        (teamName: .CHI, type: .background, color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)),
        (teamName: .CLE, type: .foreground, color: #colorLiteral(red: 0.5254901961, green: 0, blue: 0.2196078431, alpha: 1)),
        (teamName: .CLE, type: .background, color: #colorLiteral(red: 1, green: 0.7215686275, blue: 0.1098039216, alpha: 1)),
        (teamName: .DAL, type: .foreground, color: #colorLiteral(red: 0.06274509804, green: 0.3803921569, blue: 0.6745098039, alpha: 1)),
        (teamName: .DAL, type: .background, color: #colorLiteral(red: 0.7333333333, green: 0.768627451, blue: 0.7921568627, alpha: 1)),
        (teamName: .DEN, type: .foreground, color: #colorLiteral(red: 0.05098039216, green: 0.1333333333, blue: 0.2509803922, alpha: 1)),
        (teamName: .DEN, type: .background, color: #colorLiteral(red: 1, green: 0.7764705882, blue: 0.1529411765, alpha: 1)),
        (teamName: .DET, type: .foreground, color: #colorLiteral(red: 0.1137254902, green: 0.2588235294, blue: 0.5411764706, alpha: 1)),
        (teamName: .DET, type: .background, color: #colorLiteral(red: 0.7098039216, green: 0.7019607843, blue: 0.7019607843, alpha: 1)),
        (teamName: .GSW, type: .foreground, color: #colorLiteral(red: 0.1215686275, green: 0.2666666667, blue: 0.5333333333, alpha: 1)),
        (teamName: .GSW, type: .background, color: #colorLiteral(red: 1, green: 0.6332050398, blue: 0.09665319907, alpha: 1)),
        (teamName: .HOU, type: .foreground, color: #colorLiteral(red: 0.7210723459, green: 0.03529411765, blue: 0.1843137255, alpha: 1)),
        (teamName: .HOU, type: .background, color: #colorLiteral(red: 0.768627451, green: 0.8078431373, blue: 0.8274509804, alpha: 1)),
        (teamName: .IND, type: .foreground, color: #colorLiteral(red: 0, green: 0.1764705882, blue: 0.3843137255, alpha: 1)),
        (teamName: .IND, type: .background, color: #colorLiteral(red: 1, green: 0.6332050398, blue: 0.09665319907, alpha: 1)),
        (teamName: .LAC, type: .foreground, color: #colorLiteral(red: 0.9137254902, green: 0.1176470588, blue: 0.3098039216, alpha: 1)),
        (teamName: .LAC, type: .background, color: #colorLiteral(red: 0.7450980392, green: 0.7529411765, blue: 0.7607843137, alpha: 1)),
        (teamName: .LAL, type: .foreground, color: #colorLiteral(red: 0.3333333333, green: 0.1450980392, blue: 0.5098039216, alpha: 1)),
        (teamName: .LAL, type: .background, color: #colorLiteral(red: 1, green: 0.6332050398, blue: 0.09665319907, alpha: 1)),
        (teamName: .MEM, type: .foreground, color: #colorLiteral(red: 0.07058823529, green: 0.09019607843, blue: 0.2470588235, alpha: 1)),
        (teamName: .MEM, type: .background, color: #colorLiteral(red: 0.9607843137, green: 0.6941176471, blue: 0.07058823529, alpha: 1)),
        (teamName: .MIA, type: .foreground, color: #colorLiteral(red: 0.5882352941, green: 0.02352941176, blue: 0.1882352941, alpha: 1)),
        (teamName: .MIA, type: .background, color: #colorLiteral(red: 0.9764705882, green: 0.6274509804, blue: 0.1058823529, alpha: 1)),
        (teamName: .MIL, type: .foreground, color: #colorLiteral(red: 0, green: 0.2784313725, blue: 0.1058823529, alpha: 1)),
        (teamName: .MIL, type: .background, color: #colorLiteral(red: 0.9411764706, green: 0.9215686275, blue: 0.8235294118, alpha: 1)),
        (teamName: .MIN, type: .foreground, color: #colorLiteral(red: 0.04705882353, green: 0.137254902, blue: 0.2509803922, alpha: 1)),
        (teamName: .MIN, type: .background, color: #colorLiteral(red: 0.6196078431, green: 0.6352941176, blue: 0.6352941176, alpha: 1)),
        (teamName: .NOP, type: .foreground, color: #colorLiteral(red: 0, green: 0.168627451, blue: 0.3607843137, alpha: 1)),
        (teamName: .NOP, type: .background, color: #colorLiteral(red: 0.7058823529, green: 0.5921568627, blue: 0.3529411765, alpha: 1)),
        (teamName: .NYK, type: .foreground, color: #colorLiteral(red: 0, green: 0.4196078431, blue: 0.7137254902, alpha: 1)),
        (teamName: .NYK, type: .background, color: #colorLiteral(red: 0.7450980392, green: 0.7529411765, blue: 0.7607843137, alpha: 1)),
        (teamName: .OKC, type: .foreground, color: #colorLiteral(red: 0, green: 0.4901960784, blue: 0.7647058824, alpha: 1)),
        (teamName: .OKC, type: .background, color: #colorLiteral(red: 0.9921568627, green: 0.7333333333, blue: 0.1882352941, alpha: 1)),
        (teamName: .ORL, type: .foreground, color: #colorLiteral(red: 0, green: 0.4901960784, blue: 0.7725490196, alpha: 1)),
        (teamName: .ORL, type: .background, color: #colorLiteral(red: 0.768627451, green: 0.8078431373, blue: 0.8274509804, alpha: 1)),
        (teamName: .PHI, type: .foreground, color: #colorLiteral(red: 0.9176470588, green: 0.1176470588, blue: 0.3098039216, alpha: 1)),
        (teamName: .PHI, type: .background, color: #colorLiteral(red: 0.768627451, green: 0.8078431373, blue: 0.8274509804, alpha: 1)),
        (teamName: .PHX, type: .foreground, color: #colorLiteral(red: 0.1137254902, green: 0.06666666667, blue: 0.3764705882, alpha: 1)),
        (teamName: .PHX, type: .background, color: #colorLiteral(red: 0.8980392157, green: 0.3764705882, blue: 0.1254901961, alpha: 1)),
        (teamName: .POR, type: .foreground, color: #colorLiteral(red: 0.8666666667, green: 0.231372549, blue: 0.262745098, alpha: 1)),
        (teamName: .POR, type: .background, color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)),
        (teamName: .SAC, type: .foreground, color: #colorLiteral(red: 0.3450980392, green: 0.1843137255, blue: 0.4980392157, alpha: 1)),
        (teamName: .SAC, type: .background, color: #colorLiteral(red: 0.3882352941, green: 0.4431372549, blue: 0.4784313725, alpha: 0.8961365582)),
        (teamName: .SAS, type: .foreground, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),
        (teamName: .SAS, type: .background, color: #colorLiteral(red: 0.768627451, green: 0.8078431373, blue: 0.831372549, alpha: 1)),
        (teamName: .TOR, type: .foreground, color: #colorLiteral(red: 0.7960784314, green: 0.1137254902, blue: 0.2784313725, alpha: 1)),
        (teamName: .TOR, type: .background, color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)),
        (teamName: .UTA, type: .foreground, color: #colorLiteral(red: 0, green: 0.2784313725, blue: 0.1058823529, alpha: 1)),
        (teamName: .UTA, type: .background, color: #colorLiteral(red: 0.9764705882, green: 0.6274509804, blue: 0, alpha: 0.3)),
        (teamName: .WAS, type: .foreground, color: #colorLiteral(red: 0.8745098039, green: 0.1176470588, blue: 0.231372549, alpha: 1)),
        (teamName: .WAS, type: .background, color: #colorLiteral(red: 0.768627451, green: 0.8078431373, blue: 0.831372549, alpha: 1))
    ]
    
    //MARK: Public functions
    
    static func retrieveTeamColor(for team: String, in type: TeamColorType) -> UIColor {
        if let teamColor = TeamColors.teamColorsArray.filter({$0.teamName.rawValue == team && $0.type == type}).first?.color {
            return teamColor
        } else {
            if type == .background {
                return TeamColors.unknownBackgroundColor.color
            } else {
                return TeamColors.unknownForegroundColor.color
            }
        }
    }
}
