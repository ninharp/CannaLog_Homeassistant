# CannaLog Home Assistant Add-on Installation Instructions

## Quick Start

1. **Add Repository to Home Assistant:**
   - Go to Supervisor → Add-on Store → ⋮ (three dots) → Repositories
   - Add this URL: `https://github.com/ninharp/CannaLog_Homeassistant`
   - Click "Add"

2. **Install the Add-on:**
   - Find "CannaLog" in your add-on store
   - Click "Install"
   - Wait for installation to complete

3. **Configure the Add-on:**
   ```yaml
   secret_key: "your-very-secret-key-change-this"
   debug: false
   ```

4. **Start the Add-on:**
   - Click "Start"
   - Wait for startup to complete

5. **Access CannaLog:**
   - Look for "CannaLog" in your Home Assistant sidebar
   - Default login: username `admin`, password `admin123`
   - **Important:** Change the default password immediately!

## Default Credentials

- **Username:** `admin`
- **Password:** `admin123`

⚠️ **Change these credentials immediately after first login for security!**

## Data Storage

All your data is stored persistently in:
- Database: `/share/cannalog/database/cannalog.db`
- Uploaded images: `/share/cannalog/uploads/`

This ensures your data survives add-on updates and restarts.

## Configuration Options

### `secret_key`
- **Required:** Yes
- **Purpose:** Used for session security
- **Recommendation:** Generate a random 32+ character string

### `debug`
- **Required:** No
- **Default:** `false`
- **Purpose:** Enable debug logging (only for troubleshooting)

## Features

✅ Plant management with images and notes  
✅ Environment tracking and monitoring  
✅ Measurement logging (temperature, humidity, pH, EC, etc.)  
✅ Plant action logging (watering, fertilizing, repotting)  
✅ Responsive design for mobile and desktop  
✅ Full Home Assistant sidebar integration  
✅ Persistent data storage  

## Troubleshooting

### Add-on won't start
1. Check the add-on logs for error messages
2. Ensure your `secret_key` is set
3. Verify you have sufficient storage space

### Can't access from sidebar
1. Ensure the add-on is started
2. Check that ingress is enabled in the add-on configuration
3. Try refreshing your browser

### Lost data after update
- Data should persist automatically in `/share/cannalog/`
- Check if the directory exists and has the correct permissions

## Support

- GitHub Issues: [CannaLog_Homeassistant](https://github.com/ninharp/CannaLog_Homeassistant/issues)
- Original App: [CannaLog](https://github.com/ninharp/CannaLog)

## Security Notes

- Always change default credentials
- Use a strong, unique secret key
- Keep the add-on updated
- Don't enable debug mode in production