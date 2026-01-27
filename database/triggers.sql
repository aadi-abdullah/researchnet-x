-- ============================================================================
-- OPERATIONAL QUERIES - CORRECTED VERSION
-- ============================================================================

-- 1. Institutional Structure Management
-- Create institution
INSERT INTO INSTITUTION (name, location, type, website_url, established_date) 
VALUES ('New University', 'Islamabad', 'Public University', 'https://new.edu.pk', '2020-01-01');

-- Update institution
UPDATE INSTITUTION SET location = 'Lahore, Punjab' WHERE institution_id = 1;

-- Note: Delete would cascade to departments due to ON DELETE CASCADE
-- DELETE FROM INSTITUTION WHERE institution_id = 1;

-- Add department to institution
INSERT INTO DEPARTMENT (name, institution_id) VALUES ('Department of Data Science', 1);

-- Get all departments in an institution
SELECT d.name, i.name as institution_name 
FROM DEPARTMENT d 
JOIN INSTITUTION i ON d.institution_id = i.institution_id 
WHERE i.name = 'University of the Punjab';

-- Institution-wise research output
SELECT i.name, COUNT(po.output_id) as total_outputs
FROM INSTITUTION i
JOIN DEPARTMENT d ON i.institution_id = d.institution_id
JOIN RESEARCH_PROJECT rp ON d.department_id = rp.department_id
JOIN PROJECT_OUTPUT po ON rp.project_id = po.project_id
GROUP BY i.name
ORDER BY total_outputs DESC;

-- 2. Researcher Profile Management
-- Register researcher
INSERT INTO RESEARCHER (full_name, email, orcid_id, profile_url, academic_rank) 
VALUES ('Dr. New Researcher', 'new2@edu.pk', '0000-0000-0000-0001', 'https://profile2.edu.pk', 'Assistant Professor');

-- Update researcher profile
UPDATE RESEARCHER SET email = 'updated@edu.pk' WHERE researcher_id = 1;

-- Get researcher by expertise
SELECT r.full_name, ra.area_name 
FROM RESEARCHER r
JOIN RESEARCH_AREA_MAPPING ram ON r.researcher_id = ram.researcher_id
JOIN RESEARCH_AREA ra ON ram.research_area_id = ra.research_area_id
WHERE ra.area_name = 'Machine Learning';

-- Researcher publication history
SELECT r.full_name, ro.title, ro.created_date
FROM RESEARCHER r
JOIN COLLABORATION c ON r.researcher_id = c.researcher_id
JOIN PAPER p ON c.paper_id = p.paper_id
JOIN RESEARCH_OUTPUT ro ON p.paper_id = ro.output_id
WHERE r.full_name = 'Dr. Muhammad Ali'
ORDER BY ro.created_date DESC;

-- 3. Researcher Appointment & Employment Tracking
-- Record appointment
INSERT INTO EMPLOYMENT (researcher_id, department_id, position_title, start_date, end_date, employment_type)
VALUES (1, 1, 'Professor', '2024-01-01', '2027-12-31', 'Permanent');

-- Find cross-department researchers
SELECT r.full_name, COUNT(DISTINCT d.department_id) as departments_count
FROM RESEARCHER r
JOIN EMPLOYMENT e ON r.researcher_id = e.researcher_id
JOIN DEPARTMENT d ON e.department_id = d.department_id
WHERE e.end_date IS NULL OR e.end_date > CURDATE()
GROUP BY r.researcher_id
HAVING COUNT(DISTINCT d.department_id) > 1;

-- Researcher mobility timeline
SELECT r.full_name, d.name as department, e.position_title, e.start_date, e.end_date
FROM EMPLOYMENT e
JOIN RESEARCHER r ON e.researcher_id = r.researcher_id
JOIN DEPARTMENT d ON e.department_id = d.department_id
WHERE r.full_name = 'Dr. Muhammad Ali'
ORDER BY e.start_date;

