# Clinic Visit Tracker - iOS App

A native iOS application for pediatricians to track clinic visits in real-time, measure productivity through wRVU calculations, and maintain billing consistency.

## Features

### 📱 Core Functionality

- **Real-Time Timer** with pause/resume capability
- **Billing Code Selection** with 27 CPT codes and wRVU lookup
- **Visit Tracking** for sick, well, and combination visits
- **Daily Summary** with comprehensive statistics
- **Dashboard Analytics** with interactive charts
- **Custom Fields** for flexible data collection
- **QI Project Tracker** for quality improvement initiatives
- **Bible Verses** for daily inspiration

### 💰 Financial Tracking

- Automatic wRVU calculations for all billing codes
- Configurable wRVU-to-dollar conversion rate
- Privacy-focused money display toggle
- Real-time value calculations

### 📊 Analytics & Reporting

- Visit type distribution (pie charts)
- Billing code distribution (bar charts)
- Visits over time (line charts)
- Day-of-week analysis
- Custom date range filtering

### 🎨 Design

- Native iOS dark theme
- SwiftUI modern interface
- iOS design patterns and conventions
- Optimized for iPhone and iPad
- Landscape and portrait support

## Requirements

- **iOS 16.0** or later
- **Xcode 14.0** or later
- **Swift 5.7** or later

## Installation

### Opening in Xcode

1. Open `ClinicVisitTracker.xcodeproj` in Xcode
2. Select your development team in Signing & Capabilities
3. Choose your target device or simulator
4. Build and run (Cmd+R)

### Building for Release

1. Archive the app: Product > Archive
2. Distribute to App Store or TestFlight
3. Follow Apple's App Store submission guidelines

## Project Structure

```
ClinicVisitTracker/
├── ClinicVisitTrackerApp.swift      # App entry point
├── ContentView.swift                # Main tab navigation
├── Models/                          # Core Data entities
│   ├── CoreDataModel.xcdatamodeld  # Data model definition
│   ├── Visit+CoreData*.swift       # Visit entity
│   ├── CustomField+CoreData*.swift # Custom field entity
│   ├── QIProject+CoreData*.swift   # QI project entity
│   └── QIProjectEntry+CoreData*.swift
├── Views/                           # SwiftUI views
│   ├── EncountersView.swift        # Timer & manual entry
│   ├── VisitFormView.swift         # Visit completion form
│   ├── ManualEntryView.swift       # Manual visit entry
│   ├── DailySummaryView.swift      # Daily statistics
│   ├── DashboardView.swift         # Charts & analytics
│   ├── QIProjectsView.swift        # QI project tracker
│   └── SettingsView.swift          # App settings
├── ViewModels/                      # View models
│   └── TimerViewModel.swift        # Timer state management
├── Services/                        # Business logic
│   ├── PersistenceController.swift # Core Data stack
│   └── SettingsManager.swift       # User preferences
├── Utilities/                       # Helper classes
│   ├── WRVULookup.swift            # Billing code lookup
│   └── BibleVerses.swift           # Inspirational verses
└── Resources/                       # Assets & configs
    └── Info.plist                  # App configuration
```

## Core Data Schema

### Visit Entity

- `id` (UUID): Unique identifier
- `date` (Date): Visit date
- `startTime` (Date?): Start timestamp
- `endTime` (Date?): End timestamp
- `activeDuration` (Int32): Active seconds (excludes paused time)
- `visitType` (String): "Sick", "Well", or "Both"
- `billingCodes` (String): JSON array of CPT codes
- `comments` (String?): Visit notes
- `customFieldsData` (String?): JSON of custom field values
- `dayOfWeek` (String?): Day name
- `wrvu` (Double): Total work RVU value

### CustomField Entity

- `id` (UUID): Unique identifier
- `name` (String): Field name
- `fieldType` (String): "dropdown" or "number"
- `options` (String?): JSON array of dropdown options
- `sortOrder` (Int16): Display order

### QIProject Entity

- `id` (UUID): Unique identifier
- `name` (String): Project name
- `projectDescription` (String?): Project details
- `variables` (String): JSON array of QIVariable objects
- `createdAt` (Date): Creation timestamp
- `entries` (relationship): One-to-many with QIProjectEntry

### QIProjectEntry Entity

