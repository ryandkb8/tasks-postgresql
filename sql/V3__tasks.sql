CREATE TABLE tasks(
  id SERIAL,
  name text not null,
  description text not null,
  due_date timestamptz not null,
  completed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

CREATE TRIGGER update_updated_at_column BEFORE UPDATE ON tasks FOR EACH ROW EXECUTE PROCEDURE update_updated_at_coumn();
CREATE TRIGGER audit_log AFTER INSERT OR UPDATE OR DELETE ON tasks FOR EACH ROW EXECUTE PROCEDURE audit_log();

CREATE SCHEMA IF NOT EXISTS audit;
SET search_path to audit;

CREATE TABLE tasks(
  id SERIAL,
  task_id int not null,
  operation text not null,
  name text not null,
  description text not null,
  due_date timestamptz not null,
  completed_at timestamptz,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  audit_timestamp timestamptz not null default now()
);