-- Departmental research strength (by number of researchers)
SELECT d.name, COUNT(DISTINCT e.researcher_id) as researcher_count
FROM DEPARTMENT d
LEFT JOIN EMPLOYMENT e ON d.department_id = e.department_id
WHERE (e.end_date IS NULL OR e.end_date > CURDATE())
GROUP BY d.department_id
ORDER BY researcher_count DESC;

-- 4. Publication Venue Management
-- Add new journal
INSERT INTO PUBLICATION_VENUE (name, venue_type, publisher, open_access_flag, issn, website_url)
VALUES ('Journal of New Science', 'journal', 'New Publisher', TRUE, '1234-5678', 'https://jns.com');

-- Update venue metadata
UPDATE PUBLICATION_VENUE SET open_access_flag = TRUE WHERE venue_id = 1;

-- Venue-based publication trends
SELECT pv.name, pv.venue_type, COUNT(p.paper_id) as publication_count
FROM PUBLICATION_VENUE pv
LEFT JOIN PAPER p ON pv.venue_id = p.venue_id
GROUP BY pv.venue_id
ORDER BY publication_count DESC;

-- Compare venue impact
SELECT pv.name, AVG(ti.trending_score) as avg_trending_score
FROM PUBLICATION_VENUE pv
JOIN PAPER p ON pv.venue_id = p.venue_id
JOIN TREND_INDICATOR ti ON p.paper_id = ti.paper_id
WHERE ti.calculated_date = (SELECT MAX(calculated_date) FROM TREND_INDICATOR)
GROUP BY pv.venue_id
ORDER BY avg_trending_score DESC;

-- 5. Research Output Management
-- Add research output (paper)
INSERT INTO RESEARCH_OUTPUT (title, description, created_date, visibility_status)
VALUES ('New Research Paper', 'Description', CURDATE(), 'Public');

SET @output_id = LAST_INSERT_ID();

INSERT INTO PAPER (paper_id, abstract, publication_date, manuscript_status, doi, venue_id)
VALUES (@output_id, 'Abstract text', CURDATE(), 'Submitted', '10.1234/new', 1);

-- Get outputs by type
-- Papers
SELECT ro.title, p.abstract, p.publication_date
FROM RESEARCH_OUTPUT ro
JOIN PAPER p ON ro.output_id = p.paper_id
WHERE p.manuscript_status = 'Published';

-- Datasets
SELECT ro.title, d.repository_url, d.access_type
FROM RESEARCH_OUTPUT ro
JOIN DATASET d ON ro.output_id = d.dataset_id;

-- Output lifecycle tracking
SELECT ro.title, p.manuscript_status, ro.created_date, p.publication_date
FROM RESEARCH_OUTPUT ro
JOIN PAPER p ON ro.output_id = p.paper_id
WHERE ro.created_date BETWEEN '2024-01-01' AND '2024-12-31';

-- 6. Authorship and Collaboration Management
-- Assign author to paper
INSERT INTO COLLABORATION (researcher_id, paper_id, author_role_id, author_order) 
VALUES (1, 2, 1, 1);

-- Identify collaboration networks
SELECT r1.full_name as author1, r2.full_name as author2, COUNT(*) as collaboration_count
FROM COLLABORATION c1
JOIN COLLABORATION c2 ON c1.paper_id = c2.paper_id
JOIN RESEARCHER r1 ON c1.researcher_id = r1.researcher_id
JOIN RESEARCHER r2 ON c2.researcher_id = r2.researcher_id
WHERE c1.researcher_id < c2.researcher_id
GROUP BY r1.researcher_id, r2.researcher_id
ORDER BY collaboration_count DESC
LIMIT 10;

