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