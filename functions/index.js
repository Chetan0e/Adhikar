const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios");

admin.initializeApp();

// ==================== CONFIGURATION ====================

const GEMINI_API_KEY = process.env.GEMINI_API_KEY || functions.config().gemini.key;
const GEMINI_MODEL = "gemini-1.5-flash";

// ==================== HELPER FUNCTIONS ====================

function buildProfilePrompt(transcript) {
  return `You are a government welfare eligibility assistant for India.
Extract structured profile information from the user's voice description.
Return ONLY valid JSON. No explanation, no markdown, no code blocks.

User's description:
${transcript}

Expected JSON format:
{
  "name": "full name",
  "age": age in years,
  "gender": "male/female/other",
  "state": "state name",
  "district": "district name",
  "caste": "general/obc/sc/st",
  "occupation": "farmer/daily_wage/unemployed/teacher/etc",
  "annual_income": annual income in rupees (number only),
  "land_holding": land in acres (number, 0 if no land),
  "is_disabled": true/false,
  "is_widow": true/false,
  "has_bpl_card": true/false,
  "has_aadhar": true/false,
  "has_bank_account": true/false,
  "family_size": number of family members,
  "children_ages": [ages of children],
  "is_pregnant": true/false,
  "education_level": "illiterate/primary/secondary/graduate",
  "confidence": 0.0 to 1.0,
  "missing_info": ["info that couldn't be extracted"]
}

If a field cannot be determined from the text, use null or empty value.
For numbers, use actual numeric values, not strings.`;
}

function buildMatchPrompt(profile, schemes) {
  return `You are an expert on Indian government welfare schemes.
Given a user profile and a list of schemes with eligibility criteria,
return which schemes the user qualifies for and WHY.
Return ONLY valid JSON array.

User Profile:
${JSON.stringify(profile, null, 2)}

Schemes (limiting to top 30 for token efficiency):
${JSON.stringify(schemes.slice(0, 30), null, 2)}

Expected JSON array format:
[
  {
    "scheme_id": "scheme_id",
    "eligible": true/false,
    "confidence": 0.0 to 1.0,
    "reason": "brief reason for eligibility or ineligibility",
    "estimated_benefit": "benefit description",
    "missing_documents": ["doc1", "doc2"]
  }
]

Only return the array, nothing else.`;
}

function cleanGeminiResponse(text) {
  // Remove markdown code blocks if present
  text = text.replace(/```json/g, "").replace(/```/g, "").trim();
  
  // Find JSON object or array
  const start = text.indexOf("{") !== -1 ? text.indexOf("{") : text.indexOf("[");
  const end = text.lastIndexOf("}") !== -1 ? text.lastIndexOf("}") : text.lastIndexOf("]");
  
  if (start === -1 || end === -1) {
    throw new Error("No valid JSON found in response");
  }
  
  return text.substring(start, end + 1);
}

async function callGeminiAPI(prompt) {
  const url = `https://generativelanguage.googleapis.com/v1beta/models/${GEMINI_MODEL}:generateContent?key=${GEMINI_API_KEY}`;
  
  const response = await axios.post(
    url,
    {
      contents: [
        {
          parts: [{ text: prompt }]
        }
      ],
      generationConfig: {
        temperature: 0.1,
        maxOutputTokens: 2048
      }
    },
    {
      headers: {
        "Content-Type": "application/json"
      }
    }
  );

  if (!response.data.candidates || response.data.candidates.length === 0) {
    throw new Error("No response from Gemini API");
  }

  const rawText = response.data.candidates[0].content.parts[0].text;
  const cleanedJson = cleanGeminiResponse(rawText);
  
  return JSON.parse(cleanedJson);
}

// ==================== CLOUD FUNCTIONS ====================

/**
 * Extract user profile from voice transcript using Gemini AI
 * Callable from Flutter app
 */
exports.extractProfile = functions.https.onCall(async (data, context) => {
  // Check authentication
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "User must be authenticated to extract profile"
    );
  }

  const { transcript } = data;
  const userId = context.auth.uid;

  if (!transcript || transcript.length < 10) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Transcript must be at least 10 characters long"
    );
  }

  try {
    // Call Gemini API
    const profile = await callGeminiAPI(buildProfilePrompt(transcript));
    
    // Add metadata
    profile.user_id = userId;
    profile.updated_at = admin.firestore.FieldValue.serverTimestamp();
    profile.created_at = admin.firestore.FieldValue.serverTimestamp();

    // Save to Firestore
    await admin.firestore()
      .collection("users")
      .doc(userId)
      .set(profile, { merge: true });

    // Log activity
    await admin.firestore()
      .collection("activity_logs")
      .add({
        user_id: userId,
        action: "profile_extracted",
        timestamp: admin.firestore.FieldValue.serverTimestamp()
      });

    return { profile, success: true };
  } catch (error) {
    functions.logger.error("Profile extraction error:", error);
    throw new functions.https.HttpsError(
      "internal",
      "Failed to extract profile: " + error.message
    );
  }
});

