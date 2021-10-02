//
//  XNoteUITests.swift
//  XNoteUITests
//
//  Created by ilya bolotov on 02.10.2021.
//  Copyright © 2021 Ilya Bolotov. All rights reserved.
//

import XCTest

class XNoteUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    //Test on default note
    func testExample() throws {
        app.tables.element(boundBy: 0).cells.element(boundBy: 0).tap()
        let textView = app.textViews["textViewContent"]
        XCTAssertEqual("Супер\nтестовое\nзадание!\n", textView.value as? String)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
