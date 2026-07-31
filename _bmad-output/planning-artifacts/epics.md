---
stepsCompleted: [1, 2, 3, 4]
inputDocuments: ["pubspec.yaml", "lib/src/features"]
---

# auto-ease - Epic Breakdown

## Overview

This document provides the complete epic and story breakdown for auto-ease, decomposing the requirements from the PRD, UX Design, and Architecture requirements into implementable stories.

## Requirements Inventory

### Functional Requirements

- FR1: User Authentication & Onboarding (registration, login, role management for Customer/Mechanic with multi-role support, Supabase auth integration, session persistence, JWT auto-refresh)
- FR2: Location & Map Exploration (interactive Google Map with Guest mode exploration, current location via geolocator with permission/GPS fallback & manual search, service center markers, distance filtering, category search, dynamic rating ranking)
- FR3: Service Center Discovery & Profiles (service center profile details, services catalog, pricing, operating hours, photos, ratings, bottom sheet previews)
- FR4: Service Booking & Scheduling (appointment scheduling flow via interactive bottom sheets, vehicle selection, slot concurrency protection via Supabase RPC/atomic transactions, idempotent submission keys with retry policy, booking confirmation, status tracking)
- FR5: Real-time Live Tracking & Status Updates (live mechanic/roadside assistance tracking with battery-efficient adaptive geolocation polling, service progress updates, automated lifecycle cleanup upon completion)
- FR6: In-App Chat & Communication (real-time chat between customer and mechanic/service provider via Supabase Realtime with private RLS-protected storage buckets, client-side media compression & validation, offline message queueing, read-only chat archiving post-completion, auto reconnect on JWT refresh)
- FR7: Customer Reviews & Ratings (post-service feedback restricted strictly to completed bookings, rating submission, photo attachments via private storage, service provider responses, automated DB rating aggregation triggers)
- FR8: Profile & Vehicle Management (user profile editing, multiple vehicle management with soft-deletion/archival integrity, service history log, shared Riverpod providers)

### NonFunctional Requirements

- NFR1: Responsiveness & Performance (60 FPS UI rendering, map loading under 1.5s, marker clustering, adaptive battery-friendly location polling, client-side media compression)
- NFR2: Security & Data Encryption (Supabase RLS policies per role & session, private storage bucket access via signed URLs, secure token storage via shared_preferences/secure storage)
- NFR3: Offline Resiliency & Graceful Degradation (cached profile & vehicle data, optimistic UI, offline chat queue, clear offline banner)
- NFR4: Real-Time Sync Reliability (sub-second WebSocket sync for chat & booking status changes with background reconnect, idempotent RPC endpoints)

### Additional Requirements

- Flutter 3.2+ with Riverpod state management (`flutter_riverpod`, `riverpod_generator`)
- Declarative navigation with `go_router`
- Supabase integration (`supabase_flutter`) for Auth, DB, Storage, and Realtime (including DB trigger functions for rating recalculation)
- BDD Widget Testing (`bdd_widget_test`) and CI/CD pipelines

### UX Design Requirements

- UX-DR1: Automotive modern design system (Google Fonts, custom tokens, smooth animations via `flutter_animate`)
- UX-DR2: Accessibility compliance (high-contrast ratios, min 48dp touch targets, semantic labels)
- UX-DR3: Interactive map UI with custom map pins, marker clustering, bottom sheet modal drawers for contextual navigation

### FR Coverage Map

- FR1 -> Epic 1 (Story 1.1, Story 1.2)
- FR8 -> Epic 1 (Story 1.2, Story 1.3)
- FR2 -> Epic 2 (Story 2.1, Story 2.2)
- FR3 -> Epic 2 (Story 2.2, Story 2.3)
- FR4 -> Epic 3 (Story 3.1, Story 3.2, Story 3.3)
- FR5 -> Epic 4 (Story 4.3)
- FR6 -> Epic 4 (Story 4.1, Story 4.2)
- FR7 -> Epic 5 (Story 5.1, Story 5.2)

## Epic List

### Epic 1: User Authentication & Vehicle Profile Management
Users can register, authenticate with flexible multi-role support (Customer/Mechanic), manage their profile, enforce Supabase RLS isolation, and store vehicle details with soft-deletion/archival protection and offline caching support.
**FRs covered:** FR1, FR8

### Epic 2: Location-Based Discovery & Service Center Profiles
Users (including guest users) can discover nearby car service centers on an interactive map with marker clustering & location permission/GPS fallbacks, filter by services & dynamic ratings, and inspect detailed profiles via bottom sheets.
**FRs covered:** FR2, FR3

