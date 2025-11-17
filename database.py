import sqlite3
import json
from datetime import datetime, date
from typing import List, Dict, Optional, Any

# wRVU lookup table
WRVU_LOOKUP = {
    '99202': {'description': 'Level 2 new', 'wrvu': 0.93},
    '99203': {'description': 'Level 3 new', 'wrvu': 1.6},
    '99204': {'description': 'Level 4 new', 'wrvu': 2.6},
    '99205': {'description': 'Level 5 new', 'wrvu': 3.5},
    '99212': {'description': 'Level 2 established', 'wrvu': 0.7},
    '99213': {'description': 'Level 3 established', 'wrvu': 1.3},
    '99214': {'description': 'Level 4 established', 'wrvu': 1.92},
    '99215': {'description': 'Level 5 established', 'wrvu': 2.8},
    '99381': {'description': '< 1 year, new', 'wrvu': 1.5},
    '99382': {'description': '1-4 years, new', 'wrvu': 1.6},
    '99383': {'description': '5-11 years, new', 'wrvu': 1.7},
    '99384': {'description': '12-17 years, new', 'wrvu': 2.0},
    '99385': {'description': '18-39 years, new', 'wrvu': 1.92},
    '99391': {'description': '< 1 year, established', 'wrvu': 1.37},
    '99392': {'description': '1-4 years, established', 'wrvu': 1.5},
    '99393': {'description': '5-11 years, established', 'wrvu': 1.5},
    '99394': {'description': '12-17 years, established', 'wrvu': 1.7},
    '99395': {'description': '18-39 years, established', 'wrvu': 1.75},
    '25': {'description': '25 Modifier', 'wrvu': 0.0},
}

