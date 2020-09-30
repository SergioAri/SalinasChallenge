//
//  SalinasChallengeTests.swift
//  SalinasChallengeTests
//
//  Created by Sergio Arizaga on 29/09/20.
//

import XCTest

class SalinasChallengeTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // ShowsViewController.swift, ShowDetailViewController
    
    func testFindShowInFavorites() throws {
        let id = "123"
        let favorites = ["562","121","456","123"]
        var counter = 0
        var favoriteIndex = 0
        for favorite in favorites {
            if favorite == id {
                favoriteIndex = counter
            }
            counter += 1
        }
        XCTAssertEqual(favoriteIndex, 3, "favoriteIndex should be 3")
    }

    // ShowsManager.swift
    
    func testFetchShowsData(completion: @escaping ([Dictionary<String, Any>]?, Error?) -> Void) throws {
        let url = URL(string: "http://api.tvmaze.com/shows")!
        measure {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    self.measure {
                        do {
                            if let array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Dictionary<String, Any>]{                            completion(array, nil)
                            }
                        } catch {
                            XCTAssertNil(error)
                            print(error)
                            completion(nil, error)
                        }
                    }
                } else {
                    XCTAssertNil(error)
                    completion(nil, error)
                }
            }
            task.resume()
        }
    }
    
    // ShowsViewController.swift
    
    func testGetImageFromUrl() throws {
        measure {
           URLSession.shared.dataTask( with: NSURL(string:"http://static.tvmaze.com/uploads/images/original_untouched/81/202627.jpg")! as URL, completionHandler: { (data, response, error) -> Void in
              DispatchQueue.main.async {
                XCTAssert(data != nil)
              }
           }).resume()
        }
    }

}
