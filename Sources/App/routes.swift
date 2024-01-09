import Vapor
import SwiftGTFS

extension StopArrivals: Content {}

func routes(_ app: Application) throws {

    //some basic heartbeat stuff in the sample
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

    //the actual interesting endpoint
    app.get("api", "nearstops") { req async throws -> [StopArrivals] in
        do {
            let queryParameters = try req.query.decode(BusStopRequest.self)

            let stopResults = NearbyBusses.retrieveStops(location: Coordinates(lat: queryParameters.latitude, long: queryParameters.longitude))

            let arrivalsResults = NearbyBusses.retrieveRecentArrivalsByStop(stops: stopResults, arrivalThresholdInHours: 1)

            // I sorta wonder if I should be providing datetime serialized strings in the JSON
            // object in the local date format of Edmonton.

            return arrivalsResults
        } catch {
            req.logger.error("Failed to decode UserInfo from query: \(error.localizedDescription)")
            throw Abort(.badRequest, reason: "Failed to decode parameters. Error: \(error.localizedDescription)")
        }
    }


    app.post("user-info") { req async throws -> UserResponse in
        let userInfo = try req.content.decode(UserInfo.self)
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

