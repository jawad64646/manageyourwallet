# 👛 Wallet Manager

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A modern, intuitive **personal finance management application** built with **Flutter**. Designed to help users track their income, manage expenses, and visualize their financial health through a clean, responsive, and data-driven interface.

---

## 🎥 Demo

https://github.com/user-attachments/assets/8ea98911-92db-4ab5-8eb2-68526a2934a8

---

## 📸 Preview

*(SEE A DEMO VIDEO)*

---

## ✨ Features

- **📊 Financial Insights** — Interactive pie charts for expense breakdown by category using `fl_chart`.
- **💰 Live Dashboard** — Real-time overview of current balance, total income, and total expenses.
- **➕ Transaction Management** — Easily add, categorize, and save income/expense entries.
- **🧾 Transaction History** — Comprehensive, scrollable view of all historical financial data.
- **🔄 API-Driven** — Seamlessly fetches and updates data from a RESTful API.
- **🎨 Modern UI** — Built with `circle_nav_bar` for smooth, intuitive navigation.

---

## 🛠 Tech Stack

| Component              | Technology                          |
| :--------------------- | :---------------------------------- |
| **Framework**          | Flutter                             |
| **Language**           | Dart                                |
| **Data Visualization** | `fl_chart`                          |
| **UI Components**      | `circle_nav_bar`                    |
| **Networking**         | REST API (`http` package)           |
| **State Management**   | `StatefulWidget`, `FutureBuilder`   |

---

## 📂 Project Structure

```text
lib/
├── Model/              # Data models (Transaction, Category)
├── Pages/              # UI Screens (Dashboard, Add, History)
├── services/api/       # API interaction logic
├── widgets/            # Reusable UI components
└── main.dart           # App entry point
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- A running REST API backend

### Setup Instructions

1. **Clone the repository:**

   ```bash
   git clone https://github.com/jawad64646/manageyourwallet1.git
   ```

2. **Navigate to the project directory:**

   ```bash
   cd manageyourwallet1
   ```

3. **Install dependencies:**

   ```bash
   flutter pub get
   ```

4. **Run the app:**

   ```bash
   flutter run
   ```

---

## 🔌 API Integration

The application interacts with a backend via REST API. Ensure your backend is configured to provide endpoints for:

- **Fetch Transactions** — Retrieve the full transaction history.
- **Add Transactions** — POST request to add a new income/expense.
- **Fetch Categories** — Retrieve categorized data for the dashboard.
- **Wallet Status** — Get a summary of the current financial balance.

API files are located in: `services/api/`

---

## 👨‍💻 Developer

**Mohamad Alsahily**

- [LinkedIn](https://www.linkedin.com/in/mohamad-alsahily-2609b035a)
- [GitHub](https://github.com/jawad64646)

---

## 🤝 Support

If you like this project, please give it a ⭐ on [GitHub](https://github.com/jawad64646/manageyourwallet1)!

---

## 📄 License

This project is open-source and available under the [MIT License](https://opensource.org/licenses/MIT).
