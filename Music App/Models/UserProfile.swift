//
//  UserProfile.swift
//  Music App
//
//  Created by Sơn Nguyễn on 10/07/2022.
//

import Foundation
struct UserProfile: Codable {
    let country: String
    let display_name: String
    let product: String
    let id: String
    let images: [APIImage]
    let explicit_content : ExplicitContent
    let type: String
    let external_urls : ExternalURLs
    let followers: Follower
}


struct ExplicitContent : Codable {
    let filter_enabled: Bool
    let filter_locked: Bool
}
//
struct ExternalURLs: Codable {
    let spotify: String
}
//
struct Follower: Codable {
    let total: Int
}
//


//}
//{
//    country = VN;
//    "display_name" = "S\U01a1n Nguy\U1ec5n Th\U00e1i";
//    "explicit_content" =     {
//        "filter_enabled" = 0;
//        "filter_locked" = 0;
//    };
//    "external_urls" =     {
//        spotify = "https://open.spotify.com/user/314tmylbmptgstgbqib5jzrub2ky";
//    };
//    followers =     {
//        href = "<null>";
//        total = 1;
//    };
//    href = "https://api.spotify.com/v1/users/314tmylbmptgstgbqib5jzrub2ky";
//    id = 314tmylbmptgstgbqib5jzrub2ky;
//    images =     (
//                {
//            height = "<null>";
//            url = "https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=837284929989900&height=300&width=300&ext=1660443624&hash=AeQBvCJncRHBBaj3LzI";
//            width = "<null>";
//        }
//    );
//    product = open;
//    type = user;
//    uri = "spotify:user:314tmylbmptgstgbqib5jzrub2ky";
//}
//{
