# Nihongo 🇯🇵

![Swift Version](https://img.shields.io/badge/swift-3.0-orange.svg?style=flat)
[![Platform](https://img.shields.io/cocoapods/p/Typist.svg?style=flat)](http://cocoapods.org/pods/Typist)
[![Twitter](https://img.shields.io/badge/twitter-@totocaster-blue.svg)](http://twitter.com/totocaster)

Nihongo is API powered Japanese language morphological analysis Swift library for iOS. It helps you quickly tokenize Japanese sentences and understand its anatomy.

![Nihongo deconstructs your Japanese sentences.](https://raw.githubusercontent.com/totocaster/Nihongo/master/Docs/sentence_breakdown.png)

**Motivation:** `NSLinguisticTagger` is fantastic, but before it supports Japanese morphological analysis, this is your easiest option for now.

Nihongo is powered by [Yahoo Japan's morphological analysis][yjma] API. Support of multiple—online and offline—service would be nice, but this is only option for now. 

---

⚠️ **This is work in progress repo. I'll start accepting PRs as soon as I have this repo all tidy. By that time proper docs will be in place too.** Here is how my todo list looks like now:

- [x] Implement framework so its usable
- [ ] Add error handling
- [ ] Add tests and test cases
- [ ] Consider adding sample iOS/iPhone app
- [ ] Proper in-line documentation
- [ ] Clear documentation in README (you are looking at it now)
- [ ] Add Cococapods support
- [ ] Add Carthage support
- [ ] watchOS + tvOS support
- [ ] macOS support (perhaps?)

Thanks for checking-out Nihongo!

---

## Usage

Deconstructing sentences is trivial. Just instantiate `Nihongo` with valid API `app_id` and call `analize(sentence:completion:)`. You'll get array of `Word` types in completion handler as a closure parameter. 

```swift
let sentence = "昼ごはんを食べています。"

let ma = Nihongo(yahooJapanAppId: "<YAHOO_CO_JP_APP_ID>")

ma.analyze(sentence: sentence) {
    words in
    
    for token in words {
        print("Word \(token.text) reads as \(token.reading) is \(token.class) and has base form of \(token.base)")
    }
}
```

Code above will yield following in console:

```text
Word 昼ごはん reads as ひるごはん is noun and has base form of 昼ごはん
Word を reads as を is particle and has base form of を
Word 食べ reads as たべ is verb and has base form of 食べる
Word て reads as て is particle and has base form of て
Word い reads as い is auxiliaryVerb and has base form of いる
Word ます reads as ます is auxiliaryVerb and has base form of ます
Word 。 reads as 。 is special and has base form of 。
```


### Extracted Token — `Word` 

`Word` is inert/immutable struct that describes extracted token. 

* `text` — `String` that matches exact text from analyzed sentence.
* `reading` — `String` in [hiragana][hrg] syllabary describing how to read `text`.
* `class` — Internal `WordClass` enum describing what morphological part of sentance is the word.
* `base` — `String` with base form of the word (e.g. unconjugated verb). Usefull of further dictionary look-ups.

### Morphological Classes of Words — `WordClass`

`WordClass` is lexical classification of `Word`. Supported classes are:

* `.adjectivalVerb` — Adjectival Verb (形容詞, _keiyōshi_) a.k.a adjectival verb, i-adjective, adjective, stative verb
* `.adjectivalNoun` — Adjectival Noun (形容動詞, _keiyōdōshi_) a.k.a. adjectival noun, na-adjective, copular noun, quasi-adjective, nominal adjective, adjectival verb
* `.attributive` — Prenominal (連体詞, _rentaishi_) a.k.a. attributive, true adjective, prenominal, pre-noun adjectival
* `.interjection` — Interjection (感動詞, _kandōshi_)
* `.adverb` — Adverb (副詞, _fukushi_)
* `.conjunction` — Conjunction (接続詞, _setsuzokushi_)
* `.noun` — Noun (名詞, _meishi_)
* `.verb` — Verb (動詞, _dōshi_)
* `.particle` — Particle (助詞, _joshi_)
* `.auxiliaryVerb` — (助動詞, _jodōshi_)
* `.prefix` — Prefix (接頭辞)
* `.suffix` — Suffix (接尾辞)
* `.special` — Punctuation, brackets, symbols, etc.

[hrg]: https://en.wikipedia.org/wiki/Hiragana
[yjma]: http://developer.yahoo.co.jp/webapi/jlp/ma/v1/parse.html
