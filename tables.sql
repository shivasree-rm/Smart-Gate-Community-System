CREATE TABLE flats (
  flat_no VARCHAR2(10) PRIMARY KEY,
  block VARCHAR2(10),
  floor NUMBER,
  is_occupied CHAR(1) CHECK (is_occupied IN ('Y', 'N'))
);

CREATE TABLE users (
  user_id NUMBER PRIMARY KEY,
  name VARCHAR2(100),
  phone VARCHAR2(15),
  email VARCHAR2(100) UNIQUE,
  password VARCHAR2(100),
  role VARCHAR2(20),
  flat_no VARCHAR2(10),
  FOREIGN KEY (flat_no) REFERENCES flats(flat_no) ON DELETE SET NULL
);

CREATE TABLE vehicles (
  vehicle_id NUMBER PRIMARY KEY,
  user_id NUMBER,
  vehicle_number VARCHAR2(20) UNIQUE,
  type VARCHAR2(20),
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE guards (
  guard_id NUMBER PRIMARY KEY,
  name VARCHAR2(100),
  phone VARCHAR2(15),
  shift_start_time TIMESTAMP,
  shift_end_time TIMESTAMP
);

CREATE TABLE visitors (
  visitor_id NUMBER PRIMARY KEY,
  name VARCHAR2(100),
  phone VARCHAR2(15),
  flat_no VARCHAR2(10),
  FOREIGN KEY (flat_no) REFERENCES flats(flat_no)
);

CREATE TABLE emergency_contacts (
  contact_id NUMBER PRIMARY KEY,
  name VARCHAR2(100),
  role VARCHAR2(50),
  phone VARCHAR2(15),
  availability VARCHAR2(50)
);

CREATE TABLE deliveries (
  delivery_id NUMBER PRIMARY KEY,
  delivery_person_name VARCHAR2(100),
  phone VARCHAR2(15),
  flat_no VARCHAR2(10),
  FOREIGN KEY (flat_no) REFERENCES flats(flat_no)
);

CREATE TABLE loginuser (
  user_id NUMBER PRIMARY KEY,
  password VARCHAR(20),
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE loginguard (
  guard_id NUMBER PRIMARY KEY,
  password VARCHAR(20),
  FOREIGN KEY (guard_id) REFERENCES guards(guard_id) ON DELETE CASCADE
);

CREATE TABLE visitor_log (
  log_id NUMBER PRIMARY KEY,
  visitor_id NUMBER,
  entry_time TIMESTAMP DEFAULT SYSTIMESTAMP,
  exit_time TIMESTAMP,
  status VARCHAR2(20),
  reason VARCHAR2(200),
  guard_id NUMBER,
  FOREIGN KEY (guard_id) REFERENCES guards(guard_id),
  FOREIGN KEY (visitor_id) REFERENCES visitors(visitor_id)
);

CREATE TABLE delivery_log (
  log_id NUMBER PRIMARY KEY,
  delivery_id NUMBER,
  entry_time TIMESTAMP DEFAULT SYSTIMESTAMP,
  exit_time TIMESTAMP,
  status VARCHAR2(20),
  company VARCHAR2(100),
  guard_id NUMBER,
  FOREIGN KEY (guard_id) REFERENCES guards(guard_id),
  FOREIGN KEY (delivery_id) REFERENCES deliveries(delivery_id)
);
