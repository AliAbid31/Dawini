-- Dawini Supabase schema
-- Core tables, trigger, and baseline RLS policies

create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  email text not null unique,
  role text not null check (role in ('patient', 'pharmacy', 'admin')),
  phone text,
  preferred_language text not null default 'fr' check (preferred_language in ('fr', 'en')),
  created_at timestamptz not null default now()
);

create table if not exists public.patients (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid not null unique references public.profiles(id) on delete cascade,
  location text,
  birth_date date,
  gender text check (gender in ('M', 'F'))
);

create table if not exists public.pharmacies (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references public.profiles(id) on delete cascade,
  name text not null,
  address text not null,
  license_number text not null unique,
  is_verified boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.admins (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid not null unique references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now()
);

create table if not exists public.medicines (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  dci text,
  form text,
  dosage text,
  description text
);

create table if not exists public.inventory (
  id uuid primary key default gen_random_uuid(),
  pharmacy_id uuid not null references public.pharmacies(id) on delete cascade,
  medicine_id uuid not null references public.medicines(id) on delete cascade,
  quantity integer not null default 0 check (quantity >= 0),
  status text not null check (status in ('AVAILABLE', 'WEAK_STOCK', 'UNAVAILABLE')),
  updated_at timestamptz not null default now(),
  unique (pharmacy_id, medicine_id)
);

create table if not exists public.requests (
  id uuid primary key default gen_random_uuid(),
  patient_id uuid not null references public.profiles(id) on delete cascade,
  pharmacy_id uuid not null references public.pharmacies(id) on delete cascade,
  medicine_id uuid not null references public.medicines(id) on delete cascade,
  quantity integer not null default 1 check (quantity > 0),
  status text not null default 'PENDING' check (status in ('PENDING', 'CONFIRMED', 'OUT_OF_STOCK', 'REFUSED')),
  message text,
  created_at timestamptz not null default now()
);

create table if not exists public.alerts (
  id uuid primary key default gen_random_uuid(),
  patient_id uuid not null references public.profiles(id) on delete cascade,
  pharmacy_id uuid not null references public.pharmacies(id) on delete cascade,
  medicine_id uuid not null references public.medicines(id) on delete cascade,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (
    id,
    full_name,
    email,
    role,
    preferred_language
  ) values (
    new.id,
    new.raw_user_meta_data->>'full_name',
    new.email,
    coalesce(new.raw_user_meta_data->>'role', 'patient'),
    coalesce(new.raw_user_meta_data->>'preferred_language', 'fr')
  );
  return new;
end;
$$ language plpgsql security definer;

drop trigger if exists on_auth_user_created on auth.users;

create trigger on_auth_user_created
after insert on auth.users
for each row execute procedure public.handle_new_user();

alter table public.profiles enable row level security;
alter table public.patients enable row level security;
alter table public.admins enable row level security;
alter table public.pharmacies enable row level security;
alter table public.medicines enable row level security;
alter table public.inventory enable row level security;
alter table public.requests enable row level security;
alter table public.alerts enable row level security;

drop policy if exists "profiles_self" on public.profiles;
create policy "profiles_self"
on public.profiles
for all
using (auth.uid() = id)
with check (auth.uid() = id);

drop policy if exists "requests_patient_self" on public.requests;
create policy "requests_patient_self"
on public.requests
for all
using (auth.uid() = patient_id)
with check (auth.uid() = patient_id);

drop policy if exists "inventory_pharmacy_owner" on public.inventory;
create policy "inventory_pharmacy_owner"
on public.inventory
for all
using (
  exists (
    select 1
    from public.pharmacies p
    where p.id = inventory.pharmacy_id
      and p.owner_id = auth.uid()
  )
)
with check (
  exists (
    select 1
    from public.pharmacies p
    where p.id = inventory.pharmacy_id
      and p.owner_id = auth.uid()
  )
);

drop policy if exists "alerts_patient_self" on public.alerts;
create policy "alerts_patient_self"
on public.alerts
for all
using (auth.uid() = patient_id)
with check (auth.uid() = patient_id);

-- Patient details: owner only
drop policy if exists "patients_self" on public.patients;
create policy "patients_self"
on public.patients
for all
using (auth.uid() = profile_id)
with check (auth.uid() = profile_id);

-- Admin details: owner only
drop policy if exists "admins_self" on public.admins;
create policy "admins_self"
on public.admins
for all
using (auth.uid() = profile_id)
with check (auth.uid() = profile_id);

-- Pharmacies: owner manages, everyone can read
drop policy if exists "pharmacies_select" on public.pharmacies;
create policy "pharmacies_select"
on public.pharmacies
for select
using (true);

drop policy if exists "pharmacies_self" on public.pharmacies;
create policy "pharmacies_self"
on public.pharmacies
for insert
with check (auth.uid() = owner_id);

drop policy if exists "pharmacies_self_update" on public.pharmacies;
create policy "pharmacies_self_update"
on public.pharmacies
for update
using (auth.uid() = owner_id)
with check (auth.uid() = owner_id);

-- Medicines: readable by all authenticated users
drop policy if exists "medicines_read" on public.medicines;
create policy "medicines_read"
on public.medicines
for select
using (true);

-- ---------------------------------------------------------------------------
-- Admin full access
-- ---------------------------------------------------------------------------

-- Helper: returns true when the current user is an admin.
-- security definer -> bypasses RLS on profiles to avoid infinite recursion
-- when this function is called from a policy defined on profiles itself.
create or replace function public.is_admin()
returns boolean as $$
  select exists (
    select 1
    from public.profiles
    where id = auth.uid()
      and role = 'admin'
  );
$$ language sql security definer stable;

-- Admins can read and manage every table.
drop policy if exists "admin_all_profiles" on public.profiles;
create policy "admin_all_profiles"
on public.profiles
for all
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "admin_all_patients" on public.patients;
create policy "admin_all_patients"
on public.patients
for all
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "admin_all_admins" on public.admins;
create policy "admin_all_admins"
on public.admins
for all
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "admin_all_pharmacies" on public.pharmacies;
create policy "admin_all_pharmacies"
on public.pharmacies
for all
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "admin_all_medicines" on public.medicines;
create policy "admin_all_medicines"
on public.medicines
for all
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "admin_all_inventory" on public.inventory;
create policy "admin_all_inventory"
on public.inventory
for all
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "admin_all_requests" on public.requests;
create policy "admin_all_requests"
on public.requests
for all
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "admin_all_alerts" on public.alerts;
create policy "admin_all_alerts"
on public.alerts
for all
using (public.is_admin())
with check (public.is_admin());