/**
 * Match schemes for a user profile using Gemini AI
 * Callable from Flutter app
 */
exports.matchSchemes = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "User must be authenticated to match schemes"
    );
  }

  const { profile } = data;
  const userId = context.auth.uid;

  if (!profile) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Profile data is required"
    );
  }

  try {
    // Fetch all active schemes from Firestore
    const schemesSnap = await admin.firestore()
      .collection("schemes")
      .where("is_active", "==", true)
      .get();
    
    if (schemesSnap.empty) {
      throw new functions.https.HttpsError(
        "not-found",
        "No active schemes found in database"
      );
    }

    const schemes = schemesSnap.docs.map(d => ({ id: d.id, ...d.data() }));

    // Call Gemini API for matching
    const matches = await callGeminiAPI(buildMatchPrompt(profile, schemes));

    // Cache result in Firestore
    await admin.firestore()
      .collection("matches")
      .doc(userId)
      .set({
        results: matches,
        profile_snapshot: profile,
        updated_at: admin.firestore.FieldValue.serverTimestamp()
      }, { merge: true });

    // Log activity
    await admin.firestore()
      .collection("activity_logs")
      .add({
        user_id: userId,
        action: "schemes_matched",
        match_count: matches.length,
        timestamp: admin.firestore.FieldValue.serverTimestamp()
      });

    return { matches, success: true };
  } catch (error) {
    functions.logger.error("Scheme matching error:", error);
    
    // Fallback: Use rule-based matching if AI fails
    return {
      matches: fallbackRuleBasedMatching(profile, schemesSnap),
      fallback: true,
      success: true
    };
  }
});

/**
 * Submit application for a scheme
 * Callable from Flutter app
 */
exports.submitApplication = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "User must be authenticated to submit application"
    );
  }

  const { scheme_id, form_data, document_urls } = data;
  const userId = context.auth.uid;

  if (!scheme_id || !form_data) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "scheme_id and form_data are required"
    );
  }

  try {
    // Verify scheme exists
    const schemeDoc = await admin.firestore()
      .collection("schemes")
      .doc(scheme_id)
      .get();

    if (!schemeDoc.exists) {
      throw new functions.https.HttpsError(
        "not-found",
        "Scheme not found"
      );
    }

    // Create application
    const applicationRef = await admin.firestore()
      .collection("applications")
      .add({
        user_id: userId,
        scheme_id,
        scheme_name: schemeDoc.data().name,
        form_data,
        documents: document_urls || [],
        status: "submitted",
        created_at: admin.firestore.FieldValue.serverTimestamp(),
        last_updated: admin.firestore.FieldValue.serverTimestamp()
      });

    // Generate reference number
    const refNumber = `ADH${new Date().getFullYear()}${applicationRef.id.slice(-6)}`;
    await applicationRef.update({ reference_number: refNumber });

    // Get user's FCM token
    const userDoc = await admin.firestore()
      .collection("users")
      .doc(userId)
      .get();

    const fcmToken = userDoc.data()?.fcm_token;

    // Send FCM notification
    if (fcmToken) {
      try {
        await admin.messaging().send({
          token: fcmToken,
          notification: {
            title: "Application Submitted!",
            body: `Application for ${schemeDoc.data().name} submitted successfully. Ref: ${refNumber}`
          },
          data: {
            application_id: applicationRef.id,
            type: "application_submitted"
          }
        });
      } catch (notifError) {
        functions.logger.error("Failed to send notification:", notifError);
      }
    }

    // Log activity
    await admin.firestore()
      .collection("activity_logs")
      .add({
        user_id: userId,
        action: "application_submitted",
        application_id: applicationRef.id,
        scheme_id,
        timestamp: admin.firestore.FieldValue.serverTimestamp()
      });

    return {
      application_id: applicationRef.id,
      reference_number: refNumber,
      success: true
    };
  } catch (error) {
    functions.logger.error("Application submission error:", error);
    throw new functions.https.HttpsError(
      "internal",
      "Failed to submit application: " + error.message
    );
  }
});

/**
 * Update application status (for government officials)
 * Callable from admin dashboard
 */
exports.updateApplicationStatus = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "User must be authenticated"
    );
  }

  const { application_id, status, notes } = data;

  if (!application_id || !status) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "application_id and status are required"
    );
  }

  try {
    const applicationRef = admin.firestore()
      .collection("applications")
      .doc(application_id);

    const applicationDoc = await applicationRef.get();

    if (!applicationDoc.exists) {
      throw new functions.https.HttpsError(
        "not-found",
        "Application not found"
      );
    }

    // Update status
    await applicationRef.update({
      status,
      status_notes: notes || "",
      last_updated: admin.firestore.FieldValue.serverTimestamp()
    });

    // Get user's FCM token
    const userDoc = await admin.firestore()
      .collection("users")
      .doc(applicationDoc.data().user_id)
      .get();

    const fcmToken = userDoc.data()?.fcm_token;

    // Send notification
    if (fcmToken) {
      const statusMessages = {
        "under_review": "Your application is under review",
        "approved": "Congratulations! Your application has been approved",
        "rejected": "Your application has been rejected",
        "pending_documents": "Additional documents required for your application"
      };

      await admin.messaging().send({
        token: fcmToken,
        notification: {
          title: "Application Status Updated",
          body: statusMessages[status] || `Your application status is now: ${status}`
        },
        data: {
          application_id,
          type: "status_updated",
          status
        }
      });
    }

    return { success: true };
  } catch (error) {
    functions.logger.error("Status update error:", error);
    throw new functions.https.HttpsError(
      "internal",
      "Failed to update status: " + error.message
    );
  }
});

