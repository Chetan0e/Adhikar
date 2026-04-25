# Firestore Database Structure

This document outlines the Firestore collection structure for the Adhikar Firebase-only architecture.

## Collections Overview

```
firestore/
│
├── schemes/                        ← 200+ government schemes (read-only)
│   └── {schemeId}/
│       ├── name: "PM-KISAN"
│       ├── name_hindi: "पीएम-किसान"
│       ├── category: "agriculture"
│       ├── ministry: "Ministry of Agriculture"
│       ├── description: "..."
│       ├── benefit_amount: "₹6000/year"
│       ├── eligibility: { max_income: 120000, min_age: 18, ... }
│       ├── documents_required: ["Aadhar Card", "Land Records"]
│       ├── application_url: "https://..."
│       ├── application_office: "District Agriculture Office"
│       ├── is_active: true
│       └── synced_at: timestamp
│
├── users/                          ← Citizen profiles
│   └── {userId}/
│       ├── profile: { 
│       │     name, age, gender, state, district, caste,
│       │     occupation, annual_income, land_holding,
│       │     is_disabled, is_widow, has_bpl_card, has_aadhar,
│       │     has_bank_account, family_size, children_ages,
│       │     is_pregnant, education_level
│       │   }
│       ├── state: "Bihar"
│       ├── fcm_token: "..." (for push notifications)
│       ├── created_at: timestamp
│       ├── updated_at: timestamp
│       └── token_updated_at: timestamp
│
├── applications/                   ← Submitted applications
│   └── {applicationId}/
│       ├── user_id: string
│       ├── scheme_id: string
│       ├── scheme_name: "PM-KISAN"
│       ├── form_data: { 
│       │     applicant_name, father_name, dob, gender,
│       │     address, mobile, aadhar, bank_account, ifsc
│       │   }
│       ├── documents: [storageUrls]
│       ├── status: "submitted" | "under_review" | "approved" | "rejected" | "pending_documents"
│       ├── status_notes: string
│       ├── reference_number: "ADH20260012345"
│       ├── created_at: timestamp
│       └── last_updated: timestamp
│
├── matches/                        ← Cached Gemini results
│   └── {userId}/
│       ├── results: [ 
│       │     { scheme_id, eligible, confidence, reason, 
│       │       estimated_benefit, missing_documents }
│       │   ]
│       ├── profile_snapshot: { ... }
│       ├── updated_at: timestamp
│       └── total_benefit: number
│
├── notifications/                  ← Reminder queue
│   └── {userId}/
│       └── reminders: [ 
│       │     { scheme_id, message, due_date, sent } 
│       │   ]
│
├── activity_logs/                  ← User activity tracking
│   └── {logId}/
│       ├── user_id: string
│       ├── action: "profile_extracted" | "schemes_matched" | "application_submitted"
│       ├── application_id: string (optional)
│       ├── scheme_id: string (optional)
│       ├── match_count: number (optional)
│       └── timestamp: timestamp
│
└── analytics/                      └── Anonymous analytics
    └── {logId}/
        ├── event: "user_signup" | "application_submitted"
        ├── user_id: string
        ├── scheme_id: string (optional)
        └── timestamp: timestamp
```

## Collection Details

### 1. schemes (Read-Only)
- **Purpose**: Store all government welfare schemes
- **Access**: Public read, admin write only
- **Indexed fields**: `category`, `is_active`, `min_income`, `max_income`

### 2. users
- **Purpose**: Store citizen profiles extracted from voice input
- **Access**: User can read/write their own data
- **Indexed fields**: `state`, `district`, `created_at`

### 3. applications
- **Purpose**: Track all submitted applications
- **Access**: Authenticated users can read/create
- **Indexed fields**: `user_id`, `scheme_id`, `status`, `created_at`

### 4. matches
- **Purpose**: Cache AI matching results for performance
- **Access**: User can read/write their own matches
- **TTL**: 7 days (can be refreshed)

### 5. notifications
- **Purpose**: Queue for scheduled reminders
- **Access**: Authenticated users
- **Indexed fields**: `user_id`, `due_date`

### 6. activity_logs
- **Purpose**: Track user actions for analytics
- **Access**: Functions write, no public read
- **Retention**: 90 days

### 7. analytics
- **Purpose**: Anonymous aggregate analytics
- **Access**: Functions write, admin read
- **Retention**: 365 days

## Indexes

### Composite Indexes Needed

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
    },
    {
      "collectionGroup": "schemes",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "is_active", "order": "ASCENDING" },
        { "fieldPath": "category", "order": "ASCENDING" }
      ]
    }
  ]
}
```

## Security Rules Summary

- **schemes**: Public read, admin write
- **users**: User can read/write own data
- **applications**: Authenticated users can read/write
- **matches**: User can read/write own data
- **notifications**: Authenticated users
- **activity_logs**: Functions write only
- **analytics**: Functions write, admin read

## Data Flow

1. **User signs up** → `users/{userId}` created
2. **Voice input** → Cloud Function extracts profile → `users/{userId}` updated
3. **Scheme matching** → Cloud Function matches → `matches/{userId}` created
4. **Application submit** → Cloud Function processes → `applications/{applicationId}` created
5. **Status update** → Cloud Function notifies → `applications/{applicationId}` updated
6. **Daily reminders** → Scheduled Function → `notifications/{userId}` processed

## Storage Structure

```
storage/
└── users/
    └── {userId}/
        ├── aadhar.jpg
        ├── land_record.pdf
        ├── bank_passbook.jpg
        ├── ration_card.jpg
        └── income_certificate.pdf
```

- Each user has their own folder
- Documents are organized by type
- Access controlled by Firebase Storage rules
