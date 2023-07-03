//
//  SweetTreatsTests.swift
//  SweetTreatsTests
//
//  Created by Zach Tarvin on 7/1/23.
//

import XCTest
@testable import SweetTreats

final class SweetTreatsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testMealFetchCall() throws{
        let realCategory = "Desserts"
        let fakeCategory = "Bottles"
        
        Task{
            do{
                let realResults = try await NetworkManager.shared.fetchMeals(with: realCategory)
                let fakeResults = try await NetworkManager.shared.fetchMeals(with: fakeCategory)
                XCTAssert(realResults.count > 0 && fakeResults.count == 0)
            }catch{
                print("✨ Yo \(error)")
            }
        }
    }
    
    func testImageCache(){
        Task{
            let meal = Meal.preview
            let mealModel = MealViewModel(meal: meal)
            
            XCTAssertNil(mealModel.cachedImageData)
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
