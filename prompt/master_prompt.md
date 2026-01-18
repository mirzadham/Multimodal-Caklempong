Act as a Senior Multimodal Interaction Architect and Lead Flutter Developer. I am working on a final-year university group project to re-design a traditional Malay musical instrument into a digital mobile application.

**Project Context:**
* **Instrument:** Caklempong (Traditional Minangkabau gong-chime percussion).
* **Goal:** Create a "Pocket Caklempong" app that uses multimodal interaction to enhance accessibility.
* **Architecture:** **MVVM (Model-View-ViewModel)**. Strict separation of logic and UI.
* **State Management:** `ChangeNotifier` (ViewModel) and `Provider` (or `ListenableBuilder`).

**UI/UX Design & Theming (Crucial):**
* **Theme Name:** "Royal Minangkabau."
* **Color Palette:**
    * **Background:** Deep Charcoal or Black (`#1A1A1A`) to represent the "Baju Melayu" darkness and make the instrument pop.
    * **Primary (Gongs):** Metallic Gold/Bronze gradients (Radial Gradient from `#FFD700` to `#B8860B`) to mimic the physical brass construction of the Caklempong pots.
    * **Accents:** Maroon/Dark Red (`#800000`) for active states or borders.
* **Visual Style:**
    * Use **Skeuomorphic touches** for the gongs (make them look 3D using shadows and gradients) so users feel like they are hitting a physical object.
    * Use a subtle background pattern (if possible via code) or a clean dark surface.

**Requirements (Multimodal Interaction):**
1.  **Touch (Input):** User taps the Gold Gongs. Support multi-touch (chords).
2.  **Haptics (Tactile Feedback):** Trigger a vibration pattern via the ViewModel when a gong is tapped.
3.  **Visual (Feedback):** When tapped, the Gong should glow brighter or shrink slightly (scale animation) to mimic impact.
4.  **Gesture (Motion Control):** The ViewModel subscribes to the accelerometer. If the phone is tilted forward (pitch > 45 degrees), trigger "Mute/Dampen" logic.

**Technical Constraints:**
* **Packages:** `audioplayers`, `sensors_plus`, `vibration`, `provider`.
* **Asset Management:** All assets are local.
* **Code Style:** Clean, modular, production-ready MVVM.

**Output Deliverables:**

**1. Product Requirements Document (PRD) - Architecture & Design:**
* **MVVM Explanation:** Brief breakdown of Model vs. ViewModel vs. View.
* **Design Rationale:** Explain why the Black/Gold theme was chosen (Cultural authenticity + High Contrast for visibility).
* **User Flow:** Simple walkthrough of the user experience.

**2. Flutter Project Structure:**
* Tree view of the `lib` folder (`models`, `viewmodels`, `views`, `widgets`, `theme`).

**3. Implementation Code (MVVM + Theming):**
* **`theme/app_colors.dart`:** Define the specific Hex codes for Gold, Charcoal, and Maroon.
* **`models/gong_model.dart`:** Data class for the gong.
* **`viewmodels/caklempong_viewmodel.dart`:**
    * `ChangeNotifier` handling Audio, Sensors, and Haptics.
    * Logic for "Tilt to Mute."
* **`widgets/gong_button.dart`:**
    * A reusable widget for a single Gong.
    * **IMPORTANT:** Use `Container` with `BoxDecoration` (RadialGradient and BoxShadow) to create the "3D Gold Metal" look purely in code (no images needed yet).
* **`views/caklempong_view.dart`:**
    * The main screen assembling the grid of Gong widgets.
    * Background color implementation.

Ensure the code creates a visually impressive UI ("Gold gongs on dark background") immediately upon running.