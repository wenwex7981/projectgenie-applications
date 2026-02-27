# Project Genie V1 Rebuild Plan

## Core Objectives
- Refactor to Clean Architecture.
- Implement Riverpod for state management.
- Standardize UI with 8px grid and production-grade theme.
- Build 5 core modules: Home, Projects, Internships, Career Services, Account.

## 1. Foundation
- [ ] Add Riverpod dependencies.
- [ ] Set up Folder Structure:
  - `lib/core` (Theme, Utils, Constants, Network).
  - `lib/features` (Home, Projects, Internships, Career, Account).
  - `lib/shared` (Reusable global widgets).
- [ ] Define Design System:
  - Primary: Royal Blue (`#1D3B8B`)
  - Accent: Indigo
  - Bg: Soft White (`#F6F6F8`)
  - Radius: 16px

## 2. Core Navigation
- [ ] Implement `MainNavigation` with 5 tabs.
- [ ] Set up `IndexedStack` for smooth tab switching.

## 3. Home Screen
- [ ] Header: Search, Notification, University Selector.
- [ ] Hero Carousel: Multi-page promotional slider.
- [ ] Browse by Degree: Horizontal chips.
- [ ] Dynamic Branch Filter: Context-aware dropdown.
- [ ] Featured Projects: High-fidelity vertical cards.
- [ ] Other Services Grid: Career service shortcuts.

## 4. Academic Projects Module
- [ ] Projects Listing with advanced filtering (Degree, Branch, Price, etc.).
- [ ] Project Detail View:
  - High-res header.
  - Domain/Stack tags.
  - Expandable Abstract.
  - "Bundle Includes" list.
  - Custom Title checkbox.
  - Cart/Buy actions.

## 5. Internships Module
- [ ] Internship Search & Filters.
- [ ] Listing Cards: Stipend, Remote/Onsite, Company details.
- [ ] Application Flow / Details.

## 6. Career Services Module
- [ ] Record & Observation Writing packages.
- [ ] Resume Writing (ATS focus) packages.
- [ ] Service Detail screens with file upload mock.

## 7. Short Courses & Quiz
- [ ] Course Listing.
- [ ] Timer-based Quiz UI.

## 8. Account Module
- [ ] Centralized Dashboard: My Orders, Certificates, Applications.
- [ ] Settings, Help, and Logout.

## 9. Polish & Quality
- [ ] Smooth transitions between screens.
- [ ] Consistent padding/spacing (8px grid).
- [ ] Error handling & state feedback (Loading, Empty, Error).
