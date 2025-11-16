# Clinic Visit Tracker - Deployment Guide

## Option 1: Simple Launcher (Easiest - Mac Only) ⭐ RECOMMENDED FOR PERSONAL USE

### For You (Current User):
1. Simply **double-click** `launch_clinic_tracker.command`
2. Your browser will open automatically to the app
3. Press `Ctrl+C` in the terminal window to stop

**First time only**: Right-click the file → "Open With" → "Terminal" and allow it to run.

---

## Option 2: Standalone Executable (Good for Sharing on Same OS)

This creates a single executable file you can share with others on macOS (or Windows/Linux if you build on those systems).

### Using PyInstaller:

```bash
# Install PyInstaller
pip install pyinstaller

# Create standalone app (macOS)
pyinstaller --onefile --add-data "templates:templates" --add-data "static:static" --name "ClinicTracker" app.py

# The app will be in: dist/ClinicTracker
```

**Pros**: Single file, no Python needed on target computer
**Cons**: Large file size (~50MB), needs to be rebuilt for each OS

---

## Option 3: Docker Container (Best for Cross-Platform Sharing)

This works on **any** computer with Docker (Windows, Mac, Linux).

### Create Dockerfile:

```dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["python", "app.py"]
```

### Usage:

```bash
# Build the image
docker build -t clinic-tracker .

# Run the container
docker run -p 5000:5000 -v $(pwd)/clinic_tracker.db:/app/clinic_tracker.db clinic-tracker

# Access at: http://localhost:5000
```

**Pros**: Works on any OS, professional, isolated environment
**Cons**: Requires Docker installed, ~100MB download

---

## Option 4: macOS App Bundle (Most Native Feel - Mac Only)

Create a true macOS `.app` that appears in your Applications folder.

### Using py2app:

```bash
# Install py2app
pip install py2app

# Create setup.py
cat > setup.py << 'EOF'
from setuptools import setup

APP = ['app.py']
DATA_FILES = [('templates', ['templates/']), ('static', ['static/'])]
OPTIONS = {
    'argv_emulation': True,
    'packages': ['flask', 'pandas', 'openpyxl'],
}

setup(
    app=APP,
    data_files=DATA_FILES,
    options={'py2app': OPTIONS},
    setup_requires=['py2app'],
)
EOF

# Build the app
python setup.py py2app

# Find your app in: dist/app.app
```

**Pros**: Native macOS app, appears in Applications, can have custom icon
**Cons**: Mac only, requires code signing for distribution

---

## Option 5: Cloud Deployment (Access from Anywhere)

Deploy to a cloud service so you can access from any device with internet.

### Free Options:

1. **Render.com** (Free tier)
   - Push to GitHub
   - Connect Render to your repo
   - Auto-deploys on push
   - Get a URL like: `clinic-tracker.onrender.com`

2. **PythonAnywhere** (Free tier)
   - Upload your code
   - Configure WSGI
   - Get URL like: `yourusername.pythonanywhere.com`

3. **Fly.io** (Free tier)
   - Install flyctl
   - Run `fly launch`
   - Get URL like: `clinic-tracker.fly.dev`

**Pros**: Access from anywhere, automatic backups, no installation
**Cons**: Requires internet, data privacy considerations

---

## Recommended Approach by Use Case:

| Use Case | Recommended Option | Why |
|----------|-------------------|-----|
| **Just for you on your Mac** | Option 1: Simple Launcher | Easiest, no extra setup |
| **Share with Mac-using colleagues** | Option 4: macOS App Bundle | Professional, easy for them |
| **Share with Windows/Linux users** | Option 3: Docker | Cross-platform, consistent |
| **Access from multiple devices** | Option 5: Cloud (Render.com) | Available anywhere |
| **Give to non-technical users** | Option 2: PyInstaller | Single file, no dependencies |

---

## For Sharing: What to Include

If you share with others, they'll need:

1. **The executable/app** (from PyInstaller, py2app, or Docker)
2. **Instructions**: "Double-click to run, access at localhost:5000"
3. **Note**: Database file (`clinic_tracker.db`) stores all data locally

### Security Note:
This app is designed for **local use only**. If deploying to the cloud:
- Add authentication (user login)
- Use HTTPS
- Add environment variables for secrets
- Consider HIPAA compliance if storing patient data

---

## Quick Start for Most Users:

**For personal use**: Just double-click `launch_clinic_tracker.command` ✅

**To share with friends**: Use Docker or create a PyInstaller executable
