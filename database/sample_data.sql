USE research_db;
-- 1. INSTITUTION
INSERT INTO INSTITUTION (name, location, type, website_url, established_date) VALUES
('University of the Punjab', 'Lahore, Punjab', 'Public University', 'https://pu.edu.pk', '1882-10-14'),
('National University of Sciences and Technology (NUST)', 'Islamabad', 'Public University', 'https://nust.edu.pk', '1991-03-22'),
('Quaid-i-Azam University', 'Islamabad', 'Public University', 'https://qau.edu.pk', '1967-07-23'),
('University of Karachi', 'Karachi, Sindh', 'Public University', 'https://uok.edu.pk', '1951-01-23'),
('University of Engineering and Technology, Lahore', 'Lahore, Punjab', 'Public University', 'https://uet.edu.pk', '1921-10-31'),
('Aga Khan University', 'Karachi, Sindh', 'Private University', 'https://aku.edu', '1983-03-16'),
('Lahore University of Management Sciences (LUMS)', 'Lahore, Punjab', 'Private University', 'https://lums.edu.pk', '1984-01-01'),
('University of Health Sciences', 'Lahore, Punjab', 'Public University', 'https://uhs.edu.pk', '2002-10-30'),
('Pakistan Institute of Engineering and Applied Sciences (PIEAS)', 'Islamabad', 'Public University', 'https://pieas.edu.pk', '1967-01-01'),
('COMSATS University Islamabad', 'Islamabad', 'Public University', 'https://comsats.edu.pk', '1998-01-01'),
('University of Agriculture, Faisalabad', 'Faisalabad, Punjab', 'Public University', 'https://uaf.edu.pk', '1906-06-21'),
('University of Peshawar', 'Peshawar, Khyber Pakhtunkhwa', 'Public University', 'https://uop.edu.pk', '1950-10-07'),
('Balochistan University of Information Technology, Engineering and Management Sciences (BUITEMS)', 'Quetta, Balochistan', 'Public University', 'https://buitms.edu.pk', '2002-07-01'),
('Mehran University of Engineering and Technology', 'Jamshoro, Sindh', 'Public University', 'https://muet.edu.pk', '1977-01-01'),
('University of Sindh', 'Jamshoro, Sindh', 'Public University', 'https://usindh.edu.pk', '1947-04-01'),
('Government College University, Lahore', 'Lahore, Punjab', 'Public University', 'https://gcuf.edu.pk', '1864-01-01'),
('National College of Arts (NCA)', 'Lahore, Punjab', 'Public University', 'https://nca.edu.pk', '1875-01-01'),
('Shaheed Zulfiqar Ali Bhutto Medical University (SZABMU)', 'Islamabad', 'Public University', 'https://szabmu.edu.pk', '2013-08-19'),
('Institute of Business Administration (IBA)', 'Karachi, Sindh', 'Public University', 'https://iba.edu.pk', '1955-01-01'),
('University of Gujrat', 'Gujrat, Punjab', 'Public University', 'https://uog.edu.pk', '2004-01-01'),
('University of Malakand', 'Chakdara, Khyber Pakhtunkhwa', 'Public University', 'https://uom.edu.pk', '2001-10-10'),
('Bahria University', 'Islamabad', 'Public University', 'https://bahria.edu.pk', '2000-02-07'),
('Air University', 'Islamabad', 'Public University', 'https://au.edu.pk', '2002-01-01'),
('University of Education', 'Lahore, Punjab', 'Public University', 'https://ue.edu.pk', '2002-09-10');

-- 2. DEPARTMENT
INSERT INTO DEPARTMENT (name, institution_id) VALUES
('Department of Computer Science', 1),
('Department of Physics', 1),
('Department of Mathematics', 1),
('Department of Chemistry', 1),
('Department of Electrical Engineering', 2),
('Department of Mechanical Engineering', 2),
('Department of Computer Engineering', 2),
('Department of Civil Engineering', 2),
('Department of Physics', 3),
('Department of Chemistry', 3),
('Department of Biological Sciences', 3),
('Department of Economics', 3),
('Department of Medicine', 4),
('Department of Surgery', 4),
('Department of Pediatrics', 4),
('Department of Business Administration', 5),
('Department of Computer Science', 5),
('Department of Electrical Engineering', 5),
('Department of Mechanical Engineering', 6),
('Department of Civil Engineering', 6);

-- 3. RESEARCHER
INSERT INTO RESEARCHER (full_name, email, orcid_id, profile_url, academic_rank) VALUES
-- University of the Punjab (1)
('Dr. Muhammad Ali', 'm.ali@pu.edu.pk', '0000-0001-2345-6789', 'https://pu.edu.pk/faculty/mali', 'Professor'),
('Dr. Ayesha Khan', 'a.khan@pu.edu.pk', '0000-0002-3456-7890', 'https://pu.edu.pk/faculty/akhan', 'Associate Professor'),
-- National University of Sciences and Technology (2)
('Dr. Ahmed Raza', 'ahmed.raza@nust.edu.pk', '0000-0003-4567-8901', 'https://nust.edu.pk/faculty/araza', 'Professor'),
('Dr. Fatima Shah', 'fatima.shah@nust.edu.pk', '0000-0004-5678-9012', 'https://nust.edu.pk/faculty/fshah', 'Assistant Professor'),
-- Quaid-i-Azam University (3)
('Dr. Hassan Mahmood', 'h.mahmood@qau.edu.pk', '0000-0005-6789-0123', 'https://qau.edu.pk/faculty/hmahmood', 'Professor'),
('Dr. Sana Akhtar', 'sana.akhtar@qau.edu.pk', '0000-0006-7890-1234', 'https://qau.edu.pk/faculty/sakhtar', 'Lecturer'),
-- University of Karachi (4)
('Dr. Usman Khan', 'usman.khan@uok.edu.pk', '0000-0007-8901-2345', 'https://uok.edu.pk/faculty/ukhan', 'Associate Professor'),
('Dr. Nadia Chaudhry', 'nadia@uok.edu.pk', '0000-0008-9012-3456', 'https://uok.edu.pk/faculty/nchaudhry', 'Assistant Professor'),
-- University of Engineering and Technology, Lahore (5)
('Dr. Omar Farooq', 'omar.farooq@uet.edu.pk', '0000-0009-0123-4567', 'https://uet.edu.pk/faculty/ofarooq', 'Professor'),
('Engr. Sara Malik', 'sara.malik@uet.edu.pk', '0000-0010-1234-5678', 'https://uet.edu.pk/faculty/smalik', 'Assistant Professor'),
-- Aga Khan University (6)
('Dr. Khalid Rahman', 'k.rahman@aku.edu', '0000-0011-2345-6789', 'https://aku.edu/faculty/krahman', 'Professor'),
('Dr. Zainab Ali', 'zainab.ali@aku.edu', '0000-0012-3456-7890', 'https://aku.edu/faculty/zali', 'Associate Professor'),
-- Lahore University of Management Sciences (7)
('Dr. Imran Ahmed', 'imran.ahmed@lums.edu.pk', '0000-0013-4567-8901', 'https://lums.edu.pk/faculty/iahmed', 'Professor'),
('Dr. Hina Raza', 'hina.raza@lums.edu.pk', '0000-0014-5678-9012', 'https://lums.edu.pk/faculty/hraza', 'Assistant Professor'),
-- University of Health Sciences (8)
('Dr. Asma Khan', 'asma.khan@uhs.edu.pk', '0000-0015-6789-0123', 'https://uhs.edu.pk/faculty/akhan', 'Associate Professor'),
('Dr. Bilal Arif', 'bilal.arif@uhs.edu.pk', '0000-0016-7890-1234', 'https://uhs.edu.pk/faculty/barif', 'Research Fellow'),
-- Pakistan Institute of Engineering and Applied Sciences (9)
('Dr. Tariq Mehmood', 't.mehmood@pieas.edu.pk', '0000-0017-8901-2345', 'https://pieas.edu.pk/faculty/tmehmood', 'Professor'),
('Dr. Anum Fatima', 'anum.fatima@pieas.edu.pk', '0000-0018-9012-3456', 'https://pieas.edu.pk/faculty/afatima', 'Senior Lecturer'),
-- COMSATS University Islamabad (10)
('Dr. Kamran Ali', 'kamran.ali@comsats.edu.pk', '0000-0019-0123-4567', 'https://comsats.edu.pk/faculty/kali', 'Associate Professor'),
('Ms. Nida Hussain', 'nida.hussain@comsats.edu.pk', '0000-0020-1234-5678', 'https://comsats.edu.pk/faculty/nhussain', 'Lecturer');

