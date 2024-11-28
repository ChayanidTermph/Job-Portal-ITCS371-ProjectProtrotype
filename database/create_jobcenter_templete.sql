-- Temporarily disable foreign key checks
SET FOREIGN_KEY_CHECKS = 0;
-- ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'ching180647';
-- FLUSH PRIVILEGES;


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

USE jobcenter;

INSERT INTO recruiter_creditcard (r_card_no, r_holderName, r_expireMonth, r_expireYear, r_ccv) VALUES
('7810516827936574', 'Jiranan Srisawat', '08', '2029', '847'),
('8246790591034823', 'Kitti Suwanchot', '07', '2028', '235'),
('5173928460159842', 'Somchai Poonsuk', '10', '2026', '156'),
('9567134802589173', 'Nalinee Wongkorn', '03', '2027', '642'),
('4023678915432781', 'Arthit Boonprakorn', '01', '2025', '980'),
('6274591032489567', 'Rachanee Thongdee', '11', '2030', '334'),
('9183024576893145', 'Pattaraporn Suthitham', '06', '2024', '725'),
('3489176023457891', 'Suthep Chainarong', '09', '2028', '163'),
('7348910261574938', 'Worapong Jantaraporn', '12', '2027', '481'),
('6392054789120347', 'Kanokwan Jarujit', '05', '2029', '276');

INSERT INTO recruiter (r_username, r_password, r_citizenID, r_card_no) VALUES
('jiranan_hr', 'kT29**!Jse6$', '9-5762-98341-56-2', '7810516827936574'),
('kitti_admin', 'Y!r34ahzP_9l', '3-7106-27598-36-2', '8246790591034823'),
('somchai.dev', 'P@ssw0rd123', '8-7389-21034-95-7', '5173928460159842'),
('nalineeHR', '9Hp@ssW*6rT', '9-4567-89012-45-7', '9567134802589173'),
('arthit_biz', 'Wq1%t93!8Fa', '7-6914-78902-34-6', '4023678915432781'),
('racha_marketing', '4Ht$ik2@!p9', '5-3214-65789-10-2', '6274591032489567'),
('patt_admin', 'aQ$T56lo9Wr*', '9-7839-21034-87-5', '9183024576893145'),
('suthep.hr', 'Kp9W@#1lHtY%', '0-3495-76821-34-5', '3489176023457891'),
('wora_devops', 'I@m9Kt#21Wp$', '3-0923-61578-01-2', '7348910261574938'),
('kanok_recruit', 'R%a92qW#tLp8', '6-5720-45631-24-8', '6392054789120347');

INSERT INTO recruiter_personaldetail (r_fname, r_lname, r_contact, r_address, recruiterID) VALUES
('Jiranan', 'Srisawat', '0834578912', '123 Pruksa Village, Lak Si, Bangkok 10210', 1),
('Kitti', 'Suwanchot', '0892345678', '456 Suan Luang Village, Bangkapi, Bangkok 10310', 2),
('Somchai', 'Poonsuk', '0817893456', '789 Rajdamri Road, Pathumwan, Bangkok 10400', 3),
('Nalinee', 'Wongkorn', '0852349810', '201 Phahon Yothin Road, Chatuchak, Bangkok 10900', 4),
('Arthit', 'Boonprakorn', '0845671234', '99 Rama 9 Road, Huai Khwang, Bangkok 10320', 5),
('Rachanee', 'Thongdee', '0826784512', '550 Sukhumvit Road, Khlong Toei, Bangkok 10110', 6),
('Pattaraporn', 'Suthitham', '0862347890', '33/4 Ratchadaphisek Road, Din Daeng, Bangkok 10400', 7),
('Suthep', 'Chainarong', '0874567891', '101/23 Lat Phrao Road, Lat Phrao, Bangkok 10230', 8),
('Worapong', 'Jantaraporn', '0832345678', '85/12 Silom Road, Bang Rak, Bangkok 10500', 9),
('Kanokwan', 'Jarujit', '0845678934', '205 Sathorn Road, Sathorn, Bangkok 10120', 10);

