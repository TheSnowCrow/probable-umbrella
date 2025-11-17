# App Store Submission Guide

Complete guide for submitting **Clinic Visit Tracker** to the Apple App Store.

## Prerequisites

- [ ] Active Apple Developer Program membership ($99/year)
- [ ] Xcode 14.0 or later
- [ ] Valid development certificates and provisioning profiles
- [ ] App icon (1024x1024 PNG, no transparency)
- [ ] Screenshots for all required device sizes
- [ ] Privacy policy URL
- [ ] Support URL or email

## Step 1: Prepare Your Xcode Project

### 1.1 Set Bundle Identifier

1. Open `ClinicVisitTracker.xcodeproj` in Xcode
2. Select the project in the navigator
3. Select the "ClinicVisitTracker" target
4. Go to "Signing & Capabilities" tab
5. Set a unique Bundle Identifier (e.g., `com.yourcompany.clinicvisittracker`)

### 1.2 Configure Signing

1. In "Signing & Capabilities":
   - Check "Automatically manage signing"
   - Select your Team from dropdown
   - Xcode will generate provisioning profiles automatically

### 1.3 Set Version and Build Number

1. In "General" tab:
   - Set **Version**: `1.0.0`
   - Set **Build**: `1`

### 1.4 Add App Icon

1. Open `Assets.xcassets` in Xcode
2. Select "AppIcon"
3. Drag your 1024x1024 PNG icon to the "App Store" slot
4. Xcode will generate all required sizes