-- 4. RESEARCH_AREA 
INSERT INTO RESEARCH_AREA (area_name, description, parent_area_id) VALUES
-- Top-level areas (NULL parent)
('Computer Science', 'Study of computation, information, and automation', NULL),
('Engineering', 'Application of science and mathematics to solve problems', NULL),
('Medical Sciences', 'Study of health and disease in humans', NULL),
('Natural Sciences', 'Study of natural phenomena through observation and experimentation', NULL),
('Social Sciences', 'Study of human society and social relationships', NULL),
('Climate Change', 'Impact and adaptation studies for global climate change', NULL),
-- Sub-areas of Computer Science (parent_id = 1)
('Artificial Intelligence', 'Study of intelligent systems and algorithms', 1),
('Machine Learning', 'Development of algorithms that improve automatically through experience', 7),
('Natural Language Processing', 'Interaction between computers and human language', 7),
-- Sub-areas of Engineering (parent_id = 2)
('Electrical Engineering', 'Study and application of electricity, electronics, and electromagnetism', 2),
('Renewable Energy', 'Research on sustainable energy sources', 10),
('Power Systems', 'Generation, transmission, distribution and utilization of electric power', 10),
-- Sub-areas of Medical Sciences (parent_id = 3)
('Medicine', 'Diagnosis, treatment, and prevention of disease', 3),
('Surgery', 'Operative treatment of disease or injury', 3),
('Public Health', 'Protecting and improving community health', 3),
-- Sub-areas of Natural Sciences (parent_id = 4)
('Physics', 'Study of matter, energy, and fundamental forces', 4),
('Chemistry', 'Study of matter, its properties, and transformations', 4),
('Mathematics', 'Study of numbers, quantities, shapes, and patterns', 4),
-- Sub-areas of Social Sciences (parent_id = 5)
('Economics', 'Study of production, distribution, and consumption of goods and services', 5),
('Business Administration', 'Management and operation of business organizations', 5);

-- 5. RESEARCH_PROJECT
INSERT INTO RESEARCH_PROJECT (project_title, description, start_date, end_date, project_status, department_id) VALUES
('AI for Healthcare Diagnosis in Pakistan', 'Developing AI tools for disease diagnosis in under-resourced hospitals', '2023-01-01', '2025-12-31', 'Active', 1),
('Solar Energy Optimization for Rural Punjab', 'Improving solar panel efficiency for off-grid communities in rural Punjab', '2024-03-01', '2026-02-28', 'Active', 2),
('Climate Change Impact on Punjab Agriculture', 'Modeling crop yield under changing climate patterns in Punjab', '2022-06-01', '2024-05-31', 'Completed', 3),
('Machine Learning for Urdu NLP', 'Developing NLP tools for Urdu language processing and analysis', '2023-09-01', '2025-08-31', 'Active', 1),
('Smart Grid Implementation in Pakistan', 'Research on smart grid technologies for Pakistans energy sector', '2024-01-15', '2026-01-14', 'Active', 6),
('COVID-19 Epidemiology in Urban Centers', 'Study of COVID-19 spread patterns in major Pakistani cities', '2021-03-01', '2023-02-28', 'Completed', 13),
('Renewable Energy Integration in National Grid', 'Feasibility study for integrating solar and wind energy into national grid', '2023-07-01', '2025-06-30', 'Active', 7),
('Water Purification Technologies for Rural Sindh', 'Developing affordable water purification systems for rural communities', '2024-04-01', '2026-03-31', 'Active', 8),
('Cancer Research and Treatment Protocols', 'Developing improved cancer treatment protocols for Pakistani population', '2022-01-01', '2024-12-31', 'Active', 14),
('Blockchain for Financial Inclusion', 'Using blockchain technology to enhance financial services accessibility', '2023-11-01', '2025-10-31', 'Active', 17),
('Sustainable Agriculture Practices', 'Research on sustainable farming techniques for Pakistani agriculture', '2023-05-01', '2025-04-30', 'Active', 5),
('Cybersecurity for National Infrastructure', 'Developing cybersecurity frameworks for critical national infrastructure', '2024-02-01', '2026-01-31', 'Active', 7),
('Pediatric Healthcare Improvements', 'Study on improving pediatric healthcare delivery in rural areas', '2022-09-01', '2024-08-31', 'Completed', 15),
('Earthquake Resistant Building Design', 'Developing earthquake-resistant construction techniques for Pakistan', '2023-03-01', '2025-02-28', 'Active', 8),
('Diabetes Prevention and Management', 'Community-based diabetes prevention program research', '2024-01-01', '2025-12-31', 'Active', 13),
('Artificial Intelligence in Education', 'Implementing AI tools for personalized learning in Pakistani schools', '2023-08-01', '2025-07-31', 'Active', 1),
('Waste Management Solutions for Urban Areas', 'Developing sustainable waste management systems for Pakistani cities', '2024-05-01', '2026-04-30', 'Active', 20),
('Telemedicine for Remote Areas', 'Implementing telemedicine solutions for healthcare access in remote regions', '2022-11-01', '2024-10-31', 'Completed', 14),
('Economic Impact of CPEC', 'Study on economic impacts of China-Pakistan Economic Corridor', '2023-04-01', '2025-03-31', 'Active', 19),
('Flood Prediction and Management System', 'Developing early warning systems for flood prediction in Pakistan', '2024-06-01', '2026-05-31', 'Active', 6);