INSERT INTO recruiter_companyprofile (r_companyname, r_companyweb, r_industry, r_comdescription, recruiterID) VALUES
('Siam Tech Co., Ltd.', 'siamtech.com', 'Technology', 'Leading provider of innovative IT solutions.', 1),
('Thai Finance Group', 'thaifinance.co.th', 'Finance', 'Specializing in personal and corporate financial services.', 2),
('Health Hospital Ltd.', 'healthhospital.com', 'Healthcare', 'Advanced care in internal medicine and surgery.', 3),
('Thai Edutech Solutions', 'thaiedu.com', 'Education', 'Revolutionizing education with technology.', 4),
('Retail Dynamics Co.', 'retaildynamics.co.th', 'Retail', 'Leader in supply chain retail innovations.', 5),
('Boon Industries Ltd.', 'boonindustries.com', 'Manufacturing', 'Producer of high-quality industrial goods.', 6),
('Golden Construction Co.', 'goldenconstruction.co.th', 'Construction', 'Pioneers in sustainable building solutions.', 7),
('Transport Pro Solutions', 'transportpro.com', 'Transportation', 'Integrated logistics and transportation services.', 8),
('RealEstate Hub Co., Ltd.', 'realestatehub.co.th', 'Real Estate', 'Leaders in property management and sales.', 9),
('Hospitality Thai Group', 'hospitalitythai.com', 'Hospitality', 'Top-tier hotel and tourism services.', 10);


INSERT INTO job_announcement (j_title, j_salary, j_type, j_workexp, j_location, j_requirement, j_description, category, recruiterID) VALUES
-- Recruiter 1: Siam Tech Co., Ltd. (Technology)
('Backend Developer', 60000, 'full-time', 2, 'Bangkok', 
 'Proficiency in Node.js and experience with relational and non-relational databases. Knowledge of RESTful API design and microservices architecture is a must. Familiarity with Agile methodologies and version control systems like Git is preferred.',
 'Design, develop, and maintain server-side applications. Collaborate with front-end developers to integrate user-facing elements with server-side logic. Optimize performance and scalability for high-traffic applications, ensuring robust security measures.',
 'Technology', 1),
('Mobile App Developer', 52000, 'full-time', 1, 'Bangkok', 
 'Experience in developing mobile applications using Flutter or React Native. Familiarity with cross-platform development and deployment. Understanding of UI/UX principles and app store submission processes is advantageous.',
 'Design and build high-quality mobile applications for both Android and iOS platforms. Work closely with the design team to implement user-friendly interfaces. Ensure applications are optimized for performance and usability.',
 'Technology', 1),

-- Recruiter 2: Thai Finance Group (Finance)
('Financial Analyst', 45000, 'full-time', 3, 'Bangkok', 
 'Strong knowledge of financial modeling, forecasting, and advanced Excel functions. Experience in analyzing financial statements and market trends. Knowledge of financial software like Bloomberg or SAP is a plus.',
 'Analyze financial data to identify trends and provide actionable insights. Develop financial models to support decision-making. Prepare comprehensive reports and presentations for stakeholders, ensuring data accuracy.',
 'Finance', 2),
('Loan Officer', 38000, 'full-time', 1, 'Chiang Mai', 
 'Experience in customer service and loan processing. Familiarity with financial regulations and documentation. Ability to assess clients’ financial needs and recommend suitable loan products.',
 'Assist clients in the loan application process by providing detailed information on loan options and eligibility requirements. Evaluate creditworthiness and ensure compliance with financial regulations.',
 'Finance', 2),

-- Recruiter 3: Health Hospital Ltd. (Healthcare)
('Pharmacist', 42000, 'full-time', 2, 'Bangkok', 
 'Bachelor’s degree in Pharmacy and a valid pharmacist license. Strong knowledge of pharmaceuticals and drug interactions. Excellent communication and customer service skills are essential.',
 'Dispense medications accurately and provide guidance on proper usage and side effects. Counsel patients on health management and medication adherence. Ensure compliance with medical and legal regulations.',
 'Healthcare', 3),
('Radiology Technician', 36000, 'full-time', 1, 'Khon Kaen', 
 'Certification in radiology and imaging techniques. Familiarity with diagnostic equipment, including X-rays, CT scans, and MRIs. Strong attention to detail and patient care skills.',
 'Operate and maintain diagnostic imaging equipment to capture high-quality images for medical diagnosis. Collaborate with medical professionals to ensure accurate interpretations of imaging results.',
 'Healthcare', 3),

-- Recruiter 4: Thai Edutech Solutions (Education)
('Curriculum Developer', 40000, 'full-time', 3, 'Chiang Rai', 
 'Proven experience in curriculum design and educational program development. Strong knowledge of teaching methodologies and learning assessment tools. Ability to align curricula with educational standards and goals.',
 'Develop engaging and effective educational content tailored to different age groups and learning levels. Work closely with teachers and educators to implement and refine curricula. Stay updated on educational trends and innovations.',
 'Education', 4),
('E-Learning Specialist', 38000, 'full-time', 2, 'Bangkok', 
 'Familiarity with e-learning platforms and tools such as Moodle or Canvas. Knowledge of instructional design principles and digital content creation. Ability to troubleshoot technical issues and provide user support.',
 'Create interactive and engaging online learning modules that meet educational objectives. Collaborate with subject matter experts to develop multimedia content. Evaluate the effectiveness of e-learning programs and recommend improvements.',
 'Education', 4),

