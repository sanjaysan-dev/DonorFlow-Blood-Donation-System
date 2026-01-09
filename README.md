# 🩸 DonorFlow - Blood Donation Management System

![Java](https://img.shields.io/badge/Java-17-orange)
![Tomcat](https://img.shields.io/badge/Tomcat-9.0-yellow)
![MySQL](https://img.shields.io/badge/MySQL-8.0-blue)
![Docker](https://img.shields.io/badge/Docker-Ready-2496ED)
![License](https://img.shields.io/badge/License-MIT-green)

**DonorFlow** is a robust and efficient web application designed to bridge the gap between blood donors and those in need. Built with Java Servlets, JSP, and MySQL, it creates a seamless flow of life-saving information.

---

## 🌟 Key Features

### 🔐 For Users (Donors & Requesters)
*   **Secure Registration & Login:** fast and secure access.
*   **Donate Blood:** Schedule donations at specific camps or locations.
*   **Request Blood:** Raise urgent requests for blood units.
*   **Dashboard:** Track donation history and request status in real-time.

### 🛡️ For Admins
*   **Centralized Dashboard:** Overview of total stock, pending requests, and donor lists.
*   **Stock Management:** Real-time updates of blood units available (A+, B-, O+, etc.).
*   **Request Approval:** Verify and approve/reject blood requests.
*   **Donation Management:** Validate donations and update stock automatically.

---

## 🛠️ Tech Stack

*   **Backend:** Java 17, Servlets, JSP
*   **Database:** MySQL 8.0 (Compatible with Aiven/Cloud SQL)
*   **Frontend:** HTML5, CSS3, JavaScript, Bootstrap (JSP Pages)
*   **Build Tool:** Maven
*   **Containerization:** Docker (Multi-stage build)

---

## 🚀 Getting Started

### Prerequisites
*   Java JDK 17+
*   Maven 3.8+
*   MySQL Server 8.0+ (or Docker)

### 💻 Local Setup

1.  **Clone the Repository**
    ```bash
    git clone https://github.com/yourusername/blood-donation.git
    cd blood-donation
    ```

2.  **Database Configuration**
    The app automatically sets up the database schema on the first run. By default, it looks for:
    *   **URL:** `jdbc:mysql://localhost:3306/donordb`
    *   **User:** `root`
    *   **Password:** `Sanjaysan3556@`
    
    *To change this, edit `src/main/java/com/donorflow/config/DBClass.java` or use Environment Variables.*

3.  **Build & Run**
    ```bash
    mvn clean package
    # Deploy the target/ROOT.war to your Tomcat server
    ```
    *Or run via Smart Tomcat in IntelliJ IDEA.*

---

## ☁️ Cloud Deployment (Render + Aiven)

This project is cloud-ready!

### 1. Database (Aiven)
*   Create a MySQL service on Aiven.
*   Note the **Host**, **Port**, **User**, and **Password**.

### 2. Application (Render)
*   Create a new **Web Service** on Render linked to this repo.
*   **Runtime:** Docker
*   **Environment Variables:**

| Variable | Value Example |
| :--- | :--- |
| `DB_URL` | `jdbc:mysql://<HOST>:<PORT>/defaultdb?sslMode=REQUIRED` |
| `DB_USER` | `avnadmin` |
| `DB_PASS` | `<your-password>` |

---

## 👤 Default Admin Credentials

When the system starts for the first time, it automatically creates a super-admin account:

*   **Email:** `admin@donorflow.com`
*   **Password:** `password`

---

## 📂 Project Structure

```text
src/main
├── java/com/donorflow
│   ├── config/      # DB Connections & Auto-Setup
│   ├── controller/  # Servlets (Login, Register, Donate)
│   ├── dao/         # Data Access Objects
│   ├── model/       # DTOs (User, Donation, Request)
│   └── services/    # Business Logic
└── webapp/          # JSP Pages, CSS, JS
```

---

## 🤝 Contributing

Contributions are welcome! Please fork this repository and submit a pull request.

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.
