from flask import Flask, render_template, request, jsonify, send_file
from database import Database, WRVU_LOOKUP, calculate_wrvu
from datetime import datetime, date, timedelta
import pandas as pd
from io import BytesIO
from collections import defaultdict
import json

app = Flask(__name__)
db = Database()

# Helper functions
def get_today():
    return date.today().isoformat()

def format_duration(seconds):
    """Convert seconds to MM:SS format"""
    if seconds is None or seconds == 0:
        return "00:00"
    mins = seconds // 60
    secs = seconds % 60
    return f"{mins:02d}:{secs:02d}"

def calculate_statistics(visits):
    """Calculate summary statistics for a list of visits"""
    if not visits:
        return {
            'total_visits': 0,
            'avg_duration': 0,
            'total_duration': 0,
            'billing_codes': {},
            'visit_types': {},
            'custom_field_stats': {},
            'total_wrvu': 0,
            'avg_wrvu': 0,
            'days_of_week': {}
        }

    total_duration = sum(v['active_duration'] for v in visits)
    avg_duration = total_duration / len(visits) if visits else 0

    # Count billing codes and calculate wRVUs
    billing_codes = defaultdict(int)
    total_wrvu = 0.0
    for v in visits:
        if v['billing_code']:
            # Handle multiple billing codes
            try:
                codes = json.loads(v['billing_code']) if v['billing_code'].startswith('[') else [v['billing_code']]
            except:
                codes = [v['billing_code']]

            for code in codes:
                code = code.strip()
                if code:
                    billing_codes[code] += 1

            # Calculate wRVU for this visit
            total_wrvu += calculate_wrvu(v['billing_code'])

    avg_wrvu = total_wrvu / len(visits) if visits else 0

    # Count visit types
    visit_types = defaultdict(int)
    for v in visits:
        if v['visit_type']:
            visit_types[v['visit_type']] += 1

    # Count days of week
    days_of_week = defaultdict(int)
    for v in visits:
        if v.get('day_of_week'):
            days_of_week[v['day_of_week']] += 1

    # Calculate average duration by visit type
    duration_by_type = defaultdict(list)
    for v in visits:
        if v['visit_type']:
            duration_by_type[v['visit_type']].append(v['active_duration'])

    avg_by_type = {}
    for vtype, durations in duration_by_type.items():
        avg_by_type[vtype] = sum(durations) / len(durations)

    # Custom field statistics
    custom_field_stats = defaultdict(lambda: defaultdict(int))
    for v in visits:
        if v.get('custom_fields'):
            for field_name, field_value in v['custom_fields'].items():
                custom_field_stats[field_name][str(field_value)] += 1

    return {
        'total_visits': len(visits),
        'avg_duration': avg_duration,
        'total_duration': total_duration,
        'billing_codes': dict(billing_codes),
        'visit_types': dict(visit_types),
        'avg_by_type': avg_by_type,
        'custom_field_stats': dict(custom_field_stats),
        'total_wrvu': total_wrvu,
        'avg_wrvu': avg_wrvu,
        'days_of_week': dict(days_of_week)
    }

# Routes
@app.route('/')
def index():
    """Main timer interface"""
    custom_fields = db.get_custom_fields()
    return render_template('timer.html', custom_fields=custom_fields)

@app.route('/api/custom-fields')
def get_custom_fields():
    """Get all custom field configurations"""
    fields = db.get_custom_fields()
    return jsonify(fields)

@app.route('/api/visit', methods=['POST'])
def create_visit():
    """Create a new visit"""
    data = request.json
    visit_id = db.create_visit(data)
    return jsonify({'id': visit_id, 'success': True})

@app.route('/api/visit/<int:visit_id>', methods=['PUT'])
def update_visit(visit_id):
    """Update an existing visit"""
    data = request.json
    db.update_visit(visit_id, data)
    return jsonify({'success': True})

@app.route('/api/visit/<int:visit_id>', methods=['DELETE'])
def delete_visit(visit_id):
    """Delete a visit"""
    db.delete_visit(visit_id)
    return jsonify({'success': True})

@app.route('/daily-summary')
def daily_summary():
    """Daily summary page"""
    target_date = request.args.get('date', get_today())
    visits = db.get_visits_by_date(target_date)
    stats = calculate_statistics(visits)
    custom_fields = db.get_custom_fields()

    return render_template('daily_summary.html',
                         visits=visits,
                         stats=stats,
                         date=target_date,
                         custom_fields=custom_fields,
                         format_duration=format_duration)

@app.route('/api/daily-visits')
def get_daily_visits():
    """Get visits for a specific date (API)"""
    target_date = request.args.get('date', get_today())
    visits = db.get_visits_by_date(target_date)
    stats = calculate_statistics(visits)

    return jsonify({
        'visits': visits,
        'stats': stats
    })

@app.route('/dashboard')
def dashboard():
    """Dashboard with historical data"""
    return render_template('dashboard.html')

