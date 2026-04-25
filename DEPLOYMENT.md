# Firebase Deployment Guide

This guide covers deploying the Adhikar app with Firebase Cloud Functions.

## Prerequisites

- Firebase CLI installed: `npm install -g firebase-tools`
- Firebase project created
- Node.js 18+ installed

## Step 1: Initialize Firebase

```bash
firebase login
firebase init
```

Select:
- Firestore: Configure security rules
- Functions: Configure Cloud Functions
- Storage: Configure security rules
- Hosting: (optional, for web dashboard)

## Step 2: Configure Cloud Functions

```bash
cd functions
npm install
```

Set Gemini API key:

**Option 1: Environment Variables**
```bash
echo "GEMINI_API_KEY=your_key_here" > .env
```

**Option 2: Firebase Config**
```bash
firebase functions:config:set gemini.key=YOUR_KEY
```

## Step 3: Deploy Security Rules

```bash
# Deploy Firestore rules
firebase deploy --only firestore:rules

# Deploy Storage rules
firebase deploy --only storage
```

## Step 4: Deploy Cloud Functions

```bash
# Deploy all functions
firebase deploy --only functions

# Deploy specific function
firebase deploy --only functions:extractProfile
```

## Step 5: Sync Schemes to Firestore

After deploying, sync the schemes database:

```bash
# Call the sync function
firebase functions:shell
> syncSchemes()
```

Or create an admin script to upload schemes from JSON:

```javascript
const admin = require('firebase-admin');
const serviceAccount = require('./service-account-key.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();
const schemes = require('./schemes_data.json');

async function syncSchemes() {
  const batch = db.batch();
  
  schemes.forEach(scheme => {
    const ref = db.collection('schemes').doc(scheme.id);
    batch.set(ref, { ...scheme, is_active: true });
  });
  
  await batch.commit();
  console.log('Schemes synced successfully');
}

syncSchemes().catch(console.error);
```

## Step 6: Create Firestore Indexes

Create `firestore.indexes.json` if not auto-generated:

```json
{
  "indexes": [
    {
      "collectionGroup": "applications",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "user_id", "order": "ASCENDING" },
        { "fieldPath": "created_at", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "applications",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "status", "order": "ASCENDING" },
        { "fieldPath": "created_at", "order": "DESCENDING" }
      ]
    }
  ]
}
```

Deploy indexes:
```bash
firebase deploy --only firestore:indexes
```

## Step 7: Test with Emulators

```bash
firebase emulators:start
```

In another terminal, run Flutter with emulator config:
```bash
flutter run --dart-define-from-file=.env.local
```

Create `.env.local`:
```
FIREBASE_EMULATOR_HOST=localhost:8080
```

## Step 8: Monitor Functions

View logs:
```bash
firebase functions:log
```

View specific function logs:
```bash
firebase functions:log --only extractProfile
```

## Common Issues

### Functions timeout
- Increase timeout in `firebase.json`:
```json
{
  "functions": {
    "timeout": 540
  }
}
```

### Memory limit exceeded
- Increase memory:
```json
{
  "functions": {
    "memory": "1GB"
  }
}
```

### Gemini API quota
- Check quota at console.cloud.google.com
- Use fallback rule-based matching when quota exceeded

## Production Checklist

- [ ] All functions deployed
- [ ] Security rules deployed
- [ ] Storage rules deployed
- [ ] Firestore indexes created
- [ ] Schemes synced to Firestore
- [ ] Gemini API key configured
- [ ] Test with emulators
- [ ] Test on real device
- [ ] Monitor logs for errors
- [ ] Set up alerts for function failures
