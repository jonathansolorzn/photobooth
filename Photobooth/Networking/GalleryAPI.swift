//
//  GalleryNetworkService.swift
//  Photobooth
//

import Moya
import Foundation

enum GalleryAPI {
    case tags
    case cats(params: CatParams)
}

extension GalleryAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constants.baseUrl) else {
            fatalError("baseURL could not be configurated.")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .tags:
            return Endpoints.getTags
        case .cats:
            return Endpoints.getCats
        }
    }
    
    var method: Moya.Method {
        .get
    }

    var task: Task {
        switch self {
        case .cats(let params):
            return .requestParameters(
                parameters: [
                    Keys.tags: params.tag,
                    Keys.skip: params.skip,
                    Keys.limit: params.limit
                ],
                encoding: URLEncoding.default
            )
        case .tags:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        ["Content-type": "application/json"]
    }
    
    // TODO: These texts should be in json files for test targets
    
    var sampleData: Data {
        switch self {
        case .tags: return "[\"Black\",\"Box\"]".dataEncoded
        case .cats(let params):
            
            switch params.tag {
            case "Black":
                return "[{\"id\":\"595f280e557291a9750ebfa0\",\"created_at\":\"2016-10-08T23:39:12.545Z\",\"tags\":[\"black\",\"beer\"]},{\"id\":\"595f280a557291a9750ebf61\",\"created_at\":\"2016-04-13T14:22:29.197Z\",\"tags\":[\"black\",\"long-cat\"]},{\"id\":\"595f280c557291a9750ebf75\",\"created_at\":\"2016-11-22T13:10:43.662Z\",\"tags\":[\"black\",\"dance\",\"gif\"]}]".dataEncoded
            case "Box":
                return "[{\"id\":\"595f280b557291a9750ebf67\",\"created_at\":\"2016-09-22T19:22:49.206Z\",\"tags\":[\"boxe\",\"gif\"]},{\"id\":\"595f2811557291a9750ebfe9\",\"created_at\":\"2016-11-25T03:41:29.203Z\",\"tags\":[\"cats\",\"box\"]},{\"id\":\"5a12db6c5b0b89002b358643\",\"created_at\":\"2017-11-20T13:41:00.177Z\",\"tags\":[\"soon\",\"orange\",\"hide\",\"box\"]}]".dataEncoded
            default:
                return "".dataEncoded
            }
        }
    }
}
