CREATE DATABASE sebi;
USE sebi;

-- 1) SEBI Offices
CREATE TABLE offices (
  office_id INT NOT NULL AUTO_INCREMENT,
  office_code VARCHAR(16) NOT NULL UNIQUE,
  office_name VARCHAR(150) NOT NULL,
  city VARCHAR(80),
  address_line VARCHAR(255),
  contact_number VARCHAR(30),
  is_active TINYINT DEFAULT 1,
  PRIMARY KEY (office_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO offices VALUES
(1,'SEBI-HO','SEBI Head Office','Mumbai','Bandra Kurla Complex','022-26449000',1),
(2,'SEBI-RO-DEL','SEBI Regional Office Delhi','New Delhi','Connaught Place','011-23756000',1),
(3,'SEBI-RO-CHE','SEBI Regional Office Chennai','Chennai','Nungambakkam','044-28231000',1);

-- 2) Market Intermediaries
CREATE TABLE intermediaries (
  intermediary_id INT NOT NULL AUTO_INCREMENT,
  registration_no VARCHAR(40) UNIQUE,
  intermediary_name VARCHAR(150),
  intermediary_type ENUM('Broker','AMC','Registrar','Depository','Investment Advisor'),
  city VARCHAR(80),
  contact_number VARCHAR(30),
  is_active TINYINT DEFAULT 1,
  PRIMARY KEY (intermediary_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO intermediaries VALUES
(1,'INZ000001','Zerodha Broking Ltd','Broker','Bengaluru','080-47192000',1),
(2,'INZ000002','HDFC Asset Management','AMC','Mumbai','022-66316000',1),
(3,'INZ000003','CAMS','Registrar','Chennai','044-61040000',1);

-- 3) SEBI Officials
CREATE TABLE officials (
  official_id INT NOT NULL AUTO_INCREMENT,
  official_code VARCHAR(32) UNIQUE,
  first_name VARCHAR(80),
  last_name VARCHAR(80),
  designation VARCHAR(100),
  department VARCHAR(100),
  office_id INT,
  email VARCHAR(150),
  is_active TINYINT DEFAULT 1,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (official_id),
  CONSTRAINT fk_official_office FOREIGN KEY (office_id)
    REFERENCES offices(office_id)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO officials VALUES
(1,'SEBI-OFF-001','Madhabi','Puri','Chairperson','Board',1,'chairperson@sebi.gov.in',1,NOW()),
(2,'SEBI-OFF-002','Anand','Rao','Executive Director','Surveillance',1,'anand.rao@sebi.gov.in',1,NOW()),
(3,'SEBI-OFF-003','Neha','Shah','Regional Director','Compliance',2,'neha.shah@sebi.gov.in',1,NOW());

-- 4) Investors
CREATE TABLE investors (
  investor_id INT NOT NULL AUTO_INCREMENT,
  pan VARCHAR(10) UNIQUE,
  first_name VARCHAR(80),
  last_name VARCHAR(80),
  mobile VARCHAR(30),
  email VARCHAR(150),
  city VARCHAR(80),
  is_active TINYINT DEFAULT 1,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (investor_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO investors VALUES
(1,'ABCDE1234F','Rohit','Mehra','+91-9876500001','rohit.mehra@email.com','Delhi',1,NOW()),
(2,'PQRSX5678Y','Sneha','Iyer','+91-9876500002','sneha.iyer@email.com','Mumbai',1,NOW());

-- 5) Complaints (SCORES)
CREATE TABLE complaints (
  complaint_id INT NOT NULL AUTO_INCREMENT,
  investor_id INT NOT NULL,
  intermediary_id INT NOT NULL,
  complaint_type VARCHAR(150),
  complaint_description TEXT,
  lodged_on DATE,
  status ENUM('Open','Under Review','Resolved','Closed') DEFAULT 'Open',
  assigned_official INT DEFAULT NULL,
  PRIMARY KEY (complaint_id),
  CONSTRAINT fk_comp_investor FOREIGN KEY (investor_id)
    REFERENCES investors(investor_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_comp_intermediary FOREIGN KEY (intermediary_id)
    REFERENCES intermediaries(intermediary_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_comp_official FOREIGN KEY (assigned_official)
    REFERENCES officials(official_id)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO complaints VALUES
(1,1,1,'Unauthorized Trading','Trades executed without consent','2023-06-01','Resolved',2),
(2,2,2,'Delay in Redemption','Mutual fund redemption delayed','2023-07-10','Under Review',3);

-- 6) Investigations
CREATE TABLE investigations (
  investigation_id INT NOT NULL AUTO_INCREMENT,
  intermediary_id INT NOT NULL,
  initiated_on DATE,
  reason VARCHAR(255),
  lead_official INT,
  status ENUM('Ongoing','Completed','Dropped') DEFAULT 'Ongoing',
  PRIMARY KEY (investigation_id),
  CONSTRAINT fk_inv_intermediary FOREIGN KEY (intermediary_id)
    REFERENCES intermediaries(intermediary_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_inv_official FOREIGN KEY (lead_official)
    REFERENCES officials(official_id)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO investigations VALUES
(1,1,'2023-08-01','Suspected front running',2,'Ongoing');

-- 7) Regulations
CREATE TABLE regulations (
  regulation_id INT NOT NULL AUTO_INCREMENT,
  regulation_code VARCHAR(50) UNIQUE,
  title VARCHAR(255),
  issue_date DATE,
  description TEXT,
  PRIMARY KEY (regulation_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO regulations VALUES
(1,'SEBI-PIT-2015','Prohibition of Insider Trading Regulations','2015-01-15','Prevents misuse of unpublished price sensitive information'),
(2,'SEBI-LODR-2015','Listing Obligations and Disclosure Requirements','2015-09-02','Ensures transparency in listed companies');

-- 8) Circulars
CREATE TABLE circulars (
  circular_id INT NOT NULL AUTO_INCREMENT,
  regulation_id INT DEFAULT NULL,
  circular_no VARCHAR(50),
  issued_on DATE,
  subject VARCHAR(255),
  PRIMARY KEY (circular_id),
  CONSTRAINT fk_circular_reg FOREIGN KEY (regulation_id)
    REFERENCES regulations(regulation_id)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO circulars VALUES
(1,1,'SEBI/PIT/CIR/2022','2022-04-01','Disclosure of trading by insiders'),
(2,2,'SEBI/LODR/CIR/2023','2023-02-10','Quarterly compliance reporting');

-- 9) Penalties
CREATE TABLE penalties (
  penalty_id INT NOT NULL AUTO_INCREMENT,
  intermediary_id INT NOT NULL,
  amount DECIMAL(15,2),
  imposed_on DATE,
  reason VARCHAR(255),
  investigation_id INT,
  PRIMARY KEY (penalty_id),
  CONSTRAINT fk_pen_intermediary FOREIGN KEY (intermediary_id)
    REFERENCES intermediaries(intermediary_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_pen_investigation FOREIGN KEY (investigation_id)
    REFERENCES investigations(investigation_id)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO penalties VALUES
(1,1,2500000.00,'2023-09-15','Violation of insider trading norms',1);

SET FOREIGN_KEY_CHECKS = 1;