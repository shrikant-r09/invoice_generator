# 🧾 Billing and Invoice Generator

A cross-platform **Flutter + Dart** mobile app for billing, order management, menu/product management, invoice generation, and payment tracking — built for small businesses like shops, restaurants, and cafés.

<p align="left">
  <img alt="Flutter" src="https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white" />
  <img alt="Dart" src="https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart&logoColor=white" />
  <img alt="License" src="https://img.shields.io/badge/License-Apache%202.0-D22128?style=flat&logo=apache&logoColor=white" />
</p>

## Overview

The app replaces handwritten bills and manual calculation with a simple digital workflow. It offers two role-based interfaces:

- **Admin / Manager** — add/edit/remove products, receive & track orders, view payment details, update order & payment status.
- **Customer** — browse products with images, add/remove cart items, place orders, and view payment status.

## Features

- 🔐 Role-based login (Admin/Manager & Customer)
- 🍽️ Product/menu management (add, edit, remove)
- 🛒 Shopping cart with automatic total calculation
- 📦 Order receiving & tracking
- 🧾 Automatic billing & invoice details
- 💳 Payment tracking — `PAID` / `NOT PAID`

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter |
| Language | Dart |
| Storage | Shared Preferences / local persistence |
| State | Flutter state management |

## Getting Started

```bash
# Clone
git clone https://github.com/snrathod/billing-invoice-generator.git
cd billing-invoice-generator

# Install dependencies
flutter pub get

# Run on a device / emulator
flutter run
```

**Prerequisites:** Flutter SDK, Dart, and an IDE (Android Studio or VS Code) with the Flutter plugin. Run `flutter doctor` to verify your setup.

## Project Structure

```text
lib/
├── main.dart      # Entry point
├── screens/       # UI screens
├── widgets/       # Reusable components
├── models/        # Data models
├── services/      # Business logic & storage
└── utils/         # Helpers & constants
```

## Future Scope

PDF invoices · online payment gateways (UPI) · cloud database (Firebase/MySQL) · sales analytics · notifications · multi-device sync.

## Contributors

**snrathod** — Author & Maintainer · [@snrathod](https://github.com/snrathod)

## License

Licensed under the **Apache License 2.0** — see the [LICENSE](LICENSE) file for details.