-- Cross-institutional collaborations
SELECT DISTINCT i1.name as institution1, i2.name as institution2
FROM COLLABORATION c1
JOIN COLLABORATION c2 ON c1.paper_id = c2.paper_id
JOIN EMPLOYMENT e1 ON c1.researcher_id = e1.researcher_id
JOIN EMPLOYMENT e2 ON c2.researcher_id = e2.researcher_id
JOIN DEPARTMENT d1 ON e1.department_id = d1.department_id
JOIN DEPARTMENT d2 ON e2.department_id = d2.department_id
JOIN INSTITUTION i1 ON d1.institution_id = i1.institution_id
JOIN INSTITUTION i2 ON d2.institution_id = i2.institution_id
WHERE i1.institution_id < i2.institution_id;

-- Author roles distribution
SELECT ar.role_name, COUNT(*) as count
FROM COLLABORATION c
JOIN AUTHOR_ROLE ar ON c.author_role_id = ar.author_role_id
GROUP BY ar.role_name
ORDER BY count DESC;

-- 7. Keyword and Topic Classification
-- Add keyword
INSERT INTO KEYWORD (keyword_text, keyword_type) VALUES ('quantum information', 'Technology');

-- Assign keyword to paper
INSERT INTO PAPER_KEYWORD (paper_id, keyword_id) VALUES (1, LAST_INSERT_ID());

-- Topic-based search
SELECT ro.title, GROUP_CONCAT(k.keyword_text) as keywords
FROM RESEARCH_OUTPUT ro
JOIN PAPER p ON ro.output_id = p.paper_id
JOIN PAPER_KEYWORD pk ON p.paper_id = pk.paper_id
JOIN KEYWORD k ON pk.keyword_id = k.keyword_id
WHERE k.keyword_text LIKE '%machine learning%'
GROUP BY ro.output_id;

-- Popular research themes
SELECT k.keyword_text, COUNT(pk.paper_id) as paper_count
FROM KEYWORD k
JOIN PAPER_KEYWORD pk ON k.keyword_id = pk.keyword_id
GROUP BY k.keyword_id
ORDER BY paper_count DESC
LIMIT 10;

-- Emerging topics (recent keywords)
SELECT k.keyword_text, COUNT(pk.paper_id) as recent_paper_count
FROM KEYWORD k
JOIN PAPER_KEYWORD pk ON k.keyword_id = pk.keyword_id
JOIN PAPER p ON pk.paper_id = p.paper_id
WHERE p.publication_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY k.keyword_id
ORDER BY recent_paper_count DESC;

-- 8. Citation Tracking and Analysis
-- Record citation
INSERT INTO CITATION (citing_output_id, cited_output_id, citation_date) 
VALUES (1, 2, CURDATE());

-- Compute citation counts
SELECT ro.title, COUNT(c.citation_id) as citation_count
FROM RESEARCH_OUTPUT ro
LEFT JOIN CITATION c ON ro.output_id = c.cited_output_id
WHERE ro.output_id IN (SELECT paper_id FROM PAPER)
GROUP BY ro.output_id
ORDER BY citation_count DESC;

-- Citation networks
SELECT 
    c1.title as citing_paper,
    c2.title as cited_paper
FROM CITATION ci
JOIN RESEARCH_OUTPUT c1 ON ci.citing_output_id = c1.output_id
JOIN RESEARCH_OUTPUT c2 ON ci.cited_output_id = c2.output_id
LIMIT 20;

-- Most influential papers (by citations)
SELECT ro.title, COUNT(c.citation_id) as total_citations
FROM RESEARCH_OUTPUT ro
JOIN CITATION c ON ro.output_id = c.cited_output_id
GROUP BY ro.output_id
ORDER BY total_citations DESC
LIMIT 10;

-- Knowledge flow analysis (citations over time)
SELECT 
    YEAR(c.citation_date) as citation_year,
    COUNT(c.citation_id) as citation_count
FROM CITATION c
GROUP BY YEAR(c.citation_date)
ORDER BY citation_year;

-- 9. Grant and Funding Allocation Tracking
-- Add grant
INSERT INTO `GRANT` (grant_title, funding_agency, grant_amount, start_date, end_date, grant_status, grant_number) 
VALUES ('New Research Grant', 'HEC', 5000000.00, '2024-01-01', '2026-12-31', 'Active', 'HEC-2024-001');