-- 6. GRANT
INSERT INTO `GRANT` (grant_title, funding_agency, grant_amount, start_date, end_date, grant_status, grant_number) VALUES
('HEC National Research Program for Universities', 'Higher Education Commission (HEC)', 5000000.00, '2023-01-01', '2025-12-31', 'Active', 'HEC-NRPU-2023-001'),
('PSF Renewable Energy Research Initiative', 'Pakistan Science Foundation (PSF)', 3000000.00, '2024-03-01', '2026-02-28', 'Active', 'PSF-RE-2024-005'),
('World Bank Climate Resilience Project', 'World Bank', 8000000.00, '2022-06-01', '2024-05-31', 'Completed', 'WB-CRP-PK-2022-012'),
('Asian Development Bank Water Management Grant', 'Asian Development Bank (ADB)', 7500000.00, '2023-07-01', '2026-06-30', 'Active', 'ADB-WMG-PK-2023-007'),
('US-Pakistan Science & Technology Cooperation Program', 'United States Agency for International Development (USAID)', 4500000.00, '2024-01-01', '2026-12-31', 'Active', 'USAID-STCP-2024-003'),
('Chinese Government CPEC Research Grant', 'China-Pakistan Economic Corridor (CPEC) Authority', 10000000.00, '2023-09-01', '2025-08-31', 'Active', 'CPEC-RG-2023-015'),
('UKRI Global Challenges Research Fund', 'UK Research and Innovation (UKRI)', 3500000.00, '2022-11-01', '2024-10-31', 'Completed', 'UKRI-GCRF-2022-008'),
('HEC Technology Development Fund', 'Higher Education Commission (HEC)', 2500000.00, '2024-04-01', '2026-03-31', 'Active', 'HEC-TDF-2024-009'),
('UNICEF Maternal and Child Health Research', 'United Nations Children"s Fund (UNICEF)', 4200000.00, '2023-03-01', '2025-02-28', 'Active', 'UNICEF-MCH-2023-004'),
('Islamic Development Bank Education Grant', 'Islamic Development Bank (IsDB)', 5500000.00, '2024-02-01', '2027-01-31', 'Active', 'IsDB-EDU-PK-2024-011'),
('PSF COVID-19 Research Response', 'Pakistan Science Foundation (PSF)', 2800000.00, '2021-03-01', '2023-02-28', 'Completed', 'PSF-COVID-2021-002'),
('EU Horizon Europe Pakistan Partnership', 'European Union', 9200000.00, '2024-05-01', '2028-04-30', 'Active', 'EU-HE-PK-2024-020'),
('HEC Indigenous PhD Fellowship Program', 'Higher Education Commission (HEC)', 1800000.00, '2023-08-01', '2026-07-31', 'Active', 'HEC-IPFP-2023-006'),
('World Health Organization Health Systems Research', 'World Health Organization (WHO)', 3800000.00, '2024-06-01', '2026-05-31', 'Active', 'WHO-HSR-PK-2024-013'),
('Bill & Melinda Gates Foundation Agriculture Grant', 'Bill & Melinda Gates Foundation', 6700000.00, '2023-05-01', '2025-04-30', 'Active', 'BMGF-AG-PK-2023-014'),
('Pak-German Research Collaboration Program', 'German Academic Exchange Service (DAAD)', 2900000.00, '2022-09-01', '2024-08-31', 'Completed', 'DAAD-PK-2022-010'),
('HEC Digital Pakistan Initiative', 'Higher Education Commission (HEC)', 3200000.00, '2024-01-15', '2026-12-14', 'Active', 'HEC-DPI-2024-017'),
('Australian Awards Pakistan Research Fund', 'Australian Government', 4100000.00, '2023-11-01', '2026-10-31', 'Active', 'AUS-AW-PK-2023-018'),
('PSF Basic Sciences Research Program', 'Pakistan Science Foundation (PSF)', 2300000.00, '2024-03-15', '2027-03-14', 'Active', 'PSF-BSRP-2024-016'),
('UNDP Sustainable Development Goals Research', 'United Nations Development Programme (UNDP)', 4900000.00, '2023-04-01', '2025-03-31', 'Active', 'UNDP-SDG-PK-2023-019');

-- 7. KEYWORD
INSERT INTO KEYWORD (keyword_text, keyword_type) VALUES
('machine learning', 'Methodology'),
('solar power', 'Technology'),
('climate modeling', 'Domain'),
('artificial intelligence', 'Technology'),
('deep learning', 'Methodology'),
('natural language processing', 'Domain'),
('renewable energy', 'Domain'),
('healthcare', 'Domain'),
('big data', 'Methodology'),
('data mining', 'Methodology'),
('computer vision', 'Domain'),
('Internet of Things', 'Technology'),
('cloud computing', 'Technology'),
('cybersecurity', 'Domain'),
('blockchain', 'Technology'),
('quantum computing', 'Technology'),
('genomics', 'Domain'),
('bioinformatics', 'Domain'),
('nanotechnology', 'Technology'),
('robotics', 'Technology'),
('smart grid', 'Technology'),
('telemedicine', 'Domain'),
('public health', 'Domain'),
('agriculture', 'Domain'),
('water management', 'Domain'),
('sustainable development', 'Domain'),
('environmental science', 'Domain'),
('material science', 'Domain'),
('pharmaceuticals', 'Domain'),
('epidemiology', 'Domain');

-- 8. AUTHOR_ROLE
INSERT INTO AUTHOR_ROLE (role_name) VALUES
('First Author'),
('Corresponding Author'),
('Co-author'),
('Principal Investigator'),
('Co-Investigator'),
('Research Assistant'),
('Project Coordinator'),
('Technical Lead'),
('Data Analyst'),
('Field Researcher'),
('Lab Manager'),
('Methodology Expert'),
('Statistical Analyst'),
('Literature Reviewer'),
('Validation Specialist');

