#!/bin/bash
# M-Sphere → TestFlight in einem Schritt (vollautomatisch)
set -e

cd "$(dirname "$0")"

# App Store Connect API credentials
API_KEY_ID="F85P37325X"
API_ISSUER_ID="4627ad62-2172-4547-b5cb-47ec323ce2ee"
API_KEY_PATH="$(pwd)/.keys/AuthKey_${API_KEY_ID}.p8"
BUNDLE_ID="de.jochenhornung.msphere"

# Build-Nummer automatisch hochzählen
CURRENT=$(grep 'CURRENT_PROJECT_VERSION' project.yml | head -1 | sed 's/.*"\([0-9]*\)".*/\1/')
NEXT=$((CURRENT + 1))
sed -i '' "s/CURRENT_PROJECT_VERSION: \"$CURRENT\"/CURRENT_PROJECT_VERSION: \"$NEXT\"/" project.yml
echo "📦 Build $NEXT"

# Projekt generieren
xcodegen generate 2>&1 | tail -1

# Archivieren
echo "🔨 Archiviere..."
rm -rf /tmp/MSphere.xcarchive /tmp/MSphereExport
xcodebuild archive \
  -project MSphere.xcodeproj \
  -scheme MSphere \
  -archivePath /tmp/MSphere.xcarchive \
  -destination 'generic/platform=iOS' \
  -allowProvisioningUpdates \
  -quiet

# Hochladen mit API-Key (überspringt Compliance automatisch dank Info.plist)
echo "🚀 Lade zu TestFlight hoch..."
xcodebuild -exportArchive \
  -archivePath /tmp/MSphere.xcarchive \
  -exportOptionsPlist "$(pwd)/ExportOptions.plist" \
  -exportPath /tmp/MSphereExport \
  -allowProvisioningUpdates \
  -authenticationKeyPath "$API_KEY_PATH" \
  -authenticationKeyID "$API_KEY_ID" \
  -authenticationKeyIssuerID "$API_ISSUER_ID" \
  2>&1 | grep -E "Upload succeeded|EXPORT|error:"

echo "⏳ Warte auf Build-Verarbeitung..."
sleep 30

# JWT-Token generieren für App Store Connect API (Python — openssl dgst erzeugt DER, JWT braucht Raw R||S)
JWT=$(python3 -c "
import json, base64, time
from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric import ec, utils

def b64url(data):
    if isinstance(data, str): data = data.encode()
    return base64.urlsafe_b64encode(data).rstrip(b'=').decode()

key_path = '$API_KEY_PATH'
key_id = '$API_KEY_ID'
issuer_id = '$API_ISSUER_ID'

with open(key_path, 'rb') as f:
    private_key = serialization.load_pem_private_key(f.read(), password=None)

now = int(time.time())
header = b64url(json.dumps({'alg': 'ES256', 'kid': key_id, 'typ': 'JWT'}))
payload = b64url(json.dumps({'iss': issuer_id, 'iat': now, 'exp': now + 1200, 'aud': 'appstoreconnect-v1'}))
unsigned = f'{header}.{payload}'

der_sig = private_key.sign(unsigned.encode(), ec.ECDSA(hashes.SHA256()))
r, s = utils.decode_dss_signature(der_sig)
raw_sig = r.to_bytes(32, 'big') + s.to_bytes(32, 'big')
signature = b64url(raw_sig)

print(f'{unsigned}.{signature}')
")

# App-ID finden
echo "🔍 Suche App..."
APP_RESPONSE=$(curl -s -H "Authorization: Bearer $JWT" \
  "https://api.appstoreconnect.apple.com/v1/apps?filter[bundleId]=$BUNDLE_ID")
APP_ID=$(echo "$APP_RESPONSE" | python3 -c "import sys,json; print(json.load(sys.stdin)['data'][0]['id'])" 2>/dev/null)

if [ -z "$APP_ID" ]; then
  echo "⚠️  App nicht gefunden. Build ist hochgeladen — Gruppe manuell zuweisen."
  exit 0
fi

# Neuesten Build finden (mit Retries)
echo "🔍 Suche Build $NEXT..."
BUILD_ID=""
for i in 1 2 3 4 5 6; do
  BUILD_RESPONSE=$(curl -s -H "Authorization: Bearer $JWT" \
    "https://api.appstoreconnect.apple.com/v1/builds?filter[app]=$APP_ID&filter[version]=$NEXT&sort=-uploadedDate&limit=1")
  BUILD_ID=$(echo "$BUILD_RESPONSE" | python3 -c "import sys,json; d=json.load(sys.stdin)['data']; print(d[0]['id'] if d else '')" 2>/dev/null)
  if [ -n "$BUILD_ID" ]; then break; fi
  echo "   Noch nicht bereit, warte 30s... ($i/6)"
  sleep 30
done

if [ -z "$BUILD_ID" ]; then
  echo "⚠️  Build noch nicht verarbeitet. Upload war erfolgreich — Gruppe manuell zuweisen."
  exit 0
fi

# Testgruppen finden
GROUPS_RESPONSE=$(curl -s -H "Authorization: Bearer $JWT" \
  "https://api.appstoreconnect.apple.com/v1/apps/$APP_ID/betaGroups")
GROUP_IDS=$(echo "$GROUPS_RESPONSE" | python3 -c "
import sys,json
groups = json.load(sys.stdin)['data']
for g in groups:
    print(g['id'])
" 2>/dev/null)

# Build allen Gruppen zuweisen
for GID in $GROUP_IDS; do
  curl -s -X POST -H "Authorization: Bearer $JWT" -H "Content-Type: application/json" \
    "https://api.appstoreconnect.apple.com/v1/betaGroups/$GID/relationships/builds" \
    -d "{\"data\":[{\"type\":\"builds\",\"id\":\"$BUILD_ID\"}]}" > /dev/null
done

GROUP_COUNT=$(echo "$GROUP_IDS" | wc -l | tr -d ' ')
echo "✅ Build $NEXT ist bei TestFlight und $GROUP_COUNT Gruppen zugewiesen!"
