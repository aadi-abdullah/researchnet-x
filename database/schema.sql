DROP DATABASE IF EXISTS research_db;
CREATE DATABASE research_db;
USE research_db;
-- Independent Entities
CREATE TABLE INSTITUTION (
    institution_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    location VARCHAR(150),
    type VARCHAR(50),
    website_url VARCHAR(255),
    established_date DATE
);
CREATE TABLE DEPARTMENT (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    institution_id INT NOT NULL,
    FOREIGN KEY (institution_id) REFERENCES INSTITUTION(institution_id) ON DELETE CASCADE,
    INDEX idx_dept_institution (institution_id)
);
CREATE TABLE RESEARCHER (
    researcher_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(200) NOT NULL,
    email VARCHAR(150) UNIQUE,
    orcid_id VARCHAR(25) UNIQUE,
    profile_url VARCHAR(255),
    academic_rank VARCHAR(50),
    INDEX idx_researcher_name (full_name)
);
CREATE TABLE RESEARCH_AREA (
    research_area_id INT AUTO_INCREMENT PRIMARY KEY,
    area_name VARCHAR(150) NOT NULL,
    description TEXT,
    parent_area_id INT,
    FOREIGN KEY (parent_area_id) REFERENCES RESEARCH_AREA(research_area_id),
    INDEX idx_area_name (area_name)
);
CREATE TABLE RESEARCH_PROJECT (
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    project_title VARCHAR(300) NOT NULL,
    description TEXT,
    start_date DATE,
    end_date DATE,
    project_status VARCHAR(30),
    department_id INT NOT NULL,
    FOREIGN KEY (department_id) REFERENCES DEPARTMENT(department_id),
    INDEX idx_project_title (project_title),
    INDEX idx_project_status (project_status),
    INDEX idx_project_dates (start_date, end_date)
);
CREATE TABLE `GRANT` (
    grant_id INT AUTO_INCREMENT PRIMARY KEY,
    grant_title VARCHAR(300) NOT NULL,
    funding_agency VARCHAR(200),
    grant_amount DECIMAL(15,2),
    start_date DATE,
    end_date DATE,
    grant_status VARCHAR(30),
    grant_number VARCHAR(100) UNIQUE,
    INDEX idx_grant_title (grant_title),
    INDEX idx_grant_dates (start_date, end_date)
);
CREATE TABLE KEYWORD (
    keyword_id INT AUTO_INCREMENT PRIMARY KEY,
    keyword_text VARCHAR(100) NOT NULL UNIQUE,
    keyword_type VARCHAR(50),
    INDEX idx_keyword_text (keyword_text)
);
CREATE TABLE AUTHOR_ROLE (
    author_role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE
);
CREATE TABLE PUBLICATION_VENUE (
    venue_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    venue_type ENUM('journal', 'conference') NOT NULL,
    publisher VARCHAR(200),
    open_access_flag BOOLEAN DEFAULT FALSE,
    issn VARCHAR(20),
    isbn VARCHAR(20),
    website_url VARCHAR(255),
    INDEX idx_venue_name (name)
);
-- Specialization Hierarchy Entities
CREATE TABLE RESEARCH_OUTPUT (
    output_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(500) NOT NULL,
    description TEXT,
    created_date DATE,
    visibility_status VARCHAR(30),
    INDEX idx_output_title (title),
    INDEX idx_created_date (created_date)
);
CREATE TABLE PAPER (
    paper_id INT PRIMARY KEY,
    abstract TEXT,
    publication_date DATE,
    manuscript_status VARCHAR(30),
    doi VARCHAR(100),
    venue_id INT,
    FOREIGN KEY (paper_id) REFERENCES RESEARCH_OUTPUT(output_id),
    FOREIGN KEY (venue_id) REFERENCES PUBLICATION_VENUE(venue_id),
    INDEX idx_paper_doi (doi),
    INDEX idx_publication_date (publication_date)
);
CREATE TABLE DATASET (
    dataset_id INT PRIMARY KEY,
    repository_url VARCHAR(500),
    access_type VARCHAR(50),
    release_date DATE,
    license_type VARCHAR(100),
    FOREIGN KEY (dataset_id) REFERENCES RESEARCH_OUTPUT(output_id),
    INDEX idx_release_date (release_date)
);
-- Associative Entities
CREATE TABLE EMPLOYMENT (
    employment_id INT AUTO_INCREMENT PRIMARY KEY,
    researcher_id INT NOT NULL,
    department_id INT NOT NULL,
    position_title VARCHAR(100),
    start_date DATE,
    end_date DATE,
    employment_type VARCHAR(50),
    FOREIGN KEY (researcher_id) REFERENCES RESEARCHER(researcher_id),
    FOREIGN KEY (department_id) REFERENCES DEPARTMENT(department_id),
    INDEX idx_employment_dates (start_date, end_date)
);
CREATE TABLE RESEARCH_AREA_MAPPING (
    mapping_id INT AUTO_INCREMENT PRIMARY KEY,
    researcher_id INT NOT NULL,
    research_area_id INT NOT NULL,
    primary_flag BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (researcher_id) REFERENCES RESEARCHER(researcher_id),
    FOREIGN KEY (research_area_id) REFERENCES RESEARCH_AREA(research_area_id),
    UNIQUE KEY unique_researcher_area (researcher_id, research_area_id)
); 
CREATE TABLE PROJECT_MEMBER (
    membership_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    researcher_id INT NOT NULL,
    role_in_project VARCHAR(100),
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (project_id) REFERENCES RESEARCH_PROJECT(project_id),
    FOREIGN KEY (researcher_id) REFERENCES RESEARCHER(researcher_id),
    UNIQUE KEY unique_project_researcher (project_id, researcher_id, role_in_project),
    INDEX idx_member_dates (start_date, end_date)
);
CREATE TABLE PROJECT_GRANT (
    project_grant_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    grant_id INT NOT NULL,
    allocation_amount DECIMAL(15,2),
    FOREIGN KEY (project_id) REFERENCES RESEARCH_PROJECT(project_id),
    FOREIGN KEY (grant_id) REFERENCES `GRANT`(grant_id),
    UNIQUE KEY unique_project_grant (project_id, grant_id)
);
CREATE TABLE PROJECT_OUTPUT (
    project_output_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    output_id INT NOT NULL,
    FOREIGN KEY (project_id) REFERENCES RESEARCH_PROJECT(project_id),
    FOREIGN KEY (output_id) REFERENCES RESEARCH_OUTPUT(output_id),
    UNIQUE KEY unique_project_output (project_id, output_id)
);
CREATE TABLE COLLABORATION (
    researcher_id INT NOT NULL,
    paper_id INT NOT NULL,
    author_role_id INT NOT NULL,
    author_order INT,
    PRIMARY KEY (researcher_id, paper_id),
    FOREIGN KEY (researcher_id) REFERENCES RESEARCHER(researcher_id),
    FOREIGN KEY (paper_id) REFERENCES PAPER(paper_id),
    FOREIGN KEY (author_role_id) REFERENCES AUTHOR_ROLE(author_role_id),
    INDEX idx_author_order (author_order)
);
CREATE TABLE PAPER_KEYWORD (
    paper_id INT NOT NULL,
    keyword_id INT NOT NULL,
    PRIMARY KEY (paper_id, keyword_id),
    FOREIGN KEY (paper_id) REFERENCES PAPER(paper_id),
    FOREIGN KEY (keyword_id) REFERENCES KEYWORD(keyword_id)
);
CREATE TABLE PEER_REVIEW (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    paper_id INT NOT NULL,
    reviewer_id INT NOT NULL,
    review_date DATE,
    comments TEXT,
    recommendation VARCHAR(50),
    FOREIGN KEY (paper_id) REFERENCES PAPER(paper_id),
    FOREIGN KEY (reviewer_id) REFERENCES RESEARCHER(researcher_id),
    UNIQUE KEY unique_review (paper_id, reviewer_id)
);
CREATE TABLE CITATION (
    citation_id INT AUTO_INCREMENT PRIMARY KEY,
    citing_output_id INT NOT NULL,
    cited_output_id INT NOT NULL,
    citation_date DATE,
    FOREIGN KEY (citing_output_id) REFERENCES RESEARCH_OUTPUT(output_id),
    FOREIGN KEY (cited_output_id) REFERENCES RESEARCH_OUTPUT(output_id),
    UNIQUE KEY unique_citation (citing_output_id, cited_output_id)
);
-- Dependent/Analytical Entity
CREATE TABLE TREND_INDICATOR (
    paper_id INT,
    calculated_date DATE NOT NULL,
    citation_growth_rate DECIMAL(10,4),
    trending_score DECIMAL(10,4),
    calculation_window INT,
    algorithm_version VARCHAR(50),
    FOREIGN KEY (paper_id) REFERENCES PAPER(paper_id),
    PRIMARY KEY (paper_id, calculated_date),  -- Composite primary key
    INDEX idx_calculated_date (calculated_date)
);
ALTER TABLE research_project
ADD COLUMN budget DECIMAL(15,2) DEFAULT NULL;