-- 9. PUBLICATION_VENUE
INSERT INTO PUBLICATION_VENUE (name, venue_type, publisher, open_access_flag, issn, isbn, website_url) VALUES
('Pakistan Journal of Science', 'journal', 'Pakistan Academy of Sciences', TRUE, '0030-9876', NULL, 'https://pjs.org.pk'),
('IEEE Access', 'journal', 'IEEE', TRUE, '2169-3536', NULL, 'https://ieeeaccess.ieee.org'),
('International Conference on Renewable Energy', 'conference', 'Elsevier', FALSE, NULL, '978-0-123-45678-9', 'https://icre.org'),
('Journal of Pakistan Medical Association', 'journal', 'Pakistan Medical Association', TRUE, '0030-9982', NULL, 'https://jpma.org.pk'),
('Science International', 'journal', 'Knowledge Bylanes', FALSE, '1013-5316', NULL, 'https://scienceint.com'),
('Pakistan Journal of Engineering and Applied Sciences', 'journal', 'University of Engineering and Technology', TRUE, '2222-9930', NULL, 'https://pjeas.pk'),
('International Journal of Computer Science and Network Security', 'journal', 'Global Institute of IT', FALSE, '1738-7906', NULL, 'https://ijcsns.org'),
('Proceedings of International Bhurban Conference on Applied Sciences', 'conference', 'IEEE Pakistan', TRUE, NULL, '978-1-6654-1234-5', 'https://ibcas.edu.pk'),
('Journal of Basic and Applied Sciences', 'journal', 'University of Karachi', TRUE, '1814-8085', NULL, 'https://jbas.pk'),
('International Conference on Artificial Intelligence and Robotics', 'conference', 'Springer', FALSE, NULL, '978-3-031-98765-4', 'https://icair.org'),
('Pakistan Journal of Biotechnology', 'journal', 'Pakistani Society of Biotechnology', TRUE, '1812-1837', NULL, 'https://pjbt.org'),
('Journal of Economic Cooperation and Development', 'journal', 'Statistical, Economic and Social Research and Training Centre', FALSE, '1308-7800', NULL, 'https://jecd.org'),
('International Conference on Computer and Information Technology', 'conference', 'ACM', TRUE, NULL, '978-1-4503-9876-5', 'https://iccit.edu.pk'),
('Journal of Himalayan Earth Sciences', 'journal', 'National Centre of Excellence in Geology', TRUE, '1994-3237', NULL, 'https://jhes.pk'),
('Pakistan Journal of Agricultural Sciences', 'journal', 'University of Agriculture', TRUE, '0552-9034', NULL, 'https://pakjas.com.pk'),
('International Conference on Medical Sciences', 'conference', 'Elsevier', FALSE, NULL, '978-0-444-67890-1', 'https://icms.org'),
('Journal of Environmental Sciences', 'journal', 'Pakistan Environmental Protection Agency', TRUE, '2077-0375', NULL, 'https://jes.pk'),
('Proceedings of Pakistan Academy of Sciences', 'journal', 'Pakistan Academy of Sciences', TRUE, '2518-4245', NULL, 'https://ppaspk.org'),
('International Journal of Educational Sciences', 'journal', 'Kamla-Raj Enterprises', FALSE, '0975-1122', NULL, 'https://ijes.com'),
('Pakistan Journal of Information Management and Libraries', 'journal', 'University of the Punjab', TRUE, '1680-5801', NULL, 'https://pjiml.pk');

-- 10. RESEARCH_OUTPUT
INSERT INTO RESEARCH_OUTPUT (title, description, created_date, visibility_status) VALUES
('Deep Learning for Medical Diagnosis in Low-Resource Settings', 'A novel CNN model for detecting tuberculosis from chest X-rays in Pakistani hospitals', '2024-05-15', 'Public'),
('Solar Panel Efficiency Improvement Using Nanomaterials', 'Experimental study of perovskite solar cells under Pakistani climate conditions', '2024-08-20', 'Public'),
('Pakistan Climate Data 2023', 'Daily temperature, precipitation, and humidity records for major Pakistani cities', '2023-12-01', 'Restricted'),
('Urdu Sentiment Analysis Using BERT', 'BERT model fine-tuned for sentiment analysis of Urdu social media text', '2024-02-10', 'Public'),
('Smart Grid Implementation Framework for Pakistan', 'Technical framework for implementing smart grid technology in Pakistans power sector', '2024-07-30', 'Public'),
('COVID-19 Spread Patterns in Karachi', 'Epidemiological study of COVID-19 transmission in Karachi urban communities', '2023-09-25', 'Public'),
('Water Quality Assessment of Indus River', 'Comprehensive study of water contamination levels in Indus River basin', '2024-04-18', 'Restricted'),
('Cancer Incidence Registry Pakistan 2022-2023', 'National cancer incidence data from major Pakistani hospitals', '2024-01-05', 'Restricted'),
('Blockchain-Based Land Registry System', 'Prototype for blockchain-based land ownership records for Punjab province', '2024-06-22', 'Public'),
('Sustainable Farming Techniques for Wheat Cultivation', 'Field study comparing traditional and sustainable wheat farming methods', '2023-11-15', 'Public'),
('Cybersecurity Threats to Pakistani Banking Sector', 'Analysis of cybersecurity vulnerabilities in Pakistani financial institutions', '2024-03-12', 'Restricted'),
('Pediatric Malnutrition Intervention Program', 'Results of community-based malnutrition intervention in rural Sindh', '2024-09-05', 'Public'),
('Earthquake Risk Assessment of Northern Pakistan', 'Seismic risk analysis and building vulnerability assessment', '2023-08-14', 'Public'),
('Diabetes Prevalence in Urban Pakistan', 'Cross-sectional study of diabetes prevalence in major urban centers', '2024-10-30', 'Public'),
('AI-Powered Adaptive Learning Platform', 'Software platform for personalized learning in Pakistani schools', '2024-01-20', 'Public'),
('Solid Waste Management in Lahore City', 'Analysis of waste generation patterns and management solutions for Lahore', '2023-07-08', 'Restricted'),
('Telemedicine Adoption in Rural Healthcare', 'Study on telemedicine implementation challenges in rural Pakistani clinics', '2024-11-10', 'Public'),
('Economic Impact Analysis of CPEC Phase-I', 'Comprehensive economic impact assessment of CPEC first phase projects', '2024-02-28', 'Restricted'),
('Flood Early Warning System for Indus Basin', 'Prototype early warning system using IoT sensors for flood prediction', '2023-12-15', 'Public'),
('Machine Learning for Crop Yield Prediction', 'ML models for predicting wheat and cotton yields in Punjab region', '2024-08-05', 'Public');

