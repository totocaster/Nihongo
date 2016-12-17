//
//  Types.swift
//  Nihongo
//
//  Created by Toto Tvalavadze on 2016/12/17.
//  Copyright © 2016 Toto Tvalavadze. All rights reserved.
//

import Foundation

public struct Word {
    var text: String
    var reading: String
    var `class`: WordClass
    var base: String
}

public enum WordClass: String {
    case adjectivalVerb = "形容詞" // keiyōshi - adjectival verbs, i-adjectives, adjectives, stative verbs
    case adjectivalNoun = "形容動詞" // keiyōdōshi - adjectival nouns, na-adjectives, copular nouns, quasi-adjectives, nominal adjectives, adjectival verbs
    case attributive = "連体詞" // rentaishi, attributives, true adjectives, prenominals, pre-noun adjectivals
    
    case interjection = "感動詞" // kandōshi
    case adverb = "副詞" // fukushi
    case conjunction = "接続詞" // setsuzokushi
    
    case prefix = "接頭辞"
    case suffix = "接尾辞"
    
    case noun = "名詞" // meishi
    case verb = "動詞" // dōshi
    
    case particle = "助詞" // joshi
    case auxiliaryVerb = "助動詞" // jodōshi
    
    /// Punctuation, brackets, symbols, etc.
    case special = "特殊"
}