-- Allocate grant to project
INSERT INTO PROJECT_GRANT (project_id, grant_id, allocation_amount) 
VALUES (1, LAST_INSERT_ID(), 2500000.00);

-- Identify funded research outputs
SELECT g.grant_title, ro.title as output_title, ro.created_date
FROM `GRANT` g
JOIN PROJECT_GRANT pg ON g.grant_id = pg.grant_id
JOIN RESEARCH_PROJECT rp ON pg.project_id = rp.project_id
JOIN PROJECT_OUTPUT po ON rp.project_id = po.project_id
JOIN RESEARCH_OUTPUT ro ON po.output_id = ro.output_id
WHERE g.grant_status = 'Active';

-- Funding distribution across outputs
SELECT g.funding_agency, SUM(g.grant_amount) as total_funding, COUNT(po.output_id) as outputs_produced
FROM `GRANT` g
JOIN PROJECT_GRANT pg ON g.grant_id = pg.grant_id
JOIN PROJECT_OUTPUT po ON pg.project_id = po.project_id
GROUP BY g.funding_agency
ORDER BY total_funding DESC;

-- Research outcomes per grant
SELECT 
    g.grant_title,
    g.grant_amount,
    COUNT(DISTINCT po.output_id) as outputs_produced,
    (g.grant_amount / NULLIF(COUNT(DISTINCT po.output_id), 0)) as cost_per_output
FROM `GRANT` g
LEFT JOIN PROJECT_GRANT pg ON g.grant_id = pg.grant_id
LEFT JOIN PROJECT_OUTPUT po ON pg.project_id = po.project_id
GROUP BY g.grant_id
HAVING outputs_produced > 0;

-- 10. Project Management
-- Create project
INSERT INTO RESEARCH_PROJECT (project_title, description, start_date, end_date, project_status, department_id)
VALUES ('New AI Project', 'Description', '2024-01-01', '2025-12-31', 'Active', 1);

-- Link output to project
INSERT INTO PROJECT_OUTPUT (project_id, output_id) 
VALUES (1, 1)
ON DUPLICATE KEY UPDATE project_id = project_id;

-- Track project-based activities
SELECT 
    rp.project_title,
    rp.project_status,
    COUNT(DISTINCT pm.researcher_id) as team_size,
    COUNT(DISTINCT po.output_id) as outputs_produced
FROM RESEARCH_PROJECT rp
LEFT JOIN PROJECT_MEMBER pm ON rp.project_id = pm.project_id
LEFT JOIN PROJECT_OUTPUT po ON rp.project_id = po.project_id
GROUP BY rp.project_id
ORDER BY outputs_produced DESC;

-- Aggregate outputs under project
SELECT 
    rp.project_title,
    ro.title as output_title,
    ro.created_date
FROM RESEARCH_PROJECT rp
JOIN PROJECT_OUTPUT po ON rp.project_id = po.project_id
JOIN RESEARCH_OUTPUT ro ON po.output_id = ro.output_id
WHERE rp.project_id = 1;

-- 11. Peer Review Recording
-- Record peer review
INSERT INTO PEER_REVIEW (paper_id, reviewer_id, review_date, comments, recommendation) 
VALUES (21, 3, CURDATE(), 'New review for different paper', 'Accept');

-- Review history for a paper
SELECT 
    r.full_name as reviewer,
    pr.review_date,
    pr.comments,
    pr.recommendation
FROM PEER_REVIEW pr
JOIN RESEARCHER r ON pr.reviewer_id = r.researcher_id
WHERE pr.paper_id = 1
ORDER BY pr.review_date DESC;

-- Quality assessment by reviewer
SELECT 
    r.full_name as reviewer,
    COUNT(pr.review_id) as reviews_done,
    AVG(CASE 
        WHEN pr.recommendation LIKE 'Accept%' THEN 1 
        ELSE 0 
    END) as acceptance_rate
