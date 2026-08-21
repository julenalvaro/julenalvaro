-- Trivial Marcador · esquema de la sala compartida
-- Pegar tal cual en Supabase: SQL Editor → New query → Run

create table if not exists sala_jugadores (
  sala   text not null,
  nombre text not null,
  puntos numeric not null default 0,
  actualizado timestamptz not null default now(),
  primary key (sala, nombre)
);

create table if not exists partidas (
  id bigint generated always as identity primary key,
  sala  text not null,
  fecha timestamptz not null default now(),
  resultados jsonb not null
);

create index if not exists partidas_sala_fecha on partidas (sala, fecha desc);

-- Acceso anónimo controlado (nivel cuadrilla): leer y escribir marcadores,
-- y solo añadir/leer partidas (nunca borrarlas ni editarlas).
alter table sala_jugadores enable row level security;
alter table partidas enable row level security;

create policy anon_marcador on sala_jugadores
  for all to anon using (true) with check (true);

create policy anon_leer_partidas on partidas
  for select to anon using (true);

create policy anon_guardar_partidas on partidas
  for insert to anon with check (true);
