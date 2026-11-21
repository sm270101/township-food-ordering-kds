# Hyper-Local Food Ordering & Kitchen Display System (KDS)

A zero-install, real-time food ordering storefront and Kitchen Display System (KDS) built for a gated industrial township of **1,300 residential units** (1,176 flats + 124 villas) outside third-party delivery coverage.

---

## The Problem
In remote, access-controlled residential townships where Swiggy and Zomato do not operate, residents rely on calling a single Club House landline during peak dinner hours. This creates three operational failures:
1. **Busy phone lines** leading to dropped orders during rush hours.
2. **Address & item miscommunication** across multi-phase housing blocks.
3. **Phantom orders** when dishes run out offline and residents aren't notified until after calling.

## The Solution
A lightweight, two-interface web application powered by **PostgreSQL Realtime WebSockets**, designed to run at **₹0 recurring infrastructure cost** without App Store gatekeeping:

* **Resident Ordering Web App (`index.html`):**
  * **Live Inventory Sync:** Dishes toggled `SOLD OUT` in the kitchen immediately disable on resident screens via WebSockets and auto-remove from active carts.
  * **Deterministic Unit Validation:** Entering a flat or villa number automatically maps and validates the exact township phase across 1,300 discrete unit ranges, eliminating delivery mix-ups.
  * **Real-Time 4-Step Order Tracker:** Live status progression (`Placed` $\rightarrow$ `Cooking` $\rightarrow$ `On Way` $\rightarrow$ `Delivered`) with itemized receipts and local profile persistence for 1-click repeat orders.
* **Kitchen Display System (`kitchen.html`):**
  * **Kanban Order Queue:** Live 3-column workflow (`New Orders`, `Preparing`, `Out with Runner`) with elapsed-time counters.
  * **Persistent Audio Alerts:** Web Audio API chime repeats every 4 seconds while unaccepted orders are pending.
  * **One-Tap Stock Switcher:** Searchable menu panel allowing kitchen staff to toggle item availability in real time.

---

## Tech Stack
* **Frontend:** HTML5, Tailwind CSS, Vanilla JavaScript (Zero build step, instant mobile PWA compatibility)
* **Backend & Database:** Supabase (PostgreSQL, Realtime WebSockets, Row Level Security)
* **Hosting:** Netlify / Cloudflare Pages

---

## Project Structure
```text
├── index.html          # Resident menu, unit validator, checkout & live order tracker
├── kitchen.html        # Restaurant KDS Kanban board, audio alerts & stock toggles
├── schema.sql          # PostgreSQL tables, Realtime publications, RLS policies & seed data
└── config.example.js   # Supabase client configuration template# township-food-ordering-kds
