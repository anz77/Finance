//
//  Modules.swift
//  Finance
//
//  Created by Andrii Zuiok on 08.06.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import Foundation


import Foundation

// MARK: - Modules
public struct Modules: Codable {
    public var quoteSummary: ModulesQuoteSummary?

    enum CodingKeys: String, CodingKey {
        case quoteSummary = "quoteSummary"
    }
}

// MARK: - QuoteSummary
public struct ModulesQuoteSummary: Codable {
    public var result: [ModulesResult]?
    public var error: YFError?

    enum CodingKeys: String, CodingKey {
        case result = "result"
        case error = "error"
    }
}

// MARK: - Result
public struct ModulesResult: Codable {
    public var assetProfile: AssetProfileClass?
    public var financialData: FinancialDataClass?
    public var incomeStatementHistory: IncomeStatementHistoryClass?
    public var incomeStatementHistoryQuarterly: IncomeStatementHistoryClass?
    public var balanceSheetHistory: BalanceSheetHistoryClass?
    public var balanceSheetHistoryQuarterly: BalanceSheetHistoryClass?
    public var cashflowStatementHistory: CashflowStatementHistoryClass?
    public var cashflowStatementHistoryQuarterly: CashflowStatementHistoryClass?
    public var defaultKeyStatistics: DefaultKeyStatisticsClass?
    public var calendarEvents: CalendarEventsClass?
    public var secFilings: SecFilingsClass?
    public var upgradeDowngradeHistory: UpgradeDowngradeHistoryClass?
    public var institutionOwnership: OwnershipClass?
    public var fundOwnership: OwnershipClass?
    public var insiderHolders: HoldersClass?
    public var majorDirectHolders: HoldersClass?
    public var majorHoldersBreakdown: MajorHoldersBreakdownClass?
    public var insiderTransactions: InsiderTransactionsClass?
    public var netSharePurchaseActivity: NetSharePurchaseActivityClass?
    public var earnings: EarningsClass?
    public var earningsHistory: EarningsHistoryClass?
    public var recommendationTrend: RecommendationTrendClass?
    public var earningsTrend: EarningsTrendClass?
    public var indexTrend: TrendClass?
    public var industryTrend: TrendClass?
    public var sectorTrend: TrendClass?

    enum CodingKeys: String, CodingKey {
        case assetProfile = "assetProfile"
        case financialData = "financialData"
        case incomeStatementHistory = "incomeStatementHistory"
        case incomeStatementHistoryQuarterly = "incomeStatementHistoryQuarterly"
        case balanceSheetHistory = "balanceSheetHistory"
        case balanceSheetHistoryQuarterly = "balanceSheetHistoryQuarterly"
        case cashflowStatementHistory = "cashflowStatementHistory"
        case cashflowStatementHistoryQuarterly = "cashflowStatementHistoryQuarterly"
        case defaultKeyStatistics = "defaultKeyStatistics"
        case calendarEvents = "calendarEvents"
        case secFilings = "secFilings"
        case upgradeDowngradeHistory = "upgradeDowngradeHistory"
        case institutionOwnership = "institutionOwnership"
        case fundOwnership = "fundOwnership"
        case insiderHolders = "insiderHolders"
        case majorDirectHolders = "majorDirectHolders"
        case majorHoldersBreakdown = "majorHoldersBreakdown"
        case insiderTransactions = "insiderTransactions"
        case netSharePurchaseActivity = "netSharePurchaseActivity"
        case earnings = "earnings"
        case earningsHistory = "earningsHistory"
        case recommendationTrend = "recommendationTrend"
        case earningsTrend = "earningsTrend"
        case indexTrend = "indexTrend"
        case industryTrend = "industryTrend"
        case sectorTrend = "sectorTrend"
    }
}


// MARK: - AssetProfileClass
public struct AssetProfileClass: Codable {
    public var address1: String?
    public var city: String?
    public var state: String?
    public var zip: String?
    public var country: String?
    public var phone: String?
    public var website: String?
    public var industry: String?
    public var sector: String?
    public var longBusinessSummary: String?
    public var fullTimeEmployees: Int?
    public var companyOfficers: [CompanyOfficer]?
    public var auditRisk: Int?
    public var boardRisk: Int?
    public var compensationRisk: Int?
    public var shareHolderRightsRisk: Int?
    public var overallRisk: Int?
    public var governanceEpochDate: Int?
    public var compensationAsOfEpochDate: Int?
    public var maxAge: Int?

    enum CodingKeys: String, CodingKey {
        case address1 = "address1"
        case city = "city"
        case state = "state"
        case zip = "zip"
        case country = "country"
        case phone = "phone"
        case website = "website"
        case industry = "industry"
        case sector = "sector"
        case longBusinessSummary = "longBusinessSummary"
        case fullTimeEmployees = "fullTimeEmployees"
        case companyOfficers = "companyOfficers"
        case auditRisk = "auditRisk"
        case boardRisk = "boardRisk"
        case compensationRisk = "compensationRisk"
        case shareHolderRightsRisk = "shareHolderRightsRisk"
        case overallRisk = "overallRisk"
        case governanceEpochDate = "governanceEpochDate"
        case compensationAsOfEpochDate = "compensationAsOfEpochDate"
        case maxAge = "maxAge"
    }
}

// MARK: - CompanyOfficer
public struct CompanyOfficer: Codable {
    public var maxAge: Int?
    public var name: String?
    public var age: Int?
    public var title: String?
    public var yearBorn: Int?
    public var fiscalYear: Int?
    public var totalPay: DoubleLongValue?
    public var exercisedValue: DoubleLongValue?
    public var unexercisedValue: DoubleLongValue?

