# Antigravity Linux Autoupdater

A lightweight, automated Bash script to seamlessly keep your Google Antigravity installation up to date on Linux x64 systems.

## 🚀 Motivation

Google Antigravity is a fantastic IDE, but Linux users currently face several roadblocks when trying to keep their installations updated. I created this project to solve the following core issues:

### 1. The Built-in Updater Doesn't Work on Linux
Antigravity utilizes the `electron-updater` framework for its built-in "Automatic Check for Updates" toggle. However, on Linux, this officially only supports AppImage distributions. Because Antigravity is distributed as a `.tar.gz` and placed into a system-owned directory like `/usr/share/antigravity`, running the app as a standard user means it lacks the `root` privileges required to overwrite its own files. The built-in updater fails silently.

### 2. No Native Package Manager Support
Currently, Google does not provide an `apt` repository or a `.deb` package for Antigravity. This forces Linux users to manually navigate to the website, download the tarball, delete their old system files, and copy the new ones every single time an update is released.

## 🛠️ Technical Challenges & Solutions

While building this automation script, I overcame several interesting technical hurdles:

- **Compressed Web Responses**: Simply curling the download page failed because Google's servers return Gzip-compressed HTML. I solved this by using the `curl --compressed` flag to properly decode the HTTP response and parse the DOM for the dynamic download link.
- **Inconsistent Extraction Paths**: The tarball extracts into an oddly named `Antigravity-x64` folder rather than a standard `Antigravity` directory. The script dynamically handles this extraction anomaly to ensure files are routed to `/usr/share/antigravity` correctly.
- **Redundant Downloads**: To save bandwidth and time, I implemented a version tracking system. The script parses the exact version hash directly from the dynamically generated Google Cloud Storage download link, compares it against a local `/usr/share/antigravity/installed_version.txt` file, and exits instantly if you are already up to date.
- **Heavy Dependencies**: I explored using third-party download managers like `ab-download-manager` for multi-threaded speed. However, to keep this project completely dependency-free, lightweight, and native to bash, I optimized standard `curl` to handle the job perfectly.

## ⚙️ Installation & Usage

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Harshuqt/Antigravity-autoupdate.git
   cd Antigravity-autoupdate
   ```

2. **Run the updater:**
   ```bash
   ./update.sh
   ```

3. **What to expect:**
   - The script will scrape the latest version from Google's servers.
   - It will check if you already have the latest version installed.
   - If an update is needed, it will securely download and extract the tarball to a temporary directory.
   - You will be prompted for your `sudo` password **only once** at the very end to seamlessly replace the old installation in `/usr/share/antigravity`.

## 🤝 Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## 📄 License
[MIT](https://github.com/Harshuqt/Antigravity-autoupdate/blob/main/LICENSE)
