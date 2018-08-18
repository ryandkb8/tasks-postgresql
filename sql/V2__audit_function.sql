CREATE OR REPLACE FUNCTION audit_log()
RETURNS TRIGGER AS $$
BEGIN
  IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
    INSERT INTO audit.tasks(task_id, operation, name, description, due_date, completed_at, created_at, updated_at) VALUES (NEW.id, TG_OP, NEW.name, NEW.description, NEW.due_date, NEW.completed_at, NEW.created_at, new.updated_at);
  ELSIF (TG_OP = 'DELETE') THEN
    INSERT INTO audit.tasks(task_id, operation, name, description, due_date, completed_at, created_at, updated_at) VALUES (OLD.id, TG_OP, OLD.name, OLD.description, OLD.due_date, OLD.completed_at, old.created_at, old.updated_at);
  END IF;
  RETURN NULL;
END;
$$ language 'plpgsql'