    enum CodingKeys: String, CodingKey {
        case maxAge = "maxAge"
        case name = "name"
        case age = "age"
        case title = "title"
        case yearBorn = "yearBorn"
        case fiscalYear = "fiscalYear"
        case totalPay = "totalPay"
        case exercisedValue = "exercisedValue"
        case unexercisedValue = "unexercisedValue"
    }
}


// MARK: - BalanceSheetHistoryClass
public struct BalanceSheetHistoryClass: Codable {
    public var balanceSheetStatements: [BalanceSheetStatement]?
    public var maxAge: Int?

    enum CodingKeys: String, CodingKey {
        case balanceSheetStatements = "balanceSheetStatements"
        case maxAge = "maxAge"
    }
}

// MARK: - BalanceSheetStatement
public struct BalanceSheetStatement: Codable {
    public var maxAge: Int?
    public var endDate: DoubleShortValue?
    public var cash: DoubleLongValue?
    public var shortTermInvestments: DoubleLongValue?
    public var netReceivables: DoubleLongValue?
    public var inventory: DoubleLongValue?
    public var otherCurrentAssets: DoubleLongValue?
    public var totalCurrentAssets: DoubleLongValue?
    public var longTermInvestments: DoubleLongValue?
    public var propertyPlantEquipment: DoubleLongValue?
    public var otherAssets: DoubleLongValue?
    public var totalAssets: DoubleLongValue?
    public var accountsPayable: DoubleLongValue?
    public var shortLongTermDebt: DoubleLongValue?
    public var otherCurrentLiab: DoubleLongValue?
    public var longTermDebt: DoubleLongValue?
    public var otherLiab: DoubleLongValue?
    public var totalCurrentLiabilities: DoubleLongValue?
    public var totalLiab: DoubleLongValue?
    public var commonStock: DoubleLongValue?
    public var retainedEarnings: DoubleLongValue?
    public var treasuryStock: DoubleLongValue?
    public var otherStockholderEquity: DoubleLongValue?
    public var totalStockholderEquity: DoubleLongValue?
    public var netTangibleAssets: DoubleLongValue?
    public var goodWill: DoubleLongValue?
    public var intangibleAssets: DoubleLongValue?

    enum CodingKeys: String, CodingKey {
        case maxAge = "maxAge"
        case endDate = "endDate"
        case cash = "cash"
        case shortTermInvestments = "shortTermInvestments"
        case netReceivables = "netReceivables"
        case inventory = "inventory"
        case otherCurrentAssets = "otherCurrentAssets"
        case totalCurrentAssets = "totalCurrentAssets"
        case longTermInvestments = "longTermInvestments"
        case propertyPlantEquipment = "propertyPlantEquipment"
        case otherAssets = "otherAssets"
        case totalAssets = "totalAssets"
        case accountsPayable = "accountsPayable"
        case shortLongTermDebt = "shortLongTermDebt"
        case otherCurrentLiab = "otherCurrentLiab"
        case longTermDebt = "longTermDebt"
        case otherLiab = "otherLiab"
        case totalCurrentLiabilities = "totalCurrentLiabilities"
        case totalLiab = "totalLiab"
        case commonStock = "commonStock"
        case retainedEarnings = "retainedEarnings"
        case treasuryStock = "treasuryStock"
        case otherStockholderEquity = "otherStockholderEquity"
        case totalStockholderEquity = "totalStockholderEquity"
        case netTangibleAssets = "netTangibleAssets"
        case goodWill = "goodWill"
        case intangibleAssets = "intangibleAssets"
    }
}


// MARK: - CalendarEvents
public struct CalendarEvents: Codable {
    public var quoteSummary: CalendarEventsQuoteSummary?

    enum CodingKeys: String, CodingKey {
        case quoteSummary = "quoteSummary"
    }
}

// MARK: - QuoteSummary
public struct CalendarEventsQuoteSummary: Codable {
    public var result: [CalendarEventsResult]?
    public var error: YFError?

    enum CodingKeys: String, CodingKey {
        case result = "result"
        case error = "error"
    }
}

// MARK: - Result
public struct CalendarEventsResult: Codable {
    public var calendarEvents: CalendarEventsClass?

    enum CodingKeys: String, CodingKey {
        case calendarEvents = "calendarEvents"
    }
}

// MARK: - CalendarEventsClass
public struct CalendarEventsClass: Codable {
    public var maxAge: Int?
    public var earnings: CalendarEventsEarnings?
    public var exDividendDate: DoubleShortValue?
    public var dividendDate: DoubleShortValue?

    enum CodingKeys: String, CodingKey {
        case maxAge = "maxAge"
        case earnings = "earnings"
        case exDividendDate = "exDividendDate"
        case dividendDate = "dividendDate"
    }
}

// MARK: - Earnings
public struct CalendarEventsEarnings: Codable {
    public var earningsDate: [DoubleShortValue]?
    public var earningsAverage: DoubleShortValue?
    public var earningsLow: DoubleShortValue?
    public var earningsHigh: DoubleShortValue?
    public var revenueAverage: DoubleLongValue?
    public var revenueLow: DoubleLongValue?
    public var revenueHigh: DoubleLongValue?

    enum CodingKeys: String, CodingKey {
        case earningsDate = "earningsDate"
        case earningsAverage = "earningsAverage"
        case earningsLow = "earningsLow"
        case earningsHigh = "earningsHigh"
        case revenueAverage = "revenueAverage"
        case revenueLow = "revenueLow"
        case revenueHigh = "revenueHigh"
    }

