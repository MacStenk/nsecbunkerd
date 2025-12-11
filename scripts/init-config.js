const fs = require('fs');
const path = require('path');

const configPath = '/app/config/nsecbunker.json';

// Default config with nip46 relay
const defaultConfig = {
  "nostr": {
    "relays": [
      "wss://nip46.stevennoack.de"
    ]
  },
  "admin": {
    "npubs": [
      "npub1cxa0fa6vmq5evwpgk8dg6ul99ny5e2nd3hy5fa72g598t39nxy0surzuva"
    ],
    "adminRelays": [
      "wss://nip46.stevennoack.de"
    ]
  },
  "database": "sqlite://nsecbunker.db",
  "logs": "./nsecbunker.log",
  "keys": {},
  "verbose": true,
  "version": "0.10.5"
};

// Check if config exists
if (!fs.existsSync(configPath)) {
  console.log('📝 Creating default config...');
  fs.mkdirSync(path.dirname(configPath), { recursive: true });
  fs.writeFileSync(configPath, JSON.stringify(defaultConfig, null, 2));
  console.log('✅ Config created at', configPath);
} else {
  console.log('✅ Config exists at', configPath);
}

// Load existing config
const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));

// Add key if env vars are set and key doesn't exist
const keyName = process.env.NSECBUNKER_KEY;
const keyIv = process.env.NSECBUNKER_KEY_IV;
const keyData = process.env.NSECBUNKER_KEY_DATA;

if (keyName && keyIv && keyData && !config.keys[keyName]) {
  console.log(`🔑 Adding key "${keyName}" from env vars...`);
  config.keys[keyName] = {
    iv: keyIv,
    data: keyData
  };
  fs.writeFileSync(configPath, JSON.stringify(config, null, 2));
  console.log(`✅ Key "${keyName}" added`);
} else if (keyName && config.keys[keyName]) {
  console.log(`✅ Key "${keyName}" already exists`);
}

console.log('📋 Current keys:', Object.keys(config.keys));
