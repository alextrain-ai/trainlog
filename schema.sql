-- TrainLog v2 schema — paste into Supabase SQL Editor and Run.
-- Single-user app today; owner_id columns are the seam for multi-user later.

create table if not exists kv (
  key text primary key,
  value jsonb,
  owner_id text not null default 'alex'
);

create table if not exists program_exercises (
  id text primary key,
  session_key text not null,
  name text not null,
  sets int not null default 3,
  rep_lo int not null default 8,
  rep_hi int not null default 12,
  increment numeric not null default 2.5,
  unit text not null default 'kg',
  sort_order int not null default 0,
  active boolean not null default true,
  is_custom boolean not null default false,
  owner_id text not null default 'alex'
);

create table if not exists logs (
  id bigint primary key,
  date date not null,
  session_key text not null,
  notes text not null default '',
  entries jsonb not null default '{}'::jsonb,
  ex_order jsonb,
  owner_id text not null default 'alex',
  created_at timestamptz not null default now()
);

create table if not exists bodyweights (
  date date primary key,
  kg numeric not null,
  owner_id text not null default 'alex'
);

alter table kv enable row level security;
alter table program_exercises enable row level security;
alter table logs enable row level security;
alter table bodyweights enable row level security;

-- Permissive anon policies (PIN enforced app-side; tighten when real auth lands)
create policy anon_all_kv on kv for all using (true) with check (true);
create policy anon_all_program on program_exercises for all using (true) with check (true);
create policy anon_all_logs on logs for all using (true) with check (true);
create policy anon_all_bw on bodyweights for all using (true) with check (true);