**Icon Requirements:**
- 1024x1024 pixels
- PNG format
- No transparency
- No rounded corners (iOS adds automatically)
- Simple, recognizable design
- Avoid text (won't be readable at small sizes)

**Suggested Icon:** Medical cross or stethoscope with timer symbol

### 1.5 Configure Info.plist

Already configured, but verify:
- Display name: "Clinic Visit Tracker"
- Version string: "1.0"
- Requires iOS 16.0 or later
- Dark mode preference: Dark
- Supported orientations: All

## Step 2: Test Thoroughly

### 2.1 Device Testing

Test on real devices:
- [ ] iPhone SE (small screen)
- [ ] iPhone 14/15 Pro (standard)
- [ ] iPhone 14/15 Pro Max (large screen)
- [ ] iPad (if supporting iPad)

### 2.2 Feature Testing Checklist

- [ ] Timer starts, pauses, resumes, and ends correctly
- [ ] Paused time is excluded from active duration
- [ ] Visit form shows correct billing codes
- [ ] wRVU calculations are accurate
- [ ] Custom fields can be created and deleted
- [ ] QI projects can be created with variables
- [ ] Data entries save and load correctly
- [ ] Daily summary shows accurate statistics
- [ ] Dashboard charts display properly
- [ ] Settings persist after app restart
- [ ] Bible verses display randomly
- [ ] App doesn't crash on edge cases (0 visits, etc.)

### 2.3 Performance Testing

- [ ] App launches in < 2 seconds
- [ ] Scrolling is smooth (60 fps)
- [ ] No memory leaks
- [ ] Battery drain is reasonable
- [ ] Works offline (no internet required)

## Step 3: Create App Screenshots

### 3.1 Required Sizes

**iPhone:**
- 6.7" (iPhone 14/15 Pro Max): 1290 x 2796 pixels
- 6.5" (iPhone 11 Pro Max): 1242 x 2688 pixels
- 5.5" (iPhone 8 Plus): 1242 x 2208 pixels

**iPad (if supported):**
- 12.9" (iPad Pro): 2048 x 2732 pixels

### 3.2 Recommended Screenshots (5-10 images)

1. **Timer View** - Show active timer with Bible verse
2. **Visit Form** - Billing code selection screen
3. **Daily Summary** - Statistics and visit list
4. **Dashboard** - Charts and analytics
5. **QI Projects** - Project list or detail view
6. **Settings** - Custom fields configuration

**Tips:**
- Use iPhone simulator in Xcode
- Cmd+S to save screenshots
- Show real data (not empty states)
- Add text overlays explaining features (optional)
- Use consistent design/theme

### 3.3 Tools for Screenshots

- **Xcode Simulator**: Built-in (Cmd+S)
- **Screenshot Framer**: https://screenshot.rocks
- **Fastlane Frameit**: https://fastlane.tools/frameit
- **App Screenshot Maker**: https://appscreenshotmaker.com

## Step 4: Create App Store Assets

### 4.1 App Name

**Primary Name**: Clinic Visit Tracker

**Subtitle** (30 chars max): Track visits & wRVU productivity

### 4.2 Description (4000 chars max)

```
Clinic Visit Tracker helps pediatricians and physicians track clinic visits in real-time, measure productivity through work RVU (wRVU) calculations, and maintain billing consistency.

KEY FEATURES:

⏱️ REAL-TIME TIMER
• Start, pause, and resume visit timers
• Only counts active time (excludes paused intervals)
• Track multiple encounters per day
• Auto-start option for continuous workflow

💰 BILLING & wRVU TRACKING
• 27 CPT codes with accurate wRVU values
• Automatic wRVU calculations
• Smart billing suggestions based on visit duration
• Configurable wRVU-to-dollar conversion rate
• Privacy-focused money display toggle

📊 ANALYTICS & INSIGHTS
• Daily summaries with comprehensive statistics
• Interactive charts (visit types, billing codes, trends)
• Custom date range filtering
• Average duration and wRVU per visit
• Day-of-week analysis

📝 FLEXIBLE DATA COLLECTION
• Create custom fields (dropdowns and numbers)
• Track additional visit data
• Quality Improvement (QI) project tracker
• Define custom variables for QI initiatives

🔒 PRIVACY FIRST
• All data stored locally on your device
• No cloud sync (optional future feature)
• No patient identifiable information
• No internet connection required
• HIPAA-friendly design

✨ THOUGHTFUL DESIGN
• Native iOS dark theme
• Optimized for iPhone and iPad
• Landscape and portrait support
• Daily inspirational Bible verses
• Clean, intuitive interface

PERFECT FOR:
• Pediatricians tracking clinic productivity
• Physicians monitoring wRVU performance
• Practices analyzing billing patterns
• Residents learning billing codes
• Quality improvement initiatives

BILLING CODES INCLUDED:
• Established patient visits (99211-99215)
• New patient visits (99202-99205)
• Preventive visits (99381-99395)
• Immunization administration
• Behavioral assessments
• And more...

NO ADS • NO SUBSCRIPTIONS • ONE-TIME PURCHASE

Download now and start tracking your productivity today!
```

### 4.3 Keywords (100 chars max)

```
clinic,physician,pediatrics,billing,wrvu,productivity,visits,timer,medical,healthcare,rvu,cpt
```

### 4.4 Promotional Text (170 chars)

```
Track clinic visits in real-time with our powerful timer. Calculate wRVUs automatically. Analyze productivity with beautiful charts. Perfect for busy pediatricians!
```

### 4.5 Privacy Policy

Required for health-related apps. Create a simple privacy policy:

**Sample Privacy Policy:**

```markdown
# Privacy Policy for Clinic Visit Tracker

Last Updated: [Date]

## Data Collection
Clinic Visit Tracker does NOT collect, store, or transmit any personal information or patient data.

## Local Storage
All data is stored locally on your device using Core Data (SQLite). This includes:
- Visit timestamps and durations
- Billing codes and wRVU calculations
- Custom field data
- QI project information

## No Analytics
We do not use any analytics or tracking services.

## No Third-Party Services
The app does not connect to any third-party services or servers.

## Data Security
Your data remains on your device and is protected by iOS device security (passcode, Face ID, Touch ID).

## Data Deletion
Deleting the app will permanently remove all stored data.

## HIPAA Compliance
While the app does not collect patient identifiable information, users are responsible for ensuring their use complies with HIPAA and other applicable regulations.

## Contact
For questions: [your email]
```

Host this on a public URL (GitHub Pages, your website, etc.)

### 4.6 Support URL

Provide a support email or website:
- Email: `support@yourcompany.com`
- Or: Website with FAQ

## Step 5: Create App Store Connect Listing

### 5.1 Log into App Store Connect

1. Go to https://appstoreconnect.apple.com
2. Sign in with your Apple Developer account
3. Click "My Apps"
4. Click "+" → "New App"

### 5.2 Fill Out App Information

**Platforms**: iOS

**Name**: Clinic Visit Tracker

**Primary Language**: English (U.S.)

**Bundle ID**: Select your bundle identifier

**SKU**: `clinic-visit-tracker-001` (any unique string)

**User Access**: Full Access

### 5.3 Pricing and Availability

**Price**: Choose your price tier
- Free (with optional in-app purchases later)
- $4.99 (Tier 5)
- $9.99 (Tier 10)
- Or custom price

**Availability**: All territories (or select specific countries)

**Pre-Orders**: Optional

### 5.4 App Privacy

Answer questions about data collection:
- [ ] Do you collect data? **NO**
- [ ] Do you track data? **NO**
- [ ] Do you use third-party SDK? **NO**

### 5.5 App Information

**Category**:
- Primary: Medical
- Secondary: Productivity

**Content Rights**: Check if you own rights to all content

**Age Rating**: 4+ (no restricted content)

**Copyright**: © [Year] [Your Name/Company]

### 5.6 Version Information

**What's New in This Version** (4000 chars):

```
Welcome to Clinic Visit Tracker v1.0!

This is the initial release of our powerful clinic productivity tracker designed specifically for pediatricians and physicians.

FEATURES:
✓ Real-time visit timer with pause/resume
✓ 27 CPT billing codes with wRVU calculations
✓ Daily summaries and analytics dashboard
✓ Custom fields for flexible data collection
✓ QI project tracker
✓ Privacy-focused design (all data local)
✓ Dark theme optimized for iOS
✓ Inspirational Bible verses

Start tracking your productivity today!
```

## Step 6: Build and Upload

### 6.1 Archive the App

1. In Xcode, select "Any iOS Device" as target
2. Go to **Product** → **Archive**
3. Wait for archive to complete (1-5 minutes)
4. Xcode Organizer will open automatically

### 6.2 Validate the Archive

1. In Organizer, select your archive
2. Click **Validate App**
3. Follow wizard:
   - Distribution method: App Store Connect
   - Distribution options: Defaults are fine
   - Re-sign: Let Xcode manage
4. Click **Validate**
5. Fix any errors/warnings

### 6.3 Upload to App Store Connect

1. Click **Distribute App**
2. Choose **App Store Connect**
3. Follow wizard (same as validation)
4. Click **Upload**
5. Wait for upload to complete (5-15 minutes)

### 6.4 Wait for Processing

1. Log into App Store Connect
2. Go to your app → Activity tab
3. Wait for build to appear (5-30 minutes)
4. Status will change to "Ready to Submit"

## Step 7: Submit for Review

### 7.1 Select Build

1. In App Store Connect, go to your app
2. Click version "1.0.0"
3. Scroll to "Build" section
4. Click "+" and select your uploaded build

### 7.2 Add Screenshots

1. Scroll to "App Screenshots"
2. Upload screenshots for each device size
3. Arrange in best order (most important first)

### 7.3 Review Information

Double-check:
- [ ] App name
- [ ] Subtitle
- [ ] Description
- [ ] Keywords
- [ ] Screenshots
- [ ] Privacy policy URL
- [ ] Support URL
- [ ] Pricing
- [ ] Age rating

### 7.4 Submit for Review

1. Click **Submit for Review** (top-right)
2. Answer additional questions:
   - Export compliance: No (uses standard encryption)
   - Advertising identifier: No
   - Content rights: Yes
3. Click **Submit**

## Step 8: App Review Process

### 8.1 Review Timeline

- **In Review**: 24-48 hours (typically)
- **Approved**: App goes live automatically (or scheduled)
- **Rejected**: Review feedback, fix issues, resubmit

### 8.2 Common Rejection Reasons

❌ **Incomplete information** - Ensure all fields filled
❌ **Privacy policy missing** - Must have public URL
❌ **Crashes/bugs** - Test thoroughly before submission
❌ **Misleading description** - Be accurate about features
❌ **Copyright issues** - Ensure you own all content
❌ **Guideline violations** - Review App Store Review Guidelines

### 8.3 If Rejected

1. Read rejection message carefully
2. Fix the specific issues mentioned
3. Reply to App Review team if clarification needed
4. Upload new build if code changes required
5. Resubmit

## Step 9: Post-Launch

### 9.1 Monitor Reviews

- Respond to user reviews
- Fix bugs reported by users
- Gather feature requests

### 9.2 Plan Updates

Future version ideas:
- Data export to CSV/Excel
- iCloud sync
- Apple Watch app
- Widgets
- Siri shortcuts

### 9.3 Marketing

- Share on social media
- Reach out to pediatric groups
- Create demo video
- Write blog post about the app

## Helpful Resources

**Apple Documentation:**
- App Store Review Guidelines: https://developer.apple.com/app-store/review/guidelines/
- App Store Connect Help: https://help.apple.com/app-store-connect/
- Human Interface Guidelines: https://developer.apple.com/design/human-interface-guidelines/

**Tools:**
- TestFlight: Beta testing platform
- Fastlane: Automation for screenshots and uploads
- App Store Optimization (ASO): Keyword research tools

**Support:**
- Apple Developer Forums: https://developer.apple.com/forums/
- Stack Overflow: Tag `ios` and `swift`

---

## Quick Checklist

Before submitting:

- [ ] Bundle identifier configured
- [ ] App icon added (1024x1024)
- [ ] Version and build numbers set
- [ ] Tested on real devices
- [ ] All features working correctly
- [ ] Screenshots captured (5-10 images)
- [ ] Privacy policy created and hosted
- [ ] Support URL/email set up
- [ ] App Store Connect listing complete
- [ ] Build archived and uploaded
- [ ] Build selected in App Store Connect
- [ ] All metadata reviewed
- [ ] Submitted for review

---

**Good luck with your App Store submission! 🚀**

For questions or issues, refer to Apple's official documentation or reach out to Apple Developer Support.
