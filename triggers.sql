-- Existing triggers (from your input)
CREATE OR REPLACE TRIGGER trg_user_flat_check
BEFORE INSERT OR UPDATE ON users
FOR EACH ROW
DECLARE
  flat_status CHAR(1);
BEGIN
  SELECT is_occupied INTO flat_status
  FROM flats
  WHERE flat_no = :NEW.flat_no;
  IF flat_status != 'Y' THEN
    RAISE_APPLICATION_ERROR(-20001, 'Flat is not occupied. Cannot assign user.');
  END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20002, 'Flat does not exist.');
END;
/

CREATE OR REPLACE TRIGGER trg_visitor_flat_check
BEFORE INSERT OR UPDATE ON visitors
FOR EACH ROW
DECLARE
  v_dummy CHAR(1);
BEGIN
  SELECT 'X' INTO v_dummy
  FROM flats
  WHERE flat_no = :NEW.flat_no;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20003, 'Flat does not exist. Cannot allow visitor entry.');
END;
/

CREATE OR REPLACE TRIGGER trg_delivery_flat_check
BEFORE INSERT OR UPDATE ON deliveries
FOR EACH ROW
DECLARE
  d_dummy CHAR(1);
BEGIN
  SELECT 'X' INTO d_dummy
  FROM flats
  WHERE flat_no = :NEW.flat_no;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20004, 'Flat does not exist. Cannot allow delivery entry.');
END;
/

-- New trigger for visitor_log to auto-update visitor status
CREATE OR REPLACE TRIGGER trg_visitor_log_status
AFTER INSERT ON visitor_log
FOR EACH ROW
BEGIN
  UPDATE visitors
  SET flat_no = (SELECT flat_no FROM flats WHERE flat_no = (SELECT flat_no FROM visitors WHERE visitor_id = :NEW.visitor_id))
  WHERE visitor_id = :NEW.visitor_id;
END;
/

-- New trigger for delivery_log to auto-update delivery status
CREATE OR REPLACE TRIGGER trg_delivery_log_status
AFTER INSERT ON delivery_log
FOR EACH ROW
BEGIN
  UPDATE deliveries
  SET flat_no = (SELECT flat_no FROM flats WHERE flat_no = (SELECT flat_no FROM deliveries WHERE delivery_id = :NEW.delivery_id))
  WHERE delivery_id = :NEW.delivery_id;
END;
/