    public init(earningsDate: [DoubleShortValue]?, earningsAverage: DoubleShortValue?, earningsLow: DoubleShortValue?, earningsHigh: DoubleShortValue?, revenueAverage: DoubleLongValue?, revenueLow: DoubleLongValue?, revenueHigh: DoubleLongValue?) {
        self.earningsDate = earningsDate
        self.earningsAverage = earningsAverage
        self.earningsLow = earningsLow
        self.earningsHigh = earningsHigh
        self.revenueAverage = revenueAverage
        self.revenueLow = revenueLow
        self.revenueHigh = revenueHigh
    }
}


// MARK: - CashflowStatementHistoryClass
public struct CashflowStatementHistoryClass: Codable {
    public var cashflowStatements: [CashflowStatement]?
    public var maxAge: Int?

    enum CodingKeys: String, CodingKey {
        case cashflowStatements = "cashflowStatements"
        case maxAge = "maxAge"
    }
}

// MARK: - CashflowStatement
public struct CashflowStatement: Codable {
    public var maxAge: Int?
    public var endDate: DoubleShortValue?
    public var netIncome: DoubleLongValue?
    public var depreciation: DoubleLongValue?
    public var changeToNetincome: DoubleLongValue?
    public var changeToAccountReceivables: DoubleLongValue?
    public var changeToLiabilities: DoubleLongValue?
    public var changeToInventory: DoubleLongValue?
    public var changeToOperatingActivities: DoubleLongValue?
    public var totalCashFromOperatingActivities: DoubleLongValue?
    public var capitalExpenditures: DoubleLongValue?
    public var investments: DoubleLongValue?
    public var otherCashflowsFromInvestingActivities: DoubleLongValue?
    public var totalCashflowsFromInvestingActivities: DoubleLongValue?
    public var dividendsPaid: DoubleLongValue?
    public var netBorrowings: DoubleLongValue?
    public var otherCashflowsFromFinancingActivities: DoubleLongValue?
    public var totalCashFromFinancingActivities: DoubleLongValue?
    public var changeInCash: DoubleLongValue?
    public var repurchaseOfStock: DoubleLongValue?
    public var issuanceOfStock: DoubleLongValue?

    enum CodingKeys: String, CodingKey {
        case maxAge = "maxAge"
        case endDate = "endDate"
        case netIncome = "netIncome"
        case depreciation = "depreciation"
        case changeToNetincome = "changeToNetincome"
        case changeToAccountReceivables = "changeToAccountReceivables"
        case changeToLiabilities = "changeToLiabilities"
        case changeToInventory = "changeToInventory"
        case changeToOperatingActivities = "changeToOperatingActivities"
        case totalCashFromOperatingActivities = "totalCashFromOperatingActivities"
        case capitalExpenditures = "capitalExpenditures"
        case investments = "investments"
        case otherCashflowsFromInvestingActivities = "otherCashflowsFromInvestingActivities"
        case totalCashflowsFromInvestingActivities = "totalCashflowsFromInvestingActivities"
        case dividendsPaid = "dividendsPaid"
        case netBorrowings = "netBorrowings"
        case otherCashflowsFromFinancingActivities = "otherCashflowsFromFinancingActivities"
        case totalCashFromFinancingActivities = "totalCashFromFinancingActivities"
        case changeInCash = "changeInCash"
        case repurchaseOfStock = "repurchaseOfStock"
        case issuanceOfStock = "issuanceOfStock"
    }
}

// CashflowStatementHistoryQuarterly IDENTICAL WITH CashflowStatementHistory

// MARK: - DefaultKeyStatisticsClass
public struct DefaultKeyStatisticsClass: Codable {
    public var maxAge: Int?
    public var priceHint: DoubleLongValue?
    public var enterpriseValue: DoubleLongValue?
    public var forwardPE: DoubleShortValue?
    public var profitMargins: DoubleShortValue?
    public var floatShares: DoubleLongValue?
    public var sharesOutstanding: DoubleLongValue?
    public var sharesShort: DoubleLongValue?
    public var sharesShortPriorMonth: DoubleLongValue?
    public var sharesShortPreviousMonthDate: DoubleShortValue?
    public var dateShortInterest: DoubleShortValue?
    public var sharesPercentSharesOut: DoubleShortValue?
    public var heldPercentInsiders: DoubleShortValue?
    public var heldPercentInstitutions: DoubleShortValue?
    public var shortRatio: DoubleShortValue?
    public var shortPercentOfFloat: DoubleShortValue?
    public var beta: DoubleShortValue?
    public var morningStarOverallRating: DoubleLongValue?
    public var morningStarRiskRating: DoubleLongValue?
    public var category: String?
    public var bookValue: DoubleShortValue?
    public var priceToBook: DoubleShortValue?
    public var annualReportExpenseRatio: DoubleShortValue?
    public var ytdReturn: DoubleShortValue?
    public var beta3Year: DoubleShortValue?
    public var totalAssets: DoubleLongValue?
    public var yield: DoubleShortValue?
    public var fundFamily: String?
    public var fundInceptionDate: DoubleShortValue?
    public var legalType: String?
    public var threeYearAverageReturn: DoubleShortValue?
    public var fiveYearAverageReturn: DoubleShortValue?
//    public var priceToSalesTrailing12Months: SOMETHING?
    public var lastFiscalYearEnd: DoubleShortValue?
    public var nextFiscalYearEnd: DoubleShortValue?
    public var mostRecentQuarter: DoubleShortValue?
    public var earningsQuarterlyGrowth: DoubleShortValue?
    public var revenueQuarterlyGrowth: DoubleShortValue?
    public var netIncomeToCommon: DoubleLongValue?
    public var trailingEps: DoubleShortValue?
    public var forwardEps: DoubleShortValue?
    public var pegRatio: DoubleShortValue?
    public var lastSplitFactor: String?
    public var lastSplitDate: DoubleShortValue?
    public var enterpriseToRevenue: DoubleShortValue?
    public var enterpriseToEbitda: DoubleShortValue?
    public var the52WeekChange: DoubleShortValue?
    public var sandP52WeekChange: DoubleShortValue?
    public var lastDividendValue: DoubleShortValue?
    public var lastCapGain: DoubleShortValue?
    public var annualHoldingsTurnover: DoubleShortValue?