-- 11. PAPER
INSERT INTO PAPER (paper_id, abstract, publication_date, manuscript_status, doi, venue_id) VALUES
(1, 'This paper presents a novel Convolutional Neural Network (CNN) architecture specifically designed for detecting tuberculosis from chest X-rays in low-resource healthcare settings. The model achieves 94.7% accuracy on a dataset of 5,000 Pakistani patient X-rays and is optimized for deployment on mobile devices in rural clinics.', '2024-06-10', 'Published', '10.1234/pjs.2024.001', 1),
(2, 'This experimental study investigates the performance of perovskite solar cells under varying climatic conditions in Pakistan. Results show a 22% efficiency improvement over traditional silicon cells in high-temperature environments typical of Pakistani summers, with particular attention to dust accumulation effects.', '2024-09-05', 'Published', '10.1109/ACCESS.2024.1234567', 2),
(3, 'This paper presents a fine-tuned BERT model for sentiment analysis of Urdu social media text. The model handles code-mixing (Urdu-English) common in Pakistani social media and achieves 89.3% F1-score on a new annotated dataset of 50,000 tweets from Pakistani users.', '2024-03-15', 'Published', '10.1016/j.nlp.2024.100045', 4),
(4, 'This research presents a comprehensive framework for smart grid implementation in Pakistan, addressing technical, regulatory, and economic challenges. The framework includes phased deployment strategies and cost-benefit analysis for different regions of Pakistan.', '2024-08-30', 'Accepted', '10.1109/TPWRS.2024.9876543', 6),
(5, 'Epidemiological analysis of COVID-19 transmission patterns in Karachi using SEIR models with mobility data. The study identifies key super-spreader locations and evaluates the effectiveness of different lockdown strategies implemented during 2020-2022.', '2023-11-10', 'Published', '10.1097/EDE.0000000000000123', 16),
(6, 'This paper presents a prototype blockchain-based land registry system for Punjab province, addressing issues of land record fraud and dispute resolution. The system uses smart contracts for automated title transfers and has been tested with 500 mock transactions.', '2024-07-15', 'Published', '10.1145/3589132.1234567', 13),
(7, 'Field study comparing sustainable versus traditional wheat farming methods across 50 farms in Punjab. Results show 18% water savings and 12% higher yields using precision agriculture techniques with IoT sensor networks.', '2024-01-20', 'Published', '10.1016/j.agsy.2024.103456', 15),
(8, 'Results of a 2-year community-based intervention program addressing pediatric malnutrition in rural Sindh. The program reduced severe acute malnutrition by 42% through integrated healthcare, nutrition education, and local food production initiatives.', '2024-10-10', 'Accepted', '10.1136/bmj.n2345', 4),
(9, 'Seismic risk analysis of Northern Pakistan using updated fault line data and historical earthquake records. The study provides updated seismic hazard maps and recommends building code modifications for different risk zones.', '2023-09-25', 'Published', '10.1002/eqe.3456', 14),
(10, 'Cross-sectional study of diabetes prevalence in 10,000 adults across five major Pakistani cities. The study identifies significant correlations with urbanization, dietary changes, and physical activity patterns, with overall prevalence of 26.3%.', '2024-11-25', 'Under Review', '10.2337/db24-0123', 9),
(11, 'This paper presents an AI-powered adaptive learning platform tested in 20 Pakistani schools. The platform showed 35% improvement in mathematics test scores compared to traditional teaching methods over a 6-month trial period.', '2024-02-15', 'Published', '10.1080/09500693.2024.1234567', 19),
(12, 'Study on telemedicine adoption challenges in rural Pakistani healthcare facilities. The research identifies key barriers including digital literacy, infrastructure limitations, and regulatory hurdles, with recommendations for phased implementation.', '2024-12-05', 'Accepted', '10.2196/56789', 17),
(13, 'This paper presents machine learning models (Random Forest, XGBoost) for predicting wheat and cotton yields in Punjab using satellite imagery and weather data. The best model achieves 91.2% accuracy for wheat yield prediction 60 days before harvest.', '2024-09-15', 'Published', '10.1016/j.compag.2024.108567', 5),
(14, 'Comprehensive analysis of cybersecurity threats targeting Pakistani banking sector, based on data from 15 major banks. The study identifies 5 major attack vectors and proposes a multi-layered defense framework tailored to Pakistani context.', '2024-04-10', 'Restricted', NULL, 7),
(15, 'Detailed economic impact assessment of CPEC Phase-I projects on local economies, employment, and infrastructure development. The study uses input-output analysis and finds mixed results across different regions and sectors.', '2024-03-30', 'Restricted', NULL, 12),
(16, 'This paper presents a prototype IoT-based flood early warning system for the Indus River basin. The system uses 50 sensor nodes transmitting real-time data and provides 72-hour flood predictions with 87% accuracy.', '2023-12-30', 'Published', '10.1002/hyp.14567', 14),
(17, 'Analysis of solid waste generation patterns in Lahore using GIS mapping and survey data from 1,000 households. The study identifies key challenges and proposes a decentralized waste management model with improved recycling rates.', '2023-08-20', 'Restricted', NULL, 17),
(18, 'Water quality assessment of the Indus River using samples from 25 monitoring stations over 12 months. The study identifies industrial pollution hotspots and recommends targeted intervention strategies for different contamination sources.', '2024-05-05', 'Under Review', '10.1016/j.watres.2024.121234', 17),
(19, 'National cancer incidence registry data analysis covering 2022-2023 from 30 major hospitals. The study reveals increasing incidence rates for breast, lung, and oral cancers with significant regional variations across provinces.', '2024-01-25', 'Restricted', NULL, 4),
(20, 'Experimental study of low-cost water purification technologies suitable for rural Sindh. The paper evaluates 5 different purification methods and recommends a hybrid solar-distillation system as most cost-effective for the region.', '2024-06-30', 'Published', '10.1016/j.jwpe.2024.105678', 6);

