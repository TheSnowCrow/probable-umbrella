# Implementation Notes

Technical notes about the iOS adaptation of Clinic Visit Tracker.

## Architecture Overview

### Design Pattern: MVVM (Model-View-ViewModel)

- **Models**: Core Data entities (Visit, CustomField, QIProject, etc.)
- **Views**: SwiftUI views (EncountersView, DashboardView, etc.)
- **ViewModels**: State management (TimerViewModel, SettingsManager)
- **Services**: Business logic (PersistenceController, WRVULookup)

### Data Flow

```
User Input → View → ViewModel → Service → Core Data
                ↑                              ↓
                └──────── Published State ─────┘
```

## Key Design Decisions

### 1. Core Data Instead of SQLite

**Original**: Flask app uses raw SQLite with custom SQL queries

**iOS**: Core Data with NSManagedObject subclasses

**Why:**
- Type-safe Swift API
- Automatic change tracking
- iCloud sync support (future)
- Relationship management
- Memory optimization

### 2. SwiftUI Instead of UIKit

**Why:**
- Modern declarative syntax
- Less code (compared to UIKit)
- Built-in animations
- Native dark mode support
- Easier previews and testing

### 3. Swift Charts for Visualization

**Original**: Web app uses Chart.js via CDN

**iOS**: Native Swift Charts framework (iOS 16+)

**Why:**
- Native performance
- iOS design patterns
- Automatic accessibility
- No external dependencies

### 4. UserDefaults for Settings

Settings stored in UserDefaults:
- wRVU conversion rate
- Auto-start timer preference
- Show money values toggle

**Why:**
- Simple key-value storage
- Automatic iCloud sync (if enabled)
- No need for Core Data entity

### 5. JSON for Complex Data

Stored as strings in Core Data:
- Billing codes array: `["99213", "99214"]`
- Custom field values: `{"field1": "value1"}`
- QI project variables: `[{name, type, options}]`

**Why:**
- Flexible schema
- Easy to encode/decode
- Mirrors original Flask implementation

## Feature Parity with Flask App

### ✅ Implemented Features

| Feature | Flask App | iOS App | Notes |
|---------|-----------|---------|-------|
| Real-time timer | ✅ | ✅ | Pause/resume works identically |
| Billing code selection | ✅ | ✅ | All 27 codes included |
| wRVU calculations | ✅ | ✅ | Same lookup table |
| Daily summary | ✅ | ✅ | Matching statistics |
| Dashboard charts | ✅ | ✅ | Native Swift Charts |
| Custom fields | ✅ | ✅ | Dropdown and number types |
| QI projects | ✅ | ✅ | Full CRUD operations |
| Settings | ✅ | ✅ | wRVU rate configuration |
| Bible verses | ✅ | ✅ | All 40 verses included |
| Dark theme | ✅ | ✅ | Native iOS dark mode |
| Manual entry | ✅ | ✅ | Date/time/duration options |

### 🚧 Not Yet Implemented

| Feature | Reason | Priority |
|---------|--------|----------|
| Data import (CSV/Excel) | Requires file picker UI | High |
| Data export to Excel | Need openpyxl equivalent | High |
| Work day tracking | Not critical for MVP | Low |
| Multiple profiles/users | Single-user device assumption | Low |

### 🎁 iOS-Specific Enhancements

- **Native iOS design**: Follows Apple HIG
- **Gesture support**: Swipe to delete, pull to refresh
- **Accessibility**: VoiceOver, Dynamic Type support
- **Haptics**: Tactile feedback (can be added)
- **Widgets**: Home screen widgets (future)
- **Watch app**: Companion app (future)

## Code Organization

### File Structure Logic

```
Services/     - Singletons and shared instances
ViewModels/   - ObservableObject classes for state
Views/        - SwiftUI view files
Models/       - Core Data entity extensions
Utilities/    - Helper classes (no state)
Resources/    - Assets, plists, data files
```

### Naming Conventions

- **Views**: `*View.swift` (e.g., DashboardView)
- **ViewModels**: `*ViewModel.swift` (e.g., TimerViewModel)
- **Services**: `*Manager.swift` or `*Controller.swift`
- **Models**: `Entity+CoreData*.swift`

## Performance Optimizations

### 1. Lazy Loading

Charts only render when visible:
```swift
if !visitTypeData.isEmpty {
    Chart(visitTypeData, id: \.0) { ... }
}
```

### 2. Batch Updates

Core Data saves batched:
```swift
context.save() // Only when hasChanges
```

### 3. Predicate Filtering

Database queries use predicates:
```swift
NSPredicate(format: "date >= %@ AND date < %@", start, end)
```

### 4. Memory Management

- Fetch requests have sort descriptors
- @FetchRequest automatically updates views
- No retain cycles with [weak self]