    enum CodingKeys: String, CodingKey {
        case maxAge = "maxAge"
        case priceHint = "priceHint"
        case enterpriseValue = "enterpriseValue"
        case forwardPE = "forwardPE"
        case profitMargins = "profitMargins"
        case floatShares = "floatShares"
        case sharesOutstanding = "sharesOutstanding"
        case sharesShort = "sharesShort"
        case sharesShortPriorMonth = "sharesShortPriorMonth"
        case sharesShortPreviousMonthDate = "sharesShortPreviousMonthDate"
        case dateShortInterest = "dateShortInterest"
        case sharesPercentSharesOut = "sharesPercentSharesOut"
        case heldPercentInsiders = "heldPercentInsiders"
        case heldPercentInstitutions = "heldPercentInstitutions"
        case shortRatio = "shortRatio"
        case shortPercentOfFloat = "shortPercentOfFloat"
        case beta = "beta"
        case morningStarOverallRating = "morningStarOverallRating"
        case morningStarRiskRating = "morningStarRiskRating"
        case category = "category"
        case bookValue = "bookValue"
        case priceToBook = "priceToBook"
        case annualReportExpenseRatio = "annualReportExpenseRatio"
        case ytdReturn = "ytdReturn"
        case beta3Year = "beta3Year"
        case totalAssets = "totalAssets"
        case yield = "yield"
        case fundFamily = "fundFamily"
        case fundInceptionDate = "fundInceptionDate"
        case legalType = "legalType"
        case threeYearAverageReturn = "threeYearAverageReturn"
        case fiveYearAverageReturn = "fiveYearAverageReturn"
//        case priceToSalesTrailing12Months = "priceToSalesTrailing12Months"
        case lastFiscalYearEnd = "lastFiscalYearEnd"
        case nextFiscalYearEnd = "nextFiscalYearEnd"
        case mostRecentQuarter = "mostRecentQuarter"
        case earningsQuarterlyGrowth = "earningsQuarterlyGrowth"
        case revenueQuarterlyGrowth = "revenueQuarterlyGrowth"
        case netIncomeToCommon = "netIncomeToCommon"
        case trailingEps = "trailingEps"
        case forwardEps = "forwardEps"
        case pegRatio = "pegRatio"
        case lastSplitFactor = "lastSplitFactor"
        case lastSplitDate = "lastSplitDate"
        case enterpriseToRevenue = "enterpriseToRevenue"
        case enterpriseToEbitda = "enterpriseToEbitda"
        case the52WeekChange = "52WeekChange"
        case sandP52WeekChange = "SandP52WeekChange"
        case lastDividendValue = "lastDividendValue"
        case lastCapGain = "lastCapGain"
        case annualHoldingsTurnover = "annualHoldingsTurnover"
        // 52WeekChange "52WeekChange":{"raw":0.7427622,"fmt":"74.28%"},
        // SandP52WeekChange "SandP52WeekChange":{"raw":0.039875627,"fmt":"3.99%"},
    }
}


// MARK: - Earnings
public struct Earnings: Codable {
    public var quoteSummary: EarningsQuoteSummary?
    
    enum CodingKeys: String, CodingKey {
        case quoteSummary = "quoteSummary"
    }
}

// MARK: - QuoteSummary
public struct EarningsQuoteSummary: Codable {
    public var result: [EarningsResult]?
    public var error: YFError?
    
    enum CodingKeys: String, CodingKey {
        case result = "result"
        case error = "error"
    }
}

// MARK: - Result
public struct EarningsResult: Codable {
    public var earnings: EarningsClass?
    
    enum CodingKeys: String, CodingKey {
        case earnings = "earnings"
    }
}

// MARK: - ResultEarnings
public struct EarningsClass: Codable {
    public var maxAge: Int?
    public var earningsChart: EarningsChart?
    public var financialsChart: FinancialsChart?
    public var financialCurrency: String?
    
    enum CodingKeys: String, CodingKey {
        case maxAge = "maxAge"
        case earningsChart = "earningsChart"
        case financialsChart = "financialsChart"
        case financialCurrency = "financialCurrency"
    }
}

// MARK: - EarningsChart
public struct EarningsChart: Codable {
    public var quarterly: [EarningsChartQuarterly]?
    public var currentQuarterEstimate: DoubleShortValue?
    public var currentQuarterEstimateDate: String?
    public var currentQuarterEstimateYear: Int?
    public var earningsDate: [DoubleShortValue]?
    
    enum CodingKeys: String, CodingKey {
        case quarterly = "quarterly"
        case currentQuarterEstimate = "currentQuarterEstimate"
        case currentQuarterEstimateDate = "currentQuarterEstimateDate"
        case currentQuarterEstimateYear = "currentQuarterEstimateYear"
        case earningsDate = "earningsDate"
    }
}

// MARK: - EarningsChartQuarterly
public struct EarningsChartQuarterly: Codable {
    public var date: String?
    public var actual: DoubleShortValue?
    public var estimate: DoubleShortValue?
    
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case actual = "actual"
        case estimate = "estimate"
    }
}

// MARK: - FinancialsChart
public struct FinancialsChart: Codable {
    public var yearly: [Yearly]?
    public var quarterly: [FinancialsChartQuarterly]?
    