/**
 * Daily reminder for pending documents
 * Runs every 24 hours
 */
exports.dailyReminders = functions.pubsub
  .schedule("every 24 hours")
  .onRun(async (context) => {
    const pendingDocs = await admin.firestore()
      .collection("applications")
      .where("status", "==", "pending_documents")
      .get();

    const notificationPromises = [];

    pendingDocs.forEach(async (doc) => {
      const applicationData = doc.data();
      
      const userDoc = await admin.firestore()
        .collection("users")
        .doc(applicationData.user_id)
        .get();

      const fcmToken = userDoc.data()?.fcm_token;

      if (fcmToken) {
        notificationPromises.push(
          admin.messaging().send({
            token: fcmToken,
            notification: {
              title: "Documents Pending",
              body: "Your application needs additional documents. Tap to complete."
            },
            data: {
              application_id: doc.id,
              type: "documents_pending"
            }
          }).catch(err => {
            functions.logger.error(`Failed to send reminder to ${applicationData.user_id}:`, err);
          })
        );
      }
    });

    await Promise.all(notificationPromises);
    
    functions.logger.info(`Sent ${notificationPromises.length} document reminders`);
    return null;
  });

/**
 * Sync schemes from local database to Firestore
 * Run manually or on deploy
 */
exports.syncSchemes = functions.https.onRequest(async (req, res) => {
  try {
    // This would typically load from a JSON file or external source
    // For now, it's a placeholder that can be extended
    const schemes = require("./schemes_data.json") || [];
    
    const batch = admin.firestore().batch();
    
    schemes.forEach(scheme => {
      const ref = admin.firestore().collection("schemes").doc(scheme.id);
      batch.set(ref, {
        ...scheme,
        is_active: true,
        synced_at: admin.firestore.FieldValue.serverTimestamp()
      }, { merge: true });
    });

    await batch.commit();

    res.json({
      success: true,
      message: `Synced ${schemes.length} schemes to Firestore`
    });
  } catch (error) {
    functions.logger.error("Scheme sync error:", error);
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

/**
 * Fallback rule-based matching when AI fails
 */
function fallbackRuleBasedMatching(profile, schemesSnap) {
  const matches = [];
  const profileData = profile.profile || profile;

  schemesSnap.forEach(doc => {
    const scheme = doc.data();
    const eligibility = scheme.eligibility || {};
    
    let eligible = true;
    const reasons = [];
    const missingDocuments = [];

    // Simple rule checks
    if (eligibility.max_income && profileData.annual_income > eligibility.max_income) {
      eligible = false;
      reasons.push(`Income exceeds limit of ₹${eligibility.max_income}`);
    }

    if (eligibility.min_age && profileData.age < eligibility.min_age) {
      eligible = false;
      reasons.push(`Age below minimum of ${eligibility.min_age}`);
    }

    if (eligibility.max_age && profileData.age > eligibility.max_age) {
      eligible = false;
      reasons.push(`Age above maximum of ${eligibility.max_age}`);
    }

    if (eligibility.caste && !eligibility.caste.includes(profileData.caste)) {
      eligible = false;
      reasons.push(`Caste category not eligible`);
    }

    if (eligible) {
      reasons.push("All eligibility criteria met");
    }

    matches.push({
      scheme_id: doc.id,
      eligible,
      confidence: eligible ? 0.7 : 0.3,
      reason: reasons.join(", "),
      estimated_benefit: scheme.benefit_amount,
      missing_documents: scheme.documents_required || []
    });
  });

  return matches;
}

// ==================== FIRESTORE TRIGGERS ====================

/**
 * Send welcome notification when user signs up
 */
exports.onUserCreate = functions.firestore
  .document("users/{userId}")
  .onCreate(async (snap, context) => {
    const userData = snap.data();
    
    // Log new user
    await admin.firestore()
      .collection("analytics")
      .add({
        event: "user_signup",
        user_id: context.params.userId,
        timestamp: admin.firestore.FieldValue.serverTimestamp()
      });
  });

/**
 * Track application submission analytics
 */
exports.onApplicationSubmit = functions.firestore
  .document("applications/{applicationId}")
  .onCreate(async (snap, context) => {
    const applicationData = snap.data();
    
    await admin.firestore()
      .collection("analytics")
      .add({
        event: "application_submitted",
        user_id: applicationData.user_id,
        scheme_id: applicationData.scheme_id,
        timestamp: admin.firestore.FieldValue.serverTimestamp()
      });
  });