FROM RESEARCHER r
JOIN PEER_REVIEW pr ON r.researcher_id = pr.reviewer_id
GROUP BY r.researcher_id
HAVING COUNT(pr.review_id) >= 3
ORDER BY reviews_done DESC;

-- 12. Impact Metrics Calculation and Storage
-- Calculate and store researcher h-index (simplified version)
SELECT 
    r.full_name,
    COUNT(DISTINCT c.citation_id) as total_citations,
    COUNT(DISTINCT p.paper_id) as total_papers
FROM RESEARCHER r
JOIN COLLABORATION col ON r.researcher_id = col.researcher_id
JOIN PAPER p ON col.paper_id = p.paper_id
LEFT JOIN CITATION c ON p.paper_id = c.cited_output_id
GROUP BY r.researcher_id
ORDER BY total_citations DESC;

-- Citation counts by venue
SELECT 
    pv.name,
    AVG(citation_count) as avg_citations_per_paper
FROM PUBLICATION_VENUE pv
JOIN PAPER p ON pv.venue_id = p.venue_id
LEFT JOIN (
    SELECT cited_output_id, COUNT(*) as citation_count
    FROM CITATION
    GROUP BY cited_output_id
) cit ON p.paper_id = cit.cited_output_id
GROUP BY pv.venue_id
ORDER BY avg_citations_per_paper DESC;

-- Compare impact across papers
SELECT 
    ro.title,
    COUNT(c.citation_id) as citation_count,
    ti.trending_score
FROM RESEARCH_OUTPUT ro
JOIN PAPER p ON ro.output_id = p.paper_id
LEFT JOIN CITATION c ON ro.output_id = c.cited_output_id
LEFT JOIN TREND_INDICATOR ti ON p.paper_id = ti.paper_id
WHERE ti.calculated_date = (SELECT MAX(calculated_date) FROM TREND_INDICATOR)
GROUP BY ro.output_id, ti.trending_score
ORDER BY citation_count DESC;

-- 13. Trend Detection and Analysis
-- Store trend indicator
INSERT INTO TREND_INDICATOR (paper_id, calculated_date, citation_growth_rate, trending_score, calculation_window, algorithm_version) 
VALUES (1, CURDATE(), 0.25, 8.5, 30, 'v1.2');

-- Identify emerging high-impact research
SELECT 
    ro.title,
    ti.trending_score,
    ti.citation_growth_rate,
    COUNT(c.citation_id) as total_citations
FROM RESEARCH_OUTPUT ro
JOIN PAPER p ON ro.output_id = p.paper_id
JOIN TREND_INDICATOR ti ON p.paper_id = ti.paper_id
LEFT JOIN CITATION c ON ro.output_id = c.cited_output_id
WHERE ti.calculated_date = (SELECT MAX(calculated_date) FROM TREND_INDICATOR)
    AND ti.trending_score > 8.0
    AND ti.citation_growth_rate > 0.2
GROUP BY ro.output_id, ti.trending_score, ti.citation_growth_rate
ORDER BY ti.trending_score DESC;

-- Fast-growing publications
SELECT 
    ro.title,
    ti.citation_growth_rate,
    ti.trending_score,
    (SELECT COUNT(*) FROM CITATION WHERE cited_output_id = ro.output_id AND citation_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)) as recent_citations
FROM RESEARCH_OUTPUT ro
JOIN PAPER p ON ro.output_id = p.paper_id
JOIN TREND_INDICATOR ti ON p.paper_id = ti.paper_id
WHERE ti.calculated_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
ORDER BY ti.citation_growth_rate DESC
LIMIT 10;

-- Emerging topics based on citation velocity
SELECT 
    k.keyword_text,
    COUNT(DISTINCT p.paper_id) as paper_count,
    AVG(ti.citation_growth_rate) as avg_growth_rate