    enum CodingKeys: String, CodingKey {
        case yearly = "yearly"
        case quarterly = "quarterly"
    }
}

// MARK: - FinancialsChartQuarterly
public struct FinancialsChartQuarterly: Codable {
    public var date: String?
    public var revenue: DoubleLongValue?
    public var earnings: DoubleLongValue?
    
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case revenue = "revenue"
        case earnings = "earnings"
    }
}

// MARK: - Yearly
public struct Yearly: Codable {
    public var date: Int?
    public var revenue: DoubleLongValue?
    public var earnings: DoubleLongValue?
    
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case revenue = "revenue"
        case earnings = "earnings"
    }
}


// MARK: - EarningsHistory
public struct EarningsHistory: Codable {
    public var quoteSummary: EarningsHistoryQuoteSummary?

    enum CodingKeys: String, CodingKey {
        case quoteSummary = "quoteSummary"
    }
}

// MARK: - QuoteSummary
public struct EarningsHistoryQuoteSummary: Codable {
    public var result: [EarningsHistoryResult]?
    public var error: YFError?

    enum CodingKeys: String, CodingKey {
        case result = "result"
        case error = "error"
    }
}

// MARK: - Result
public struct EarningsHistoryResult: Codable {
    public var earningsHistory: EarningsHistoryClass?

    enum CodingKeys: String, CodingKey {
        case earningsHistory = "earningsHistory"
    }
}

// MARK: - EarningsHistoryClass
public struct EarningsHistoryClass: Codable {
    public var history: [EarningsHistoryHistory]?
    public var maxAge: Int?

    enum CodingKeys: String, CodingKey {
        case history = "history"
        case maxAge = "maxAge"
    }
}

// MARK: - History
public struct EarningsHistoryHistory: Codable {
    public var maxAge: Int?
    public var epsActual: DoubleShortValue?
    public var epsEstimate: DoubleShortValue?
    public var epsDifference: DoubleShortValue?
    public var surprisePercent: DoubleShortValue?
    public var quarter: DoubleShortValue?
    public var period: String?

    enum CodingKeys: String, CodingKey {
        case maxAge = "maxAge"
        case epsActual = "epsActual"
        case epsEstimate = "epsEstimate"
        case epsDifference = "epsDifference"
        case surprisePercent = "surprisePercent"
        case quarter = "quarter"
        case period = "period"
    }
}


// MARK: - EarningsTrend
public struct EarningsTrend: Codable {
    public var quoteSummary: EarningsTrendQuoteSummary?

    enum CodingKeys: String, CodingKey {
        case quoteSummary = "quoteSummary"
    }
}

// MARK: - QuoteSummary
public struct EarningsTrendQuoteSummary: Codable {
    public var result: [EarningsTrendResult]?
    public var error: YFError?

    enum CodingKeys: String, CodingKey {
        case result = "result"
        case error = "error"
    }
}

// MARK: - Result
public struct EarningsTrendResult: Codable {
    public var earningsTrend: EarningsTrendClass?

    enum CodingKeys: String, CodingKey {
        case earningsTrend = "earningsTrend"
    }
}

// MARK: - EarningsTrendClass
public struct EarningsTrendClass: Codable {
    public var trend: [EarningsTrendTrend]?
    public var maxAge: Int?

    enum CodingKeys: String, CodingKey {
        case trend = "trend"
        case maxAge = "maxAge"
    }
}

// MARK: - Trend
public struct EarningsTrendTrend: Codable {
    public var maxAge: Int?
    public var period: String?
    public var endDate: String?
    public var growth: DoubleShortValue?
    public var earningsEstimate: EarningsEstimate?
    public var revenueEstimate: RevenueEstimate?
    public var epsTrend: EpsTrend?
    public var epsRevisions: EpsRevisions?

    enum CodingKeys: String, CodingKey {
        case maxAge = "maxAge"
        case period = "period"
        case endDate = "endDate"
        case growth = "growth"
        case earningsEstimate = "earningsEstimate"
        case revenueEstimate = "revenueEstimate"
        case epsTrend = "epsTrend"
        case epsRevisions = "epsRevisions"
    }
}

// MARK: - EpsRevisions
public struct EpsRevisions: Codable {
    public var upLast7Days: DoubleLongValue?
    public var upLast30Days: DoubleLongValue?
    public var downLast30Days: DoubleLongValue?
    public var downLast90Days: DoubleLongValue?

    enum CodingKeys: String, CodingKey {
        case upLast7Days = "upLast7days"
        case upLast30Days = "upLast30days"
        case downLast30Days = "downLast30days"
        case downLast90Days = "downLast90days"
    }
}

// MARK: - EpsTrend
public struct EpsTrend: Codable {
    public var current: DoubleShortValue?
    public var the7DaysAgo: DoubleShortValue?
    public var the30DaysAgo: DoubleShortValue?
    public var the60DaysAgo: DoubleShortValue?
    public var the90DaysAgo: DoubleShortValue?

    enum CodingKeys: String, CodingKey {
        case current = "current"
        case the7DaysAgo = "7daysAgo"
        case the30DaysAgo = "30daysAgo"
        case the60DaysAgo = "60daysAgo"
        case the90DaysAgo = "90daysAgo"
    }
}

// MARK: - RevenueEstimate
public struct RevenueEstimate: Codable {
    public var avg: DoubleLongValue?
    public var low: DoubleLongValue?
    public var high: DoubleLongValue?
    public var numberOfAnalysts: DoubleLongValue?
    public var yearAgoRevenue: DoubleLongValue?
    public var growth: DoubleShortValue?

