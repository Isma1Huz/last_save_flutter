// const functions = require('firebase-functions');
// const admin = require('firebase-admin');
// admin.initializeApp();

// // Generate a random 4-digit OTP
// function generateOTP() {
//   return Math.floor(1000 + Math.random() * 9000).toString();
// }

// // Function to send OTP via email
// exports.sendPasswordResetOTP = functions.https.onCall(async (data, context) => {
//   const email = data.email;
  
//   try {
//     // Check if user exists
//     const userRecord = await admin.auth().getUserByEmail(email);
    
//     // Generate OTP
//     const otp = generateOTP();
    
//     // Store OTP in Firestore with expiration time (15 minutes)
//     await admin.firestore().collection('otps').doc(email).set({
//       otp: otp,
//       createdAt: admin.firestore.FieldValue.serverTimestamp(),
//       expiresAt: admin.firestore.Timestamp.fromDate(
//         new Date(Date.now() + 15 * 60 * 1000)
//       ),
//       uid: userRecord.uid
//     });
    
//     // Send email with OTP using Firebase's built-in email sending
//     // This is a workaround since Firebase Functions can't directly send emails
//     // We'll create a custom email template with the OTP
    
//     const actionCodeSettings = {
//       url: `https://your-app-domain.com/passwordReset?email=${email}&otp=${otp}`,
//       handleCodeInApp: false
//     };
    
//     await admin.auth().generatePasswordResetLink(email, actionCodeSettings)
//       .then((link) => {
//         // Here you would typically send a custom email with the OTP
//         // For this example, we're using the default Firebase email
//         // In a production app, you'd use a service like SendGrid or Mailgun
//         console.log(`Password reset link for ${email}: ${link}`);
//         console.log(`OTP for ${email}: ${otp}`);
//       });
    
//     return { success: true, message: 'Verification code sent successfully to your email' };
//   } catch (error) {
//     console.error('Error sending email OTP:', error);
//     throw new functions.https.HttpsError('internal', 'Failed to send verification code: ' + error.message);
//   }
// });

// // Function to verify OTP and reset password
// exports.verifyOTPAndResetPassword = functions.https.onCall(async (data, context) => {
//   const { email, otp, newPassword } = data;
  
//   try {
//     // Get stored OTP
//     const otpDoc = await admin.firestore().collection('otps').doc(email).get();
    
//     if (!otpDoc.exists) {
//       throw new functions.https.HttpsError('not-found', 'Verification code not found. Please request a new code.');
//     }
    
//     const otpData = otpDoc.data();
    
//     // Check if OTP is expired
//     if (otpData.expiresAt.toDate() < new Date()) {
//       // Delete expired OTP
//       await admin.firestore().collection('otps').doc(email).delete();
//       throw new functions.https.HttpsError('deadline-exceeded', 'Verification code expired. Please request a new code.');
//     }
    
//     // Verify OTP
//     if (otpData.otp !== otp) {
//       throw new functions.https.HttpsError('invalid-argument', 'Invalid verification code. Please try again.');
//     }
    
//     // Reset password using the stored UID
//     await admin.auth().updateUser(otpData.uid, {
//       password: newPassword
//     });
    
//     // Delete the used OTP
//     await admin.firestore().collection('otps').doc(email).delete();
    
//     return { 
//       success: true, 
//       message: 'Password reset successful. You can now login with your new password.' 
//     };
//   } catch (error) {
//     console.error('Error verifying OTP:', error);
//     throw new functions.https.HttpsError('internal', 'Failed to verify code: ' + error.message);
//   }
// });

// exports.resendPasswordResetOTP = functions.https.onCall(async (data, context) => {
//   const email = data.email;
  
//   try {
//     await admin.firestore().collection('otps').doc(email).delete();
    
//     // Call the sendPasswordResetOTP function to generate and send a new OTP
//     const sendOTPFunction = require('firebase-functions').https.onCallHandler(exports.sendPasswordResetOTP);
//     return await sendOTPFunction({ email });
//   } catch (error) {
//     console.error('Error resending OTP:', error);
//     throw new functions.https.HttpsError('internal', 'Failed to resend verification code: ' + error.message);
//   }
// });