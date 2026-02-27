import * as nodemailer from 'nodemailer';

// Enterprise email service using SMTP
// Uses Ethereal for development, replace with Gmail/SendGrid/AWS SES for production
class EmailService {
  private static transporter: nodemailer.Transporter | null = null;
  private static isReady = false;

  static async initialize() {
    try {
      // For production use real SMTP: Gmail, SendGrid, AWS SES, etc.
      const smtpHost = process.env.SMTP_HOST;
      const smtpUser = process.env.SMTP_USER;
      const smtpPass = process.env.SMTP_PASS;

      if (smtpHost && smtpUser && smtpPass) {
        // Real SMTP configured
        this.transporter = nodemailer.createTransport({
          host: smtpHost,
          port: parseInt(process.env.SMTP_PORT || '587'),
          secure: process.env.SMTP_SECURE === 'true',
          auth: { user: smtpUser, pass: smtpPass },
        });
        console.log('📧 Email: Connected to SMTP server');
        this.isReady = true;
      } else {
        console.log('⚠️  Email: No SMTP provided. OTPs will be logged to console only.');
        this.isReady = false;
      }
    } catch (e) {
      console.log('⚠️  Email: Failed to initialize, OTP will be logged to console');
      this.isReady = false;
    }
  }

  static generateOTP(): string {
    return Math.floor(100000 + Math.random() * 900000).toString();
  }

  static async sendOTP(to: string, otp: string, type: 'register' | 'login' | 'reset', name?: string): Promise<boolean> {
    const subject = {
      register: 'Verify Your Email — ProjectGenie',
      login: 'Login Verification Code — ProjectGenie',
      reset: 'Password Reset Code — ProjectGenie',
    }[type];

    const html = `
<!DOCTYPE html>
<html>
<head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
<body style="margin:0;padding:0;background:#f8fafc;font-family:'Inter','Segoe UI',Helvetica,Arial,sans-serif;">
<table width="100%" cellpadding="0" cellspacing="0" style="background:#f8fafc;padding:40px 20px;">
<tr><td align="center">
<table width="480" cellpadding="0" cellspacing="0" style="background:#ffffff;border-radius:16px;overflow:hidden;box-shadow:0 4px 24px rgba(0,0,0,0.06);">
  <!-- Header -->
  <tr><td style="background:linear-gradient(135deg,#0f172a,#1e3a5f);padding:32px 32px 24px;">
    <table width="100%"><tr>
      <td style="color:#ffffff;font-size:24px;font-weight:800;letter-spacing:-0.5px;">
        🎓 ProjectGenie
      </td>
    </tr></table>
    <p style="color:rgba(255,255,255,0.7);font-size:13px;margin:8px 0 0;">Enterprise Academic Commerce Platform</p>
  </td></tr>
  
  <!-- Body -->
  <tr><td style="padding:32px;">
    <h2 style="color:#0f172a;font-size:20px;font-weight:700;margin:0 0 8px;">
      ${type === 'register' ? 'Welcome aboard!' : type === 'login' ? 'Login Verification' : 'Password Reset'}
    </h2>
    <p style="color:#64748b;font-size:14px;line-height:1.6;margin:0 0 24px;">
      ${name ? `Hi <strong>${name}</strong>,` : 'Hello,'}<br>
      ${type === 'register'
        ? 'Thank you for registering on ProjectGenie. Please verify your email address using the OTP below.'
        : type === 'login'
          ? 'A login attempt was made on your account. Use the OTP below to complete sign-in.'
          : 'We received a request to reset your password. Use the OTP below to proceed.'}
    </p>
    
    <!-- OTP Box -->
    <table width="100%" cellpadding="0" cellspacing="0">
    <tr><td align="center" style="padding:16px 0;">
      <div style="display:inline-block;background:#f1f5f9;border:2px dashed #94a3b8;border-radius:12px;padding:20px 40px;">
        <span style="font-size:36px;font-weight:900;letter-spacing:12px;color:#0f172a;font-family:monospace;">${otp}</span>
      </div>
    </td></tr>
    </table>

    <p style="color:#94a3b8;font-size:12px;text-align:center;margin:16px 0 0;">
      ⏱ This code is valid for <strong>10 minutes</strong>. Do not share it with anyone.
    </p>
  </td></tr>
  
  <!-- Footer -->
  <tr><td style="padding:20px 32px;background:#f8fafc;border-top:1px solid #e2e8f0;">
    <p style="color:#94a3b8;font-size:11px;text-align:center;margin:0;">
      This email was sent by ProjectGenie • Enterprise Academic Commerce<br>
      If you didn't request this, please ignore this email.
    </p>
  </td></tr>
</table>
</td></tr>
</table>
</body>
</html>`;

    // Always log OTP to console (for dev)
    console.log(`\n📧 ═══════════════════════════════════════════`);
    console.log(`  📬 OTP for ${to}: ${otp}`);
    console.log(`  📋 Type: ${type}`);
    console.log(`═══════════════════════════════════════════════\n`);

    if (!this.isReady || !this.transporter) {
      console.log('⚠️  Email transport not ready, OTP logged above');
      return true; // Still return true — the OTP is logged
    }

    try {
      const info = await this.transporter.sendMail({
        from: '"ProjectGenie" <noreply@projectgenie.com>',
        to,
        subject,
        html,
      });

      // For Ethereal, log the preview URL
      const previewUrl = nodemailer.getTestMessageUrl(info);
      if (previewUrl) {
        console.log(`  🔗 Preview: ${previewUrl}`);
      }
      return true;
    } catch (e) {
      console.error('❌ Failed to send email:', e);
      return true; // Don't block auth flow
    }
  }
}

export default EmailService;
