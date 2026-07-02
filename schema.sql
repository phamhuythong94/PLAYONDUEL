-- Run this once in Supabase: Project → SQL Editor → New query → paste all → Run

-- Table of casinos/brands you're running affiliate for
create table casinos (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text not null unique,
  aff_link text not null,
  logo_url text,
  active boolean not null default true,
  sort_order int not null default 0,
  created_at timestamptz not null default now()
);

-- Table of big win entries shown on the leaderboard
create table wins (
  id uuid primary key default gen_random_uuid(),
  casino_id uuid not null references casinos(id) on delete cascade,
  player_name text not null,
  game text,
  amount numeric not null,
  image_url text,
  created_at timestamptz not null default now()
);

alter table casinos enable row level security;
alter table wins enable row level security;

-- Anyone (public visitors) can read active casinos
create policy "public read active casinos" on casinos
  for select using (active = true);

-- Anyone (public visitors) can read all wins
create policy "public read wins" on wins
  for select using (true);

-- Only logged-in users (your admin account) can add/edit/delete
create policy "admin manage casinos" on casinos
  for all using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');

create policy "admin manage wins" on wins
  for all using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');

-- Seed the first casino: Duel. Edit the aff_link to your real referral link.
insert into casinos (name, slug, aff_link, sort_order)
values ('Duel', 'duel', 'https://duel.win/?ref=YOUR_CODE', 1);