    enum CodingKeys: String, CodingKey {
        case avg = "avg"
        case low = "low"
        case high = "high"
        case numberOfAnalysts = "numberOfAnalysts"
        case yearAgoRevenue = "yearAgoRevenue"
        case growth = "growth"
    }
}

// MARK: - EarningsEstimate
public struct EarningsEstimate: Codable {
    public var avg: DoubleShortValue?
    public var low: DoubleShortValue?
    public var high: DoubleShortValue?
    public var yearAgoEps: DoubleShortValue?
    public var numberOfAnalysts: DoubleLongValue?
    public var growth: DoubleShortValue?

    enum CodingKeys: String, CodingKey {
        case avg = "avg"
        case low = "low"
        case high = "high"
        case yearAgoEps = "yearAgoEps"
        case numberOfAnalysts = "numberOfAnalysts"
        case growth = "growth"
    }
}



// MARK: - FinancialDataClass
public struct FinancialDataClass: Codable {
    public var maxAge: Int?
    public var currentPrice: DoubleShortValue?
    public var targetHighPrice: DoubleShortValue?
    public var targetLowPrice: DoubleShortValue?
    public var targetMeanPrice: DoubleShortValue?
    public var targetMedianPrice: DoubleShortValue?
    public var recommendationMean: DoubleShortValue?
    public var recommendationKey: String?
    public var numberOfAnalystOpinions: DoubleLongValue?
    public var totalCash: DoubleLongValue?
    public var totalCashPerShare: DoubleShortValue?
    public var ebitda: DoubleLongValue?
    public var totalDebt: DoubleLongValue?
    public var quickRatio: DoubleShortValue?
    public var currentRatio: DoubleShortValue?
    public var totalRevenue: DoubleLongValue?
    public var debtToEquity: DoubleShortValue?
    public var revenuePerShare: DoubleShortValue?
    public var returnOnAssets: DoubleShortValue?
    public var returnOnEquity: DoubleShortValue?
    public var grossProfits: DoubleLongValue?
    public var freeCashflow: DoubleLongValue?
    public var operatingCashflow: DoubleLongValue?
    public var earningsGrowth: DoubleShortValue?
    public var revenueGrowth: DoubleShortValue?
    public var grossMargins: DoubleShortValue?
    public var ebitdaMargins: DoubleShortValue?
    public var operatingMargins: DoubleShortValue?
    public var profitMargins: DoubleShortValue?
    public var financialCurrency: String?

    enum CodingKeys: String, CodingKey {
        case maxAge = "maxAge"
        case currentPrice = "currentPrice"
        case targetHighPrice = "targetHighPrice"
        case targetLowPrice = "targetLowPrice"
        case targetMeanPrice = "targetMeanPrice"
        case targetMedianPrice = "targetMedianPrice"
        case recommendationMean = "recommendationMean"
        case recommendationKey = "recommendationKey"
        case numberOfAnalystOpinions = "numberOfAnalystOpinions"
        case totalCash = "totalCash"
        case totalCashPerShare = "totalCashPerShare"
        case ebitda = "ebitda"
        case totalDebt = "totalDebt"
        case quickRatio = "quickRatio"
        case currentRatio = "currentRatio"
        case totalRevenue = "totalRevenue"
        case debtToEquity = "debtToEquity"
        case revenuePerShare = "revenuePerShare"
        case returnOnAssets = "returnOnAssets"
        case returnOnEquity = "returnOnEquity"
        case grossProfits = "grossProfits"
        case freeCashflow = "freeCashflow"
        case operatingCashflow = "operatingCashflow"
        case earningsGrowth = "earningsGrowth"
        case revenueGrowth = "revenueGrowth"
        case grossMargins = "grossMargins"
        case ebitdaMargins = "ebitdaMargins"
        case operatingMargins = "operatingMargins"
        case profitMargins = "profitMargins"
        case financialCurrency = "financialCurrency"
    }
}


// MARK: - FundOwnership
public struct FundOwnership: Codable {
    public var quoteSummary: FundOwnershipQuoteSummary?

    enum CodingKeys: String, CodingKey {
        case quoteSummary = "quoteSummary"
    }
}

// MARK: - QuoteSummary
public struct FundOwnershipQuoteSummary: Codable {
    public var result: [FundOwnershipResult]?
    public var error: YFError?

    enum CodingKeys: String, CodingKey {
        case result = "result"
        case error = "error"
    }
}

// MARK: - Result
public struct FundOwnershipResult: Codable {
    public var fundOwnership: OwnershipClass?

    enum CodingKeys: String, CodingKey {
        case fundOwnership = "fundOwnership"
    }
}


// MARK: - ResultIncomeStatementHistory
public struct IncomeStatementHistoryClass: Codable {
    public var incomeStatementHistory: [IncomeStatementHistoryElement]?
    public var maxAge: Int?

    enum CodingKeys: String, CodingKey {
        case incomeStatementHistory = "incomeStatementHistory"
        case maxAge = "maxAge"
    }
}

// MARK: - IncomeStatementHistoryElement
public struct IncomeStatementHistoryElement: Codable {
    public var maxAge: Int?
    public var endDate: DoubleShortValue?
    public var totalRevenue: DoubleLongValue?
    public var costOfRevenue: DoubleLongValue?
    public var grossProfit: DoubleLongValue?
    public var researchDevelopment: DoubleLongValue?
    public var sellingGeneralAdministrative: DoubleLongValue?
//    public var nonRecurring: SOMETHING?
//    public var otherOperatingExpenses: SOMETHING?
    public var totalOperatingExpenses: DoubleLongValue?
    public var operatingIncome: DoubleLongValue?
    public var totalOtherIncomeExpenseNet: DoubleLongValue?
    public var ebit: DoubleLongValue?
    public var interestExpense: DoubleLongValue?
    public var incomeBeforeTax: DoubleLongValue?
    public var incomeTaxExpense: DoubleLongValue?
//    public var minorityInterest: SOMETHING?
    public var netIncomeFromContinuingOps: DoubleLongValue?
//    public var discontinuedOperations: SOMETHING?
//    public var extraordinaryItems: SOMETHING?
//    public var effectOfAccountingCharges: SOMETHING?
//    public var otherItems: SOMETHING?
    public var netIncome: DoubleLongValue?
    public var netIncomeApplicableToCommonShares: DoubleLongValue?

