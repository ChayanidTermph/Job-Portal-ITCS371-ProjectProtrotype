-- Temporarily disable foreign key checks
SET FOREIGN_KEY_CHECKS = 0;
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'ching180647';
FLUSH PRIVILEGES;


-- Drop Tables in Dependency Order
-- DROP TABLE IF EXISTS job_announcement;
-- DROP TABLE IF EXISTS recruiter_companyprofile;
-- DROP TABLE IF EXISTS recruiter_personaldetail;
-- DROP TABLE IF EXISTS recruiter_creditcard;
-- DROP TABLE IF EXISTS recruiter;

-- DROP TABLE IF EXISTS applicant_personaldetail;
-- DROP TABLE IF EXISTS applicant_creditcard;
-- DROP TABLE IF EXISTS applicant;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- Drop Database if Exists
DROP DATABASE IF EXISTS jobcenter;

-- Create Database
CREATE DATABASE jobcenter;
USE jobcenter;

-- Recruiter Part
CREATE TABLE recruiter_creditcard (
    r_card_no CHAR(16) NOT NULL,
    r_holderName VARCHAR(30),
    r_expireMonth CHAR(2),
    r_expireYear CHAR(4),
    r_ccv CHAR(3),
    PRIMARY KEY (r_card_no)
);

CREATE TABLE recruiter (
    recruiterID INT NOT NULL AUTO_INCREMENT,
    r_username VARCHAR(100) NOT NULL,
    r_password VARCHAR(100) NOT NULL,
    r_citizenID CHAR(17) NOT NULL,
    r_card_no CHAR(16),
    PRIMARY KEY (recruiterID),
    FOREIGN KEY (r_card_no) REFERENCES recruiter_creditcard(r_card_no)
);

CREATE TABLE recruiter_personaldetail (
    r_pdID INT NOT NULL AUTO_INCREMENT,
    r_fname VARCHAR(30),
    r_lname VARCHAR(30),
    r_contact CHAR(10),
    r_address TEXT,
    recruiterID INT UNIQUE,
    PRIMARY KEY (r_pdID),
    FOREIGN KEY (recruiterID) REFERENCES recruiter(recruiterID)
);

CREATE TABLE recruiter_companyprofile (
    r_cpID INT NOT NULL AUTO_INCREMENT,
    r_companyname VARCHAR(50) NOT NULL,
    r_companyweb VARCHAR(100),
    r_industry ENUM('Technology', 'Finance', 'Healthcare', 'Education', 'Retail', 
                    'Manufacturing', 'Construction', 'Transportation', 
                    'Real Estate', 'Hospitality') NOT NULL,
    r_comdescription TEXT,
    recruiterID INT UNIQUE,
    PRIMARY KEY (r_cpID),
    FOREIGN KEY (recruiterID) REFERENCES recruiter(recruiterID)
);

CREATE TABLE job_announcement (
    jobID INT NOT NULL AUTO_INCREMENT,
    j_title VARCHAR(100),
    j_salary FLOAT,
    j_type VARCHAR(20) CHECK (j_type IN ('full-time', 'part-time', 'contract', 'casual')),
    j_workexp INT,
    j_location TEXT,
    j_requirement TEXT,
    j_description TEXT,
    recruiterID INT,
    category VARCHAR(255),
    views INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (jobID),
    FOREIGN KEY (recruiterID) REFERENCES recruiter(recruiterID)
);

-- Applicant Part
CREATE TABLE applicant_creditcard (
    a_card_no CHAR(16) NOT NULL,
    a_holderName VARCHAR(30),
    a_expireMonth CHAR(2),
    a_expireYear CHAR(4),
    a_ccv CHAR(3),
    PRIMARY KEY (a_card_no)
);

CREATE TABLE applicant (
    applicantID INT NOT NULL AUTO_INCREMENT,
    a_username VARCHAR(100) NOT NULL,
    a_password VARCHAR(100) NOT NULL,
    a_citizenID CHAR(17) NOT NULL,
    a_card_no CHAR(16),
    PRIMARY KEY (applicantID),
    FOREIGN KEY (a_card_no) REFERENCES applicant_creditcard(a_card_no)
);

CREATE TABLE applicant_personaldetail (
    a_pdID INT NOT NULL AUTO_INCREMENT,
    a_fname VARCHAR(30),
    a_lname VARCHAR(30),
    a_contact CHAR(10),
    a_address VARCHAR(200),
    applicantID INT UNIQUE,
    PRIMARY KEY (a_pdID),
    FOREIGN KEY (applicantID) REFERENCES applicant(applicantID)
);

-- Queries to Fetch Data
SELECT * FROM job_announcement 
WHERE category = 'user_preference_category' 
ORDER BY created_at DESC;

SELECT * FROM job_announcement 
ORDER BY views DESC LIMIT 10;
