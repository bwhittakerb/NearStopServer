# NearStopServer

A Vapor webserver that's definitely minimum viable.

Runs on port 8080 by default (I developed it behind a reverse proxy).

I have never done compiled OO programming or web service programming before so please keep that in mind.

Example usage:

`http://ets.bramblers.ca/api/nearstops?latitude=53.54077042545684&longitude=-113.50812525829596`

From coordinates 53.54077042545684, -113.50812525829596 (which are Downtown Edmonton at the intersection of Jasper and 109th)

It requires my SwiftGTFS project as a dependency.

## TODOs
- Write out request time and datestamp in log/console for each request (although I don't want to track personal info like geolocation)
- Implement optional parameters in get request to change radius of bus stop search and time window.