-- ============================================================================
-- Township Hyper-Local Food Ordering & Kitchen Display System (KDS)
-- PostgreSQL Schema, Realtime Publication & Row Level Security (RLS)
-- ============================================================================

-- 1. Menu Items Table
create table menu_items (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  category text not null,
  diet_type text default 'Veg' check (diet_type in ('Veg', 'Non-Veg')),
  portion_size text,
  price numeric(10, 2) not null check (price >= 0),
  is_available boolean default true,
  updated_at timestamp with time zone default timezone('utc'::text, now())
);

-- 2. Order Lifecycle Status Enum
create type order_status as enum (
  'placed',
  'accepted',
  'out_for_delivery',
  'delivered',
  'cancelled'
);

-- 3. Orders Table
create table orders (
  id uuid primary key default gen_random_uuid(),
  customer_name text not null,
  customer_phone text not null,
  quarter_number text not null,
  total_amount numeric(10, 2) not null check (total_amount >= 0),
  payment_method text not null check (payment_method in ('COD', 'UPI_ON_DELIVERY')),
  status order_status default 'placed',
  rejection_reason text,
  created_at timestamp with time zone default timezone('utc'::text, now())
);

-- 4. Order Line Items Join Table
create table order_items (
  id uuid primary key default gen_random_uuid(),
  order_id uuid references orders(id) on delete cascade,
  item_id uuid references menu_items(id) on delete set null,
  item_name text not null,
  quantity integer not null check (quantity > 0),
  price_at_order numeric(10, 2) not null check (price_at_order >= 0)
);

-- 5. Enable Supabase Realtime WebSocket Publications
alter publication supabase_realtime add table orders;
alter publication supabase_realtime add table menu_items;

-- 6. Enable Row Level Security (RLS)
alter table menu_items enable row level security;
alter table orders enable row level security;
alter table order_items enable row level security;

-- 7. Menu Policies (Public read-only; stock status update allowed; no client INSERT/DELETE)
create policy "Public read menu"
  on menu_items for select using (true);

create policy "Kitchen update stock"
  on menu_items for update using (true) with check (true);

-- 8. Orders Policies (Residents can place & track; kitchen updates status; no DELETE)
create policy "Anyone can place order"
  on orders for insert with check (true);

create policy "Anyone can view orders"
  on orders for select using (true);

create policy "Update order status"
  on orders for update using (true) with check (true);

-- 9. Order Items Policies (Insert & read only; immutable once placed)
create policy "Anyone can insert order items"
  on order_items for insert with check (true);

create policy "Anyone can read order items"
  on order_items for select using (true);

-- 10. Sample Seed Data for Local / Sandbox Testing
insert into menu_items (name, category, diet_type, portion_size, price, is_available) values
  ('Paneer Tikka Masala', 'Main Course (North Indian)', 'Veg', '6 pcs', 160, true),
  ('Butter Chicken', 'Main Course (North Indian)', 'Non-Veg', '6 pcs', 194, true),
  ('Garlic Butter Naan', 'Indian Breads', 'Veg', '1 nos', 23, true),
  ('Chicken Biryani', 'Biryani & Rice', 'Non-Veg', '300 gms', 148, true),
  ('Cold Coffee', 'Beverages', 'Veg', '200 ml', 80, false);