@app.route('/api/dashboard-data')
def get_dashboard_data():
    """Get dashboard data for specified date range"""
    period = request.args.get('period', 'today')

    today = date.today()

    if period == 'today':
        start_date = end_date = today.isoformat()
    elif period == 'week':
        start_date = (today - timedelta(days=today.weekday())).isoformat()
        end_date = today.isoformat()
    elif period == 'month':
        start_date = today.replace(day=1).isoformat()
        end_date = today.isoformat()
    elif period == 'last30':
        start_date = (today - timedelta(days=30)).isoformat()
        end_date = today.isoformat()
    elif period == 'custom':
        start_date = request.args.get('start_date')
        end_date = request.args.get('end_date')
    else:
        start_date = end_date = today.isoformat()

    visits = db.get_visits(start_date, end_date)
    stats = calculate_statistics(visits)

    # Group by date for trend analysis
    visits_by_date = defaultdict(list)
    for v in visits:
        visits_by_date[v['date']].append(v)

    daily_stats = {}
    for date_str, day_visits in visits_by_date.items():
        daily_stats[date_str] = calculate_statistics(day_visits)

    return jsonify({
        'stats': stats,
        'daily_stats': daily_stats,
        'start_date': start_date,
        'end_date': end_date
    })

@app.route('/settings')
def settings():
    """Settings page for managing custom fields"""
    custom_fields = db.get_custom_fields()
    conversion_rate = db.get_wrvu_conversion_rate()
    return render_template('settings.html',
                         custom_fields=custom_fields,
                         conversion_rate=conversion_rate)

@app.route('/api/custom-field', methods=['POST'])
def create_custom_field():
    """Create a new custom field"""
    data = request.json
    db.create_custom_field(
        data['field_name'],
        data['field_type'],
        data.get('options')
    )
    return jsonify({'success': True})

@app.route('/api/custom-field/<int:field_id>', methods=['DELETE'])
def delete_custom_field(field_id):
    """Delete a custom field"""
    db.delete_custom_field(field_id)
    return jsonify({'success': True})

@app.route('/api/wrvu-lookup')
def get_wrvu_lookup():
    """Get wRVU lookup table"""
    return jsonify(WRVU_LOOKUP)

@app.route('/api/wrvu-conversion-rate', methods=['GET'])
def get_wrvu_conversion_rate():
    """Get wRVU conversion rate"""
    rate = db.get_wrvu_conversion_rate()
    return jsonify({'rate': rate})

@app.route('/api/wrvu-conversion-rate', methods=['POST'])
def set_wrvu_conversion_rate():
    """Set wRVU conversion rate"""
    data = request.json
    db.set_wrvu_conversion_rate(float(data['rate']))
    return jsonify({'success': True})

@app.route('/api/export')
def export_data():
    """Export data to Excel"""
    start_date = request.args.get('start_date')
    end_date = request.args.get('end_date')

    visits = db.get_visits(start_date, end_date)

    # Prepare data for Excel
    export_data = []
    for i, visit in enumerate(visits, 1):
        row = {
            'Encounter #': i,
            'Date': visit['date'],
            'Start Time': visit['start_time'],
            'End Time': visit['end_time'],
            'Duration (min)': visit['active_duration'] / 60,
            'Visit Type': visit['visit_type'],
            'Billing Code': visit['billing_code'],
            'Comments': visit['comments']
        }

        # Add custom fields
        if visit.get('custom_fields'):
            for field_name, field_value in visit['custom_fields'].items():
                row[field_name] = field_value

        export_data.append(row)

    # Create Excel file
    df = pd.DataFrame(export_data)

    output = BytesIO()
    with pd.ExcelWriter(output, engine='openpyxl') as writer:
        df.to_excel(writer, sheet_name='Visits', index=False)

        # Add statistics sheet
        visits_list = db.get_visits(start_date, end_date)
        stats = calculate_statistics(visits_list)

        stats_data = [
            ['Metric', 'Value'],
            ['Total Visits', stats['total_visits']],
            ['Average Duration (min)', stats['avg_duration'] / 60],
            ['Total Duration (min)', stats['total_duration'] / 60],
            ['', ''],
            ['Visit Types', 'Count']
        ]

        for vtype, count in stats['visit_types'].items():
            stats_data.append([vtype, count])

        stats_data.append(['', ''])
        stats_data.append(['Billing Codes', 'Count'])

        for code, count in stats['billing_codes'].items():
            stats_data.append([code, count])

        stats_df = pd.DataFrame(stats_data)
        stats_df.to_excel(writer, sheet_name='Statistics', index=False, header=False)

    output.seek(0)

    filename = f"clinic_visits_{start_date}_to_{end_date}.xlsx"
    return send_file(output,
                     mimetype='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                     as_attachment=True,
                     download_name=filename)

@app.template_filter('format_duration')
def format_duration_filter(seconds):
    return format_duration(seconds)

@app.template_filter('calc_wrvu')
def calc_wrvu_filter(billing_code):
    return calculate_wrvu(billing_code)

if __name__ == '__main__':
    app.run(debug=True, port=5000)
