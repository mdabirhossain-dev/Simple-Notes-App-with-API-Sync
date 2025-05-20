
        Simple-Notes-App-with-API-Sync

Notes App completed.

**User Installation Guideline**
1. First, clone the repository using the link "https://github.com/mdabirhossain-dev/Simple-Notes-App-with-API-Sync.git"
2. Buld the project in Xcode and run in the real iPhone or Simulator.

**No external or 3rd party library used**
**Used CoreData to store the Notes**
**XCTest is added for unit testing(all test cases passed)**

**App use Procedures**
1. After opening/running the app top left side 'Sync' button needs to be tapped to fetch the data.
2. In the bottom of the screen last sync time will be visible. But it will not show any time when app is launched and the data is not fetched yet.
3. When 'Sync' button is tapped a loader will be visible and after successfully fetching the data it will show 'Synced!'.
4. On the top right side of the screen '+' button is added to add new Note.
5. On each note there is a 'Edit' Button added to edit the existing note.
6. Swiping each note from right to left will make visible the 'Delete' button. Tapping on delete button will delete the note.
7. Each sync only new notes fetched from the API will be saved to CoreData. Already fetched note from API and edited later will stay same.
8. Newly added notes will be listed at the bottom of the screen. And notes can be added only if both 'Title' and 'Body' field is not empty or something is written. If any field is empty 'Save' button will be faded and the save action is disabled.



**Md Abir Hossain**, 
**iOS Developer**, 
**mdabirhossain.dev@gmail.com**