-- 12. DATASET
INSERT INTO DATASET (dataset_id, repository_url, access_type, release_date, license_type) VALUES
(3, 'https://data.pakistanclimate.gov.pk/datasets/2023-climate', 'Restricted Access', '2023-12-15', 'Government Data License'),
(7, 'https://data.water.gov.pk/indus-river-quality-2024', 'Restricted Access', '2024-04-20', 'Government Data License'),
(8, 'https://healthdata.gov.pk/cancer-registry-2022-2023', 'Restricted Access', '2024-01-10', 'Health Data Access Agreement'),
(11, 'https://cybersecurity.gov.pk/banking-threats-2024', 'Restricted Access', '2024-03-15', 'National Security Data License'),
(15, 'https://data.cpec.gov.pk/phase1-economic-impact', 'Restricted Access', '2024-03-25', 'Government Data License'),
(17, 'https://data.lahore.gov.pk/waste-management-2023', 'Restricted Access', '2023-08-25', 'Municipal Data License'),
(19, 'https://healthdata.gov.pk/cancer-incidence-2022-2023', 'Restricted Access', '2024-02-01', 'Health Data Access Agreement'),
(12, 'https://data.unicef.org/pakistan/malnutrition-intervention-2024', 'CC-BY-NC 4.0', '2024-09-10', 'Creative Commons Attribution-NonCommercial'),
(13, 'https://data.ndma.gov.pk/earthquake-risk-2023', 'CC-BY 4.0', '2023-09-01', 'Open Data Commons Attribution'),
(14, 'https://healthdata.gov.pk/diabetes-prevalence-2024', 'CC-BY-NC-SA 4.0', '2024-11-05', 'Creative Commons Attribution-NonCommercial-ShareAlike'),
(16, 'https://data.floods.gov.pk/indus-basin-iot-2023', 'CC-BY 4.0', '2023-12-20', 'Open Data Commons Attribution'),
(18, 'https://data.water.gov.pk/indus-water-quality-2024', 'CC-BY 4.0', '2024-05-10', 'Open Data Commons Attribution'),
(20, 'https://data.research.edu.pk/water-purification-2024', 'CC-BY 4.0', '2024-07-05', 'Creative Commons Attribution'),
(4, 'https://data.nlp.org.pk/urdu-sentiment-bert', 'CC-BY 4.0', '2024-03-20', 'Creative Commons Attribution'),
(5, 'https://data.energy.gov.pk/smart-grid-framework-2024', 'CC-BY-SA 4.0', '2024-08-05', 'Creative Commons Attribution-ShareAlike'),
(6, 'https://data.health.gov.pk/covid19-karachi-2023', 'CC0 1.0', '2023-11-15', 'Public Domain Dedication'),
(9, 'https://data.blockchain.gov.pk/land-registry-prototype', 'MIT License', '2024-07-01', 'Open Source Software License'),
(10, 'https://data.agriculture.gov.pk/sustainable-farming-2023', 'CC-BY 4.0', '2023-11-20', 'Creative Commons Attribution'),
(1, 'https://data.health.gov.pk/tb-xray-dataset-2024', 'CC-BY-NC 4.0', '2024-06-05', 'Creative Commons Attribution-NonCommercial'),
(2, 'https://data.energy.gov.pk/solar-cell-performance-2024', 'CC-BY 4.0', '2024-08-25', 'Creative Commons Attribution');

-- 13. EMPLOYMENT
INSERT INTO EMPLOYMENT (researcher_id, department_id, position_title, start_date, end_date, employment_type) VALUES
(1, 1, 'Professor of Computer Science', '2015-07-01', NULL, 'Permanent'),
(2, 2, 'Associate Professor of Physics', '2018-09-01', NULL, 'Permanent'),
(3, 3, 'Assistant Professor of Mathematics', '2021-01-01', NULL, 'Permanent'),
(4, 4, 'Associate Professor of Chemistry', '2019-03-15', NULL, 'Permanent'),
(5, 5, 'Professor of Electrical Engineering', '2012-08-01', NULL, 'Permanent'),
(6, 6, 'Professor of Computer Engineering', '2014-06-01', NULL, 'Permanent'),
(7, 7, 'Assistant Professor of Civil Engineering', '2022-02-01', NULL, 'Contract'),
(8, 8, 'Lecturer in Physics', '2020-11-01', '2024-10-31', 'Contract'),
(9, 9, 'Professor of Chemistry', '2010-09-01', NULL, 'Permanent'),
(10, 10, 'Associate Professor of Biological Sciences', '2017-04-01', NULL, 'Permanent'),
(11, 11, 'Assistant Professor of Economics', '2023-01-15', NULL, 'Permanent'),
(12, 12, 'Professor of Medicine', '2008-03-01', NULL, 'Permanent'),
(13, 13, 'Associate Professor of Surgery', '2015-11-01', NULL, 'Permanent'),
(14, 14, 'Assistant Professor of Pediatrics', '2021-07-01', NULL, 'Contract'),
(15, 15, 'Professor of Business Administration', '2013-10-01', NULL, 'Permanent'),
(16, 16, 'Senior Lecturer in Computer Science', '2019-08-01', NULL, 'Permanent'),
(17, 17, 'Assistant Professor of Electrical Engineering', '2022-06-01', NULL, 'Permanent'),
(18, 18, 'Research Fellow in Mechanical Engineering', '2023-03-01', '2025-02-28', 'Contract'),
(19, 19, 'Professor of Civil Engineering', '2011-05-01', NULL, 'Permanent'),
(20, 20, 'Lecturer in Data Science', '2024-01-01', NULL, 'Contract');

-- 14. RESEARCH_AREA_MAPPING 
INSERT INTO RESEARCH_AREA_MAPPING (researcher_id, research_area_id, primary_flag) VALUES
(1, 7, TRUE),   -- Artificial Intelligence (ID 7)
(1, 8, FALSE),  -- Machine Learning (ID 8)
(2, 10, TRUE),  -- Electrical Engineering (ID 10)
(2, 11, FALSE), -- Renewable Energy (ID 11)
(3, 16, TRUE),  -- Physics (ID 16, not 17)
(3, 17, FALSE), -- Chemistry (ID 17, not 18)
(4, 17, TRUE),  -- Chemistry (ID 17, not 18)
(5, 11, TRUE),  -- Renewable Energy (ID 11)
(5, 12, FALSE), -- Power Systems (ID 12)
(6, 7, TRUE),   -- Artificial Intelligence (ID 7)
(6, 9, FALSE),  -- Natural Language Processing (ID 9)
(7, 8, TRUE),   -- Machine Learning (ID 8)
(7, 1, FALSE),  -- Computer Science (ID 1)
(8, 11, TRUE),  -- Renewable Energy (ID 11)
(9, 17, TRUE),  -- Chemistry (ID 17, not 18)
(10, 18, TRUE), -- Mathematics (ID 18, not 19)
(10, 4, FALSE), -- Natural Sciences (ID 4)
(11, 19, TRUE), -- Economics (ID 19, not 20)
(11, 20, FALSE),-- Business Administration (ID 20, not 21)
(12, 13, TRUE), -- Medicine (ID 13)
(12, 14, FALSE),-- Surgery (ID 14)
(13, 14, TRUE), -- Surgery (ID 14)
(13, 15, FALSE),-- Public Health (ID 15)
(14, 15, TRUE), -- Public Health (ID 15)
(15, 20, TRUE), -- Business Administration (ID 20, not 21)
(15, 19, FALSE),-- Economics (ID 19, not 20)
(16, 8, TRUE),  -- Machine Learning (ID 8)
(16, 7, FALSE), -- Artificial Intelligence (ID 7)
(17, 11, TRUE), -- Renewable Energy (ID 11)
(18, 10, TRUE), -- Electrical Engineering (ID 10)
(19, 12, TRUE), -- Power Systems (ID 12)
(20, 8, TRUE);  -- Machine Learning (ID 8)

