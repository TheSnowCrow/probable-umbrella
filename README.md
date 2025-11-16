# Clinic Visit Tracker

A web-based application for pediatricians to track clinic visits, improve workflow efficiency, and maintain billing consistency.

## Features

- **Real-time Visit Timing**: Large stopwatch interface with pause/resume functionality
- **POS-Style Data Entry**: Large, tappable square buttons for fast billing code selection (like a cash register)
- **Manual Data Entry**: Add visits without using the timer - perfect for retrospective entry
- **Data Import**: Bulk import visits from CSV or Excel files
- **Visit Documentation**: Track visit type (Sick/Well), billing codes, and custom notes
- **wRVU Tracking**: Automatic calculation of work RVUs for all billing codes
- **Multiple Billing Codes**: Select multiple codes per visit (e.g., well visit + sick visit + 25 modifier)
- **Financial Analytics**: Track wRVU earnings with customizable conversion rate
- **Privacy-First Money Display**: Dollar values hidden by default, toggle to show
- **Day-of-Week Analysis**: Automatic tracking of visit patterns by day
- **Custom Fields**: Define your own dropdown or number fields for additional tracking
- **Daily Summary**: View all visits for the day with comprehensive statistics
- **Dashboard**: Analyze trends over time with interactive charts including custom field analytics
- **Excel Export**: Export your data for external analysis
- **Dark macOS Theme**: Professional, minimalistic interface designed for macOS

## Installation

### Prerequisites

- Python 3.8 or higher
- pip (Python package manager)

### Setup

1. **Navigate to the project directory**:
   ```bash
   cd /path/to/probable-umbrella
   ```

2. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

3. **Run the application**:
   ```bash
   python app.py
   ```

4. **Access the application**:
   Open your web browser and go to: `http://localhost:5000`

## Usage

### Main Timer Interface

1. **Starting a Visit**:
   - Click "Start Visit" to begin timing
   - The encounter number increments automatically
   - Timer displays in MM:SS format

2. **During a Visit**:
   - Click "Pause" if interrupted (paused time is not counted)
   - Click "Resume" to continue timing
   - Only active (non-paused) time is tracked

3. **Ending a Visit**:
   - Click "End Visit" when the patient encounter is complete
   - Fill in visit details:
     - Visit Type (Sick/Well)
     - Billing Codes - Select one or more (organized by category):
       - Established Patient (99212-99215)
       - New Patient (99202-99205)
       - Well Visit New (99381-99385)
       - Well Visit Established (99391-99395)
       - 25 Modifier (for combined well + sick visits)
     - Each code shows its wRVU value for reference
     - Custom fields (if configured)
     - Comments/notes
   - Click "Save & Start Next Visit" to save and automatically start the next encounter

### Manual Data Entry

For entering visits without using the timer (e.g., when you forgot to track or doing retrospective entry):

1. Go to **Manual Entry** page
2. Fill in the form:
   - Date (required)
   - Start Time (required)
   - End Time (optional - auto-calculates duration)
   - Duration in minutes (auto-filled or manual)
   - Visit Type
   - Billing Codes - Click the large square buttons to select
   - Custom fields
   - Comments
3. Click **Save Visit** to add to your records
4. Form resets for next entry

### Import Data

Bulk import visits from spreadsheets:

1. Go to **Import Data** page
2. Download the CSV template (optional but recommended)
3. Prepare your file with columns:
   - `date` (YYYY-MM-DD, required)
   - `start_time` (ISO format, required)
   - `end_time` (ISO format, optional)
   - `active_duration` (seconds, required)
   - `visit_type`, `billing_code`, `comments` (optional)
   - Any custom field names
