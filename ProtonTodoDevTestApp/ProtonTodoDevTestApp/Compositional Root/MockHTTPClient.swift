//
//  MockHTTPClient.swift
//  ProtonTodoDevTestApp
//
//  Created by Fenominall on 2/8/25.
//

import Foundation
import ProtonTodoDevTest

let mockJSONString = """
{
  "tasks": [
    {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "title": "Buy Groceries",
      "description": "Milk, Bread, Eggs, Butter",
      "completed": false,
      "createdAt": "2025-02-06T12:00:00Z",
      "dueDate": "2025-02-10T12:00:00Z",
      "imageURL": "https://images.unsplash.com/photo-1738168246881-40f35f8aba0a?q=80&w=3028&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    },
    {
      "id": "660e8400-e29b-41d4-a716-446655440001",
      "title": "Go to the Gym",
      "description": "Workout session at 6 PM",
      "completed": true,
      "createdAt": "2025-02-05T08:00:00Z",
      "dueDate": "2025-02-07T18:00:00Z",
      "imageURL": "https://images.unsplash.com/photo-1738941329663-4401102e9dab?q=80&w=2980&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    },
    {
      "id": "770e8400-e29b-41d4-a716-446655440002",
      "title": "Finish Project Report",
      "description": "Prepare and submit the final report",
      "completed": false,
      "createdAt": "2025-02-01T09:30:00Z",
      "dueDate": "2025-02-08T12:00:00Z",
      "imageURL": "https://images.unsplash.com/photo-1738940251292-49709608c8aa?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    },
    {
      "id": "880e8400-e29b-41d4-a716-446655440003",
      "title": "Doctor Appointment",
      "description": "Check-up at 10 AM",
      "completed": false,
      "createdAt": "2025-02-04T14:45:00Z",
      "dueDate": "2025-02-06T10:00:00Z",
      "imageURL": "https://images.unsplash.com/photo-1738694237335-a537515c0b7b?q=80&w=2942&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    },
    {
      "id": "990e8400-e29b-41d4-a716-446655440004",
      "title": "Read a Book",
      "description": "Finish reading 'Atomic Habits'",
      "completed": false,
      "createdAt": "2025-02-02T20:15:00Z",
      "dueDate": "2025-02-09T22:00:00Z",
      "imageURL": "https://images.unsplash.com/photo-1738878524656-44ac4654826e?q=80&w=3174&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    },
    {
      "id": "AA0e8400-e29b-41d4-a716-446655440005",
      "title": "Team Meeting",
      "description": "Weekly sync-up at 3 PM",
      "completed": true,
      "createdAt": "2025-02-03T07:00:00Z",
      "dueDate": "2025-02-05T15:00:00Z",
      "imageURL": "https://images.unsplash.com/photo-1738830656378-c8f96e01ec50?q=80&w=3000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    },
    {
      "id": "BB0e8400-e29b-41d4-a716-446655440006",
      "title": "Laundry Day",
      "description": "Wash and fold clothes",
      "completed": false,
      "createdAt": "2025-02-06T10:30:00Z",
      "dueDate": "2025-02-07T18:00:00Z",
      "imageURL": "https://images.unsplash.com/photo-1738830986230-57029d6ef4f8?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    },
    {
      "id": "CC0e8400-e29b-41d4-a716-446655440007",
      "title": "Grocery Shopping",
      "description": "Buy vegetables, fruits, and snacks",
      "completed": true,
      "createdAt": "2025-02-05T16:10:00Z",
      "dueDate": "2025-02-06T20:00:00Z",
      "imageURL": "https://images.unsplash.com/photo-1738762389087-35bcc2b03b2d?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    },
    {
      "id": "DD0e8400-e29b-41d4-a716-446655440008",
      "title": "Call Parents",
      "description": "Check in with Mom and Dad",
      "completed": false,
      "createdAt": "2025-02-07T11:25:00Z",
      "dueDate": "2025-02-08T19:00:00Z",
      "imageURL": "https://images.unsplash.com/photo-1735908235870-f4dd182a2f12?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    },
    {
      "id": "EE0e8400-e29b-41d4-a716-446655440009",
      "title": "Car Service",
      "description": "Oil change and tire check",
      "completed": false,
      "createdAt": "2025-02-03T14:00:00Z",
      "dueDate": "2025-02-10T16:30:00Z",
      "imageURL": "https://images.unsplash.com/photo-1736354485341-d165463e0133?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    }
  ]
}
"""

final class MockHTTPClient: HTTPClient {
    private let data: Data
    private let statusCode: Int
    
    init(data: Data, statusCode: Int) {
        self.data = data
        self.statusCode = statusCode
    }
    
    func get(from url: URL) async throws -> HTTPResult {
        let response = HTTPURLResponse(
            url: url,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
        return (data, response)
    }
}


