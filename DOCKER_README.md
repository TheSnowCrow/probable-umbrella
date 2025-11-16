# Running Clinic Tracker with Docker

Docker is the **easiest way to share this app** with others on any operating system (Windows, Mac, Linux).

## For You (First Time Setup):

1. **Install Docker Desktop**: Download from [docker.com](https://www.docker.com/products/docker-desktop)

2. **Build the image** (one time):
   ```bash
   docker build -t clinic-tracker .
   ```

3. **Run the app**:
   ```bash
   docker run -p 5000:5000 -v $(pwd)/clinic_tracker.db:/app/clinic_tracker.db clinic-tracker
   ```

4. **Open browser**: Go to `http://localhost:5000`

5. **To stop**: Press `Ctrl+C` in the terminal

## For Sharing with Others:

### Option A: Share Docker Image (Recommended)

1. **Save the image to a file**:
   ```bash
   docker save clinic-tracker -o clinic-tracker.tar
   ```

2. **Share the file** `clinic-tracker.tar` (will be ~200MB)

3. **They load it**:
   ```bash
   docker load -i clinic-tracker.tar
   ```

4. **They run it**:
   ```bash
   docker run -p 5000:5000 clinic-tracker
   ```

### Option B: Push to Docker Hub (Public)

1. **Create account** at [hub.docker.com](https://hub.docker.com)

2. **Tag and push**:
   ```bash
   docker tag clinic-tracker yourusername/clinic-tracker
   docker push yourusername/clinic-tracker
   ```

3. **Others can pull and run**:
   ```bash
   docker pull yourusername/clinic-tracker
   docker run -p 5000:5000 yourusername/clinic-tracker
   ```

## Benefits of Docker:

✅ **Cross-platform**: Works on Windows, Mac, and Linux
✅ **No Python needed**: Everything bundled in container
✅ **Consistent**: Same environment everywhere
✅ **Isolated**: Doesn't interfere with other software
✅ **Easy updates**: Just rebuild and share new image

## Persistent Data:

To keep your database between runs, always use the volume mount:

```bash
docker run -p 5000:5000 -v $(pwd)/clinic_tracker.db:/app/clinic_tracker.db clinic-tracker
```

This saves the database file on your computer, not inside the container.