FROM KEYWORD k
JOIN PAPER_KEYWORD pk ON k.keyword_id = pk.keyword_id
JOIN PAPER p ON pk.paper_id = p.paper_id
JOIN TREND_INDICATOR ti ON p.paper_id = ti.paper_id
WHERE ti.calculated_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
GROUP BY k.keyword_id
HAVING paper_count >= 3
ORDER BY avg_growth_rate DESC;

-- 14. Advanced Analytical Query Support
-- 1. Top researchers by impact in a department
SELECT 
    r.full_name,
    d.name as department,
    COUNT(DISTINCT col.paper_id) as papers_published,
    COUNT(DISTINCT cit.citation_id) as total_citations
FROM RESEARCHER r
JOIN EMPLOYMENT e ON r.researcher_id = e.researcher_id
JOIN DEPARTMENT d ON e.department_id = d.department_id
JOIN COLLABORATION col ON r.researcher_id = col.researcher_id
LEFT JOIN CITATION cit ON col.paper_id = cit.cited_output_id
WHERE d.name = 'Department of Computer Science'
    AND (e.end_date IS NULL OR e.end_date > CURDATE())
GROUP BY r.researcher_id
ORDER BY total_citations DESC
LIMIT 10;

-- 2. Most cited papers funded by a grant
SELECT 
    ro.title,
    g.grant_title,
    COUNT(c.citation_id) as citation_count
FROM RESEARCH_OUTPUT ro
JOIN PAPER p ON ro.output_id = p.paper_id
JOIN PROJECT_OUTPUT po ON ro.output_id = po.output_id
JOIN PROJECT_GRANT pg ON po.project_id = pg.project_id
JOIN `GRANT` g ON pg.grant_id = g.grant_id
LEFT JOIN CITATION c ON ro.output_id = c.cited_output_id
WHERE g.grant_number = 'HEC-NRPU-2023-001'
GROUP BY ro.output_id, g.grant_title
ORDER BY citation_count DESC;

-- 3. Venues with highest average citation impact (CORRECTED)
SELECT 
    pv.name,
    pv.venue_type,
    COUNT(DISTINCT p.paper_id) as papers_published,
    AVG(IFNULL(cit.citation_count, 0)) as avg_citations_per_paper
FROM PUBLICATION_VENUE pv
JOIN PAPER p ON pv.venue_id = p.venue_id
LEFT JOIN (
    SELECT cited_output_id, COUNT(*) as citation_count
    FROM CITATION
    GROUP BY cited_output_id
) cit ON p.paper_id = cit.cited_output_id
GROUP BY pv.venue_id
ORDER BY avg_citations_per_paper DESC;

-- 4. Researchers with cross-department collaborations
SELECT 
    r.full_name,
    COUNT(DISTINCT d.department_id) as departments_collaborated,
    COUNT(DISTINCT col.paper_id) as collaborative_papers
FROM RESEARCHER r
JOIN COLLABORATION col ON r.researcher_id = col.researcher_id
JOIN (
    SELECT paper_id, COUNT(DISTINCT d.department_id) as dept_count
    FROM COLLABORATION c
    JOIN EMPLOYMENT e ON c.researcher_id = e.researcher_id
    JOIN DEPARTMENT d ON e.department_id = d.department_id
    WHERE e.end_date IS NULL OR e.end_date > CURDATE()
    GROUP BY paper_id
    HAVING COUNT(DISTINCT d.department_id) > 1
) multi_dept ON col.paper_id = multi_dept.paper_id
JOIN EMPLOYMENT e ON r.researcher_id = e.researcher_id
JOIN DEPARTMENT d ON e.department_id = d.department_id
WHERE e.end_date IS NULL OR e.end_date > CURDATE()
GROUP BY r.researcher_id
ORDER BY departments_collaborated DESC
LIMIT 10;

-- 5. Emerging research topics based on citation velocity
SELECT 
    k.keyword_text,
    COUNT(DISTINCT pk.paper_id) as recent_papers,
    SUM(CASE 
        WHEN ti.trending_score > 7.5 THEN 1 
        ELSE 0 
    END) as trending_papers,
    AVG(ti.citation_growth_rate) as avg_growth_rate
