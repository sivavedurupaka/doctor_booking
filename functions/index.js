const functions = require("firebase-functions");
const admin = require("firebase-admin");
const nodemailer = require("nodemailer");

// ✅ Initialize Firebase Admin SDK
admin.initializeApp();

// ✅ Get Email & Password from Firebase Config
const gmailUser = functions.config().email.user;
const gmailPass = functions.config().email.pass;

// ✅ Setup Nodemailer Transporter
const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: gmailUser, // 🔥 Secure Email from Config
    pass: gmailPass, // 🔥 Secure App Password from Config
  },
});

// ✅ Function to Send Email When a Booking is Made
exports.sendBookingConfirmation = functions.firestore
  .document("bookings/{bookingId}")
  .onCreate(async (snap, context) => {
    const bookingData = snap.data(); // 🔥 Get booking data

    // ✅ Check if email exists in the booking data
    if (!bookingData.email) {
      console.error("❌ No email found in booking data.");
      return null;
    }

    const mailOptions = {
      from: gmailUser, // 🔹 Secure Email from Config
      to: bookingData.email, // 🔥 Send email to the user
      subject: "Appointment Confirmation - Doctor Booking App",
      html: `
        <h2>Dear Patient,</h2>
        <p>Your appointment with <b>Dr. ${bookingData.doctorName}</b> has been successfully booked.</p>
        <p><b>Date:</b> ${bookingData.appointmentDate}</p>
        <p><b>Time:</b> ${bookingData.appointmentTime}</p>
        <br>
        <p>Thank you for using our service! ❤️</p>
        <p>- Your HealthCare Team</p>
      `,
    };

    try {
      await transporter.sendMail(mailOptions);
      console.log("✅ Booking confirmation email sent to:", bookingData.email);
    } catch (error) {
      console.error("❌ Error sending email:", error);
    }
  });