### Epic 3: Service Booking & Scheduling Workflow
Users can select services via bottom sheet drawers, pick date/time slots with atomic double-booking prevention, choose vehicles, and submit bookings using idempotent submission keys with optimistic UI updates and status tracking.
**FRs covered:** FR4

### Epic 4: Real-Time Tracking & In-App Communication
Users can track live mechanic/roadside dispatches via battery-friendly adaptive polling and chat in real-time with service providers using private RLS-secured media buckets (with compressed uploads & offline message queueing), background reconnect logic, and post-completion session/chat archiving.
**FRs covered:** FR5, FR6

### Epic 5: Customer Reviews & Service History
Users can view complete service history logs and leave ratings, reviews, and private photos (strictly for completed bookings), triggering automated DB rating aggregation for search ranking.
**FRs covered:** FR7

---

## Epic 1: User Authentication & Vehicle Profile Management

### Story 1.1: User Onboarding, Multi-Role Registration & Supabase Auth Integration

As a new user,  
I want to register an account using email/password or phone and select my role (Customer or Mechanic/Service Provider),  
So that I can securely authenticate, persist my session, and access role-specific application features.

**Acceptance Criteria:**

**Given** an unauthenticated user on the onboarding/registration screen,  
**When** they enter valid credentials, select a role (Customer or Mechanic/Service Center), and submit,  
**Then** an account is created in Supabase Auth, a corresponding record is inserted into the `profiles` table with role metadata, and the user is redirected to the home screen.  
**And** JWT authentication tokens are saved in secure storage (`shared_preferences`/secure storage) with automatic background token refresh before expiration.

### Story 1.2: User Profile Editing & Role-Based Supabase RLS Security Policy

As an authenticated user,  
I want to view and edit my profile details and switch/add service provider roles if needed,  
So that my profile remains up to date while enforcing strict data isolation so only authorized users can access my personal data.

**Acceptance Criteria:**

**Given** an authenticated user on the profile screen,  
**When** they update their name, phone, or avatar photo and save changes,  
**Then** the updated information is persisted in Supabase `profiles` table.  
**And** Supabase Row Level Security (RLS) policies strictly enforce that users can only read/write their own profile data, while allowing Mechanics to expose public service center details.

### Story 1.3: Vehicle Profile Management with Soft-Deletion Archival & Offline Caching

As a customer user,  
I want to add, edit, view, and soft-delete my vehicle profiles (make, model, year, license plate),  
So that I can select specific vehicles when booking car services even when working offline.

**Acceptance Criteria:**

**Given** an authenticated customer in the Vehicle Management section,  
**When** they add a new vehicle or archive an existing vehicle,  
**Then** the vehicle record is written to Supabase `vehicles` table (with `is_deleted = true` for soft-deletion) and cached locally via Riverpod `NotifierProvider`.  
**And** when the app is offline, cached vehicle profiles remain available for view and booking preparation with an offline indicator banner.

---

## Epic 2: Location-Based Discovery & Service Center Profiles

### Story 2.1: Interactive Map Setup, Geolocator Location Permission Fallback & Guest Exploration

As a guest or registered user,  
I want to explore an interactive Google Map centered on my current location or a searched city,  
So that I can immediately discover car service centers nearby without mandatory initial login.

**Acceptance Criteria:**

**Given** any app user opening the map view,  
**When** the app requests location permissions via `geolocator`,  
**Then** if permission is granted, the map centers on current GPS coordinates; if denied or offline (`onPlatformException`), the app displays a graceful fallback search bar allowing manual city/postal code entry.

### Story 2.2: Service Center Marker Clustering, Category Filtering & Dynamic Rating Ranking

As a user searching for car repair services,  
I want to filter service centers by service category (e.g., Oil Change, Engine Repair, Towing) and dynamic customer rating,  
So that map markers are clearly clustered without UI lag and I can find top-rated providers quickly.

**Acceptance Criteria:**

**Given** a user viewing map markers in a high-density area,  
**When** they zoom out or apply a category/rating filter,  
**Then** markers cluster smoothly retaining 60 FPS performance, and only service centers meeting the filter criteria (ranked by Supabase aggregated rating) are rendered.

### Story 2.3: Service Center Profile Drawer, Pricing Catalog & Bottom Sheet Preview

As a user inspecting a map marker,  
I want to tap a service center pin to open an interactive bottom sheet drawer showing services, pricing, photos, and ratings,  
So that I can review provider details in context without leaving the map screen.

**Acceptance Criteria:**

**Given** a user viewing the map screen,  
**When** they tap on a service center marker,  
**Then** a responsive bottom sheet modal drawer slides up smoothly using `flutter_animate`, displaying operating hours, service catalog with prices, ratings, and a prominent "Book Service" button.

