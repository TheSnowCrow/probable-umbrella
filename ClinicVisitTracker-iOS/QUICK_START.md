# Quick Start Guide

Get your Clinic Visit Tracker iOS app running in minutes!

## What You'll Need

- **Mac** with macOS Ventura or later
- **Xcode 14+** (free from Mac App Store)
- **iPhone/iPad** running iOS 16.0+ (or use Simulator)

## Step 1: Install Xcode

1. Open **Mac App Store**
2. Search for "Xcode"
3. Click **Get** or **Install**
4. Wait for download (8-12 GB, takes 30-60 minutes)

## Step 2: Open the Project

### Option A: Create Xcode Project File (Required)

Since this is a code-only repository, you need to create an Xcode project:

1. Open **Xcode**
2. Click **Create a new Xcode project**
3. Choose **iOS** → **App**
4. Configure project:
   - Product Name: `ClinicVisitTracker`
   - Team: Select your Apple ID
   - Organization Identifier: `com.yourname` (or company domain reversed)
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Storage: **Core Data**
   - Include Tests: ✓ (optional)
5. Click **Next**
6. Save location: Choose a temporary folder
7. Click **Create**

### Option B: Add Files to Xcode Project

1. In Xcode Navigator (left sidebar), right-click on `ClinicVisitTracker` folder
2. Select **Add Files to "ClinicVisitTracker"...**
3. Navigate to your downloaded repository folder
4. Select the `ClinicVisitTracker-iOS/ClinicVisitTracker` folder
5. Choose:
   - **Copy items if needed**: ✓
   - **Create groups**: Selected
   - **Add to targets**: ✓ ClinicVisitTracker
6. Click **Add**

### Option C: Manual File Addition

Copy each file from the repository to your Xcode project:

**Core Files:**
```
ClinicVisitTrackerApp.swift → Root folder
ContentView.swift → Root folder
Info.plist → Root folder
```

**Models:**
```
All files from Models/ → Create "Models" group in Xcode
```

**Views:**
```
All files from Views/ → Create "Views" group in Xcode
```

**ViewModels:**
```
All files from ViewModels/ → Create "ViewModels" group
```

**Services:**
```
All files from Services/ → Create "Services" group
```

**Utilities:**
```
All files from Utilities/ → Create "Utilities" group
```

## Step 3: Configure Core Data Model

1. Delete the auto-generated `.xcdatamodeld` file in Xcode
2. Drag the `CoreDataModel.xcdatamodeld` file from repository into Xcode
3. Make sure it's added to the target

## Step 4: Build and Run

1. Select target device:
   - Click device selector (top-left, near Play button)
   - Choose **iPhone 15 Pro** (or any iOS 16+ simulator)
   - Or select your real iPhone if connected

2. Click **Build and Run** (▶️ button) or press **Cmd+R**

3. Wait for build:
   - First build: 30-60 seconds
   - Subsequent builds: 5-10 seconds

4. App launches in Simulator!

## Step 5: Test Key Features

### Test Timer

1. Tap **Timer** tab (bottom)
2. Tap **Start** button
3. Watch timer count up
4. Tap **Pause** (timer stops)
5. Tap **Resume** (timer continues)
6. Tap **End**

### Complete a Visit

1. After ending timer, visit form appears
2. Select **Visit Type**: Sick/Well/Both
3. Tap billing codes (buttons turn blue when selected)
4. Add comments (optional)
5. Tap **Save**

### View Daily Summary

1. Tap **Daily** tab
2. See today's statistics
3. Scroll to see visit list
4. Use date picker to view other days

### Explore Dashboard

1. Tap **Dashboard** tab
2. See charts (pie, bar, line)
3. Change time period (segmented control at top)
4. View totals and averages

### Create Custom Field

1. Tap **Settings** tab
2. Scroll to **Custom Fields** section
3. Tap **Add Custom Field**
4. Enter name: "Patient Age"
5. Select type: **Number**
6. Tap **Save**
7. Now appears on visit forms!

### Create QI Project

1. Tap **QI Projects** tab
2. Tap **+** button
3. Enter project name: "Asthma Action Plans"
4. Add description (optional)
5. Tap **Add Variable**
6. Create variable: "Plan Given" (dropdown)
7. Add options: "Yes", "No"
8. Tap **Save** → **Save**
9. Tap project to view
10. Tap **+** to add data entries

## Common Issues & Solutions

### Issue: "Failed to build"

**Solution:**
1. Clean build folder: **Product** → **Clean Build Folder** (Shift+Cmd+K)
2. Close and reopen Xcode
3. Rebuild (Cmd+B)

### Issue: "No such module 'CoreData'"

**Solution:**
CoreData is built-in, but if error persists:
1. Select project in Navigator
2. Go to **Build Phases** tab
3. Expand **Link Binary With Libraries**
4. Click **+** → Add **CoreData.framework**

### Issue: Core Data model not found

**Solution:**
1. Ensure `.xcdatamodeld` file is in project
2. Check **Target Membership** (right sidebar)
3. Make sure `ClinicVisitTracker` target is checked