## Testing Strategy

### Unit Tests (Future)

- wRVU calculation accuracy
- Date range filtering
- JSON encoding/decoding
- Custom field validation

### UI Tests (Future)

- Timer flow (start → pause → resume → end)
- Visit form submission
- Navigation between tabs
- Settings persistence

### Preview Tests (Current)

All views have SwiftUI previews:
```swift
#Preview {
    DashboardView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
```

## Known Limitations

### 1. No Multi-User Support

**Issue**: iOS app assumes single user per device

**Flask app**: Could support multiple physician profiles

**Workaround**: Each physician uses their own device

### 2. No Cloud Sync

**Issue**: Data not synced across devices

**Future**: Add iCloud Core Data sync

**Workaround**: Manual export/import (when implemented)

### 3. No Background Timer

**Issue**: Timer pauses when app backgrounded

**Current behavior**: User must keep app open

**Future**: Background task API for continuous timing

### 4. Limited Export Options

**Issue**: No CSV/Excel export yet

**Planned**: Share sheet with CSV generation

## Security Considerations

### Data Protection

- Core Data encrypted at rest (iOS default)
- No network transmission
- No analytics/tracking
- Keychain not needed (no sensitive credentials)

### Privacy

- No PII collection
- Money values hidden by default
- Local-only storage
- No third-party SDKs

## Accessibility Features

### Built-in Support

- ✅ VoiceOver labels (automatic)
- ✅ Dynamic Type (text scaling)
- ✅ Reduce Motion respected
- ✅ Dark Mode toggle
- ✅ High Contrast support

### Future Enhancements

- [ ] Custom VoiceOver hints
- [ ] Accessibility identifiers for UI tests
- [ ] Large button mode
- [ ] Color-blind friendly charts

## Future Roadmap

### Phase 2: Essential Features

1. **Data Export**
   - CSV generation
   - Share sheet integration
   - Email export

2. **Data Import**
   - CSV parser
   - File picker UI
   - Validation and error handling

3. **Background Timer**
   - Background task API
   - Local notifications
   - App refresh

### Phase 3: Advanced Features

1. **iCloud Sync**
   - NSPersistentCloudKitContainer
   - Conflict resolution
   - Sync indicator

2. **Widgets**
   - Today's statistics widget
   - Timer quick-start widget
   - WidgetKit implementation

3. **Apple Watch**
   - Timer control
   - Quick visit logging
   - Glance view

### Phase 4: Pro Features

1. **Analytics**
   - Advanced charts
   - Trends and predictions
   - Export to PDF

2. **Integration**
   - Health app integration
   - Calendar sync
   - Practice management systems

3. **Collaboration**
   - Team dashboards
   - Shared QI projects
   - Benchmarking

## Migration from Flask App

### For Current Users

**Manual Migration Steps:**

1. **Export from Flask app**:
   - Use existing export feature
   - Download CSV file

2. **Import to iOS app** (when feature available):
   - Tap Import in settings
   - Select CSV file
   - Confirm import

### Data Format Compatibility

iOS app uses same data structure:
- Date formats: ISO 8601
- Duration: Seconds (Int32)
- Billing codes: JSON array
- wRVU values: Double (2 decimal places)

CSV should have columns:
```
date,start_time,end_time,active_duration,visit_type,billing_code,comments,wrvu
```

## Contributing Guidelines

### Code Style

- **Swift**: Follow Swift API Design Guidelines
- **Formatting**: Use Xcode default formatting
- **Comments**: Document complex logic
- **Naming**: Descriptive variable names

### Commit Messages

Format: `[Component] Action description`

Examples:
- `[Timer] Fix pause/resume state bug`
- `[Dashboard] Add custom date range picker`
- `[Core Data] Optimize fetch requests`

### Pull Request Process

1. Create feature branch
2. Implement changes
3. Test thoroughly
4. Update documentation
5. Submit PR with description

## Resources

### SwiftUI Learning

- Apple SwiftUI Tutorials: https://developer.apple.com/tutorials/swiftui
- Hacking with Swift: https://www.hackingwithswift.com/quick-start/swiftui
- SwiftUI Lab: https://swiftui-lab.com

### Core Data

- Apple Core Data Guide: https://developer.apple.com/documentation/coredata
- Core Data by Tutorials: https://www.raywenderlich.com/books/core-data-by-tutorials

### App Store

- App Store Review Guidelines: https://developer.apple.com/app-store/review/guidelines/
- Human Interface Guidelines: https://developer.apple.com/design/human-interface-guidelines/

---

## Questions?

For technical questions about the iOS implementation:
1. Check inline code comments
2. Review this document
3. Refer to Apple documentation
4. Open GitHub issue

**Happy coding! 🚀**
