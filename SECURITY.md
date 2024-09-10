# Security Policy

## Supported Versions

We regularly release updates to the iOS project to ensure the latest security patches and improvements are available. Please make sure you're using the most recent version of the app or framework to benefit from the latest security enhancements.

## Reporting a Vulnerability

We take the security of our iOS project seriously. If you discover a security vulnerability, we ask you to responsibly disclose it to us so we can investigate and fix it as soon as possible.

### How to Report

**Please send an email to srikar@finbox.in with the following details**:
   - Include a description of the vulnerability, steps to reproduce it, and any potential impact.
   - Do **not** post the details in public GitHub issues, as it may expose the vulnerability to malicious actors.

### What Happens Next?

- We will acknowledge receipt of your report within 48 hours.
- We will investigate and provide an estimated timeline for addressing the issue.
- Once the vulnerability is resolved, we will release a patch or security update and inform you of the fix.
- If applicable, we will credit you for the report (unless you prefer to remain anonymous).

## Security Best Practices

To ensure your project remains secure, we recommend the following best practices:

- **Use Keychain Services**: Secure sensitive data like passwords, tokens, and keys in the iOS Keychain.
- **Regular Dependency Updates**: Keep third-party libraries (e.g., CocoaPods, Swift Package Manager) up-to-date to minimize the risk of vulnerabilities in external code.
- **App Transport Security (ATS)**: Enforce ATS to ensure secure network connections within the app.
- **Static Analysis Tools**: Use tools like [SwiftLint](https://github.com/realm/SwiftLint) or [SonarQube](https://www.sonarsource.com/products/sonarqube/) to identify potential security issues in the codebase.
- **Penetration Testing**: Regularly perform penetration testing to find and fix potential vulnerabilities.

## Acknowledgements

We appreciate your efforts to responsibly disclose security vulnerabilities and for helping to keep our iOS project secure.

Thank you!
