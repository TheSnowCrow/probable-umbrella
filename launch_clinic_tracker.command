#!/bin/bash
# Clinic Visit Tracker Launcher

# Get the directory where this script is located
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"

# Activate virtual environment if it exists
if [ -d "venv" ]; then
    source venv/bin/activate
fi

# Start Flask server in background
echo "Starting Clinic Visit Tracker..."
python app.py &
FLASK_PID=$!

# Wait for server to start
sleep 2

# Open browser
echo "Opening browser..."
open http://127.0.0.1:5000

# Keep terminal open and wait for user to press Ctrl+C
echo ""
echo "✅ Clinic Visit Tracker is running!"
echo "🌐 Access it at: http://127.0.0.1:5000"
echo ""
echo "Press Ctrl+C to stop the server"

# Wait for Flask process
wait $FLASK_PID