-- 5. ADDITIONAL CONSTRAINTS AND INDEXES
-- Index for faster researcher-project queries
CREATE INDEX idx_project_member_researcher ON PROJECT_MEMBER(researcher_id);
CREATE INDEX idx_project_member_project ON PROJECT_MEMBER(project_id);

-- Index for faster employment queries
CREATE INDEX idx_employment_researcher ON EMPLOYMENT(researcher_id);
CREATE INDEX idx_employment_department ON EMPLOYMENT(department_id);

-- Index for faster area mapping queries
CREATE INDEX idx_area_mapping_researcher ON RESEARCH_AREA_MAPPING(researcher_id);
CREATE INDEX idx_area_mapping_area ON RESEARCH_AREA_MAPPING(research_area_id);

-- Index for faster project-grant queries
CREATE INDEX idx_project_grant_project ON PROJECT_GRANT(project_id);
CREATE INDEX idx_project_grant_grant ON PROJECT_GRANT(grant_id);

-- Index for faster project-output queries
CREATE INDEX idx_project_output_project ON PROJECT_OUTPUT(project_id);
CREATE INDEX idx_project_output_output ON PROJECT_OUTPUT(output_id);

-- Index for faster citation queries
CREATE INDEX idx_citation_citing ON CITATION(citing_output_id);
CREATE INDEX idx_citation_cited ON CITATION(cited_output_id);
CREATE INDEX idx_citation_date ON CITATION(citation_date);

-- Index for faster collaboration queries
CREATE INDEX idx_collaboration_paper ON COLLABORATION(paper_id);
CREATE INDEX idx_collaboration_role ON COLLABORATION(author_role_id);

-- Index for faster peer review queries
CREATE INDEX idx_peer_review_paper ON PEER_REVIEW(paper_id);
CREATE INDEX idx_peer_review_reviewer ON PEER_REVIEW(reviewer_id);
CREATE INDEX idx_review_date ON PEER_REVIEW(review_date);

-- Constraint for at most one primary research area per researcher
CREATE UNIQUE INDEX idx_primary_research_area 
ON RESEARCH_AREA_MAPPING(researcher_id, (CASE WHEN primary_flag = TRUE THEN 1 ELSE NULL END));