---

## Epic 3: Service Booking & Scheduling Workflow

### Story 3.1: Service Selection & Vehicle Appointment Scheduling Flow

As a registered customer,  
I want to select specific car services, pick a saved vehicle, and choose an available date/time slot,  
So that I can prepare a complete service booking.

**Acceptance Criteria:**

**Given** an authenticated customer tapping "Book Service" on a service center drawer,  
**When** they select target services, select a vehicle from their cached vehicle list, and pick an available date/time slot,  
**Then** a booking summary review card is rendered displaying selected services, total estimated price, and vehicle details.

### Story 3.2: Idempotent Booking Submission & Atomic Concurrency Slot Reservation (Supabase RPC)

As a customer submitting a booking,  
I want my booking to be processed atomically without double-booking or duplicate charges on network retries,  
So that my appointment is guaranteed and resistant to network timeouts.

**Acceptance Criteria:**

**Given** a customer submitting a booking confirmation,  
**When** the submission request is sent with a client-generated UUID idempotency key via a Supabase SQL RPC procedure (`SELECT FOR UPDATE`),  
**Then** the appointment slot is atomically locked preventing double-booking; if a network timeout occurs, Riverpod retries the request safely using the same idempotency key without creating duplicate entries.

### Story 3.3: User Booking Management Dashboard & Status Timeline Tracking

As a customer or service provider,  
I want to view a timeline dashboard of my active and past bookings (Pending, Confirmed, In Progress, Completed, Cancelled),  
So that I can monitor service status in real time.

**Acceptance Criteria:**

**Given** an authenticated user navigating to the Booking Dashboard,  
**When** a booking status changes (e.g., from Confirmed to In Progress),  
**Then** the status timeline updates instantly via Supabase Realtime stream with visual progress indicators and status badges.

---

## Epic 4: Real-Time Tracking & In-App Communication

### Story 4.1: Real-Time In-App Chat with Supabase Realtime & Offline Queueing

As a customer or mechanic,  
I want to communicate via real-time text chat within an active booking,  
So that we can clarify vehicle issue details and send status updates instantly.

**Acceptance Criteria:**

**Given** a customer and mechanic in an active booking session,  
**When** either party sends a message,  
**Then** the message appears in sub-second time via Supabase Realtime WebSockets; if sent while momentarily offline, the message is queued in local Riverpod state and sent automatically upon reconnection.

### Story 4.2: Private RLS-Secured Chat Attachment Uploads & Client-Side Compression

As a user in a chat session,  
I want to send photos or videos of vehicle damage,  
So that the mechanic can inspect the issue visually with secure access restrictions.

**Acceptance Criteria:**

**Given** a user uploading an image or video in chat,  
**When** the media is selected,  
**Then** it is compressed client-side (Max 10MB limit) and uploaded to a private Supabase Storage bucket accessible exclusively via signed URLs by the customer and assigned mechanic for that booking.

### Story 4.3: Live Mechanic Location Tracking with Adaptive Polling & Session Archiving

As a customer awaiting roadside assistance or mobile repair,  
I want to see the mechanic's live location on the map with battery-efficient updates,  
So that I can track their estimated arrival time in real time until service completion.

**Acceptance Criteria:**

**Given** an active dispatch booking in progress,  
**When** the mechanic is en route,  
**Then** their GPS location streams to the customer's map using adaptive polling intervals (5-10s); when the booking transitions to `Completed`, live location streaming terminates automatically and chat shifts to archived read-only mode.

---

## Epic 5: Customer Reviews & Service History

### Story 5.1: Vehicle Service History Log & Completed Booking Archival

As a vehicle owner,  
I want to view a complete historical log of all completed service bookings for each of my vehicles,  
So that I can track maintenance history and past expenses over time.

**Acceptance Criteria:**

**Given** a customer viewing a vehicle profile,  
**When** they select "Service History",  
**Then** a chronological timeline of completed service bookings (showing service center name, date, services performed, total cost, and invoice notes) is rendered from Supabase.

### Story 5.2: Post-Service Review & Rating Submission with Automated Supabase Rating Aggregation Triggers

As a customer with a completed service booking,  
I want to rate (1-5 stars), review, and upload photos of completed work for the service center,  
So that I can share my feedback and help other users discover quality service centers.

**Acceptance Criteria:**

**Given** a customer with a booking in `Completed` status,  
**When** they submit a rating score, written review, and optional photos,  
**Then** the review record is saved to Supabase `reviews` table (enforced by RLS to permit reviews only for completed bookings).  
**And** a Supabase database trigger automatically recalculates `avg_rating` and `total_reviews` on the service center profile table, immediately updating map search ranking in Epic 2.