- `id` (UUID): Unique identifier
- `entryData` (String): JSON of variable values
- `createdAt` (Date): Entry timestamp
- `project` (relationship): Many-to-one with QIProject

## Billing Codes

The app includes 27 CPT codes with accurate wRVU values:

### Established Patient Visits
- 99211-99215 (0.18 - 2.80 wRVU)

### New Patient Visits
- 99202-99205 (0.93 - 3.50 wRVU)

### Preventive Visits
- 99381-99385 (New: 1.50 - 2.00 wRVU)
- 99391-99395 (Established: 1.37 - 1.75 wRVU)

### Additional Codes
- Immunization administration (90471, 90472)
- Behavioral assessment (96127)
- Modifier 25 (auto-applied for well + sick visits)
- And more...

## Key Features Explained

### Timer Functionality

- **Start**: Begin timing a visit
- **Pause**: Temporarily stop (paused time not counted)
- **Resume**: Continue timing
- **End**: Complete visit and open form

The timer only counts active time, excluding paused intervals.

### Smart Billing Suggestions

Based on visit duration, the app suggests appropriate billing codes:
- < 15 min: 99212
- 15-24 min: 99213
- 25-34 min: 99214
- 35+ min: 99215

### Custom Fields

Create unlimited custom fields to track additional data:
- **Dropdown**: Predefined options
- **Number**: Numeric values

Custom fields appear on visit forms and in summaries.

### QI Projects

Track quality improvement initiatives:
1. Create a project with custom variables
2. Define variable types (text, number, dropdown, date)
3. Log data entries
4. View project history
5. Export to CSV (future feature)

### Privacy Features

- Money values hidden by default
- Toggle visibility in settings
- No PHI/PII stored
- Local-only data storage (Core Data)

## App Settings

### General Settings

- **wRVU Conversion Rate**: Dollar value per wRVU (default: $36)
- **Auto-start Timer**: Automatically start next timer after saving
- **Show Money Values**: Toggle financial data visibility

### Custom Fields Management

- Create new fields
- Configure dropdown options
- Delete existing fields
- Reorder fields (via sortOrder)

## Data Persistence

All data is stored locally using Core Data:
- SQLite database on device
- No cloud sync (privacy-focused)
- Automatic saves after each change
- iCloud sync can be added if desired

## Future Enhancements

Potential features for future releases:

- [ ] Data export to CSV/Excel
- [ ] iCloud sync across devices
- [ ] Widget for today's statistics
- [ ] Apple Watch companion app
- [ ] Siri shortcuts integration
- [ ] PDF report generation
- [ ] Dark/light theme toggle
- [ ] Haptic feedback
- [ ] Push notifications for goals
- [ ] Integration with practice management systems

## Testing

### Unit Tests
Run tests in Xcode: Product > Test (Cmd+U)

### Preview Mode
All views include SwiftUI previews for rapid development.

### Sample Data
Preview mode includes sample visits and custom fields.

## App Store Submission

### Requirements

1. **Bundle ID**: Set unique identifier in project settings
2. **App Icon**: Add 1024x1024 icon to Assets.xcassets
3. **Screenshots**: Capture for all required device sizes
4. **Privacy Policy**: Required for health-related apps
5. **App Description**: Highlight productivity and billing features

### Categories

- Primary: Medical
- Secondary: Productivity

### Keywords

clinic, physician, pediatrics, billing, wRVU, productivity, visits, timer, medical, healthcare

## Privacy Considerations

This app:
- ✅ Stores data locally only
- ✅ Does not collect patient identifiable information
- ✅ Does not require internet connection
- ✅ Does not transmit data externally
- ✅ Provides privacy-focused money display toggle

**Note**: If you add cloud sync or analytics, update privacy policy accordingly.

## Support

For issues or questions:
- Review code documentation
- Check inline comments
- Refer to SwiftUI documentation
- Contact: [your email/support channel]

## License

[Specify your license here]

## Credits

**Original Web App**: Flask-based Clinic Visit Tracker
**iOS Adaptation**: Native SwiftUI implementation
**Bible Verses**: 40 inspirational verses for daily encouragement

## Version History

### v1.0.0 (Current)
- Initial iOS release
- Core timer functionality
- Billing code tracking
- Daily summary and dashboard
- Custom fields
- QI project tracker
- Dark theme
- Bible verses

---

**Built with ❤️ for pediatricians who want to track their productivity and improve their practice**
