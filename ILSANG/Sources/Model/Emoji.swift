//
//  Emoji.swift
//  ILSANG
//
//  Created by Lee Jinhee on 6/16/24.
//

struct EmojiModel: Decodable {
    let data: Emoji
    let status, message: String
    let errorStatus: String?
    let errMessage: String?
}

struct Emoji: Decodable {
    var isLike: Bool
    var isHate: Bool
}