-- Recruiter 5: Retail Dynamics Co. (Retail)
('Merchandiser', 30000, 'part-time', 1, 'Pattaya', 
 'Experience in retail or inventory management. Ability to analyze sales trends and adjust stock levels accordingly. Excellent organizational and communication skills are a plus.',
 'Plan and execute product displays and arrangements to maximize sales. Monitor inventory levels and coordinate with suppliers for restocking. Ensure compliance with brand standards and promotional activities.',
 'Retail', 5),
('Cashier', 25000, 'part-time', 0, 'Bangkok', 
 'Good customer service skills and basic math proficiency. Familiarity with cash registers and point-of-sale systems. Ability to handle cash and card transactions accurately.',
 'Handle payments and manage customer queries efficiently. Ensure the cash counter is balanced at the end of the shift. Provide excellent customer service to enhance the shopping experience.',
 'Retail', 5),

-- Recruiter 6: Boon Industries Ltd. (Manufacturing)
('Production Supervisor', 38000, 'full-time', 4, 'Ayutthaya', 
 'Experience in manufacturing operations and team supervision. Knowledge of production schedules, workflow optimization, and safety regulations. Strong leadership and problem-solving skills.',
 'Supervise production lines to ensure efficiency and quality standards are met. Train and manage team members, and address operational issues promptly. Maintain compliance with health and safety regulations.',
 'Manufacturing', 6),
('Quality Control Analyst', 32000, 'full-time', 2, 'Ayutthaya', 
 'Knowledge of quality standards, testing procedures, and statistical analysis. Familiarity with ISO certifications and industry regulations. Attention to detail and strong documentation skills.',
 'Conduct quality checks and testing on products to ensure compliance with standards. Document findings and recommend corrective actions. Collaborate with production teams to maintain quality assurance.',
 'Manufacturing', 6),

-- Recruiter 7: Golden Construction Co. (Construction)
('Civil Engineer', 50000, 'full-time', 3, 'Bangkok', 
 'Licensed civil engineer with experience in structural and site design. Proficiency in CAD software and project management tools. Knowledge of construction materials and safety standards.',
 'Design and oversee construction projects from planning to execution. Conduct site inspections to ensure compliance with design specifications and safety standards. Collaborate with stakeholders to deliver projects on time and within budget.',
 'Construction', 7),
('Safety Officer', 40000, 'full-time', 2, 'Bangkok', 
 'Certification in occupational safety and health. Familiarity with workplace hazard assessments and risk mitigation strategies. Excellent communication and training skills.',
 'Monitor and enforce workplace safety protocols to minimize risks. Conduct safety audits and provide training for staff. Prepare safety reports and ensure compliance with legal regulations.',
 'Construction', 7),

-- Recruiter 8: Transport Pro Solutions (Transportation)
('Logistics Coordinator', 35000, 'full-time', 1, 'Bangkok', 
 'Knowledge of supply chain logistics and inventory management. Strong organizational skills and proficiency in logistics software. Ability to handle multiple tasks under pressure.',
 'Coordinate shipments, deliveries, and warehouse activities. Optimize logistics processes to reduce costs and improve efficiency. Communicate with vendors, carriers, and clients to ensure smooth operations.',
 'Transportation', 8),
('Truck Driver', 30000, 'contract', 1, 'Bangkok', 
 'Valid driving license and experience in long-distance transportation. Familiarity with vehicle maintenance and road safety regulations. Good communication skills are a plus.',
 'Transport goods across regions while ensuring timely and safe delivery. Perform routine vehicle checks and maintenance. Adhere to traffic rules and company policies during operations.',
 'Transportation', 8),

-- Recruiter 9: RealEstate Hub Co., Ltd. (Real Estate)
('Real Estate Agent', 45000, 'full-time', 1, 'Bangkok', 
 'Experience in property sales and knowledge of the real estate market. Strong negotiation and interpersonal skills. Ability to manage multiple clients and transactions effectively.',
 'Assist clients in buying, selling, or renting properties. Provide market insights and guidance on property values. Prepare necessary documentation and facilitate smooth transactions.',
 'Real Estate', 9),
('Property Manager', 47000, 'full-time', 3, 'Bangkok', 
 'Experience in property management and tenant relations. Knowledge of maintenance schedules, leasing agreements, and budget management. Strong organizational and problem-solving skills.',
 'Oversee property maintenance, repairs, and tenant relations. Ensure compliance with lease agreements and regulatory standards. Manage budgets and financial records for properties.',
 'Real Estate', 9),

