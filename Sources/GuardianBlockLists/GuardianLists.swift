import Foundation

struct GuardianLists {
    static let kAdsFile = "adlist"
    static let kHostFile = "contentlist"
    static let kKeywordsFile = "keywordlist"
    static let kUrlsFile = "urllist"
}

public enum GLists {
    static public let adlist = Bundle.module.url(forResource: GuardianLists.kAdsFile, withExtension: "txt" )
    static public let NSCHostList = Bundle.module.url(forResource: GuardianLists.kHostFile, withExtension: "txt")
    static public let NSCKeywordList = Bundle.module.url(forResource: GuardianLists.kKeywordsFile, withExtension: "txt")
    static public let NSCUrlList = Bundle.module.url(forResource: GuardianLists.kUrlsFile, withExtension: "txt")
}