### Issue: "Signing for 'ClinicVisitTracker' requires a development team"

**Solution:**
1. Select project in Navigator
2. Select **ClinicVisitTracker** target
3. Go to **Signing & Capabilities** tab
4. Select your **Team** (Apple ID)
5. Or sign in: **Xcode** → **Preferences** → **Accounts** → **+**

### Issue: Dark theme not showing

**Solution:**
Simulator should auto-apply dark mode. If not:
1. In Simulator: **Settings** → **Developer**
2. Toggle **Dark Appearance**
Or force in code (already set in `ClinicVisitTrackerApp.swift`):
```swift
.preferredColorScheme(.dark)
```

### Issue: App crashes on launch

**Check Console:**
1. View → **Debug Area** → **Show Debug Area** (Cmd+Shift+Y)
2. Look for error messages
3. Common issue: Core Data model mismatch

**Solution:**
1. Delete app from Simulator
2. Clean build folder
3. Rebuild and run

## Running on Real iPhone

### Requirements

- **Apple Developer account** (free or paid)
- **Lightning/USB-C cable** to connect iPhone

### Steps

1. Connect iPhone to Mac
2. Trust computer on iPhone (popup appears)
3. In Xcode, select your iPhone from device list
4. Ensure **Signing & Capabilities** has your Team selected
5. Click **Run** (▶️)
6. On iPhone, go to **Settings** → **General** → **VPN & Device Management**
7. Trust your developer certificate
8. Return to home screen, tap app icon

## Next Steps

### Customize the App

1. **Change App Name**: Edit `CFBundleDisplayName` in Info.plist
2. **Add App Icon**: Drag 1024x1024 PNG to Assets.xcassets → AppIcon
3. **Adjust wRVU Rates**: Modify values in `WRVULookup.swift`
4. **Add Billing Codes**: Extend `allCodes` array in `WRVULookup.swift`
5. **Customize Colors**: Edit accent color in ContentView.swift

### Learn More

- **SwiftUI Basics**: https://developer.apple.com/tutorials/swiftui
- **Core Data Guide**: https://developer.apple.com/documentation/coredata
- **Xcode Help**: **Help** → **Xcode Help** in menu bar

### Prepare for App Store

See **APP_STORE_GUIDE.md** for complete submission instructions.

### Get Help

- **Apple Forums**: https://developer.apple.com/forums/
- **Stack Overflow**: Tag questions with `ios`, `swift`, `swiftui`
- **Project Issues**: Check IMPLEMENTATION_NOTES.md

## Tips for Development

### Keyboard Shortcuts

- **Build**: Cmd+B
- **Run**: Cmd+R
- **Stop**: Cmd+.
- **Clean**: Shift+Cmd+K
- **Find**: Cmd+F
- **Find in Project**: Shift+Cmd+F

### Xcode Interface

- **Navigator** (left): Project files
- **Editor** (center): Code editing
- **Inspector** (right): File/view properties
- **Debug Area** (bottom): Console and variables

### Useful Xcode Features

- **Canvas Preview**: Click Resume (▶️) button in Canvas to see live preview
- **Scheme Editor**: Configure build settings
- **Breakpoints**: Click line number to add breakpoint for debugging
- **Instruments**: Profile performance (Product → Profile)

### SwiftUI Previews

Each view has a preview at bottom:
```swift
#Preview {
    DashboardView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
```

Enable Canvas: **Editor** → **Canvas** (Cmd+Option+Enter)

## Project File Structure

After setup, your project should look like:

```
ClinicVisitTracker/
├── ClinicVisitTrackerApp.swift
├── ContentView.swift
├── Models/
│   ├── CoreDataModel.xcdatamodeld
│   ├── Visit+CoreDataClass.swift
│   ├── Visit+CoreDataProperties.swift
│   ├── CustomField+CoreDataClass.swift
│   ├── CustomField+CoreDataProperties.swift
│   ├── QIProject+CoreDataClass.swift
│   ├── QIProject+CoreDataProperties.swift
│   ├── QIProjectEntry+CoreDataClass.swift
│   └── QIProjectEntry+CoreDataProperties.swift
├── Views/
│   ├── EncountersView.swift
│   ├── VisitFormView.swift
│   ├── ManualEntryView.swift
│   ├── DailySummaryView.swift
│   ├── DashboardView.swift
│   ├── QIProjectsView.swift
│   └── SettingsView.swift
├── ViewModels/
│   └── TimerViewModel.swift
├── Services/
│   ├── PersistenceController.swift
│   └── SettingsManager.swift
├── Utilities/
│   ├── WRVULookup.swift
│   └── BibleVerses.swift
├── Resources/
│   └── Assets.xcassets
└── Info.plist
```

---

## You're All Set! 🎉

You now have a fully functional clinic visit tracker running on iOS!

Start tracking visits, explore the features, and customize to fit your workflow.

**Questions?** Check the other documentation files or Apple's developer resources.

**Happy tracking! 📱⏱️**
