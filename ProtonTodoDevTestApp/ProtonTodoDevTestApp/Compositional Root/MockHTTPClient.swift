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
      "imageURL": "https://images.ctfassets.net/f7l5sefbt57k/5qtjdCxnDwJ1drPVMkwBpf/410b1e7193b8f488d0d3fe2e5b65a0ce/Default_A_pair_of_hands_their_fingers_dancing_skillfully_acro_1.jpg"
    },
    {
      "id": "660e8400-e29b-41d4-a716-446655440001",
      "title": "Go to the Gym",
      "description": "Workout session at 6 PM",
      "completed": true,
      "createdAt": "2025-02-05T08:00:00Z",
      "dueDate": "2025-02-07T18:00:00Z",
      "imageURL": "https://s.yimg.com/ny/api/res/1.2/JZqyCklnD.41dRADG.VkAg--/YXBwaWQ9aGlnaGxhbmRlcjt3PTEyNDI7aD04Mjg7Y2Y9d2VicA--/https://media.zenfs.com/en/afp.co.uk/0d65ca9502dba95e03653a6d345740c6"
    },
    {
      "id": "770e8400-e29b-41d4-a716-446655440002",
      "title": "Finish Project Report",
      "description": "Prepare and submit the final report",
      "completed": false,
      "createdAt": "2025-02-01T09:30:00Z",
      "dueDate": "2025-02-08T12:00:00Z",
      "imageURL": "https://s.yimg.com/ny/api/res/1.2/JZqyCklnD.41dRADG.VkAg--/YXBwaWQ9aGlnaGxhbmRlcjt3PTEyNDI7aD04Mjg7Y2Y9d2VicA--/https://media.zenfs.com/en/afp.co.uk/0d65ca9502dba95e03653a6d345740c6"
    },
    {
      "id": "880e8400-e29b-41d4-a716-446655440003",
      "title": "Doctor Appointment",
      "description": "Check-up at 10 AM",
      "completed": false,
      "createdAt": "2025-02-04T14:45:00Z",
      "dueDate": "2025-02-06T10:00:00Z",
      "imageURL": "https://s.yimg.com/ny/api/res/1.2/JZqyCklnD.41dRADG.VkAg--/YXBwaWQ9aGlnaGxhbmRlcjt3PTEyNDI7aD04Mjg7Y2Y9d2VicA--/https://media.zenfs.com/en/afp.co.uk/0d65ca9502dba95e03653a6d345740c6"
    },
    {
      "id": "990e8400-e29b-41d4-a716-446655440004",
      "title": "Read a Book",
      "description": "Finish reading 'Atomic Habits'",
      "completed": false,
      "createdAt": "2025-02-02T20:15:00Z",
      "dueDate": "2025-02-09T22:00:00Z",
      "imageURL": "https://s.yimg.com/ny/api/res/1.2/JZqyCklnD.41dRADG.VkAg--/YXBwaWQ9aGlnaGxhbmRlcjt3PTEyNDI7aD04Mjg7Y2Y9d2VicA--/https://media.zenfs.com/en/afp.co.uk/0d65ca9502dba95e03653a6d345740c6"
    },
    {
      "id": "AA0e8400-e29b-41d4-a716-446655440005",
      "title": "Team Meeting",
      "description": "Weekly sync-up at 3 PM",
      "completed": true,
      "createdAt": "2025-02-03T07:00:00Z",
      "dueDate": "2025-02-05T15:00:00Z",
      "imageURL": "https://s.yimg.com/ny/api/res/1.2/JZqyCklnD.41dRADG.VkAg--/YXBwaWQ9aGlnaGxhbmRlcjt3PTEyNDI7aD04Mjg7Y2Y9d2VicA--/https://media.zenfs.com/en/afp.co.uk/0d65ca9502dba95e03653a6d345740c6"
    },
    {
      "id": "BB0e8400-e29b-41d4-a716-446655440006",
      "title": "Laundry Day",
      "description": "Wash and fold clothes",
      "completed": false,
      "createdAt": "2025-02-06T10:30:00Z",
      "dueDate": "2025-02-07T18:00:00Z",
      "imageURL": "https://s.yimg.com/ny/api/res/1.2/JZqyCklnD.41dRADG.VkAg--/YXBwaWQ9aGlnaGxhbmRlcjt3PTEyNDI7aD04Mjg7Y2Y9d2VicA--/https://media.zenfs.com/en/afp.co.uk/0d65ca9502dba95e03653a6d345740c6"
    },
    {
      "id": "CC0e8400-e29b-41d4-a716-446655440007",
      "title": "Grocery Shopping",
      "description": "Buy vegetables, fruits, and snacks",
      "completed": true,
      "createdAt": "2025-02-05T16:10:00Z",
      "dueDate": "2025-02-06T20:00:00Z",
      "imageURL": "https://s.yimg.com/ny/api/res/1.2/JZqyCklnD.41dRADG.VkAg--/YXBwaWQ9aGlnaGxhbmRlcjt3PTEyNDI7aD04Mjg7Y2Y9d2VicA--/https://media.zenfs.com/en/afp.co.uk/0d65ca9502dba95e03653a6d345740c6"
    },
    {
      "id": "DD0e8400-e29b-41d4-a716-446655440008",
      "title": "Call Parents",
      "description": "Check in with Mom and Dad",
      "completed": false,
      "createdAt": "2025-02-07T11:25:00Z",
      "dueDate": "2025-02-08T19:00:00Z",
      "imageURL": "https://s.yimg.com/ny/api/res/1.2/JZqyCklnD.41dRADG.VkAg--/YXBwaWQ9aGlnaGxhbmRlcjt3PTEyNDI7aD04Mjg7Y2Y9d2VicA--/https://media.zenfs.com/en/afp.co.uk/0d65ca9502dba95e03653a6d345740c6"
    },
    {
      "id": "EE0e8400-e29b-41d4-a716-446655440009",
      "title": "Car Service",
      "description": "Oil change and tire check",
      "completed": false,
      "createdAt": "2025-02-03T14:00:00Z",
      "dueDate": "2025-02-10T16:30:00Z",
      "imageURL": "https://s.yimg.com/ny/api/res/1.2/JZqyCklnD.41dRADG.VkAg--/YXBwaWQ9aGlnaGxhbmRlcjt3PTEyNDI7aD04Mjg7Y2Y9d2VicA--/https://media.zenfs.com/en/afp.co.uk/0d65ca9502dba95e03653a6d345740c6"
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


