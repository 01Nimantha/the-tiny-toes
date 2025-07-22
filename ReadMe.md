# The Tiny Toes 👣

A Flutter-based **baby gallery app** developed as part of the Flutter Developer Internship challenge by **CeylonEdge**. This app demonstrates login authentication, state management, local storage, and API integration using JSONPlaceholder and Picsum.

---

## ![ The Tiny Toes Banner ](./docs/The%20Tiny%20Toes.png)

## 📱 Features

- ✅ Login screen with validation
- 🔒 Persistent login using local storage (`shared_preferences`)
- 👥 User listing page (fetched via JSONPlaceholder API)
- 📁 Albums for each user
- 🖼️ Gallery page showing photos using [Picsum.photos](https://picsum.photos)
- 🔍 Photo viewer with details
- 📦 State management using `Provider` and `MultiProvider`
- 🧭 Shared Navigation Bar with username, back, and logout
- 📸 Screenshots and demo video included

---

## 🧰 Tech Stack

- **Flutter SDK**: `3.32.7`
- **Dart SDK**: `3.8.1`
- **Java Version**: `17.0.8 (Microsoft OpenJDK)`
- **State Management**: `Provider`
- **Local Storage**: `shared_preferences`
- **REST APIs**:
  - [JSONPlaceholder](https://jsonplaceholder.typicode.com/)
  - [Picsum API](https://picsum.photos/v2/list?page=2&limit=100)

---

## 🚀 Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/01Nimantha/the-tiny-toes.git
cd the-tiny-toes/client/apps/baby_gallery
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Run the app

```bash
flutter run
```

⚠️ Make sure you are using the correct versions of Flutter, Dart, and Java as mentioned above.

### 🔐 Login Credentials

Use the following hardcoded credentials to log in:

```bash
Username: user
Password: pass1234@
```

### 📂 Folder Structure

```bash
the-tiny-toes/
│
├── client/
│    └──apps/
│       └── baby_gallery/    # Main Flutter app
├── docs/                         # Screenshots and demo video
│   ├── 5.1_login_screen.png
│   ├── 7.1_users_page.png
│   ├── 8.1_album_page.png
│   ├── 9.1_gallery_page.png
│   └── demo_video.mp4
├── README.md                     # This file
```

### 📸 Gallery API

For the gallery, this app uses:

📷 [Picsum.photos](https://picsum.photos)
– a simple photo API to fetch a list of 100 images.

Sample API response:

```bash
[
  {
    "id": "102",
    "author": "Ben Moore",
    "url": "https://unsplash.com/photos/pJILiyPdrXI",
    "download_url": "https://picsum.photos/id/102/4320/3240"
  },
  ...
]
```

Each image is displayed in a grid format. Clicking an image opens it in full view with its metadata.

### 📸 Screenshots & Demo

All screenshots and a full walkthrough video are available in the docs/ folder.

> 5.1_login_screen.png

> 7.1_users_page.png

> 8.1_album_page.png

> 9.1_gallery_page.png

> 10_Photo_Details_Page.png

> demo_video.mp4

### 📜 Assignment Reference

This project was developed in response to the official assignment brief provided by CeylonEdge as part of the Flutter Developer Internship challenge. The task included implementing login, persistent auth, fetching data via REST APIs, and managing app state using Provider.

## 👨‍💻 Developer

**Nimantha Madhushan**  
📍 Sri Lanka  
🔗 [GitHub](https://github.com/01Nimantha)  
🔗 [LinkedIn](https://linkedin.com/in/01nimantha)

### 📝 License

This project is part of a coding assignment and is not intended for commercial use.
