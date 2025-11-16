import sqlite3
import json
from datetime import datetime, date
from typing import List, Dict, Optional, Any

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

        conn.commit()
        conn.close()

    # Visit operations
    def create_visit(self, visit_data: Dict[str, Any]) -> int:
        """Create a new visit record"""
        conn = self.get_connection()
        cursor = conn.cursor()

        cursor.execute('''
            INSERT INTO visits (date, start_time, end_time, active_duration,
                              visit_type, billing_code, comments, custom_fields)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        ''', (
            visit_data.get('date'),
            visit_data.get('start_time'),
            visit_data.get('end_time'),
            visit_data.get('active_duration', 0),
            visit_data.get('visit_type'),
            visit_data.get('billing_code'),
            visit_data.get('comments'),
            json.dumps(visit_data.get('custom_fields', {}))
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