    enum CodingKeys: String, CodingKey {
        case maxAge = "maxAge"
        case endDate = "endDate"
        case totalRevenue = "totalRevenue"
        case costOfRevenue = "costOfRevenue"
        case grossProfit = "grossProfit"
        case researchDevelopment = "researchDevelopment"
        case sellingGeneralAdministrative = "sellingGeneralAdministrative"
//        case nonRecurring = "nonRecurring"
//        case otherOperatingExpenses = "otherOperatingExpenses"
        case totalOperatingExpenses = "totalOperatingExpenses"
        case operatingIncome = "operatingIncome"
        case totalOtherIncomeExpenseNet = "totalOtherIncomeExpenseNet"
        case ebit = "ebit"
        case interestExpense = "interestExpense"
        case incomeBeforeTax = "incomeBeforeTax"
        case incomeTaxExpense = "incomeTaxExpense"
//        case minorityInterest = "minorityInterest"
        case netIncomeFromContinuingOps = "netIncomeFromContinuingOps"
//        case discontinuedOperations = "discontinuedOperations"
//        case extraordinaryItems = "extraordinaryItems"
//        case effectOfAccountingCharges = "effectOfAccountingCharges"
//        case otherItems = "otherItems"
        case netIncome = "netIncome"
        case netIncomeApplicableToCommonShares = "netIncomeApplicableToCommonShares"
    }
}

// MARK: - IndexTrend
public struct IndexTrend: Codable {
    public var quoteSummary: IndexTrendQuoteSummary?

    enum CodingKeys: String, CodingKey {
        case quoteSummary = "quoteSummary"
    }
}

// MARK: - QuoteSummary
public struct IndexTrendQuoteSummary: Codable {
    public var result: [IndexTrendResult]?
    public var error: YFError?

    enum CodingKeys: String, CodingKey {
        case result = "result"
        case error = "error"
    }
}

// MARK: - Result
public struct IndexTrendResult: Codable {
    public var indexTrend: TrendClass?

    enum CodingKeys: String, CodingKey {
        case indexTrend = "indexTrend"
    }
}

// MARK: - IndexTrendClass
public struct TrendClass: Codable {
    public var maxAge: Int?
    public var symbol: String?
    public var peRatio: DoubleShortValue?
    public var pegRatio: DoubleShortValue?
    public var estimates: [Estimate]?

    enum CodingKeys: String, CodingKey {
        case maxAge = "maxAge"
        case symbol = "symbol"
        case peRatio = "peRatio"
        case pegRatio = "pegRatio"
        case estimates = "estimates"
    }
}

// MARK: - Estimate
public struct Estimate: Codable {
    public var period: String?
    public var growth: DoubleShortValue?

    enum CodingKeys: String, CodingKey {
        case period = "period"
        case growth = "growth"
    }
}


// MARK: - InsiderHoldersClass
public struct HoldersClass: Codable {
    public var holders: [Holder]?
    public var maxAge: Int?

    enum CodingKeys: String, CodingKey {
        case holders = "holders"
        case maxAge = "maxAge"
    }
}

// MARK: - Holder
public struct Holder: Codable {
    public var maxAge: Int?
    public var name: String?
    public var relation: String?
    public var url: String?
    public var transactionDescription: String?
    public var latestTransDate: DoubleShortValue?
    public var positionDirect: DoubleLongValue?
    public var positionDirectDate: DoubleShortValue?
    public var positionIndirect: DoubleLongValue?
    public var positionIndirectDate: DoubleShortValue?

    enum CodingKeys: String, CodingKey {
        case maxAge = "maxAge"
        case name = "name"
        case relation = "relation"
        case url = "url"
        case transactionDescription = "transactionDescription"
        case latestTransDate = "latestTransDate"
        case positionDirect = "positionDirect"
        case positionDirectDate = "positionDirectDate"
        case positionIndirect = "positionIndirect"
        case positionIndirectDate = "positionIndirectDate"
    }
}


// MARK: - InsiderTransactionsClass
public struct InsiderTransactionsClass: Codable {
    public var transactions: [Transaction]?
    public var maxAge: Int?

    enum CodingKeys: String, CodingKey {
        case transactions = "transactions"
        case maxAge = "maxAge"
    }
}

// MARK: - Transaction
public struct Transaction: Codable {
    public var maxAge: Int?
    public var shares: DoubleLongValue?
    public var value: DoubleLongValue?
    public var filerURL: String?
    public var transactionText: String?
    public var filerName: String?
    public var filerRelation: String?
    public var moneyText: String?
    public var startDate: DoubleShortValue?
    public var ownership: String?

    enum CodingKeys: String, CodingKey {
        case maxAge = "maxAge"
        case shares = "shares"
        case value = "value"
        case filerURL = "filerUrl"
        case transactionText = "transactionText"
        case filerName = "filerName"
        case filerRelation = "filerRelation"
        case moneyText = "moneyText"
        case startDate = "startDate"
        case ownership = "ownership"
    }
}


// MARK: - InstitutionOwnershipClass
public struct OwnershipClass: Codable {
    public var maxAge: Int?
    public var ownershipList: [OwnershipList]?

