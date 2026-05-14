<div align="center">
<h1> CoPose </h1>


CoPose is a Flutter-powered mobile app that extracts pose skeletons from reference images and overlays them live on your camera feed — so you can mirror any pose in real time.
<br>
<!-- Badges -->
[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey?style=for-the-badge&logo=android&logoColor=white)

<br>

[Features](#-features)  · [Getting Started](#-getting-started) · [How It Works](#-how-it-works) · [Roadmap](#️-roadmap) ·

<br>
<br>

</div>


>[!Note] 
This project is a personal learning playground. It is not under active development and may contain unfinished features, rough edges, or breaking changes at any time. 

## ✨ Features

| Feature | Description |
|---|---|
| 🦴 **Pose Extraction** | Detects and maps body keypoints from any reference photo |
| 📷 **Live Camera Overlay** | Projects the extracted skeleton over your real-time camera feed |
| 🎯 **Pose Score** | Calculating a similiarity score to guide |
| 📱 **Cross-Platform** | Runs on both Android and iOS from a single codebase |

---


## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) **≥ 3.7.2**
- Android Studio / Xcode (for emulator) or physical device
- A physical device is recommended for camera features

**Notice that CoPose won't run on Web due to the need of PoseNet**

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/mitaku-dev/CoPose.git
cd CoPose/cos_pose

# 2. Install dependencies
flutter pub get

# 3. Run on your connected device or emulator
flutter run
```

### Build for Release

```bash
# Android
flutter build apk --release

# iOS
flutter build ipa --release
```

---

## 🧠 How It Works

CoPose uses on-device PoseNet to detect human body keypoints from a reference image and renders a skeleton overlay directly on the live camera feed.

```
Reference Image
      │
      ▼
┌─────────────────┐
│  Pose Estimator │  ← PoseNet model detects keypoints (shoulders, hips, knees, etc.)
│  (on-device   ) │
└────────┬────────┘
         │ Keypoint coordinates
         ▼
┌─────────────────┐
│ Skeleton Painter│  ← Draws lines & joints as a skeleton overlay to orientate
└────────┬────────┘
         │ Rendered skeleton
         ▼
┌─────────────────┐
│  Camera Preview │  ← Detect Position of person in live feed to position and scale scalaton guide
└─────────────────┘
```

### Tech Stack

- **Framework:** Flutter / Dart
- **Pose Estimation:** On-device (TFLite / PoseNet)
---

## 🗺️ Roadmap

- [x] **MVP** — Core pose overlay
- [ ] **Pose scoring** — Real-time accuracy feedback comparing your pose to the reference
- [ ] **Multi-person detection** — Support for group poses
- [ ] **Pose library** — Save and organize favorite reference poses
- [ ] **AR mode** — Augmented reality depth-aware overlay
- [ ] **Pose Guide** - AI Guide to recommand changes to archive the desired pose
- [ ] **Video reference** — Extract poses from video frames

---