-- Recruiter 10: Hospitality Thai Group (Hospitality)
('Hotel Manager', 55000, 'full-time', 5, 'Phuket', 
 'Experience in hospitality management and operations. Strong leadership and organizational skills. Knowledge of hotel management software and industry trends is preferred.',
 'Manage daily hotel operations, including staff supervision and guest services. Ensure compliance with quality standards and enhance guest satisfaction. Oversee financial planning and marketing strategies.',
 'Hospitality', 10),
('Receptionist', 25000, 'part-time', 0, 'Bangkok', 
 'Good communication and interpersonal skills. Familiarity with front desk operations and reservation systems. Ability to multitask and handle inquiries professionally.',
 'Welcome guests and assist with check-ins and check-outs. Manage reservations and address guest inquiries promptly. Maintain a friendly and professional demeanor at all times.',
 'Hospitality', 10);



INSERT INTO applicant_creditcard (a_card_no, a_holderName, a_expireMonth, a_expireYear, a_ccv) VALUES
('5938471209456731', 'Chaiwat Boonyarit', '07', '2028', '219'),
('8457612394056738', 'Manatsanan Prajong', '03', '2026', '842'),
('7395021847639205', 'Worawan Jindarat', '12', '2029', '117'),
('6284932056781394', 'Narong Kongsak', '11', '2030', '604'),
('4817263095827461', 'Sasithorn Maneewan', '01', '2025', '436'),
('9204857623478134', 'Anuwat Suksawat', '08', '2027', '198'),
('3049821759643812', 'Nattapong Somchai', '05', '2024', '654'),
('4812630958721396', 'Nanticha Rattanakorn', '02', '2026', '712'),
('5839012476134285', 'Prasert Chonwanich', '04', '2028', '863'),
('7845290136782451', 'Kamolwan Srisuk', '09', '2029', '105');


INSERT INTO applicant (a_username, a_password, a_citizenID, a_card_no) VALUES
('chaiwat.b', 'Chaiwat123', '1-2345-67890-12-3', '5938471209456731'),
('manatsanan.p', 'Mana7890', '2-3456-78901-23-4', '8457612394056738'),
('worawan.j', 'Wora5678', '3-4567-89012-34-5', '7395021847639205'),
('narong.k', 'Narong123', '4-5678-90123-45-6', '6284932056781394'),
('sasithorn.m', 'Sasi4567', '5-6789-01234-56-7', '4817263095827461'),
('anuwat.s', 'Anuwat123', '6-7890-12345-67-8', '9204857623478134'),
('nattapong.s', 'Natta7890', '7-8901-23456-78-9', '3049821759643812'),
('nanticha.r', 'Nanti5678', '8-9012-34567-89-0', '4812630958721396'),
('prasert.c', 'Prase123', '9-0123-45678-90-1', '5839012476134285'),
('kamolwan.s', 'Kamo4567', '0-1234-56789-01-2', '7845290136782451');


INSERT INTO applicant_personaldetail (a_fname, a_lname, a_contact, a_address, applicantID) VALUES
('Chaiwat', 'Boonyarit', '0845612398', '85/4 Ladprao Road, Ladprao, Bangkok 10230', 1),
('Manatsanan', 'Prajong', '0892135467', '102/3 Sukhumvit Soi 11, Wattana, Bangkok 10110', 2),
('Worawan', 'Jindarat', '0874591236', '45/12 Ratchada Road, Din Daeng, Bangkok 10400', 3),
('Narong', 'Kongsak', '0827345698', '12/7 Phahonyothin Road, Chatuchak, Bangkok 10900', 4),
('Sasithorn', 'Maneewan', '0862413987', '77/3 Rama IV Road, Pathumwan, Bangkok 10330', 5),
('Anuwat', 'Suksawat', '0883456129', '66/4 Vibhavadi Road, Chatuchak, Bangkok 10900', 6),
('Nattapong', 'Somchai', '0851298346', '101/45 Sukhumvit Road, Khlong Toei, Bangkok 10110', 7),
('Nanticha', 'Rattanakorn', '0845672391', '50/8 Silom Road, Bang Rak, Bangkok 10500', 8),
('Prasert', 'Chonwanich', '0831297654', '200/4 Srinakarin Road, Suan Luang, Bangkok 10250', 9),
('Kamolwan', 'Srisuk', '0893456712', '155/6 Rama IX Road, Huai Khwang, Bangkok 10320', 10);

-- Queries to Fetch Data
SELECT * FROM job_announcement 
WHERE category = 'user_preference_category' 
ORDER BY created_at DESC;

SELECT * FROM job_announcement 
ORDER BY views DESC LIMIT 10;