4. Upload CSV or Excel file
5. Review import results (shows # imported and any errors)
6. Check Daily Summary or Dashboard to verify

### Daily Summary

- View all visits recorded for a specific date
- See summary statistics:
  - Total visits
  - Average duration
  - Total time spent
  - **Total wRVU** earned for the day
  - **Average wRVU** per visit
  - **Total Value** (toggle to show/hide dollar amount)
  - Visit type breakdown with averages
  - Billing code distribution
  - Day of week tracking
  - Custom field statistics
- Visit table shows:
  - Encounter number
  - Day of week
  - Duration
  - Billing codes
  - **wRVU** for each visit
  - All custom data
- **Privacy Feature**: Click "Show $ Values" to reveal earnings (hidden by default)
- Delete visits if needed
- Change date to view previous days

### Dashboard

- **Time Period Selection**:
  - Today
  - This Week
  - This Month
  - Last 30 Days
  - Custom Date Range

- **Visualizations**:
  - Visit types distribution (pie chart)
  - Billing codes distribution (bar chart)
  - Visits and duration over time (line chart)
  - **Custom field distributions** (pie chart for each custom field)
  - All charts update based on selected time period

- **wRVU Display**: Toggle to show/hide dollar values

- **Export**: Download data as Excel spreadsheet

### Settings

**wRVU Conversion Rate**:
- Set the dollar value per wRVU (default: $36.00)
- Applies to new visits going forward
- Used for calculating "Total Value" in summaries and dashboard

**Custom Fields**:
- Add dropdown fields (e.g., "Patient Complexity: Low, Medium, High")
- Add number fields (e.g., "Number of Issues Addressed")
- Custom fields appear in:
  - Timer interface for data entry
  - Daily summary statistics
  - Dashboard analytics
  - Excel exports

## Data Storage

- All data is stored in a local SQLite database (`clinic_tracker.db`)
- Database is created automatically on first run
- Data persists between sessions
- No patient identifying information is stored (tracking your actions only)

## File Structure

```
probable-umbrella/
├── app.py                  # Main Flask application
├── database.py            # Database models and operations
├── requirements.txt       # Python dependencies
├── clinic_tracker.db      # SQLite database (created on first run)
├── templates/             # HTML templates
│   ├── base.html
│   ├── timer.html
│   ├── daily_summary.html
│   ├── dashboard.html
│   └── settings.html
└── static/                # CSS and JavaScript
    └── css/
        └── style.css
```

## Billing Codes Reference

**Established Patient Visit Codes**:
- 99212: Office/outpatient visit, 10 minutes
- 99213: Office/outpatient visit, 20 minutes
- 99214: Office/outpatient visit, 30 minutes
- 99215: Office/outpatient visit, 40 minutes

**New Patient Visit Codes**:
- 99202: Office/outpatient visit, 15-29 minutes
- 99203: Office/outpatient visit, 30-44 minutes
- 99204: Office/outpatient visit, 45-59 minutes
- 99205: Office/outpatient visit, 60-74 minutes

**Preventive Visit Codes** (Age-based):
- 99391: Preventive visit, infant (under 1 year)
- 99392: Preventive visit, ages 1-4
- 99393: Preventive visit, ages 5-11
- 99394: Preventive visit, ages 12-17
- 99395: Preventive visit, ages 18-39

## Tips for Effective Use

1. **Start timer immediately** when entering the exam room
2. **Use pause** for interruptions (phone calls, pages, etc.)
3. **Add comments** while details are fresh
4. **Review daily summary** at end of day to identify patterns
5. **Use custom fields** to track specific metrics important to your practice
6. **Export data monthly** for long-term analysis

## Troubleshooting

**Application won't start**:
- Verify Python 3.8+ is installed: `python --version`
- Ensure all dependencies are installed: `pip install -r requirements.txt`

**Can't access in browser**:
- Verify the application is running (should see "Running on http://127.0.0.1:5000")
- Try `http://127.0.0.1:5000` instead of `http://localhost:5000`

**Data not saving**:
- Check file permissions in the application directory
- Ensure `clinic_tracker.db` can be created/modified

**Charts not displaying**:
- Ensure you have an internet connection (Chart.js loads from CDN)
- Try refreshing the page

## Privacy & Security

- This application is designed for **local use only** (not for deployment over the internet)
- **No patient identifying information** should be entered
- Data tracks your workflow and decisions, not patient details
- Database is stored locally on your machine
- For production use over a network, additional security measures would be required

## License

Personal use application - all rights reserved.

## Version

1.0 - Initial Release
