import Vapor
import SwiftGTFS

extension StopArrivals: Content {}

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

    // 1
app.get("hello", ":name") { req async throws -> String in
    // 2
    let name = try req.parameters.require("name")
    // 3
    return "Hello, \(name.capitalized)!"
}

// 1
app.get("json", ":name") { req async throws -> UserResponse in
    // 2
    let name = try req.parameters.require("name")
    let message = "Hello, \(name.capitalized)!"
    // 3
    return UserResponse(message: message)
}

app.get("api", "nearstops") { req async throws -> [StopArrivals] in
    do {
        let queryParameters = try req.query.decode(BusStopRequest.self)

        let stopResults = NearbyBusses.retrieveStops(location: Coordinates(lat: queryParameters.latitude, long: queryParameters.longitude))

        let arrivalsResults = NearbyBusses.retrieveRecentArrivalsByStop(stops: stopResults, arrivalThresholdInHours: 1)

        // let encoder = JSONEncoder()
        // encoder.dateEncodingStrategy = .iso8601 // Set the date encoding strategy to ISO 8601 format
        // if let encodedData = try? encoder.encode(arrivalsResults),
        // let jsonString = String(data: encodedData, encoding: .utf8) {
        //     print(jsonString)




        return arrivalsResults
    } catch {
        req.logger.error("Failed to decode UserInfo from query: \(error.localizedDescription)")
        throw Abort(.badRequest, reason: "Failed to decode parameters. Error: \(error.localizedDescription)")
    }
}

// 1
app.post("user-info") { req async throws -> UserResponse in
    // 2
    let userInfo = try req.content.decode(UserInfo.self)
    // 3
    let message = "Hello, \(userInfo.name.capitalized)! You are \(userInfo.age) years old."
    return UserResponse(message: message)
}

}

struct UserResponse: Content {
    let message: String
}

struct UserInfo: Content {
    let name: String
    let age: Int
}

struct BusStopRequest: Content {
    let latitude: Double
    let longitude: Double
}

