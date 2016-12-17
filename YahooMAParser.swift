//
//  YahooMAParser.swift
//  Nihongo
//
//  Created by Toto Tvalavadze on 2016/12/17.
//  Copyright © 2016 Toto Tvalavadze. All rights reserved.
//

import Foundation

class YahooMAServiceResponseParser: NSObject, XMLParserDelegate {
    let parser: XMLParser
    
    private var completionCallback: ParsingCompleteCallback
    init(data: Data, completion: @escaping ParsingCompleteCallback) {
        parser = XMLParser(data: data)
        completionCallback = completion
    }
    
    typealias ParsingCompleteCallback = ([Word]) -> ()
    func parse() {
        parser.delegate = self
        parser.parse()
    }
    
    private var words: [Word] = []
    private var isParsingWord = false
    private var currentWordNode: String?
    private var intermediateWord:[String: String] = [:]
    
    // MARK: XMLParserDelegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "word" {
            isParsingWord = true
        } else {
            if isParsingWord {
                currentWordNode = elementName
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard isParsingWord else { return }
        if let currentNode = currentWordNode {
            intermediateWord[currentNode] = string
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "word" {
            isParsingWord = false
            if  let position = intermediateWord["pos"],
                let text = intermediateWord["surface"],
                let reading = intermediateWord["reading"],
                let base = intermediateWord["baseform"],
                let lexical = WordClass(rawValue: position)
            {
                let word = Word(text: text, reading: reading, class: lexical, base: base)
                words.append(word)
            }
            intermediateWord = [:]
            currentWordNode = nil
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        completionCallback(words)
    }
}