-- 15. PROJECT_MEMBER
INSERT INTO PROJECT_MEMBER (project_id, researcher_id, role_in_project, start_date, end_date) VALUES
(1, 1, 'Principal Investigator', '2023-01-01', '2025-12-31'),
(1, 6, 'Co-Investigator', '2023-01-01', '2025-12-31'),
(1, 16, 'Data Analyst', '2023-01-01', '2025-12-31'),
(2, 2, 'Lead Researcher', '2024-03-01', '2026-02-28'),
(2, 8, 'Field Researcher', '2024-03-01', '2026-02-28'),
(2, 17, 'Technical Lead', '2024-03-01', '2026-02-28'),
(3, 3, 'Principal Investigator', '2022-06-01', '2024-05-31'),
(3, 11, 'Statistical Analyst', '2022-06-01', '2024-05-31'),
(4, 1, 'Principal Investigator', '2023-09-01', '2025-08-31'),
(4, 20, 'NLP Specialist', '2023-09-01', '2025-08-31'),
(5, 5, 'Project Coordinator', '2024-01-15', '2026-01-14'),
(5, 18, 'Electrical Engineer', '2024-01-15', '2026-01-14'),
(6, 12, 'Principal Investigator', '2021-03-01', '2023-02-28'),
(6, 13, 'Epidemiologist', '2021-03-01', '2023-02-28'),
(7, 8, 'Renewable Energy Expert', '2023-07-01', '2025-06-30'),
(8, 7, 'Civil Engineer', '2024-04-01', '2026-03-31'),
(9, 12, 'Oncologist', '2022-01-01', '2024-12-31'),
(9, 14, 'Research Assistant', '2022-01-01', '2024-12-31'),
(10, 15, 'Blockchain Developer', '2023-11-01', '2025-10-31'),
(11, 4, 'Agricultural Scientist', '2023-05-01', '2025-04-30'),
(12, 6, 'Cybersecurity Analyst', '2024-02-01', '2026-01-31'),
(13, 13, 'Pediatrician', '2022-09-01', '2024-08-31'),
(14, 7, 'Structural Engineer', '2023-03-01', '2025-02-28'),
(15, 12, 'Endocrinologist', '2024-01-01', '2025-12-31'),
(16, 1, 'AI Specialist', '2023-08-01', '2025-07-31'),
(17, 19, 'Environmental Engineer', '2024-05-01', '2026-04-30'),
(18, 12, 'Telemedicine Coordinator', '2022-11-01', '2024-10-31'),
(19, 11, 'Economist', '2023-04-01', '2025-03-31'),
(20, 5, 'Hydrologist', '2024-06-01', '2026-05-31');

-- 16. PROJECT_GRANT
INSERT INTO PROJECT_GRANT (project_id, grant_id, allocation_amount) VALUES
(1, 1, 2500000.00),
(2, 2, 1500000.00),
(3, 3, 4000000.00),
(4, 6, 1200000.00),
(5, 4, 3000000.00),
(6, 11, 1800000.00),
(7, 2, 1000000.00),
(8, 4, 2000000.00),
(9, 9, 2200000.00),
(10, 6, 800000.00),
(11, 15, 2500000.00),
(12, 13, 1600000.00),
(13, 14, 1900000.00),
(14, 12, 2800000.00),
(15, 9, 2100000.00),
(16, 17, 1500000.00),
(17, 20, 1800000.00),
(18, 8, 1200000.00),
(19, 5, 3500000.00),
(20, 10, 2200000.00);

-- 17. PROJECT_OUTPUT
INSERT INTO PROJECT_OUTPUT (project_id, output_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10),
(11, 11),
(12, 12),
(13, 13),
(14, 14),
(15, 15),
(16, 16),
(17, 17),
(18, 18),
(19, 19),
(20, 20);

-- 18. COLLABORATION
INSERT INTO COLLABORATION (researcher_id, paper_id, author_role_id, author_order) VALUES
(1, 1, 1, 1),   -- Researcher 1 is First Author on Paper 1
(6, 1, 3, 2),   -- Researcher 6 is Co-author on Paper 1
(16, 1, 3, 3),  -- Researcher 16 is Co-author on Paper 1
(2, 2, 1, 1),   -- Researcher 2 is First Author on Paper 2
(8, 2, 3, 2),   -- Researcher 8 is Co-author on Paper 2
(17, 2, 3, 3),  -- Researcher 17 is Co-author on Paper 2
(3, 3, 1, 1),   -- Researcher 3 is First Author on Paper 3
(20, 3, 3, 2),  -- Researcher 20 is Co-author on Paper 3
(5, 4, 1, 1),   -- Researcher 5 is First Author on Paper 4
(18, 4, 3, 2),  -- Researcher 18 is Co-author on Paper 4
(12, 5, 1, 1),  -- Researcher 12 is First Author on Paper 5
(13, 5, 3, 2),  -- Researcher 13 is Co-author on Paper 5
(8, 6, 1, 1),   -- Researcher 8 is First Author on Paper 6
(7, 7, 1, 1),   -- Researcher 7 is First Author on Paper 7
(12, 8, 1, 1),  -- Researcher 12 is First Author on Paper 8
(14, 8, 3, 2),  -- Researcher 14 is Co-author on Paper 8
(15, 9, 1, 1),  -- Researcher 15 is First Author on Paper 9
(4, 10, 1, 1),  -- Researcher 4 is First Author on Paper 10
(6, 11, 1, 1),  -- Researcher 6 is First Author on Paper 11
(13, 12, 1, 1), -- Researcher 13 is First Author on Paper 12
(7, 13, 1, 1),  -- Researcher 7 is First Author on Paper 13
(12, 14, 1, 1), -- Researcher 12 is First Author on Paper 14
(1, 15, 1, 1),  -- Researcher 1 is First Author on Paper 15
(5, 16, 1, 1),  -- Researcher 5 is First Author on Paper 16
(19, 17, 1, 1), -- Researcher 19 is First Author on Paper 17
(12, 18, 1, 1), -- Researcher 12 is First Author on Paper 18
(11, 19, 1, 1), -- Researcher 11 is First Author on Paper 19
(5, 20, 1, 1);  -- Researcher 5 is First Author on Paper 20
-- 19. PAPER_KEYWORD
INSERT INTO PAPER_KEYWORD (paper_id, keyword_id) VALUES
(1, 1),
(1, 4),
(1, 8),
(2, 2),
(2, 7),
(2, 20),
(3, 1),
(3, 4),
(3, 6),
(4, 13),
(4, 21),
(5, 30),
(5, 8),
(6, 15),
(6, 13),
(7, 25),
(7, 27),
(8, 8),
(8, 23),
(9, 14),
(9, 13),
(10, 8),
(10, 30),
(11, 1),
(11, 4),
(12, 22),
(12, 8),
(13, 1),
(13, 24),
(14, 14),
(14, 13),
(15, 26),
(15, 17),
(16, 25),
(16, 27),
(17, 26),
(17, 27),
(18, 25),
(18, 27),
(19, 8),
(19, 17),
(20, 7),
(20, 25);