class Database:
    def __init__(self, db_path='clinic_tracker.db'):
        self.db_path = db_path
        self.init_db()

    def get_connection(self):
        conn = sqlite3.connect(self.db_path)
        conn.row_factory = sqlite3.Row
        return conn

    def init_db(self):
        """Initialize database tables"""
        conn = self.get_connection()
        cursor = conn.cursor()

        # Visits table
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS visits (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                date TEXT NOT NULL,
                start_time TEXT NOT NULL,
                end_time TEXT,
                active_duration INTEGER DEFAULT 0,
                visit_type TEXT,
                billing_code TEXT,
                comments TEXT,
                custom_fields TEXT,
                day_of_week TEXT,
                created_at TEXT DEFAULT CURRENT_TIMESTAMP
            )
        ''')

        # Custom fields configuration table
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS custom_fields (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                field_name TEXT NOT NULL UNIQUE,
                field_type TEXT NOT NULL,
                options TEXT,
                created_at TEXT DEFAULT CURRENT_TIMESTAMP
            )
        ''')

        # Days table for tracking work days
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS work_days (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                date TEXT NOT NULL UNIQUE,
                notes TEXT,
                ended_at TEXT
            )
        ''')

        # Settings table
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS settings (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                key TEXT NOT NULL UNIQUE,
                value TEXT NOT NULL,
                updated_at TEXT DEFAULT CURRENT_TIMESTAMP
            )
        ''')

        # QI Projects table
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS qi_projects (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                description TEXT,
                variables TEXT NOT NULL,
                created_at TEXT DEFAULT CURRENT_TIMESTAMP,
                updated_at TEXT DEFAULT CURRENT_TIMESTAMP
            )
        ''')

        # QI Project Data table
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS qi_project_data (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                project_id INTEGER NOT NULL,
                data TEXT NOT NULL,
                created_at TEXT DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (project_id) REFERENCES qi_projects (id) ON DELETE CASCADE
            )
        ''')

        # Add day_of_week column to existing visits table if it doesn't exist
        try:
            cursor.execute('ALTER TABLE visits ADD COLUMN day_of_week TEXT')
        except sqlite3.OperationalError:
            pass  # Column already exists

        # Initialize default wRVU conversion rate if not set
        cursor.execute('SELECT value FROM settings WHERE key = ?', ('wrvu_conversion_rate',))
        if not cursor.fetchone():
            cursor.execute('INSERT INTO settings (key, value) VALUES (?, ?)',
                         ('wrvu_conversion_rate', '36.00'))

        conn.commit()
        conn.close()

    # Visit operations
    def create_visit(self, visit_data: Dict[str, Any]) -> int:
        """Create a new visit record"""
        conn = self.get_connection()
        cursor = conn.cursor()

        # Calculate day of week from date
        visit_date = visit_data.get('date')
        if visit_date:
            day_of_week = datetime.fromisoformat(visit_date).strftime('%A')
        else:
            day_of_week = None

        cursor.execute('''
            INSERT INTO visits (date, start_time, end_time, active_duration,
                              visit_type, billing_code, comments, custom_fields, day_of_week)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''', (
            visit_data.get('date'),
            visit_data.get('start_time'),
            visit_data.get('end_time'),
            visit_data.get('active_duration', 0),
            visit_data.get('visit_type'),
            visit_data.get('billing_code'),
            visit_data.get('comments'),
            json.dumps(visit_data.get('custom_fields', {})),
            day_of_week
        ))

        visit_id = cursor.lastrowid
        conn.commit()
        conn.close()
        return visit_id

    def get_visits(self, start_date: Optional[str] = None,
                   end_date: Optional[str] = None) -> List[Dict]:
        """Get visits within date range"""
        conn = self.get_connection()
        cursor = conn.cursor()

        if start_date and end_date:
            cursor.execute('''
                SELECT * FROM visits
                WHERE date BETWEEN ? AND ?
                ORDER BY date DESC, start_time DESC
            ''', (start_date, end_date))
        elif start_date:
            cursor.execute('''
                SELECT * FROM visits
                WHERE date >= ?
                ORDER BY date DESC, start_time DESC
            ''', (start_date,))
        else:
            cursor.execute('SELECT * FROM visits ORDER BY date DESC, start_time DESC')

        visits = []
        for row in cursor.fetchall():
            visit = dict(row)
            visit['custom_fields'] = json.loads(visit['custom_fields']) if visit['custom_fields'] else {}
            visits.append(visit)

        conn.close()
        return visits

    def get_visits_by_date(self, target_date: str) -> List[Dict]:
        """Get all visits for a specific date"""
        return self.get_visits(start_date=target_date, end_date=target_date)

    def update_visit(self, visit_id: int, visit_data: Dict[str, Any]):
        """Update an existing visit"""
        conn = self.get_connection()
        cursor = conn.cursor()

        # Build dynamic update query based on provided fields
        update_fields = []
        values = []

        for field in ['end_time', 'active_duration', 'visit_type', 'billing_code', 'comments']:
            if field in visit_data:
                update_fields.append(f"{field} = ?")
                values.append(visit_data[field])

        if 'custom_fields' in visit_data:
            update_fields.append("custom_fields = ?")
            values.append(json.dumps(visit_data['custom_fields']))

        if update_fields:
            values.append(visit_id)
            query = f"UPDATE visits SET {', '.join(update_fields)} WHERE id = ?"
            cursor.execute(query, values)
            conn.commit()

        conn.close()

    def delete_visit(self, visit_id: int):
        """Delete a visit"""
        conn = self.get_connection()
        cursor = conn.cursor()
        cursor.execute('DELETE FROM visits WHERE id = ?', (visit_id,))
        conn.commit()
        conn.close()

    # Custom field operations
    def create_custom_field(self, field_name: str, field_type: str,
                           options: Optional[List[str]] = None):
        """Create a new custom field configuration"""
        conn = self.get_connection()
        cursor = conn.cursor()

        cursor.execute('''
            INSERT INTO custom_fields (field_name, field_type, options)
            VALUES (?, ?, ?)
        ''', (field_name, field_type, json.dumps(options) if options else None))

        conn.commit()
        conn.close()

    def get_custom_fields(self) -> List[Dict]:
        """Get all custom field configurations"""
        conn = self.get_connection()
        cursor = conn.cursor()

        cursor.execute('SELECT * FROM custom_fields ORDER BY id')

        fields = []
        for row in cursor.fetchall():
            field = dict(row)
            field['options'] = json.loads(field['options']) if field['options'] else None
            fields.append(field)

        conn.close()
        return fields

    def delete_custom_field(self, field_id: int):
        """Delete a custom field configuration"""
        conn = self.get_connection()
        cursor = conn.cursor()
        cursor.execute('DELETE FROM custom_fields WHERE id = ?', (field_id,))
        conn.commit()
        conn.close()

    # Work day operations
    def start_work_day(self, work_date: str):
        """Mark the start of a work day"""
        conn = self.get_connection()
        cursor = conn.cursor()

        cursor.execute('''
            INSERT OR IGNORE INTO work_days (date)
            VALUES (?)
        ''', (work_date,))

        conn.commit()
        conn.close()

    def end_work_day(self, work_date: str, notes: Optional[str] = None):
        """Mark the end of a work day"""
        conn = self.get_connection()
        cursor = conn.cursor()

        cursor.execute('''
            UPDATE work_days
            SET ended_at = ?, notes = ?
            WHERE date = ?
        ''', (datetime.now().isoformat(), notes, work_date))

        conn.commit()
        conn.close()

    # Settings operations
    def get_setting(self, key: str, default: Optional[str] = None) -> Optional[str]:
        """Get a setting value"""
        conn = self.get_connection()
        cursor = conn.cursor()

        cursor.execute('SELECT value FROM settings WHERE key = ?', (key,))
        row = cursor.fetchone()

        conn.close()
        return row['value'] if row else default

    def set_setting(self, key: str, value: str):
        """Set a setting value"""
        conn = self.get_connection()
        cursor = conn.cursor()

        cursor.execute('''
            INSERT OR REPLACE INTO settings (key, value, updated_at)
            VALUES (?, ?, ?)
        ''', (key, value, datetime.now().isoformat()))

        conn.commit()
        conn.close()

    def get_wrvu_conversion_rate(self) -> float:
        """Get the wRVU to dollar conversion rate"""
        rate = self.get_setting('wrvu_conversion_rate', '36.00')
        return float(rate)

    def set_wrvu_conversion_rate(self, rate: float):
        """Set the wRVU to dollar conversion rate"""
        self.set_setting('wrvu_conversion_rate', str(rate))

    # QI Project operations
    def create_qi_project(self, name: str, description: str, variables: List[Dict]) -> int:
        """Create a new QI project"""
        conn = self.get_connection()
        cursor = conn.cursor()

        cursor.execute('''
            INSERT INTO qi_projects (name, description, variables)
            VALUES (?, ?, ?)
        ''', (name, description, json.dumps(variables)))

        project_id = cursor.lastrowid
        conn.commit()
        conn.close()
        return project_id

    def get_qi_projects(self) -> List[Dict]:
        """Get all QI projects"""
        conn = self.get_connection()
        cursor = conn.cursor()

        cursor.execute('SELECT * FROM qi_projects ORDER BY updated_at DESC')

        projects = []
        for row in cursor.fetchall():
            project = dict(row)
            project['variables'] = json.loads(project['variables'])

            # Get entry count for this project
            cursor.execute('SELECT COUNT(*) as count FROM qi_project_data WHERE project_id = ?',
                         (project['id'],))
            count_row = cursor.fetchone()
            project['entry_count'] = count_row['count'] if count_row else 0

            projects.append(project)

        conn.close()
        return projects

    def get_qi_project(self, project_id: int) -> Optional[Dict]:
        """Get a specific QI project"""
        conn = self.get_connection()
        cursor = conn.cursor()

        cursor.execute('SELECT * FROM qi_projects WHERE id = ?', (project_id,))
        row = cursor.fetchone()

        if row:
            project = dict(row)
            project['variables'] = json.loads(project['variables'])
            conn.close()
            return project

        conn.close()
        return None

    def update_qi_project(self, project_id: int, name: str, description: str, variables: List[Dict]):
        """Update a QI project"""
        conn = self.get_connection()
        cursor = conn.cursor()

        cursor.execute('''
            UPDATE qi_projects
            SET name = ?, description = ?, variables = ?, updated_at = ?
            WHERE id = ?
        ''', (name, description, json.dumps(variables), datetime.now().isoformat(), project_id))

        conn.commit()
        conn.close()

    def delete_qi_project(self, project_id: int):
        """Delete a QI project and all its data"""
        conn = self.get_connection()
        cursor = conn.cursor()

        # Delete project data first
        cursor.execute('DELETE FROM qi_project_data WHERE project_id = ?', (project_id,))
        # Delete project
        cursor.execute('DELETE FROM qi_projects WHERE id = ?', (project_id,))

        conn.commit()
        conn.close()

    def create_qi_project_entry(self, project_id: int, data: Dict) -> int:
        """Create a new data entry for a QI project"""
        conn = self.get_connection()
        cursor = conn.cursor()

        cursor.execute('''
            INSERT INTO qi_project_data (project_id, data)
            VALUES (?, ?)
        ''', (project_id, json.dumps(data)))

        # Update project's updated_at timestamp
        cursor.execute('''
            UPDATE qi_projects
            SET updated_at = ?
            WHERE id = ?
        ''', (datetime.now().isoformat(), project_id))

        entry_id = cursor.lastrowid
        conn.commit()
        conn.close()
        return entry_id

    def get_qi_project_entries(self, project_id: int) -> List[Dict]:
        """Get all data entries for a QI project"""
        conn = self.get_connection()
        cursor = conn.cursor()

        cursor.execute('''
            SELECT * FROM qi_project_data
            WHERE project_id = ?
            ORDER BY created_at DESC
        ''', (project_id,))

        entries = []
        for row in cursor.fetchall():
            entry = dict(row)
            entry['data'] = json.loads(entry['data'])
            entries.append(entry)

        conn.close()
        return entries

    def delete_qi_project_entry(self, entry_id: int):
        """Delete a QI project data entry"""
        conn = self.get_connection()
        cursor = conn.cursor()
        cursor.execute('DELETE FROM qi_project_data WHERE id = ?', (entry_id,))
        conn.commit()
        conn.close()

# Helper function to calculate wRVUs for a visit
def calculate_wrvu(billing_codes: str) -> float:
    """Calculate total wRVU from billing code(s)"""
    if not billing_codes:
        return 0.0

    # Handle both single code (string) and multiple codes (JSON array)
    try:
        codes = json.loads(billing_codes) if billing_codes.startswith('[') else [billing_codes]
    except:
        codes = [billing_codes]

    total_wrvu = 0.0
    for code in codes:
        code = code.strip()
        if code in WRVU_LOOKUP:
            total_wrvu += WRVU_LOOKUP[code]['wrvu']

    return total_wrvu
