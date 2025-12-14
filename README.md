# Session-Burner

## A speed-first Tor burner browsing launcher for Linux systems that cannot run Tor Browser (no SSE2, minimal systems, VMs, older CPUs).

This tool launches disposable Firefox sessions routed through Tor, with:

- RAM-only browser profiles
- DNS fully tunneled through Tor
- Automatic Tor circuit refresh between sessions
- Lightweight fingerprint resistance
- Zero disk persistence
  
Each run creates a fresh, isolated browsing identity and destroys it on exit.

⚙️ Requirements
Mandatory
- Tor daemon running
- Firefox (ESR recommended)
- Optional (but recommended)
  Tor control port enabled (9051),
  netcat (nc) for circuit refresh

📦 Installation Requirements
1. Install and Start Tor
```
sudo apt update
sudo apt install tor
sudo systemctl start tor
```


2. Verify:

``` 
curl --socks5-hostname 127.0.0.1:9050 https://check.torproject.org
```

(Optional) Enable Tor Control Port

Edit:
```
sudo nano /etc/tor/torrc
ControlPort 9051
CookieAuthentication 1
```

3. Restart Tor
```
sudo systemctl restart tor
```

🚀 Installation

Clone the repo:

```
git clone https://github.com/YOURNAME/session-burner.git
cd session-burner
chmod +x session-burner.sh
```

▶️ Usage
```
./session-burner.sh
```


What happens:

- New Tor circuit requested
- Temporary Firefox profile created in RAM
- Firefox launches through Tor
- DuckDuckGo opens automatically
- On exit → profile is destroyed
- Run it again = new identity

🧼 Burner Session Guarantees

- No cookies saved
- No cache saved
- No history saved
- No DNS leaks
- No WebRTC leaks
- No disk artifacts
- No profile reuse

⚡ Speed Philosophy

This project prioritizes:

- Low latency
- Minimal Tor overhead
- No mid-session circuit rotation
- No heavy Tor Browser patches

Trade-off:

- Less fingerprint uniformity than Tor Browser
- Much faster browsing

🧠 Usage Recommendations

Do:

- One task per session
- Close browser when done
- Relaunch for new identity

Don’t:

- Log into personal accounts
- Install extensions
- Reuse sessions for days