    enum CodingKeys: String, CodingKey {
        case maxAge = "maxAge"
        case ownershipList = "ownershipList"
    }
}

// MARK: - OwnershipList
public struct OwnershipList: Codable {
    public var maxAge: Int?
    public var reportDate: DoubleShortValue?
    public var organization: String?
    public var pctHeld: DoubleShortValue?
    public var position: DoubleLongValue?
    public var value: DoubleLongValue?

    enum CodingKeys: String, CodingKey {
        case maxAge = "maxAge"
        case reportDate = "reportDate"
        case organization = "organization"
        case pctHeld = "pctHeld"
        case position = "position"
        case value = "value"
    }
}


// MARK: - MajorHoldersBreakdownClass
public struct MajorHoldersBreakdownClass: Codable {
    public var maxAge: Int?
    public var insidersPercentHeld: DoubleShortValue?
    public var institutionsPercentHeld: DoubleShortValue?
    public var institutionsFloatPercentHeld: DoubleShortValue?
    public var institutionsCount: DoubleLongValue?

    enum CodingKeys: String, CodingKey {
        case maxAge = "maxAge"
        case insidersPercentHeld = "insidersPercentHeld"
        case institutionsPercentHeld = "institutionsPercentHeld"
        case institutionsFloatPercentHeld = "institutionsFloatPercentHeld"
        case institutionsCount = "institutionsCount"
    }
}


// MARK: - NetSharePurchaseActivityClass
public struct NetSharePurchaseActivityClass: Codable {
    public var maxAge: Int?
    public var period: String?
    public var buyInfoCount: DoubleLongValue?
    public var buyInfoShares: DoubleLongValue?
    public var buyPercentInsiderShares: DoubleShortValue?
    public var sellInfoCount: DoubleLongValue?
    public var sellInfoShares: DoubleLongValue?
    public var sellPercentInsiderShares: DoubleShortValue?
    public var netInfoCount: DoubleLongValue?
    public var netInfoShares: DoubleLongValue?
    public var netPercentInsiderShares: DoubleShortValue?
    public var totalInsiderShares: DoubleLongValue?

    enum CodingKeys: String, CodingKey {
        case maxAge = "maxAge"
        case period = "period"
        case buyInfoCount = "buyInfoCount"
        case buyInfoShares = "buyInfoShares"
        case buyPercentInsiderShares = "buyPercentInsiderShares"
        case sellInfoCount = "sellInfoCount"
        case sellInfoShares = "sellInfoShares"
        case sellPercentInsiderShares = "sellPercentInsiderShares"
        case netInfoCount = "netInfoCount"
        case netInfoShares = "netInfoShares"
        case netPercentInsiderShares = "netPercentInsiderShares"
        case totalInsiderShares = "totalInsiderShares"
    }
}


// MARK: - RecommendationTrendClass
public struct RecommendationTrendClass: Codable {
    public var trend: [RecommendationTrendTrend]?
    public var maxAge: Int?

    enum CodingKeys: String, CodingKey {
        case trend = "trend"
        case maxAge = "maxAge"
    }
}

// MARK: - Trend
public struct RecommendationTrendTrend: Codable {
    public var period: String?
    public var strongBuy: Int?
    public var buy: Int?
    public var hold: Int?
    public var sell: Int?
    public var strongSell: Int?

    enum CodingKeys: String, CodingKey {
        case period = "period"
        case strongBuy = "strongBuy"
        case buy = "buy"
        case hold = "hold"
        case sell = "sell"
        case strongSell = "strongSell"
    }
}


// MARK: - SecFilingsClass
public struct SecFilingsClass: Codable {
    public var filings: [Filing]?
    public var maxAge: Int?

    enum CodingKeys: String, CodingKey {
        case filings = "filings"
        case maxAge = "maxAge"
    }
}

// MARK: - Filing
public struct Filing: Codable {
    public var date: String?
    public var epochDate: Int?
    public var type: String?
    public var title: String?
    public var url: String?
    public var edgarURL: String?
    public var maxAge: Int?

    enum CodingKeys: String, CodingKey {
        case date = "date"
        case epochDate = "epochDate"
        case type = "type"
        case title = "title"
        case url = "url"
        case edgarURL = "edgarUrl"
        case maxAge = "maxAge"
    }
}


// MARK: - UpgradeDowngradeHistoryClass
public struct UpgradeDowngradeHistoryClass: Codable {
    public var history: [History]?
    public var maxAge: Int?

    enum CodingKeys: String, CodingKey {
        case history = "history"
        case maxAge = "maxAge"
    }
}

// MARK: - History
public struct History: Codable {
    public var epochGradeDate: Int?
    public var firm: String?
    public var toGrade: String?
    public var fromGrade: String?
    public var action: String?

    enum CodingKeys: String, CodingKey {
        case epochGradeDate = "epochGradeDate"
        case firm = "firm"
        case toGrade = "toGrade"
        case fromGrade = "fromGrade"
        case action = "action"
    }

}

// MARK: - DoubleLongValue
public struct DoubleLongValue: Codable {
    public var raw: Double?
    public var fmt: String?
    public var longFmt: String?

    enum CodingKeys: String, CodingKey {
        case raw = "raw"
        case fmt = "fmt"
        case longFmt = "longFmt"
    }

}

// MARK: - DoubleShortValue
public struct DoubleShortValue: Codable {
    public var raw: Double?
    public var fmt: String?

    enum CodingKeys: String, CodingKey {
        case raw = "raw"
        case fmt = "fmt"
    }
}


// MARK: - Encode/decode helpers

public class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public func hash(into hasher: inout Hasher) {
        // No-op
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
