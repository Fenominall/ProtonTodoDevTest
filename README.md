# ProtonTodoDevTest

## Requirements
- Tasks data should be downloaded and stored for offline use.
- A task status (Done, Todo) must be added and persisted locally.
- Some tasks may have prerequisite tasks (dependencies), to finish before starting it.
- The main screen displays two task lists:
  - All tasks: must be ordered by creation date.
  - Upcoming tasks: must be ordered according to task dependencies.
- The main screen lets the user change a task status to Done, persisted locally.
- It should not be possible to change a task status to Done if dependencies are not met.
- The upcoming tasks list only displays the tasks in Todo status.
- All data that is encrypted in the API response should also be encrypted when stored locally.
- Decryption should be performed on the fly when presenting data to the user.
- Business and presentation logic should be tested.

## Design Document
[Design.pdf](./Design.pdf)
