# YAFAR: Yet Another Fortnite AFK Reminder

![YAFAR Logo](Assets/logo.ico)

**YAFAR** is a lightweight WPF application designed to help Fortnite players stay active and track AFK (Away From Keyboard) time, while also reminding them to collect Gold XP Coins from creative maps. It's easy to use.

---

![Screenshot 1](screenshots/1.png)

<details>
  <summary>📸 View Fortnite screenshot with Yafar.exe</summary>

  <br>

  <img src="screenshots/3.png" alt="Screenshot 3" width="100%">

</details>

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Requirements](#requirements)
- [Source Code](#source-code)
- [Contributing](#contributing)
- [License](#license)
- [Author](#author)

---

## Features

- **Gold Coins Reminder:** Set a timer to get notified when it's time to collect your gold coins.
- **AFK Countdown:** Track inactivity and receive alerts if you've been idle too long.
- **Customizable Timers:** Enter your preferred duration (up to 2 hours) for each timer.
- **Visual & Audio Alerts:** Popups with sound notifications.
- **Cross-functional UI:** Clean WPF interface with background image, shadows, and modern buttons.
- **Safe to Use:** Does not require administrator privileges and does **not interfere with Fortnite** or any other program—it only shows reminders.

---

## Installation

Make sure the `Yafar.exe` is always in the **same folder as the `Assets` folder**.  
The application will not show the background or play sounds if this structure is not maintained.

You can place it in your Downloads folder, on the Desktop, or in the root of `C:\`.

Example:

C:\Yafar\
- Yafar.exe
- Assets\
    - background.png
    - xp.png
    - logo.ico
    - reminder.wav

    
**Run `Yafar.exe` directly.** No administrator privileges are required.

> You can download the latest release from the [Releases](https://github.com/BraVRom/YAFAR-AFK/releases) page as `Yafar.zip`.

---

## Usage

1. Launch `Yafar.exe`.
2. Enter your desired minutes for **Gold XP Coins** and **AFK timers**.
3. Click the **Start Coins Timer** or **Start AFK Timer** buttons.
4. Popups will notify you when timers reach zero.

![Screenshot 2](screenshots/2.png)

> ⚠️ Reminder: YAFAR is a safe reminder tool. It does **not interfere with Fortnite** Easy Anti-Cheat, or any other programs. It simply alerts you to move and collect coins.

## ⚠️ Antivirus & False Positives

Some antivirus engines may flag **Yafar.exe** as suspicious.  
This is a **false positive**.

YAFAR is built from a simple PowerShell script (`Yafar.ps1`) using **ps2exe**, a common method that many heuristic-based antivirus scanners misinterpret as malicious because:

- It is a script converted into an executable  
- It shows popups and plays sounds  
- It uses idle detection and timers  
- It is not digitally signed  
- It is a small custom tool not recognized by reputation databases  

**YAFAR does *not* contain any malicious code.**  
If you don’t trust the provided executable, you can compile it yourself.

### 🔧 Compile it yourself (optional)

If you want to generate your own EXE:

1. Download the original script: `Yafar.ps1`
2. Install **ps2exe**:  
   ```powershell
   Install-Module ps2exe
Compile the tool manually:
```powershell`
ps2exe Yafar.ps1 Yafar.exe -noConsole```

This will create the exact same executable that the project ships in the Releases section.

---

## Requirements

- Windows 10 or higher
- No administrator privileges needed
- .NET Framework 4.7+ (for WPF)

---

## Source Code

If you want to review the code yourself, the full source is available in [`Yafar.ps1`](Yafar.ps1).  

---

## Contributing

Contributions are welcome! Please submit **issues**, **feature requests**, or **pull requests** through GitHub.

---

## License

This project is licensed under the **MIT License**. See `LICENSE` for details.

---

## Author

**Br4hx** – [GitHub](https://github.com/BraVRom)
