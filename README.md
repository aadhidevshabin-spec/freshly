# Grocery Reminder App

A Flutter app that helps you track grocery items and get notifications before they expire.

## Features

### 🏠 Home Page
- Clean, modern interface with "Grocery" title
- Checklist of all grocery items with color-coded expiry status
- Sort button to arrange items by expiry date (closest first)
- Add button (floating action button) to add new items
- Long press to select items for deletion
- Delete button appears when items are selected

### ➕ Add Item Page
- Yellow input field for item name
- Date picker for expiry date selection
- Save and Cancel buttons
- Form validation

### 🚨 Alert/Expired Page
- Shows only expired items
- Same selection and deletion functionality as home page
- Red-themed interface to indicate urgency

### 🎨 Color Coding System
- **Blue**: 3+ months until expiry
- **Green**: 30 days to 3 months until expiry  
- **Yellow**: 10-30 days until expiry
- **Red**: Less than 10 days until expiry or expired

### 🔔 Notifications
- Automatic notifications 1 day before expiry
- Notifications on expiry day
- Local notifications using flutter_local_notifications

### 🎭 Animations
- Smooth page transitions
- Animated slider on bottom navigation
- Fade-in animations for list items
- Smooth color transitions

### 📱 Navigation
- Bottom navigation with Home and Alert tabs
- Animated slider that moves between selected tabs
- Smooth transitions between pages

## Technical Features

- **Data Persistence**: Uses SharedPreferences for local storage
- **State Management**: Built-in Flutter state management
- **Date Handling**: Intl package for date formatting
- **Notifications**: Local notifications with timezone support
- **Animations**: Flutter Animate for smooth animations
- **Responsive Design**: Works on different screen sizes

## Getting Started

1. Make sure you have Flutter installed
2. Clone this repository
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to start the app

## Dependencies

- `shared_preferences`: For data persistence
- `intl`: For date formatting
- `flutter_local_notifications`: For local notifications
- `timezone`: For timezone support
- `flutter_animate`: For smooth animations

## Usage

1. **Adding Items**: Tap the + button, enter item name, select expiry date, and save
2. **Viewing Items**: All items are displayed on the home page with color-coded status
3. **Sorting**: Tap the sort button to arrange items by expiry date
4. **Deleting Items**: Long press an item to select it, then tap the delete button
5. **Viewing Expired**: Tap the Alert tab to see only expired items
6. **Notifications**: The app will automatically notify you before items expire

## Color Status Guide

- 🔵 **Blue**: Item is fresh (3+ months)
- 🟢 **Green**: Item is good (30 days - 3 months)
- 🟡 **Yellow**: Item needs attention (10-30 days)
- 🔴 **Red**: Item is expiring soon or expired (< 10 days)

Enjoy keeping track of your groceries! 🛒