-- 20. PEER_REVIEW
INSERT INTO PEER_REVIEW (paper_id, reviewer_id, review_date, comments, recommendation) VALUES
(1, 2, '2024-04-20', 'Well-written paper with strong methodology. Minor revisions needed in literature review section.', 'Accept with revisions'),
(2, 3, '2024-07-15', 'Excellent experimental design and clear results. Strong contribution to renewable energy research.', 'Accept'),
(1, 3, '2024-04-25', 'Good contribution to AI in healthcare. Suggest expanding discussion on ethical considerations.', 'Accept with revisions'),
(3, 1, '2024-02-05', 'Novel approach to Urdu NLP. Need more details on dataset construction.', 'Major revisions'),
(4, 6, '2024-07-10', 'Comprehensive framework but lacks implementation details.', 'Major revisions'),
(5, 12, '2023-10-05', 'Important epidemiological study. Statistical analysis is robust.', 'Accept'),
(6, 15, '2024-06-18', 'Innovative blockchain application. Need more security analysis.', 'Accept with revisions'),
(7, 4, '2024-03-12', 'Good field study but sample size is limited.', 'Major revisions'),
(8, 13, '2024-09-15', 'Valuable community health research. Clear policy implications.', 'Accept'),
(9, 7, '2023-08-30', 'Important seismic study. Maps need better resolution.', 'Accept with revisions'),
(10, 9, '2024-11-05', 'Large-scale diabetes study. Well-executed statistical analysis.', 'Accept'),
(11, 20, '2024-01-25', 'Promising educational technology. Needs longer-term evaluation.', 'Accept with revisions'),
(12, 12, '2024-11-20', 'Good telemedicine study. Practical recommendations.', 'Accept'),
(13, 11, '2024-08-28', 'Solid ML application in agriculture. Good predictive accuracy.', 'Accept'),
(14, 6, '2024-03-25', 'Important cybersecurity research. Restricted access appropriate.', 'Accept'),
(15, 10, '2024-03-01', 'Comprehensive economic analysis. Sensitive data handled properly.', 'Accept'),
(16, 19, '2023-11-30', 'Innovative flood warning system. Good prototype development.', 'Accept with revisions'),
(17, 8, '2023-07-25', 'Detailed waste management analysis. Good GIS application.', 'Accept'),
(18, 4, '2024-04-15', 'Important water quality research. Needs more chemical analysis details.', 'Major revisions'),
(19, 13, '2024-01-10', 'Valuable cancer registry data. Well-organized analysis.', 'Accept');

-- 21. CITATION
INSERT INTO CITATION (citing_output_id, cited_output_id, citation_date) VALUES
(1, 3, '2024-06-12'),
(2, 1, '2024-09-10'),
(3, 2, '2024-01-20'),
(4, 1, '2024-03-20'),
(5, 2, '2024-08-15'),
(6, 5, '2023-11-20'),
(7, 6, '2024-05-05'),
(8, 7, '2024-09-25'),
(9, 8, '2024-07-10'),
(10, 9, '2024-01-30'),
(11, 10, '2023-12-10'),
(12, 11, '2024-10-05'),
(13, 12, '2023-09-28'),
(14, 13, '2024-04-12'),
(15, 14, '2024-03-05'),
(16, 15, '2023-12-25'),
(17, 16, '2023-08-30'),
(18, 17, '2024-05-20'),
(19, 18, '2024-02-15'),
(20, 19, '2024-07-01'),
(1, 20, '2024-06-15'),
(2, 19, '2024-09-05'),
(3, 18, '2024-02-10'),
(4, 17, '2024-03-25'),
(5, 16, '2024-08-20'),
(6, 15, '2023-11-25'),
(7, 14, '2024-05-10'),
(8, 13, '2024-10-01'),
(9, 12, '2024-07-15'),
(10, 11, '2024-02-05');

-- 22. TREND_INDICATOR
INSERT INTO TREND_INDICATOR
(paper_id, calculated_date, citation_growth_rate, trending_score, calculation_window, algorithm_version) 
VALUES
(1, '2024-12-31', 0.25, 8.7, 30, 'v1.2'),
(2, '2024-12-31', 0.18, 7.2, 30, 'v1.2'),
(3, '2024-12-31', 0.22, 8.1, 30, 'v1.2'),
(4, '2024-12-31', 0.15, 6.5, 30, 'v1.2'),
(5, '2024-12-31', 0.12, 5.8, 30, 'v1.2'),
(6, '2024-12-31', 0.28, 9.3, 30, 'v1.2'),
(7, '2024-12-31', 0.19, 7.4, 30, 'v1.2'),
(8, '2024-12-31', 0.24, 8.5, 30, 'v1.2'),
(9, '2024-12-31', 0.16, 6.9, 30, 'v1.2'),
(10, '2024-12-31', 0.21, 8.0, 30, 'v1.2'),
(11, '2024-12-31', 0.32, 9.8, 30, 'v1.2'),
(12, '2024-12-31', 0.14, 6.2, 30, 'v1.2'),
(13, '2024-12-31', 0.26, 8.9, 30, 'v1.2'),
(14, '2024-12-31', 0.11, 5.5, 30, 'v1.2'),
(15, '2024-12-31', 0.23, 8.3, 30, 'v1.2'),
(16, '2024-12-31', 0.29, 9.5, 30, 'v1.2'),
(17, '2024-12-31', 0.17, 7.1, 30, 'v1.2'),
(18, '2024-12-31', 0.20, 7.8, 30, 'v1.2'),
(19, '2024-12-31', 0.13, 6.0, 30, 'v1.2'),
(20, '2024-12-31', 0.27, 9.1, 30, 'v1.2'),
(1, '2025-01-31', 0.30, 9.1, 30, 'v1.3'),
(2, '2025-01-31', 0.21, 7.8, 30, 'v1.3'),
(3, '2025-01-31', 0.25, 8.6, 30, 'v1.3'),
(6, '2025-01-31', 0.35, 10.2, 30, 'v1.3'),
(11, '2025-01-31', 0.38, 10.8, 30, 'v1.3'),
(16, '2025-01-31', 0.33, 9.9, 30, 'v1.3'),
(20, '2025-01-31', 0.31, 9.4, 30, 'v1.3');