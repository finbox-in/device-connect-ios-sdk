# Contributing to DeviceConnect IOS SDK

We value your contributions to the IOS project! This guide will help ensure that our team maintains high standards and a smooth workflow. Please follow these guidelines when contributing to the project.

## Table of Contents
1. [Getting Started](#getting-started)
2. [Code of Conduct](#code-of-conduct)
3. [How to Contribute](#how-to-contribute)
   - [Issues](#issues)
   - [Feature Requests](#feature-requests)
   - [Pull Requests](#pull-requests)
4. [Coding Guidelines](#coding-guidelines)
5. [Testing](#testing)
6. [Communication](#communication)

## Getting Started

Before contributing, make sure you have the latest version of the repository. The project uses standard tools such as:
- **Xcode**: Use the latest stable version.
- **CocoaPods**: Download the latest stable version.
- **Swift Package Manager**: Download the latest Swift version which comes with Swift Package Manager.

To get the repository up and running:

1. Clone the repository:
   ```bash
   git clone https://github.com/finbox-in/device-connect-ios-sdk.git
2. Install dependencies (Cocoapod or Swift package manager)
   ```bash
   pod install
   ```
   or
   ```bash
   swift package resolve
3. Open the project in XCode and ensure all dependencies are correctly configured.


## Code of Conduct

Please review our [Code of Conduct](CODE_OF_CONDUCT.md) to understand our expectations for behavior when contributing to the project. We aim to foster a positive and respectful environment.


## How to Contribute


### Issues

1. Provide a clear and descriptive title.
2. Include steps to reproduce, expected behavior, and actual behavior.
3. Attach relevant logs, screenshots, or crash reports (if applicable).
4. Assign appropriate labels (e.g., `bug`, `enchancement`, `documentation`).


### Feature Requests

1. Describe the feature and its benefit to the project or users.
2. Include design documents, sketches, or screenshots to illustrate the idea.
3. Before submitting, ensure the issue or feature has not already been raised in the repository.


### Pull Requests

To contribute new features, improvements, or bug fixes, follow these steps:

1. Create a JIRA ticket in the SDK project.
2. Create your branch with name that starts with the JIRA ticket number:
   ```bash
   git checkout -b SDK-XXX-your-feature-name
3. Make your changes while adhering to our [coding guidelines](#coding-guidelines).
4. Submit the pull request (PR) with the following:
   - A clear title and description of the changes.
   - Add all the related JIRA ticket numbers.
   - Link any related issues.
   - Fill all the details in the PR template.
   - Mention details about all the devices tested.
   - Ensure your code passes all tests.
5. PR Review Process:
   - PRs will undergo a review process by the maintainers. Be open to feedback and make adjustments as needed.
   - Keep your branch up to date with `main` before final approval.
6. Merging:
   - Only maintainers can merge PRs after ensuring code quality and testing have been completed.


## Coding Guidelines

To ensure the quality and consistency of the codebase, follow these guidelines:

- Code Style:
  - Use **Swift** for new code development and avoid Objective-C unless necessary.
  - Follow the [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/) and [SwiftLint](https://realm.github.io/SwiftLint/) rules for code formatting.
- File Structure:
  - Organize your files logically based on feature modules and follow the existing folder structure.
- Comments:
  - Comment your code where necessary to explain complex logic or important decisions.
- Commit Messages:
  - Use meaningful commit messages that explain why a change was made, not just what was changed.
  - Example format: `SDK-XXX Fix user login crash on iOS 14`.
- Branch Naming:
  - Use descriptive branch names like `SDK-XXX-your-feature-name` or `SDK-XXX-issue-123`.


## Testing

Ensure that your changes do not introduce new bugs. Follow these testing guidelines:

1. Unit Tests:
   - Write unit tests for any new or modified functionality.
   - Use **XCTest** for testing where appropriate.
   - Run tests locally before submitting:
     ``bash
     xcodebuild test
2. Manual Testing:
   - Test your changes on different IOS versions and various screen sizes.
   - Test both in simulatoes and physical devices where possible.
3. Lint Checks:
   - Run `SwiftLint` to ensure code quality:
     ```bash
     swiftlint
4. Continuous Integration:
   - Ensure that the project builds successfully in our CI environment (e.g., GitHub Actions or Jenkins).


## Communication

We use the following channels to communicate and collaborate on the project:

- Slack/Teams: For real-time discussions and general questions.
- Email: For detailed feedback or specific concerns (use srikar@finbox.in).
- JIRA Tickets: For tracking bugs, enhancements, and documentation.

Be proactive in reaching out if you need help or clarification.

-------------------------------
Thank you for contributing to the project! Your efforts help us maintain a robust and well-functioning IOS SDK.
