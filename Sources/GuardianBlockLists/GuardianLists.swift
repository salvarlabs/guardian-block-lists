import Foundation

public struct GuardianListNames {
    public static let kAdsFile = "adlist"
    public static let kHostFile = "contentlist"
    public static let kKeywordsFile = "keywordlist"
    public static let kUrlsFile = "urllist"
    public static let kBlockerJSONFile = "blockerList"
}

public enum GLists {
    static public let adlist = Bundle.module.url(forResource: GuardianListNames.kAdsFile, withExtension: "txt" )
    static public let NSCHostList = Bundle.module.url(forResource: GuardianListNames.kHostFile, withExtension: "txt")
    static public let NSCKeywordList = Bundle.module.url(forResource: GuardianListNames.kKeywordsFile, withExtension: "txt")
    static public let NSCUrlList = Bundle.module.url(forResource: GuardianListNames.kUrlsFile, withExtension: "txt")
    static public let NSCBlockerJSONFile = Bundle.module.url(forResource: GuardianListNames.kBlockerJSONFile, withExtension: "json")
}