FROM KEYWORD k
JOIN PAPER_KEYWORD pk ON k.keyword_id = pk.keyword_id
JOIN PAPER p ON pk.paper_id = p.paper_id
JOIN TREND_INDICATOR ti ON p.paper_id = ti.paper_id
WHERE p.publication_date >= DATE_SUB(CURDATE(), INTERVAL 2 YEAR)
    AND ti.calculated_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
GROUP BY k.keyword_id
HAVING recent_papers >= 5
ORDER BY avg_growth_rate DESC, trending_papers DESC
LIMIT 15;

-- 15. Data Integrity and Consistency Enforcement
-- Check for orphan records
-- Orphan departments (no institution)
SELECT d.* FROM DEPARTMENT d 
LEFT JOIN INSTITUTION i ON d.institution_id = i.institution_id 
WHERE i.institution_id IS NULL;

-- Orphan researchers in employment (no researcher)
SELECT e.* FROM EMPLOYMENT e 
LEFT JOIN RESEARCHER r ON e.researcher_id = r.researcher_id 
WHERE r.researcher_id IS NULL;

-- Orphan papers (no output)
SELECT p.* FROM PAPER p 
LEFT JOIN RESEARCH_OUTPUT ro ON p.paper_id = ro.output_id 
WHERE ro.output_id IS NULL;

-- Validate temporal constraints (employment dates)
SELECT * FROM EMPLOYMENT 
WHERE start_date > IFNULL(end_date, CURDATE());

-- Validate project dates
SELECT * FROM RESEARCH_PROJECT 
WHERE start_date > end_date;

-- Check for duplicate collaborations
SELECT paper_id, researcher_id, COUNT(*) as duplicate_count
FROM COLLABORATION 
GROUP BY paper_id, researcher_id 
HAVING COUNT(*) > 1;

-- Data consistency check: All papers should be linked to projects
SELECT p.* 
FROM PAPER p
LEFT JOIN PROJECT_OUTPUT po ON p.paper_id = po.output_id
WHERE po.project_id IS NULL;

-- Referential integrity verification
SELECT 'RESEARCH_PROJECT missing DEPARTMENT' as check_name,
    COUNT(*) as violations
FROM RESEARCH_PROJECT rp
LEFT JOIN DEPARTMENT d ON rp.department_id = d.department_id
WHERE d.department_id IS NULL

UNION ALL

SELECT 'PROJECT_MEMBER missing RESEARCHER' as check_name,
    COUNT(*) as violations
FROM PROJECT_MEMBER pm
LEFT JOIN RESEARCHER r ON pm.researcher_id = r.researcher_id
WHERE r.researcher_id IS NULL

UNION ALL

SELECT 'CITATION missing OUTPUT (citing)' as check_name,
    COUNT(*) as violations
FROM CITATION c
LEFT JOIN RESEARCH_OUTPUT ro ON c.citing_output_id = ro.output_id
WHERE ro.output_id IS NULL

UNION ALL

SELECT 'CITATION missing OUTPUT (cited)' as check_name,
    COUNT(*) as violations
FROM CITATION c
LEFT JOIN RESEARCH_OUTPUT ro ON c.cited_output_id = ro.output_id
WHERE ro.output_id IS NULL;

-- Summary statistics
SELECT 
    (SELECT COUNT(*) FROM INSTITUTION) as total_institutions,
    (SELECT COUNT(*) FROM DEPARTMENT) as total_departments,
    (SELECT COUNT(*) FROM RESEARCHER) as total_researchers,
    (SELECT COUNT(*) FROM RESEARCH_PROJECT) as total_projects,
    (SELECT COUNT(*) FROM PAPER) as total_papers,
    (SELECT COUNT(*) FROM DATASET) as total_datasets,
    (SELECT COUNT(*) FROM CITATION) as total_citations;