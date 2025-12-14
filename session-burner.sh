#!/usr/bin/env bash
set -euo pipefail

####################################
# CONFIG
####################################
TOR_SOCKS="127.0.0.1:9050"
TOR_CONTROL="127.0.0.1:9051"
START_URL="https://duckduckgo.com"

####################################
# USER-AGENT POOL (SAFE, COMMON)
####################################
UAS=(
"Mozilla/5.0 (X11; Linux x86_64; rv:115.0) Gecko/20100101 Firefox/115.0"
"Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0"
"Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:115.0) Gecko/20100101 Firefox/115.0"
)

UA="${UAS[$RANDOM % ${#UAS[@]}]}"

####################################
# RAM-ONLY PROFILE
####################################
BURNER_DIR="$(mktemp -d /dev/shm/tor-burner-XXXXXX)"

####################################
# Tor circuit refresh (BEST EFFORT)
####################################
refresh_tor() {
  if command -v nc >/dev/null 2>&1; then
    {
      echo "AUTHENTICATE"
      echo "SIGNAL NEWNYM"
      echo "QUIT"
    } | nc 127.0.0.1 9051 >/dev/null 2>&1 || true
  fi
}

refresh_tor

####################################
# Firefox hardening
####################################
cat > "$BURNER_DIR/user.js" << EOF
// --- Proxy ---
user_pref("network.proxy.type", 1);
user_pref("network.proxy.socks", "127.0.0.1");
user_pref("network.proxy.socks_port", 9050);
user_pref("network.proxy.socks_version", 5);
user_pref("network.proxy.socks_remote_dns", true);

// --- Network safety ---
user_pref("network.dns.disableIPv6", true);
user_pref("media.peerconnection.enabled", false);

// --- No persistence ---
user_pref("browser.cache.disk.enable", false);
user_pref("browser.cache.memory.enable", false);
user_pref("browser.cache.offline.enable", false);
user_pref("privacy.sanitize.sanitizeOnShutdown", true);
user_pref("privacy.clearOnShutdown.cache", true);
user_pref("privacy.clearOnShutdown.cookies", true);
user_pref("privacy.clearOnShutdown.history", true);
user_pref("privacy.clearOnShutdown.sessions", true);
user_pref("privacy.clearOnShutdown.offlineApps", true);

// --- Fingerprinting (balanced) ---
user_pref("privacy.resistFingerprinting", true);
user_pref("privacy.firstparty.isolate", true);

// --- UA ---
user_pref("general.useragent.override", "$UA");

// --- Disable noise ---
user_pref("toolkit.telemetry.enabled", false);
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("browser.shell.checkDefaultBrowser", false);
EOF

####################################
# Launch
####################################
echo "[+] Tor burner session starting"
echo "[+] UA: $UA"

firefox \
  --no-remote \
  --new-instance \
  --profile "$BURNER_DIR" \
  "$START_URL"

####################################
# Cleanup
####################################
rm -rf "$BURNER_DIR"
echo "[+] Session destroyed (RAM wiped)"
