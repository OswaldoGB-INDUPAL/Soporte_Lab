import XCTest

final class SoporteLabUITests: XCTestCase {
    private func capture(_ name: String) {
        let attachment = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    func test_recorridoPrincipal() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-inMemory"]
        app.launch()
        XCTAssertTrue(app.navigationBars["Tickets"].waitForExistence(timeout: 20))
        capture("01-tickets")

        let ticket = app.staticTexts["Proyector no enciende"].firstMatch
        XCTAssertTrue(ticket.waitForExistence(timeout: 10))
        ticket.tap()
        XCTAssertTrue(app.navigationBars["Detalle"].waitForExistence(timeout: 5))
        capture("02-detalle")

        app.buttons["Editar"].tap()
        XCTAssertTrue(app.navigationBars["Editar ticket"].waitForExistence(timeout: 5))
        capture("03-formulario-ticket")
        app.buttons["Cancelar"].tap()
        app.navigationBars.buttons.element(boundBy: 0).tap()

        app.tabBars.buttons["Técnicos"].tap()
        XCTAssertTrue(app.navigationBars["Técnicos"].waitForExistence(timeout: 5))
        capture("04-tecnicos")
        app.buttons["Nuevo técnico"].tap()
        XCTAssertTrue(app.navigationBars["Nuevo técnico"].waitForExistence(timeout: 5))
        capture("05-formulario-tecnico")
        app.buttons["Cancelar"].tap()

        app.tabBars.buttons["Resumen"].tap()
        XCTAssertTrue(app.navigationBars["Resumen"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["10 tickets registrados"].waitForExistence(timeout: 5))
        capture("06-resumen")
    }
}
