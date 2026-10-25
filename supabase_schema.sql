-- =====================================================================
-- Control de Turnos SPB · Esquema para Supabase
-- Ejecutar completo en: Supabase > SQL Editor > New query > Run
-- Es seguro volver a ejecutarlo (usa IF NOT EXISTS / DROP IF EXISTS).
-- =====================================================================

-- 1) NOVEDADES: vacaciones, licencias, chequera y permisos ------------
create table if not exists public.novedades (
  id          bigint generated always as identity primary key,
  trabajador  text        not null,                       -- nombre tal como aparece en la herramienta
  tipo        text        not null
              check (tipo in ('Vacaciones','Licencia','Chequera','Permiso')),
  desde       date        not null,
  hasta       date        not null,
  created_at  timestamptz not null default now(),
  constraint novedades_fechas_ok check (hasta >= desde)
);
create index if not exists novedades_trabajador_idx on public.novedades (trabajador);
create index if not exists novedades_fechas_idx     on public.novedades (desde, hasta);

-- 2) PERSONAL AGREGADO A MANO (pestaña "Personal") --------------------
create table if not exists public.personal_manual (
  id          bigint generated always as identity primary key,
  nombre      text        not null,
  area        text        not null default 'General',
  ciclo_dia   smallint    check (ciclo_dia between 0 and 7),  -- día del ciclo de 8 días el lunes 19/10; NULL = por programar
  created_at  timestamptz not null default now()
);

-- 3) MÍNIMO DE PERSONAL POR TURNO, por área ---------------------------
create table if not exists public.minimos (
  area        text        primary key,
  minimo      integer     not null default 0 check (minimo >= 0),
  updated_at  timestamptz not null default now()
);

create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at := now();
  return new;
end $$;

drop trigger if exists minimos_updated_at on public.minimos;
create trigger minimos_updated_at
  before update on public.minimos
  for each row execute function public.set_updated_at();

-- 4) SEGURIDAD (RLS) Y PERMISOS ---------------------------------------
-- La herramienta no tiene inicio de sesión: usa la clave "anon".
-- Por eso las políticas permiten leer y escribir a anon/authenticated.
-- Ver nota de seguridad en el mensaje de entrega.
do $$
declare t text;
begin
  foreach t in array array['novedades','personal_manual','minimos'] loop
    execute format('alter table public.%I enable row level security', t);
    execute format('drop policy if exists "spb_acceso_app" on public.%I', t);
    execute format(
      'create policy "spb_acceso_app" on public.%I for all to anon, authenticated using (true) with check (true)', t);
    execute format('grant select, insert, update, delete on public.%I to anon, authenticated', t);
  end loop;
end $$;

grant usage on schema public to anon, authenticated;
