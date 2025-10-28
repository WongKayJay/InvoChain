# Hostinger DNS Configuration Guide for InvoChain
## Setting up g1t2.drshaiban.cloud

This guide walks you through configuring DNS in Hostinger to point `g1t2.drshaiban.cloud` to your server.

---

## 📋 Prerequisites

- Hostinger account with domain management access
- Server IP address for `drshaiban.cloud`
- Access to Hostinger control panel

---

## 🌐 Step-by-Step DNS Configuration

### Step 1: Log into Hostinger

1. Go to https://www.hostinger.com
2. Click **Login** (top right)
3. Enter your credentials
4. Navigate to **Domains** section

### Step 2: Select Your Domain

1. Find `drshaiban.cloud` in your domain list
2. Click **Manage** next to the domain

### Step 3: Access DNS Settings

1. Look for **DNS Zone** or **DNS Settings** or **DNS/Nameservers**
2. Click on it to access DNS record management
3. You should see existing DNS records

### Step 4: Add A Record for Subdomain

Click **Add Record** or **Add New Record**, then enter:

```
┌─────────────────────────────────────────────┐
│ Record Type:  A                             │
│ Name:         g1t2                          │
│ Points to:    [YOUR_SERVER_IP]              │
│ TTL:          14400 (or leave default)      │
└─────────────────────────────────────────────┘
```

**Example:**
```
Type: A
Name: g1t2
Points to: 123.45.67.89  (replace with your actual server IP)
TTL: 14400
```

### Step 5: Save the Record

1. Click **Save** or **Add Record**
2. Wait for confirmation message
3. Record should appear in your DNS records list

---

## ✅ Verify DNS Configuration

### Method 1: Using nslookup (Windows)

```powershell
nslookup g1t2.drshaiban.cloud
```

**Expected output:**
```
Server:  [Your DNS Server]
Address:  [DNS Server IP]

Name:    g1t2.drshaiban.cloud
Address:  [Your Server IP]
```

### Method 2: Using ping

```powershell
ping g1t2.drshaiban.cloud
```

Should return your server IP.

### Method 3: Online DNS Checker

Visit these websites:
- https://dnschecker.org
- https://www.whatsmydns.net

Enter `g1t2.drshaiban.cloud` and verify it resolves to your server IP.

---

## ⏱️ DNS Propagation

**Important**: DNS changes take time to propagate globally.

- **Minimum**: 5-15 minutes
- **Average**: 1-2 hours  
- **Maximum**: 24-48 hours

**Tips:**
- Clear your DNS cache after making changes
- Use incognito/private browsing to test
- Check from different locations/networks

### Clear DNS Cache

**Windows:**
```powershell
ipconfig /flushdns
```

**Mac/Linux:**
```bash
sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder
```

---

## 🔧 Additional DNS Records (Optional)

### Add AAAA Record (IPv6)

If your server has IPv6:

```
Type: AAAA
Name: g1t2
Points to: [Your IPv6 Address]
TTL: 14400
```

### Add CAA Record (SSL Security)

For additional SSL security:

```
Type: CAA
Name: g1t2
Flags: 0
Tag: issue
Value: letsencrypt.org
TTL: 14400
```

### Add TXT Record (Email/Verification)

For domain verification:

```
Type: TXT
Name: g1t2
Value: "v=spf1 -all" (or your verification string)
TTL: 14400
```

---

## 🛡️ Security Recommendations

### 1. Enable DNSSEC (if available)

In Hostinger DNS settings:
- Look for DNSSEC option
- Enable it for added security
- Follow Hostinger's DNSSEC setup guide

### 2. Set Appropriate TTL

- **Development**: 300 (5 minutes) - for quick changes
- **Production**: 14400 (4 hours) - balance between caching and flexibility
- **Stable**: 86400 (24 hours) - maximum caching

### 3. Backup DNS Records

Before making changes:
1. Screenshot current DNS records
2. Export DNS zone file (if available)
3. Document all records

---

## 🔍 Troubleshooting

### Issue: DNS Not Resolving

**Check:**
1. Record type is "A" (not CNAME)
2. Name is exactly "g1t2" (no trailing dots)
3. IP address is correct
4. TTL is reasonable (14400)
5. Record is saved and active

**Solutions:**
- Wait longer (up to 48 hours)
- Clear DNS cache
- Check with different DNS servers
- Verify in Hostinger that record is active

### Issue: Wrong IP Returned

**Causes:**
- Old DNS cache
- Incorrect IP in record
- Propagation in progress

**Solutions:**
```powershell
# Check what IP is configured
nslookup g1t2.drshaiban.cloud 8.8.8.8

# Use Google DNS to bypass local cache
```

### Issue: SSL Certificate Fails

**Causes:**
- DNS not yet propagated
- Certbot can't verify domain ownership

**Solutions:**
1. Wait for full DNS propagation
2. Verify with: `nslookup g1t2.drshaiban.cloud`
3. Try certificate again after DNS resolves

---

## 📊 DNS Record Summary

After configuration, your DNS should look like:

```
┌──────────────────────────────────────────────────────┐
│ Type │ Name │ Points To / Value        │ TTL          │
├──────────────────────────────────────────────────────┤
│ A    │ g1t2 │ 123.45.67.89            │ 14400        │
│ CAA  │ g1t2 │ 0 issue "letsencrypt.org"│ 14400        │
└──────────────────────────────────────────────────────┘
```

---

## 🔄 Updating DNS Records

To change the server IP later:

1. Go to Hostinger DNS management
2. Find the A record for `g1t2`
3. Click **Edit** or the pencil icon
4. Update the IP address
5. Save changes
6. Wait for propagation

---

## 📞 Hostinger Support

If you encounter issues:

- **Help Center**: https://support.hostinger.com
- **Live Chat**: Available 24/7 in control panel
- **Email**: support@hostinger.com
- **Knowledge Base**: Search for "DNS configuration" or "A record"

---

## ✅ Verification Checklist

Before proceeding with server setup:

- [ ] A record created in Hostinger
- [ ] Name is `g1t2`
- [ ] Points to correct server IP
- [ ] Record is saved and active
- [ ] DNS resolves correctly (`nslookup g1t2.drshaiban.cloud`)
- [ ] Can ping the subdomain
- [ ] Waited sufficient time for propagation (minimum 15 minutes)

---

## 🚀 Next Steps

Once DNS is configured and propagated:

1. **Server Setup**: Follow `DEPLOYMENT.md` or `QUICKSTART.md`
2. **Deploy Files**: Upload website and Flutter app
3. **Configure Nginx**: Use provided `nginx.conf`
4. **Get SSL**: Run `certbot --nginx -d g1t2.drshaiban.cloud`
5. **Test**: Visit https://g1t2.drshaiban.cloud

---

**Configuration Time**: 5-10 minutes  
**Propagation Time**: 15 minutes - 48 hours  
**Difficulty**: Beginner-Friendly

© 2025 InvoChain
