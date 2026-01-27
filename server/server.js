const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const multer = require('multer');
const path = require('path');
const fs = require('fs');

const app = express();
const PORT = 3000;
const JWT_SECRET = 'research-net-x-secret-key-2024';

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static('public'));

// Database connection
const pool = mysql.createPool({
    host: 'localhost',
    user: 'root',
    password: 'Aadi950',
    database: 'research_db',
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

// Create promise wrapper for pool
const promisePool = pool.promise();

// Test database connection
promisePool.getConnection()
    .then(connection => {
        console.log('Successfully connected to research_db database');
        connection.release();
    })
    .catch(err => {
        console.error('Database connection failed:', err.message);
    });

// Configure multer for file uploads
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        // Create uploads directory if it doesn't exist
        const uploadDir = 'uploads/';
        if (!fs.existsSync(uploadDir)) {
            fs.mkdirSync(uploadDir, { recursive: true });
        }
        cb(null, uploadDir);
    },
    filename: function (req, file, cb) {
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
        cb(null, file.fieldname + '-' + uniqueSuffix + path.extname(file.originalname));
    }
});

// Initialize upload middleware
const upload = multer({
    storage: storage,
    limits: { fileSize: 10 * 1024 * 1024 }, // 10MB limit
    fileFilter: function (req, file, cb) {
        // Accept CSV and Excel files
        if (file.mimetype === 'text/csv' || 
            file.mimetype === 'application/vnd.ms-excel' ||
            file.mimetype === 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') {
            cb(null, true);
        } else {
            cb(new Error('Only CSV and Excel files are allowed'));
        }
    }
});

// ==================== MIDDLEWARE ====================

// Authentication middleware
const authenticateToken = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1]; // Bearer TOKEN
    
    if (!token) {
        // For demo, if no token, set a dummy user (remove this in production)
        req.user = { userId: 1, username: 'demo', role: 'admin' };
        return next();
        // In production, you might want to return an error:
        // return res.status(401).json({ error: 'Authentication required' });
    }
    
    jwt.verify(token, JWT_SECRET, (err, user) => {
        if (err) {
            return res.status(403).json({ error: 'Invalid or expired token' });
        }
        req.user = user;
        next();
    });
};

// ==================== AUTHENTICATION ENDPOINTS ====================

// Register new user
app.post('/api/auth/register', async (req, res) => {
    try {
        const { username, email, password, full_name } = req.body;
        
        // Validate input
        if (!username || !email || !password) {
            return res.status(400).json({ error: 'Username, email, and password are required' });
        }
        
        // Check if user already exists
        const [existing] = await promisePool.execute(
            'SELECT user_id FROM users WHERE username = ? OR email = ?',
            [username, email]
        );
        
        if (existing.length > 0) {
            return res.status(400).json({ error: 'Username or email already exists' });
        }
        
        // Hash password
        const passwordHash = await bcrypt.hash(password, 10);
        
        // Insert user
        const [result] = await promisePool.execute(
            `INSERT INTO users (username, email, password_hash, full_name, role) 
             VALUES (?, ?, ?, ?, 'user')`,
            [username, email, passwordHash, full_name || null]
        );
        
        // Generate JWT token
        const token = jwt.sign(
            { userId: result.insertId, username, role: 'user' },
            JWT_SECRET,
            { expiresIn: '24h' }
        );
        
        res.status(201).json({
            success: true,
            token,
            user: {
                user_id: result.insertId,
                username,
                email,
                full_name,
                role: 'user'
            }
        });
        
    } catch (error) {
        console.error('Registration error:', error);
        res.status(500).json({ error: 'Server error' });
    }
});

// Login user
app.post('/api/auth/login', async (req, res) => {
    try {
        const { username, password } = req.body;
        
        // Validate input
        if (!username || !password) {
            return res.status(400).json({ error: 'Username and password are required' });
        }
        
        // Find user
        const [users] = await promisePool.execute(
            'SELECT * FROM users WHERE username = ?',
            [username]
        );
        
        if (users.length === 0) {
            return res.status(401).json({ error: 'Invalid credentials' });
        }
        
        const user = users[0];
        
        // Check password
        const validPassword = await bcrypt.compare(password, user.password_hash);
        if (!validPassword) {
            return res.status(401).json({ error: 'Invalid credentials' });
        }
        
        // Generate JWT token
        const token = jwt.sign(
            { userId: user.user_id, username: user.username, role: user.role },
            JWT_SECRET,
            { expiresIn: '24h' }
        );
        
        res.json({
            success: true,
            token,
            user: {
                user_id: user.user_id,
                username: user.username,
                email: user.email,
                full_name: user.full_name,
                role: user.role
            }
        });
        
    } catch (error) {
        console.error('Login error:', error);
        res.status(500).json({ error: 'Server error' });
    }
});

// Get current user profile
app.get('/api/auth/me', authenticateToken, async (req, res) => {
    try {
        const [users] = await promisePool.execute(
            'SELECT user_id, username, email, full_name, role, created_at FROM users WHERE user_id = ?',
            [req.user.userId]
        );
        
        if (users.length === 0) {
            return res.status(404).json({ error: 'User not found' });
        }
        
        res.json(users[0]);
    } catch (error) {
        console.error('Error fetching user:', error);
        res.status(500).json({ error: 'Server error' });
    }
});

// ==================== INSTITUTION ENDPOINTS ====================

// Get all institutions with filters
app.get('/api/institutions', async (req, res) => {
    try {
        const { type, search } = req.query;
        let query = 'SELECT * FROM INSTITUTION WHERE 1=1';
        const params = [];
        
        if (type && type !== '') {
            query += ' AND type = ?';
            params.push(type);
        }
        
        if (search && search !== '') {
            query += ' AND (name LIKE ? OR location LIKE ?)';
            params.push(`%${search}%`, `%${search}%`);
        }
        
        query += ' ORDER BY name';
        
        const [rows] = await promisePool.execute(query, params);
        res.json(rows);
    } catch (error) {
        console.error('Error fetching institutions:', error);
        res.status(500).json({ error: 'Server error' });
    }
});

// Get single institution with all details
app.get('/api/institutions/:id', async (req, res) => {
    try {
        // First get the institution basic info
        const [institution] = await promisePool.execute(
            `SELECT i.* FROM INSTITUTION i WHERE i.institution_id = ?`,
            [req.params.id]
        );
        
        if (institution.length === 0) {
            return res.status(404).json({ error: 'Institution not found' });
        }
        
        // Get department count
        const [deptCount] = await promisePool.execute(
            `SELECT COUNT(DISTINCT d.department_id) as department_count
             FROM INSTITUTION i
             LEFT JOIN DEPARTMENT d ON i.institution_id = d.institution_id
             WHERE i.institution_id = ?`,
            [req.params.id]
        );
        
        // Get researcher count
        const [researcherCount] = await promisePool.execute(
            `SELECT COUNT(DISTINCT e.researcher_id) as researcher_count
             FROM INSTITUTION i
             LEFT JOIN DEPARTMENT d ON i.institution_id = d.institution_id
             LEFT JOIN EMPLOYMENT e ON d.department_id = e.department_id
             WHERE i.institution_id = ? AND (e.end_date IS NULL OR e.end_date > CURDATE())`,
            [req.params.id]
        );
        
        // Get departments list
        const [departments] = await promisePool.execute(
            `SELECT GROUP_CONCAT(DISTINCT d.name SEPARATOR ', ') as departments
             FROM INSTITUTION i
             LEFT JOIN DEPARTMENT d ON i.institution_id = d.institution_id
             WHERE i.institution_id = ?`,
            [req.params.id]
        );
        
        // Get project count
        const [projectCount] = await promisePool.execute(
            `SELECT COUNT(DISTINCT rp.project_id) as project_count
             FROM INSTITUTION i
             LEFT JOIN DEPARTMENT d ON i.institution_id = d.institution_id
             LEFT JOIN RESEARCH_PROJECT rp ON d.department_id = rp.department_id
             WHERE i.institution_id = ?`,
            [req.params.id]
        );
        
        // Get paper count
        const [paperCount] = await promisePool.execute(
            `SELECT COUNT(DISTINCT ro.output_id) as paper_count
             FROM INSTITUTION i
             LEFT JOIN DEPARTMENT d ON i.institution_id = d.institution_id
             LEFT JOIN RESEARCH_PROJECT rp ON d.department_id = rp.department_id
             LEFT JOIN PROJECT_OUTPUT po ON rp.project_id = po.project_id
             LEFT JOIN RESEARCH_OUTPUT ro ON po.output_id = ro.output_id
             LEFT JOIN PAPER p ON ro.output_id = p.paper_id
             WHERE i.institution_id = ? AND p.paper_id IS NOT NULL`,
            [req.params.id]
        );
        
        const result = institution[0];
        result.department_count = deptCount[0]?.department_count || 0;
        result.researcher_count = researcherCount[0]?.researcher_count || 0;
        result.departments = departments[0]?.departments || 'No departments';
        result.project_count = projectCount[0]?.project_count || 0;
        result.paper_count = paperCount[0]?.paper_count || 0;
        
        res.json(result);
    } catch (error) {
        console.error('Error fetching institution:', error);
        res.status(500).json({ error: 'Server error' });
    }
});

// ==================== INSTITUTION CRUD OPERATIONS ====================

// Update the POST /api/institutions endpoint to remove department_code
app.post('/api/institutions', async (req, res) => {
    let connection;
    
    try {
        connection = await promisePool.getConnection();
        await connection.beginTransaction();
        
        const { name, location, type, established_date, website_url, departments } = req.body;
        
        // Validate required fields
        if (!name || !location || !type) {
            return res.status(400).json({ 
                error: 'Name, location, and type are required fields' 
            });
        }
        
        // Insert institution
        const [result] = await connection.execute(
            `INSERT INTO INSTITUTION (name, location, type, established_date, website_url) 
             VALUES (?, ?, ?, ?, ?)`,
            [
                name, 
                location, 
                type, 
                established_date || null, 
                website_url || null
            ]
        );
        
        const institutionId = result.insertId;
        
        // Add departments if provided
        if (departments && Array.isArray(departments)) {
            for (const dept of departments) {
                if (dept.name && dept.name.trim() !== '') {
                    // Check what columns actually exist in your table
                    // If department_code doesn't exist, only insert name
                    await connection.execute(
                        `INSERT INTO DEPARTMENT (institution_id, name) 
                         VALUES (?, ?)`,
                        [institutionId, dept.name.trim()]
                    );
                }
            }
        }
        
        await connection.commit();
        
        res.status(201).json({ 
            success: true, 
            institution_id: institutionId,
            message: 'Institution created successfully' + 
                    (departments && departments.length > 0 ? ` with ${departments.length} departments` : '')
        });
        
    } catch (error) {
        if (connection) await connection.rollback();
        console.error('Error creating institution:', error);
        res.status(500).json({ error: 'Server error: ' + error.message });
    } finally {
        if (connection) connection.release();
    }
});
// Update the PUT /api/institutions/:id endpoint for better department handling
app.put('/api/institutions/:id', async (req, res) => {
    let connection;
    
    try {
        connection = await promisePool.getConnection();
        await connection.beginTransaction();
        
        const { name, location, type, established_date, website_url, departments } = req.body;
        
        // Check if institution exists
        const [existing] = await connection.execute(
            'SELECT institution_id FROM INSTITUTION WHERE institution_id = ?',
            [req.params.id]
        );
        
        if (existing.length === 0) {
            await connection.rollback();
            return res.status(404).json({ error: 'Institution not found' });
        }
        
        // Update institution
        await connection.execute(
            `UPDATE INSTITUTION 
             SET name = ?, location = ?, type = ?, established_date = ?, 
                 website_url = ?
             WHERE institution_id = ?`,
            [
                name, 
                location, 
                type, 
                established_date || null, 
                website_url || null,
                req.params.id
            ]
        );
        
        // Update the department handling section in PUT endpoint
if (departments && Array.isArray(departments)) {
    // Get existing departments
    const [existingDepartments] = await connection.execute(
        'SELECT department_id, name FROM DEPARTMENT WHERE institution_id = ?',
        [req.params.id]
    );
    
    // If departments array is empty, we might want to delete all departments
    // Or keep existing ones. Let's ask what should happen:
    if (departments.length === 0) {
        // Option 1: Delete all departments if array is empty
        // await connection.execute('DELETE FROM DEPARTMENT WHERE institution_id = ?', [req.params.id]);
        
        // Option 2: Keep existing departments (do nothing)
        console.log('No departments provided in update, keeping existing departments');
    } else {
        // Process departments as before
        const existingDeptMap = new Map();
        existingDepartments.forEach(dept => {
            existingDeptMap.set(dept.department_id, dept.name);
        });
        
        const departmentsToKeep = new Set();
        
        for (const dept of departments) {
            if (dept.name && dept.name.trim() !== '') {
                // If department_id is provided and exists, update it
                if (dept.department_id && existingDeptMap.has(parseInt(dept.department_id))) {
                    await connection.execute(
                        `UPDATE DEPARTMENT 
                         SET name = ?, department_code = ?
                         WHERE department_id = ?`,
                        [dept.name.trim(), dept.code || null, dept.department_id]
                    );
                    departmentsToKeep.add(parseInt(dept.department_id));
                } else {
                    // Insert new department
                    const [newDept] = await connection.execute(
                        `INSERT INTO DEPARTMENT (institution_id, name, department_code) 
                         VALUES (?, ?, ?)`,
                        [req.params.id, dept.name.trim(), dept.code || null]
                    );
                    departmentsToKeep.add(newDept.insertId);
                }
            }
        }
        
        // Delete departments that are no longer in the list
        for (const existingDept of existingDepartments) {
            if (!departmentsToKeep.has(existingDept.department_id)) {
                // Check for dependencies before deleting
                const [hasDependencies] = await connection.execute(
                    `SELECT EXISTS(
                        SELECT 1 FROM EMPLOYMENT WHERE department_id = ?
                        UNION ALL
                        SELECT 1 FROM RESEARCH_PROJECT WHERE department_id = ?
                    ) as has_deps`,
                    [existingDept.department_id, existingDept.department_id]
                );
                
                if (hasDependencies[0].has_deps === 0) {
                    await connection.execute(
                        'DELETE FROM DEPARTMENT WHERE department_id = ?',
                        [existingDept.department_id]
                    );
                } else {
                    console.warn(`Department ${existingDept.department_id} (${existingDept.name}) has dependencies and cannot be deleted`);
                }
            }
        }
    }
}
        await connection.commit();
        
        res.json({ 
            success: true, 
            message: 'Institution updated successfully' 
        });
        
    } catch (error) {
        if (connection) await connection.rollback();
        console.error('Error updating institution:', error);
        res.status(500).json({ error: 'Server error: ' + error.message });
    } finally {
        if (connection) connection.release();
    }
});
// Update institution delete endpoint to handle ALL constraints
app.delete('/api/institutions/:id', async (req, res) => {
    let connection;
    
    try {
        connection = await promisePool.getConnection();
        await connection.beginTransaction();
        
        // Check if institution exists
        const [existing] = await connection.execute(
            'SELECT institution_id FROM INSTITUTION WHERE institution_id = ?',
            [req.params.id]
        );
        
        if (existing.length === 0) {
            await connection.rollback();
            return res.status(404).json({ error: 'Institution not found' });
        }
        
        // Get all departments in this institution
        const [departments] = await connection.execute(
            'SELECT department_id FROM DEPARTMENT WHERE institution_id = ?',
            [req.params.id]
        );
        
        // Delete each department's dependencies in the correct order
        for (const dept of departments) {
            // Get projects in this department
            const [projects] = await connection.execute(
                'SELECT project_id FROM RESEARCH_PROJECT WHERE department_id = ?',
                [dept.department_id]
            );
            
            // For each project, delete its dependencies
            for (const project of projects) {
                // Delete project_grants
                await connection.execute(
                    'DELETE FROM PROJECT_GRANT WHERE project_id = ?',
                    [project.project_id]
                );
                
                // Delete project_members
                await connection.execute(
                    'DELETE FROM PROJECT_MEMBER WHERE project_id = ?',
                    [project.project_id]
                );
                
                // Delete project_outputs
                await connection.execute(
                    'DELETE FROM PROJECT_OUTPUT WHERE project_id = ?',
                    [project.project_id]
                );
                
                // Delete the project
                await connection.execute(
                    'DELETE FROM RESEARCH_PROJECT WHERE project_id = ?',
                    [project.project_id]
                );
            }
            
            // Delete employment records for this department
            await connection.execute(
                'DELETE FROM EMPLOYMENT WHERE department_id = ?',
                [dept.department_id]
            );
            
            // Delete the department
            await connection.execute(
                'DELETE FROM DEPARTMENT WHERE department_id = ?',
                [dept.department_id]
            );
        }
        
        // Delete institution
        await connection.execute(
            'DELETE FROM INSTITUTION WHERE institution_id = ?',
            [req.params.id]
        );
        
        await connection.commit();
        
        res.json({ 
            success: true, 
            message: `Institution deleted successfully (${departments.length} departments and all related data removed)` 
        });
        
    } catch (error) {
        if (connection) await connection.rollback();
        console.error('Error deleting institution:', error);
        res.status(500).json({ error: 'Server error: ' + error.message });
    } finally {
        if (connection) connection.release();
    }
});
app.get('/api/debug/department-structure', async (req, res) => {
    try {
        const [columns] = await promisePool.execute('DESCRIBE DEPARTMENT');
        res.json({
            table: 'DEPARTMENT',
            columns: columns
        });
    } catch (error) {
        console.error('Error fetching DEPARTMENT structure:', error.message);
        res.status(500).json({ 
            error: error.message,
            sqlState: error.sqlState,
            code: error.code 
        });
    }
});
// Add this endpoint to check if a department can be deleted
app.get('/api/departments/:id/dependencies', async (req, res) => {
    try {
        const [employmentCount] = await promisePool.execute(
            'SELECT COUNT(*) as count FROM EMPLOYMENT WHERE department_id = ?',
            [req.params.id]
        );
        
        const [projectCount] = await promisePool.execute(
            'SELECT COUNT(*) as count FROM RESEARCH_PROJECT WHERE department_id = ?',
            [req.params.id]
        );
        
        res.json({
            department_id: req.params.id,
            employment_count: employmentCount[0].count,
            project_count: projectCount[0].count,
            can_delete: (employmentCount[0].count + projectCount[0].count) === 0
        });
    } catch (error) {
        console.error('Error checking department dependencies:', error);
        res.status(500).json({ error: 'Server error' });
    }
});
// ==================== RESEARCHER ENDPOINTS ====================

// Get all researchers
app.get('/api/researchers', async (req, res) => {
    try {
        const [rows] = await promisePool.execute(
            `SELECT r.*, 
                    i.name as institution_name,
                    d.name as department_name
             FROM RESEARCHER r
             LEFT JOIN EMPLOYMENT e ON r.researcher_id = e.researcher_id 
                 AND (e.end_date IS NULL OR e.end_date > CURDATE())
             LEFT JOIN DEPARTMENT d ON e.department_id = d.department_id
             LEFT JOIN INSTITUTION i ON d.institution_id = i.institution_id
             ORDER BY r.full_name`
        );
        res.json(rows);
    } catch (error) {
        console.error('Error fetching researchers:', error);
        res.status(500).json({ error: 'Server error' });
    }
});

// Get researcher with details
app.get('/api/researchers/:id', async (req, res) => {
    try {
        // Get basic researcher info
        const [researcher] = await promisePool.execute(
            `SELECT r.*
             FROM RESEARCHER r
             WHERE r.researcher_id = ?`,
            [req.params.id]
        );
        
        if (researcher.length === 0) {
            return res.status(404).json({ error: 'Researcher not found' });
        }
        
        // Get current institution and department
        const [currentEmployment] = await promisePool.execute(
            `SELECT i.name as current_institution, d.name as current_department
             FROM RESEARCHER r
             LEFT JOIN EMPLOYMENT e ON r.researcher_id = e.researcher_id 
                 AND (e.end_date IS NULL OR e.end_date > CURDATE())
             LEFT JOIN DEPARTMENT d ON e.department_id = d.department_id
             LEFT JOIN INSTITUTION i ON d.institution_id = i.institution_id
             WHERE r.researcher_id = ?
             LIMIT 1`,
            [req.params.id]
        );
        
        // Get publication count
        const [publicationCount] = await promisePool.execute(
            `SELECT COUNT(DISTINCT c.paper_id) as publication_count
             FROM COLLABORATION c
             WHERE c.researcher_id = ?`,
            [req.params.id]
        );
        
        // Get project count
        const [projectCount] = await promisePool.execute(
            `SELECT COUNT(DISTINCT pm.project_id) as project_count
             FROM PROJECT_MEMBER pm
             WHERE pm.researcher_id = ?`,
            [req.params.id]
        );
        
        // Get citation count
        const [citationCount] = await promisePool.execute(
            `SELECT COUNT(DISTINCT cit.citation_id) as citation_count
             FROM COLLABORATION c
             LEFT JOIN CITATION cit ON c.paper_id = cit.cited_output_id
             WHERE c.researcher_id = ?`,
            [req.params.id]
        );
        
        // Get research areas
        const [researchAreas] = await promisePool.execute(
            `SELECT ra.area_name
             FROM RESEARCH_AREA_MAPPING ram
             JOIN RESEARCH_AREA ra ON ram.research_area_id = ra.research_area_id
             WHERE ram.researcher_id = ?`,
            [req.params.id]
        );
        
        // Get H-index (simplified calculation)
        const [hIndex] = await promisePool.execute(
            `SELECT COUNT(*) as h_index
             FROM (
                 SELECT p.paper_id, COUNT(c.citation_id) as citations
                 FROM COLLABORATION col
                 JOIN PAPER p ON col.paper_id = p.paper_id
                 LEFT JOIN CITATION c ON p.paper_id = c.cited_output_id
                 WHERE col.researcher_id = ?
                 GROUP BY p.paper_id
                 HAVING citations > 0
             ) as paper_citations
             WHERE paper_citations.citations >= (
                 SELECT COUNT(*)
                 FROM (
                     SELECT p2.paper_id, COUNT(c2.citation_id) as citations2
                     FROM COLLABORATION col2
                     JOIN PAPER p2 ON col2.paper_id = p2.paper_id
                     LEFT JOIN CITATION c2 ON p2.paper_id = c2.cited_output_id
                     WHERE col2.researcher_id = ?
                     GROUP BY p2.paper_id
                     HAVING citations2 > 0
                 ) as pc2
                 WHERE pc2.citations2 >= paper_citations.citations
             )`,
            [req.params.id, req.params.id]
        );
        
        const result = researcher[0];
        result.current_institution = currentEmployment[0]?.current_institution || 'Unknown';
        result.current_department = currentEmployment[0]?.current_department || 'Unknown';
        result.publication_count = publicationCount[0]?.publication_count || 0;
        result.project_count = projectCount[0]?.project_count || 0;
        result.citation_count = citationCount[0]?.citation_count || 0;
        result.research_areas = researchAreas.map(ra => ra.area_name).join(', ') || 'No research areas';
        result.h_index = hIndex[0]?.h_index || 0;
        
        res.json(result);
    } catch (error) {
        console.error('Error fetching researcher:', error);
        res.status(500).json({ error: 'Server error' });
    }
});

// Advanced researcher search with multiple criteria
app.get('/api/researchers/advanced-search', async (req, res) => {
    const { institution_id, research_area, min_citations, min_h_index } = req.query;
    
    let query = `
        SELECT r.*, 
               i.name as institution_name,
               COUNT(DISTINCT col.paper_id) as publication_count,
               COUNT(DISTINCT cit.citation_id) as citation_count
        FROM RESEARCHER r
        LEFT JOIN EMPLOYMENT e ON r.researcher_id = e.researcher_id
        LEFT JOIN DEPARTMENT d ON e.department_id = d.department_id
        LEFT JOIN INSTITUTION i ON d.institution_id = i.institution_id
        LEFT JOIN COLLABORATION col ON r.researcher_id = col.researcher_id
        LEFT JOIN CITATION cit ON col.paper_id = cit.cited_output_id
        WHERE 1=1
    `;
    
    const params = [];
    
    if (institution_id) {
        query += ' AND i.institution_id = ?';
        params.push(institution_id);
    }
    
    if (research_area) {
        query += ` AND r.researcher_id IN (
            SELECT researcher_id FROM RESEARCH_AREA_MAPPING ram
            JOIN RESEARCH_AREA ra ON ram.research_area_id = ra.research_area_id
            WHERE ra.area_name LIKE ?
        )`;
        params.push(`%${research_area}%`);
    }
    
    query += ' GROUP BY r.researcher_id HAVING 1=1';
    
    if (min_citations) {
        query += ' AND citation_count >= ?';
        params.push(min_citations);
    }
    
    const [results] = await promisePool.execute(query, params);
    res.json(results);
});

// ==================== RESEARCHER CRUD OPERATIONS ====================

// Add new researcher
app.post('/api/researchers', async (req, res) => {
    const connection = await promisePool.getConnection();
    
    try {
        await connection.beginTransaction();
        
        const { full_name, email, academic_rank, orcid_id, google_scholar_id, 
                institution_id, department_id, research_areas } = req.body;
        
        // Validate required fields
        if (!full_name || !email) {
            return res.status(400).json({ 
                error: 'Full name and email are required fields' 
            });
        }
        
        // FIXED: Use profile_url instead of google_scholar_id
        const [researcherResult] = await connection.execute(
            `INSERT INTO RESEARCHER (full_name, email, academic_rank, orcid_id, profile_url) 
             VALUES (?, ?, ?, ?, ?)`,
            [
                full_name, 
                email, 
                academic_rank || null, 
                orcid_id || null, 
                google_scholar_id || null  // Store in profile_url instead
            ]
        );
        
        const researcherId = researcherResult.insertId;
        
        // Create employment if institution and department provided
        if (institution_id && department_id) {
            await connection.execute(
                `INSERT INTO EMPLOYMENT (researcher_id, department_id, start_date, employment_type) 
                 VALUES (?, ?, CURDATE(), 'Full-time')`,
                [researcherId, department_id]
            );
        }
        
        // Add research areas if provided
        if (research_areas && research_areas.trim()) {
            const areas = research_areas.split(',').map(area => area.trim());
            
            for (const area of areas) {
                if (area) {
                    // Check if area exists
                    const [existingArea] = await connection.execute(
                        `SELECT research_area_id FROM RESEARCH_AREA WHERE area_name = ?`,
                        [area]
                    );
                    
                    let areaId;
                    if (existingArea.length > 0) {
                        areaId = existingArea[0].research_area_id;
                    } else {
                        const [areaResult] = await connection.execute(
                            `INSERT INTO RESEARCH_AREA (area_name) VALUES (?)`,
                            [area]
                        );
                        areaId = areaResult.insertId;
                    }
                    
                    // Link researcher to research area
                    await connection.execute(
                        `INSERT INTO RESEARCH_AREA_MAPPING (researcher_id, research_area_id) 
                         VALUES (?, ?)`,
                        [researcherId, areaId]
                    );
                }
            }
        }
        
        await connection.commit();
        
        res.status(201).json({ 
            success: true, 
            researcher_id: researcherId,
            message: 'Researcher created successfully' 
        });
        
    } catch (error) {
        await connection.rollback();
        console.error('Error creating researcher:', error);
        res.status(500).json({ error: 'Server error' });
    } finally {
        connection.release();
    }
});

// Update researcher
app.put('/api/researchers/:id', async (req, res) => {
    const connection = await promisePool.getConnection();
    
    try {
        await connection.beginTransaction();
        
        const { full_name, email, academic_rank, orcid_id, google_scholar_id, 
                institution_id, department_id, research_areas } = req.body;
        
        // Check if researcher exists
        const [existing] = await connection.execute(
            'SELECT researcher_id FROM RESEARCHER WHERE researcher_id = ?',
            [req.params.id]
        );
        
        if (existing.length === 0) {
            return res.status(404).json({ error: 'Researcher not found' });
        }
        
        // FIXED: Update profile_url instead of google_scholar_id
        const [result] = await connection.execute(
            `UPDATE RESEARCHER 
             SET full_name = ?, email = ?, academic_rank = ?, 
                 orcid_id = ?, profile_url = ?
             WHERE researcher_id = ?`,
            [
                full_name, 
                email, 
                academic_rank || null, 
                orcid_id || null, 
                google_scholar_id || null,  // Store in profile_url instead
                req.params.id
            ]
        );
        
        // Update employment if institution/department provided
        if (institution_id && department_id) {
            // Delete existing employment
            await connection.execute(
                'DELETE FROM EMPLOYMENT WHERE researcher_id = ?',
                [req.params.id]
            );
            
            // Add new employment
            await connection.execute(
                `INSERT INTO EMPLOYMENT (researcher_id, department_id, start_date, employment_type) 
                 VALUES (?, ?, CURDATE(), 'Full-time')`,
                [req.params.id, department_id]
            );
        }
        
        // Update research areas if provided
        if (research_areas) {
            // Delete existing research areas
            await connection.execute(
                'DELETE FROM RESEARCH_AREA_MAPPING WHERE researcher_id = ?',
                [req.params.id]
            );
            
            const areas = research_areas.split(',').map(area => area.trim());
            
            for (const area of areas) {
                if (area) {
                    // Check if area exists
                    const [existingArea] = await connection.execute(
                        `SELECT research_area_id FROM RESEARCH_AREA WHERE area_name = ?`,
                        [area]
                    );
                    
                    let areaId;
                    if (existingArea.length > 0) {
                        areaId = existingArea[0].research_area_id;
                    } else {
                        const [areaResult] = await connection.execute(
                            `INSERT INTO RESEARCH_AREA (area_name) VALUES (?)`,
                            [area]
                        );
                        areaId = areaResult.insertId;
                    }
                    
                    // Link researcher to research area
                    await connection.execute(
                        `INSERT INTO RESEARCH_AREA_MAPPING (researcher_id, research_area_id) 
                         VALUES (?, ?)`,
                        [req.params.id, areaId]
                    );
                }
            }
        }
        
        await connection.commit();
        
        res.json({ 
            success: true, 
            message: 'Researcher updated successfully' 
        });
        
    } catch (error) {
        await connection.rollback();
        console.error('Error updating researcher:', error);
        res.status(500).json({ error: 'Server error' });
    } finally {
        connection.release();
    }
});

// Update researcher delete endpoint to handle ALL constraints
app.delete('/api/researchers/:id', async (req, res) => {
    let connection;
    
    try {
        connection = await promisePool.getConnection();
        await connection.beginTransaction();
        
        // Check if researcher exists
        const [existing] = await connection.execute(
            'SELECT researcher_id FROM RESEARCHER WHERE researcher_id = ?',
            [req.params.id]
        );
        
        if (existing.length === 0) {
            await connection.rollback();
            return res.status(404).json({ error: 'Researcher not found' });
        }
        
        // Delete ALL dependent records in the correct order:
        
        // 1. Delete from peer_review (as reviewer)
        await connection.execute(
            'DELETE FROM PEER_REVIEW WHERE reviewer_id = ?',
            [req.params.id]
        );
        
        // 2. Remove researcher from collaborations
        await connection.execute(
            'DELETE FROM COLLABORATION WHERE researcher_id = ?',
            [req.params.id]
        );
        
        // 3. Remove researcher from project memberships
        await connection.execute(
            'DELETE FROM PROJECT_MEMBER WHERE researcher_id = ?',
            [req.params.id]
        );
        
        // 4. Delete research areas mapping
        await connection.execute(
            'DELETE FROM RESEARCH_AREA_MAPPING WHERE researcher_id = ?',
            [req.params.id]
        );
        
        // 5. Delete employment records
        await connection.execute(
            'DELETE FROM EMPLOYMENT WHERE researcher_id = ?',
            [req.params.id]
        );
        
        // 6. Delete researcher
        const [result] = await connection.execute(
            `DELETE FROM RESEARCHER WHERE researcher_id = ?`,
            [req.params.id]
        );
        
        await connection.commit();
        
        res.json({ 
            success: true, 
            message: 'Researcher deleted successfully (all related data removed)' 
        });
        
    } catch (error) {
        if (connection) await connection.rollback();
        console.error('Error deleting researcher:', error);
        res.status(500).json({ error: 'Server error: ' + error.message });
    } finally {
        if (connection) connection.release();
    }
});

// ==================== PROJECT ENDPOINTS ====================

// Get all projects
app.get('/api/projects', async (req, res) => {
    try {
        // First get projects with basic info
        const [projects] = await promisePool.execute(
            `SELECT rp.*, 
                    d.name as department_name,
                    i.name as institution_name
             FROM RESEARCH_PROJECT rp
             LEFT JOIN DEPARTMENT d ON rp.department_id = d.department_id
             LEFT JOIN INSTITUTION i ON d.institution_id = i.institution_id
             ORDER BY rp.start_date DESC`
        );
        
        // For each project, get team size and outputs count
        const projectsWithDetails = await Promise.all(projects.map(async (project) => {
            const [teamSize] = await promisePool.execute(
                `SELECT COUNT(DISTINCT pm.researcher_id) as team_size
                 FROM PROJECT_MEMBER pm
                 WHERE pm.project_id = ?`,
                [project.project_id]
            );
            
            const [outputsCount] = await promisePool.execute(
                `SELECT COUNT(DISTINCT po.output_id) as outputs_count
                 FROM PROJECT_OUTPUT po
                 WHERE po.project_id = ?`,
                [project.project_id]
            );
            
            const [teamMembers] = await promisePool.execute(
                `SELECT GROUP_CONCAT(DISTINCT r.full_name SEPARATOR ', ') as team_members
                 FROM PROJECT_MEMBER pm
                 JOIN RESEARCHER r ON pm.researcher_id = r.researcher_id
                 WHERE pm.project_id = ?
                 LIMIT 3`,
                [project.project_id]
            );
            
            return {
                ...project,
                team_size: teamSize[0]?.team_size || 0,
                outputs_count: outputsCount[0]?.outputs_count || 0,
                team_members: teamMembers[0]?.team_members || 'No team members'
            };
        }));
        
        res.json(projectsWithDetails);
    } catch (error) {
        console.error('Error fetching projects:', error);
        res.status(500).json({ error: 'Server error' });
    }
});

// Get single project with full details
app.get('/api/projects/:id', async (req, res) => {
    try {
        // Get project basic info
        const [project] = await promisePool.execute(
            `SELECT rp.*, 
                    d.name as department_name,
                    i.name as institution_name
             FROM RESEARCH_PROJECT rp
             LEFT JOIN DEPARTMENT d ON rp.department_id = d.department_id
             LEFT JOIN INSTITUTION i ON d.institution_id = i.institution_id
             WHERE rp.project_id = ?`,
            [req.params.id]
        );
        
        if (project.length === 0) {
            return res.status(404).json({ error: 'Project not found' });
        }
        
        // Get team members
        const [teamMembers] = await promisePool.execute(
            `SELECT r.researcher_id, r.full_name, pm.role_in_project
             FROM PROJECT_MEMBER pm
             JOIN RESEARCHER r ON pm.researcher_id = r.researcher_id
             WHERE pm.project_id = ?
             ORDER BY pm.role_in_project`,
            [req.params.id]
        );
        
        // Get outputs
        const [outputs] = await promisePool.execute(
            `SELECT ro.output_id, ro.title, ro.description
             FROM PROJECT_OUTPUT po
             JOIN RESEARCH_OUTPUT ro ON po.output_id = ro.output_id
             WHERE po.project_id = ?`,
            [req.params.id]
        );
        
        // Get grants
        const [grants] = await promisePool.execute(
            `SELECT g.grant_id, g.grant_title, g.funding_agency, 
                    pg.allocation_amount, g.start_date, g.end_date
             FROM PROJECT_GRANT pg
             JOIN \`GRANT\` g ON pg.grant_id = g.grant_id
             WHERE pg.project_id = ?`,
            [req.params.id]
        );
        
        const result = project[0];
        result.team_members = teamMembers;
        result.outputs = outputs;
        result.grants = grants;
        
        // Calculate total funding amount
        result.funding_amount = grants.reduce((sum, grant) => sum + (grant.allocation_amount || 0), 0);
        
        res.json(result);
    } catch (error) {
        console.error('Error fetching project details:', error);
        res.status(500).json({ error: 'Server error' });
    }
});

// ==================== IMPORT/EXPORT ENDPOINTS ====================

// Import data from CSV/Excel
app.post('/api/import/:entity', upload.single('file'), async (req, res) => {
    try {
        const entity = req.params.entity;
        const filePath = req.file.path;
        
        // This is a simplified version - in production, you'd parse the file
        // and import data into the appropriate table
        if (!req.file) {
            return res.status(400).json({ error: 'No file uploaded' });
        }
        
        // TODO: Implement proper CSV/Excel parsing and import logic
        // For now, just return a success message
        res.json({
            success: true,
            message: `Import for ${entity} received. File saved at: ${filePath}`,
            entity: entity,
            file: req.file
        });
    } catch (error) {
        console.error('Import error:', error);
        res.status(500).json({ error: 'Import failed' });
    }
});

// Export data to CSV
app.get('/api/export/:entity', async (req, res) => {
    try {
        const entity = req.params.entity;
        const format = req.query.format || 'csv';
        
        // Basic table mapping
        const tableMap = {
            'institutions': 'INSTITUTION',
            'researchers': 'RESEARCHER',
            'projects': 'RESEARCH_PROJECT',
            'papers': 'PAPER',
            'grants': 'GRANT'
        };
        
        const tableName = tableMap[entity];
        if (!tableName) {
            return res.status(400).json({ error: 'Invalid entity type' });
        }
        
        // Fetch data
        const [rows] = await promisePool.execute(`SELECT * FROM ${tableName}`);
        
        if (format === 'json') {
            res.json(rows);
        } else {
            // Convert to CSV
            const headers = Object.keys(rows[0] || {}).join(',');
            const csvRows = rows.map(row => 
                Object.values(row).map(val => 
                    `"${(val || '').toString().replace(/"/g, '""')}"`
                ).join(',')
            );
            
            const csv = [headers, ...csvRows].join('\n');
            
            res.header('Content-Type', 'text/csv');
            res.attachment(`${entity}-export-${Date.now()}.csv`);
            res.send(csv);
        }
    } catch (error) {
        console.error('Export error:', error);
        res.status(500).json({ error: 'Export failed' });
    }
});

// ==================== PROJECT CRUD OPERATIONS ====================

// Update project POST endpoint
app.post('/api/projects', async (req, res) => {
    let connection;
    
    try {
        connection = await promisePool.getConnection();
        await connection.beginTransaction();
        
        const { project_title, description, start_date, end_date, 
                project_status, department_id, team_members } = req.body;
        
        // Validate required fields including department_id
        if (!project_title || !start_date || !project_status || !department_id) {
            await connection.rollback();
            return res.status(400).json({ 
                error: 'Project title, start date, status, and department are required fields' 
            });
        }
        
        // Validate department_id
        const deptId = parseInt(department_id);
        if (isNaN(deptId) || deptId <= 0) {
            await connection.rollback();
            return res.status(400).json({ error: 'Invalid department ID' });
        }
        
        // Verify department exists
        const [deptCheck] = await connection.execute(
            'SELECT department_id FROM DEPARTMENT WHERE department_id = ?',
            [deptId]
        );
        
        if (deptCheck.length === 0) {
            await connection.rollback();
            return res.status(400).json({ error: 'Department does not exist' });
        }
        
        // Insert project
        const [projectResult] = await connection.execute(
            `INSERT INTO RESEARCH_PROJECT 
             (project_title, description, start_date, end_date, project_status, department_id) 
             VALUES (?, ?, ?, ?, ?, ?)`,
            [
                project_title, 
                description || null, 
                start_date, 
                end_date || null, 
                project_status, 
                deptId
            ]
        );
        
        const projectId = projectResult.insertId;
        
        // Add team members if provided
        if (team_members && Array.isArray(team_members)) {
            for (const memberId of team_members) {
                if (memberId) {
                    await connection.execute(
                        `INSERT INTO PROJECT_MEMBER (project_id, researcher_id, role_in_project) 
                         VALUES (?, ?, 'Team Member')`,
                        [projectId, memberId]
                    );
                }
            }
        }
        
        await connection.commit();
        
        res.status(201).json({ 
            success: true, 
            project_id: projectId,
            message: 'Project created successfully' 
        });
        
    } catch (error) {
        if (connection) await connection.rollback();
        console.error('Error creating project:', error);
        res.status(500).json({ error: 'Server error: ' + error.message });
    } finally {
        if (connection) connection.release();
    }
});
// Update project PUT endpoint - handle department_id constraint
// Update project PUT endpoint to handle non-nullable department_id
app.put('/api/projects/:id', async (req, res) => {
    let connection;
    
    try {
        connection = await promisePool.getConnection();
        await connection.beginTransaction();
        
        const { project_title, description, start_date, end_date, 
                project_status, department_id, team_members } = req.body;
        
        // Check if project exists and get current department_id
        const [existing] = await connection.execute(
            'SELECT project_id, department_id FROM RESEARCH_PROJECT WHERE project_id = ?',
            [req.params.id]
        );
        
        if (existing.length === 0) {
            await connection.rollback();
            return res.status(404).json({ error: 'Project not found' });
        }
        
        // Handle department_id - it CANNOT be null
        let deptId;
        
        // First priority: Use provided department_id
        if (department_id && department_id !== '') {
            deptId = parseInt(department_id);
        }
        // Second priority: Use existing department_id
        else if (existing[0].department_id) {
            deptId = existing[0].department_id;
        }
        // Last resort: Find any department
        else {
            const [departments] = await connection.execute(
                'SELECT department_id FROM DEPARTMENT LIMIT 1'
            );
            if (departments.length > 0) {
                deptId = departments[0].department_id;
            } else {
                await connection.rollback();
                return res.status(400).json({ 
                    error: 'No departments exist. Please create a department first.' 
                });
            }
        }
        
        // Validate department_id is a valid integer
        if (!deptId || isNaN(deptId) || deptId <= 0) {
            await connection.rollback();
            return res.status(400).json({ error: 'Invalid department ID. Project must belong to a department.' });
        }
        
        // Verify the department exists
        const [deptCheck] = await connection.execute(
            'SELECT department_id FROM DEPARTMENT WHERE department_id = ?',
            [deptId]
        );
        
        if (deptCheck.length === 0) {
            await connection.rollback();
            return res.status(400).json({ error: 'Department does not exist. Please select a valid department.' });
        }
        
        // Update project
        await connection.execute(
            `UPDATE RESEARCH_PROJECT 
             SET project_title = ?, description = ?, start_date = ?, 
                 end_date = ?, project_status = ?, department_id = ?
             WHERE project_id = ?`,
            [
                project_title || '', 
                description || null, 
                start_date || null, 
                end_date || null, 
                project_status || 'Active', 
                deptId,
                req.params.id
            ]
        );
        
        // Update team members if provided
        if (team_members && Array.isArray(team_members)) {
            // First delete existing team members
            await connection.execute(
                'DELETE FROM PROJECT_MEMBER WHERE project_id = ?',
                [req.params.id]
            );
            
            // Add new team members
            for (const memberId of team_members) {
                if (memberId) {
                    await connection.execute(
                        `INSERT INTO PROJECT_MEMBER (project_id, researcher_id, role_in_project) 
                         VALUES (?, ?, 'Team Member')`,
                        [req.params.id, memberId]
                    );
                }
            }
        }
        
        await connection.commit();
        
        res.json({ 
            success: true, 
            message: 'Project updated successfully' 
        });
        
    } catch (error) {
        if (connection) await connection.rollback();
        console.error('Error updating project:', error);
        res.status(500).json({ error: 'Server error: ' + error.message });
    } finally {
        if (connection) connection.release();
    }
});
// Update the project delete endpoint in server.js:
app.delete('/api/projects/:id', async (req, res) => {
    const connection = await promisePool.getConnection();
    
    try {
        await connection.beginTransaction();
        
        // Check if project exists
        const [existing] = await connection.execute(
            'SELECT project_id FROM RESEARCH_PROJECT WHERE project_id = ?',
            [req.params.id]
        );
        
        if (existing.length === 0) {
            return res.status(404).json({ error: 'Project not found' });
        }
        
        // Remove the restriction for outputs
        // Just remove or comment out this check:
        /*
        const [outputs] = await connection.execute(
            'SELECT COUNT(*) as output_count FROM PROJECT_OUTPUT WHERE project_id = ?',
            [req.params.id]
        );
        
        if (outputs[0].output_count > 0) {
            return res.status(400).json({ 
                error: 'Cannot delete project with associated outputs' 
            });
        }
        */
        
        // Delete project outputs associations first
        await connection.execute(
            'DELETE FROM PROJECT_OUTPUT WHERE project_id = ?',
            [req.params.id]
        );
        
        // Delete project members
        await connection.execute(
            'DELETE FROM PROJECT_MEMBER WHERE project_id = ?',
            [req.params.id]
        );
        
        // Delete project grants
        await connection.execute(
            'DELETE FROM PROJECT_GRANT WHERE project_id = ?',
            [req.params.id]
        );
        
        // Delete project
        const [result] = await connection.execute(
            `DELETE FROM RESEARCH_PROJECT WHERE project_id = ?`,
            [req.params.id]
        );
        
        await connection.commit();
        
        res.json({ 
            success: true, 
            message: 'Project deleted successfully' 
        });
        
    } catch (error) {
        await connection.rollback();
        console.error('Error deleting project:', error);
        res.status(500).json({ error: 'Server error' });
    } finally {
        connection.release();
    }
});
// ==================== PUBLICATION ENDPOINTS ====================

// Get all papers
app.get('/api/papers', async (req, res) => {
    try {
        // Get papers with basic info
        const [papers] = await promisePool.execute(
            `SELECT ro.output_id, ro.title, ro.description, ro.created_date, ro.visibility_status,
                    p.abstract, p.publication_date, p.manuscript_status, p.doi,
                    pv.name as venue_name, pv.venue_type, pv.publisher
             FROM RESEARCH_OUTPUT ro
             JOIN PAPER p ON ro.output_id = p.paper_id
             LEFT JOIN PUBLICATION_VENUE pv ON p.venue_id = pv.venue_id
             ORDER BY p.publication_date DESC`
        );
        
        // For each paper, get citation count and authors
        const papersWithDetails = await Promise.all(papers.map(async (paper) => {
            const [citationCount] = await promisePool.execute(
                `SELECT COUNT(DISTINCT c.citation_id) as citation_count
                 FROM CITATION c
                 WHERE c.cited_output_id = ?`,
                [paper.output_id]
            );
            
            const [authors] = await promisePool.execute(
                `SELECT GROUP_CONCAT(DISTINCT r.full_name SEPARATOR ', ') as authors
                 FROM COLLABORATION col
                 JOIN RESEARCHER r ON col.researcher_id = r.researcher_id
                 WHERE col.paper_id = ?
                 LIMIT 3`,
                [paper.output_id]
            );
            
            return {
                ...paper,
                citation_count: citationCount[0]?.citation_count || 0,
                authors: authors[0]?.authors || 'No authors listed'
            };
        }));
        
        res.json(papersWithDetails);
    } catch (error) {
        console.error('Error fetching papers:', error);
        res.status(500).json({ error: 'Server error' });
    }
});

// Get single paper with full details
app.get('/api/papers/:id', async (req, res) => {
    try {
        // Get paper basic info
        const [paper] = await promisePool.execute(
            `SELECT ro.output_id, ro.title, ro.description, ro.created_date, ro.visibility_status,
                    p.abstract, p.publication_date, p.manuscript_status, p.doi,
                    pv.name as venue_name, pv.venue_type, pv.publisher
             FROM RESEARCH_OUTPUT ro
             JOIN PAPER p ON ro.output_id = p.paper_id
             LEFT JOIN PUBLICATION_VENUE pv ON p.venue_id = pv.venue_id
             WHERE ro.output_id = ?`,
            [req.params.id]
        );
        
        if (paper.length === 0) {
            return res.status(404).json({ error: 'Paper not found' });
        }
        
        // Get authors
        const [authors] = await promisePool.execute(
            `SELECT r.researcher_id, r.full_name, ar.role_name
             FROM COLLABORATION c
             JOIN RESEARCHER r ON c.researcher_id = r.researcher_id
             LEFT JOIN AUTHOR_ROLE ar ON c.author_role_id = ar.author_role_id
             WHERE c.paper_id = ?
             ORDER BY c.author_order`,
            [req.params.id]
        );
        
        // Get citation count
        const [citationCount] = await promisePool.execute(
            `SELECT COUNT(DISTINCT c.citation_id) as citation_count
             FROM CITATION c
             WHERE c.cited_output_id = ?`,
            [req.params.id]
        );
        
        // Get keywords
        const [keywords] = await promisePool.execute(
            `SELECT k.keyword_text
             FROM PAPER_KEYWORD pk
             JOIN KEYWORD k ON pk.keyword_id = k.keyword_id
             WHERE pk.paper_id = ?`,
            [req.params.id]
        );
        
        const result = paper[0];
        result.authors = authors;
        result.citation_count = citationCount[0]?.citation_count || 0;
        result.keywords = keywords.map(k => k.keyword_text);
        
        res.json(result);
    } catch (error) {
        console.error('Error fetching paper details:', error);
        res.status(500).json({ error: 'Server error' });
    }
});

// ==================== PAPER CRUD OPERATIONS ====================
// Add new paper - fix author_role_id issue
app.post('/api/papers', async (req, res) => {
    let connection;
    
    try {
        connection = await promisePool.getConnection();
        await connection.beginTransaction();
        
        const { title, abstract, publication_date, manuscript_status, 
                doi, venue_id, authors, keywords } = req.body;
        
        // Validate required fields
        if (!title) {
            await connection.rollback();
            return res.status(400).json({ 
                error: 'Title is a required field' 
            });
        }
        
        // First create research output
        const [outputResult] = await connection.execute(
            `INSERT INTO RESEARCH_OUTPUT (title, description) 
             VALUES (?, ?)`,
            [title, abstract || null]
        );
        
        const outputId = outputResult.insertId;
        
        // Then create paper
        await connection.execute(
            `INSERT INTO PAPER (paper_id, abstract, publication_date, manuscript_status, doi, venue_id) 
             VALUES (?, ?, ?, ?, ?, ?)`,
            [
                outputId, 
                abstract || null, 
                publication_date || null, 
                manuscript_status || 'Published', 
                doi || null, 
                venue_id || null
            ]
        );
        
        // Get the default author role ID
        const [authorRole] = await connection.execute(
            `SELECT author_role_id FROM AUTHOR_ROLE WHERE role_name = 'Author' LIMIT 1`
        );
        
        let authorRoleId = 1; // Default to 1 if not found
        
        if (authorRole.length > 0) {
            authorRoleId = authorRole[0].author_role_id;
        }
        
        // Add authors WITH author_role_id
        if (authors && Array.isArray(authors)) {
            for (let i = 0; i < authors.length; i++) {
                if (authors[i]) {
                    await connection.execute(
                        `INSERT INTO COLLABORATION (researcher_id, paper_id, author_role_id, author_order) 
                         VALUES (?, ?, ?, ?)`,
                        [authors[i], outputId, authorRoleId, i + 1]
                    );
                }
            }
        }
        
        // Add keywords
        if (keywords && keywords.trim()) {
            const keywordList = keywords.split(',').map(k => k.trim());
            
            for (const keyword of keywordList) {
                if (keyword) {
                    // Check if keyword exists
                    const [existingKeyword] = await connection.execute(
                        `SELECT keyword_id FROM KEYWORD WHERE keyword_text = ?`,
                        [keyword]
                    );
                    
                    let keywordId;
                    if (existingKeyword.length > 0) {
                        keywordId = existingKeyword[0].keyword_id;
                    } else {
                        const [keywordResult] = await connection.execute(
                            `INSERT INTO KEYWORD (keyword_text) VALUES (?)`,
                            [keyword]
                        );
                        keywordId = keywordResult.insertId;
                    }
                    
                    // Link paper to keyword
                    await connection.execute(
                        `INSERT INTO PAPER_KEYWORD (paper_id, keyword_id) 
                         VALUES (?, ?)`,
                        [outputId, keywordId]
                    );
                }
            }
        }
        
        await connection.commit();
        
        res.status(201).json({ 
            success: true, 
            output_id: outputId,
            message: 'Paper created successfully' 
        });
        
    } catch (error) {
        if (connection) await connection.rollback();
        console.error('Error creating paper:', error);
        res.status(500).json({ error: 'Server error: ' + error.message });
    } finally {
        if (connection) connection.release();
    }
});
// Update paper PUT endpoint to handle author_role_id
app.put('/api/papers/:id', async (req, res) => {
    let connection;
    
    try {
        connection = await promisePool.getConnection();
        await connection.beginTransaction();
        
        const { title, abstract, publication_date, manuscript_status, 
                doi, venue_id, authors, keywords } = req.body;
        
        // Check if paper exists
        const [existing] = await connection.execute(
            'SELECT output_id FROM RESEARCH_OUTPUT WHERE output_id = ?',
            [req.params.id]
        );
        
        if (existing.length === 0) {
            await connection.rollback();
            return res.status(404).json({ error: 'Paper not found' });
        }
        
        // Update research output
        await connection.execute(
            `UPDATE RESEARCH_OUTPUT 
             SET title = ?, description = ?
             WHERE output_id = ?`,
            [title || '', abstract || null, req.params.id]
        );
        
        // Update paper
        await connection.execute(
            `UPDATE PAPER 
             SET abstract = ?, publication_date = ?, manuscript_status = ?, 
                 doi = ?, venue_id = ?
             WHERE paper_id = ?`,
            [
                abstract || null,
                publication_date || null,
                manuscript_status || 'Published',
                doi || null,
                venue_id || null,
                req.params.id
            ]
        );
        
        // Update authors if provided
        if (authors && Array.isArray(authors)) {
            // Delete existing collaborations
            await connection.execute(
                'DELETE FROM COLLABORATION WHERE paper_id = ?',
                [req.params.id]
            );
            
            // Get the default author role ID (assuming 'Author' exists)
            const [authorRole] = await connection.execute(
                `SELECT author_role_id FROM AUTHOR_ROLE WHERE role_name = 'Author' LIMIT 1`
            );
            
            let authorRoleId = 1; // Default to 1 if not found
            
            if (authorRole.length > 0) {
                authorRoleId = authorRole[0].author_role_id;
            }
            
            // Add new authors WITH author_role_id
            for (let i = 0; i < authors.length; i++) {
                if (authors[i]) {
                    await connection.execute(
                        `INSERT INTO COLLABORATION (researcher_id, paper_id, author_role_id, author_order) 
                         VALUES (?, ?, ?, ?)`,
                        [authors[i], req.params.id, authorRoleId, i + 1]
                    );
                }
            }
        }
        
        // Update keywords if provided
        if (keywords && keywords.trim()) {
            // Delete existing keywords
            await connection.execute(
                'DELETE FROM PAPER_KEYWORD WHERE paper_id = ?',
                [req.params.id]
            );
            
            const keywordList = keywords.split(',').map(k => k.trim());
            
            for (const keyword of keywordList) {
                if (keyword) {
                    // Check if keyword exists
                    const [existingKeyword] = await connection.execute(
                        `SELECT keyword_id FROM KEYWORD WHERE keyword_text = ?`,
                        [keyword]
                    );
                    
                    let keywordId;
                    if (existingKeyword.length > 0) {
                        keywordId = existingKeyword[0].keyword_id;
                    } else {
                        const [keywordResult] = await connection.execute(
                            `INSERT INTO KEYWORD (keyword_text) VALUES (?)`,
                            [keyword]
                        );
                        keywordId = keywordResult.insertId;
                    }
                    
                    // Link paper to keyword
                    await connection.execute(
                        `INSERT INTO PAPER_KEYWORD (paper_id, keyword_id) 
                         VALUES (?, ?)`,
                        [req.params.id, keywordId]
                    );
                }
            }
        }
        
        await connection.commit();
        
        res.json({ 
            success: true, 
            message: 'Paper updated successfully' 
        });
        
    } catch (error) {
        if (connection) await connection.rollback();
        console.error('Error updating paper:', error);
        res.status(500).json({ error: 'Server error: ' + error.message });
    } finally {
        if (connection) connection.release();
    }
});


// Update paper delete endpoint - fix dataset constraint
app.delete('/api/papers/:id', async (req, res) => {
    let connection;
    
    try {
        connection = await promisePool.getConnection();
        await connection.beginTransaction();
        
        // Check if paper exists
        const [existing] = await connection.execute(
            'SELECT output_id FROM RESEARCH_OUTPUT WHERE output_id = ?',
            [req.params.id]
        );
        
        if (existing.length === 0) {
            await connection.rollback();
            return res.status(404).json({ error: 'Paper not found' });
        }
        
        // Delete ALL dependent records in the correct order:
        
        // 1. Delete from DATASET where dataset_id = output_id (FIX FOR NEW CONSTRAINT)
        await connection.execute(
            'DELETE FROM DATASET WHERE dataset_id = ?',
            [req.params.id]
        );
        
        // 2. Delete trend_indicator records
        await connection.execute(
            'DELETE FROM TREND_INDICATOR WHERE paper_id = ?',
            [req.params.id]
        );
        
        // 3. Delete peer_review records
        await connection.execute(
            'DELETE FROM PEER_REVIEW WHERE paper_id = ?',
            [req.params.id]
        );
        
        // 4. Delete citations where this paper is cited or is citing
        await connection.execute(
            'DELETE FROM CITATION WHERE citing_output_id = ? OR cited_output_id = ?',
            [req.params.id, req.params.id]
        );
        
        // 5. Delete paper keywords
        await connection.execute(
            'DELETE FROM PAPER_KEYWORD WHERE paper_id = ?',
            [req.params.id]
        );
        
        // 6. Delete collaborations
        await connection.execute(
            'DELETE FROM COLLABORATION WHERE paper_id = ?',
            [req.params.id]
        );
        
        // 7. Delete from project outputs
        await connection.execute(
            'DELETE FROM PROJECT_OUTPUT WHERE output_id = ?',
            [req.params.id]
        );
        
        // 8. Delete paper
        const [paperDelete] = await connection.execute(
            'DELETE FROM PAPER WHERE paper_id = ?',
            [req.params.id]
        );
        
        // 9. Delete research output (should work now that DATASET is deleted)
        const [outputDelete] = await connection.execute(
            'DELETE FROM RESEARCH_OUTPUT WHERE output_id = ?',
            [req.params.id]
        );
        
        await connection.commit();
        
        res.json({ 
            success: true, 
            message: 'Paper deleted successfully (all related data removed)' 
        });
        
    } catch (error) {
        if (connection) await connection.rollback();
        console.error('Error deleting paper:', error);
        res.status(500).json({ error: 'Server error: ' + error.message });
    } finally {
        if (connection) connection.release();
    }
});
// ==================== CITATION ENDPOINTS ====================
// Add new citation (UPDATED with duplicate handling)
app.post('/api/citations', async (req, res) => {
    try {
        console.log('Received citation data:', req.body);
        
        const { citing_paper_id, cited_paper_id, citation_date } = req.body;
        
        // First, check if this citation already exists
        const [existing] = await promisePool.execute(
            `SELECT citation_id FROM CITATION 
             WHERE citing_output_id = ? AND cited_output_id = ?`,
            [citing_paper_id, cited_paper_id]
        );
        
        if (existing.length > 0) {
            return res.status(400).json({ 
                error: 'Citation already exists',
                message: `A citation from paper ${citing_paper_id} to paper ${cited_paper_id} already exists.`,
                citation_id: existing[0].citation_id
            });
        }
        
        // If not exists, insert it
        const [result] = await promisePool.execute(
            `INSERT INTO CITATION (citing_output_id, cited_output_id, citation_date) 
             VALUES (?, ?, ?)`,
            [citing_paper_id, cited_paper_id, citation_date || new Date().toISOString().split('T')[0]]
        );
        
        res.status(201).json({ 
            success: true, 
            citation_id: result.insertId,
            message: 'Citation added successfully' 
        });
        
    } catch (error) {
        console.error('Error creating citation:', error);
        
        // Handle duplicate entry error specifically
        if (error.code === 'ER_DUP_ENTRY') {
            return res.status(400).json({ 
                error: 'Duplicate citation',
                message: 'This citation already exists in the database.'
            });
        }
        
        res.status(500).json({ 
            error: 'Server error',
            details: error.message
        });
    }
});
// ==================== GRANT/FUNDING ENDPOINTS ====================

// Add new grant (UPDATED with grant number duplicate handling)
app.post('/api/grants', async (req, res) => {
    const connection = await promisePool.getConnection();
    
    try {
        await connection.beginTransaction();
        
        console.log('Received grant data:', req.body);
        
        const { grant_title, funding_agency, grant_number, start_date, 
                end_date, total_amount, grant_status, project_ids, allocation_amount } = req.body;
        
        // Validate required fields
        if (!grant_title || !funding_agency) {
            return res.status(400).json({ 
                error: 'Missing required fields',
                message: 'Grant title and funding agency are required.'
            });
        }
        
        // Check if grant number already exists (if provided)
        if (grant_number) {
            const [existingGrant] = await connection.execute(
                'SELECT grant_id, grant_title FROM `GRANT` WHERE grant_number = ?',
                [grant_number]
            );
            
            if (existingGrant.length > 0) {
                return res.status(400).json({ 
                    error: 'Duplicate grant number',
                    message: `Grant number "${grant_number}" already exists (Grant ID: ${existingGrant[0].grant_id}, Title: "${existingGrant[0].grant_title}").`,
                    existing_grant: existingGrant[0]
                });
            }
        }
        
        // Insert the grant
        const [grantResult] = await connection.execute(
            `INSERT INTO \`GRANT\` 
             (grant_title, funding_agency, grant_number, start_date, end_date, 
              grant_amount, grant_status) 
             VALUES (?, ?, ?, ?, ?, ?, ?)`,
            [
                grant_title, 
                funding_agency, 
                grant_number || null, 
                start_date, 
                end_date || null, 
                total_amount || 0, 
                grant_status || 'Active'
            ]
        );
        
        const grantId = grantResult.insertId;
        
        // Add project allocations if provided
        if (project_ids && Array.isArray(project_ids) && project_ids.length > 0) {
            const perProjectAllocation = allocation_amount || 
                (total_amount ? (total_amount / project_ids.length) : 0);
            
            // Validate each project ID exists before inserting
            for (const projectId of project_ids) {
                // Check if project exists
                const [projectExists] = await connection.execute(
                    'SELECT project_id FROM RESEARCH_PROJECT WHERE project_id = ?',
                    [projectId]
                );
                
                if (projectExists.length === 0) {
                    throw new Error(`Project ID ${projectId} does not exist in the database.`);
                }
                
                // Insert project grant allocation
                await connection.execute(
                    `INSERT INTO PROJECT_GRANT (project_id, grant_id, allocation_amount) 
                     VALUES (?, ?, ?)`,
                    [projectId, grantId, perProjectAllocation]
                );
            }
        }
        
        await connection.commit();
        
        res.status(201).json({ 
            success: true, 
            grant_id: grantId,
            message: 'Grant added successfully' 
        });
        
    } catch (error) {
        await connection.rollback();
        console.error('Error creating grant:', error);
        
        // Handle specific errors
        if (error.message.includes('does not exist')) {
            return res.status(400).json({ 
                error: 'Invalid project ID',
                message: error.message
            });
        }
        
        if (error.code === 'ER_NO_REFERENCED_ROW_2') {
            return res.status(400).json({ 
                error: 'Invalid project ID',
                message: 'One or more project IDs do not exist in the database.'
            });
        }
        
        if (error.code === 'ER_DUP_ENTRY') {
            return res.status(400).json({ 
                error: 'Duplicate entry',
                message: 'This grant number already exists in the database. Please use a unique grant number.'
            });
        }
        
        res.status(500).json({ 
            error: 'Server error',
            details: error.message
        });
    } finally {
        connection.release();
    }
});
// ==================== STATISTICS ENDPOINTS ====================

// Dashboard statistics
app.get('/api/statistics/dashboard', async (req, res) => {
  try {
    // Get counts individually to avoid complex queries
    const [institutionCount] = await promisePool.execute('SELECT COUNT(*) as total_institutions FROM INSTITUTION');
    const [researcherCount] = await promisePool.execute('SELECT COUNT(*) as total_researchers FROM RESEARCHER');
    const [projectCount] = await promisePool.execute('SELECT COUNT(*) as total_projects FROM RESEARCH_PROJECT');
    const [paperCount] = await promisePool.execute('SELECT COUNT(*) as total_papers FROM PAPER');
    const [citationCount] = await promisePool.execute('SELECT COUNT(*) as total_citations FROM CITATION');
    
    const [activeFunding] = await promisePool.execute(
      `SELECT COALESCE(SUM(pg.allocation_amount), 0) as active_funding
       FROM PROJECT_GRANT pg
       JOIN RESEARCH_PROJECT rp ON pg.project_id = rp.project_id
       JOIN \`GRANT\` g ON pg.grant_id = g.grant_id
       WHERE rp.project_status = 'Active'`
    );
    
    const stats = {
      total_institutions: institutionCount[0]?.total_institutions || 0,
      total_researchers: researcherCount[0]?.total_researchers || 0,
      total_projects: projectCount[0]?.total_projects || 0,
      total_papers: paperCount[0]?.total_papers || 0,
      total_citations: citationCount[0]?.total_citations || 0,
      active_funding: activeFunding[0]?.active_funding || 0
    };
    
    res.json(stats);
  } catch (error) {
    console.error('Error fetching dashboard statistics:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Publications per year for chart
app.get('/api/statistics/publications-per-year', async (req, res) => {
    try {
        const [rows] = await promisePool.execute(
            `SELECT YEAR(publication_date) as year, COUNT(*) as count
             FROM PAPER
             WHERE publication_date IS NOT NULL
             GROUP BY YEAR(publication_date)
             ORDER BY year`
        );
        res.json(rows);
    } catch (error) {
        console.error('Error fetching publications per year:', error);
        res.status(500).json({ error: 'Server error' });
    }
});

// Project completion status for pie chart
app.get('/api/statistics/project-completion', async (req, res) => {
    try {
        const [rows] = await promisePool.execute(
            `SELECT project_status, COUNT(*) as count
             FROM RESEARCH_PROJECT
             WHERE project_status IS NOT NULL
             GROUP BY project_status`
        );
        res.json(rows);
    } catch (error) {
        console.error('Error fetching project completion:', error);
        res.status(500).json({ error: 'Server error' });
    }
});

// Top researchers by citations
app.get('/api/statistics/top-researchers', async (req, res) => {
    try {
        // Get all researchers with their citation counts
        const [researchers] = await promisePool.execute(
            `SELECT r.researcher_id, r.full_name
             FROM RESEARCHER r`
        );
        
        // For each researcher, get their citation and paper counts
        const researchersWithStats = await Promise.all(researchers.map(async (researcher) => {
            const [citationCount] = await promisePool.execute(
                `SELECT COUNT(DISTINCT cit.citation_id) as citation_count
                 FROM COLLABORATION col
                 LEFT JOIN CITATION cit ON col.paper_id = cit.cited_output_id
                 WHERE col.researcher_id = ?`,
                [researcher.researcher_id]
            );
            
            const [paperCount] = await promisePool.execute(
                `SELECT COUNT(DISTINCT col.paper_id) as paper_count
                 FROM COLLABORATION col
                 WHERE col.researcher_id = ?`,
                [researcher.researcher_id]
            );
            
            const [currentInstitution] = await promisePool.execute(
                `SELECT i.name as current_institution
                 FROM EMPLOYMENT e
                 JOIN DEPARTMENT d ON e.department_id = d.department_id
                 JOIN INSTITUTION i ON d.institution_id = i.institution_id
                 WHERE e.researcher_id = ? 
                   AND (e.end_date IS NULL OR e.end_date > CURDATE())
                 LIMIT 1`,
                [researcher.researcher_id]
            );
            
            return {
                ...researcher,
                citation_count: citationCount[0]?.citation_count || 0,
                paper_count: paperCount[0]?.paper_count || 0,
                current_institution: currentInstitution[0]?.current_institution || 'Unknown'
            };
        }));
        
        // Sort by citation count and take top 10
        const topResearchers = researchersWithStats
            .sort((a, b) => b.citation_count - a.citation_count)
            .slice(0, 10);
        
        res.json(topResearchers);
    } catch (error) {
        console.error('Error fetching top researchers:', error);
        res.status(500).json({ error: 'Server error' });
    }
});

// ==================== SEARCH ENDPOINT ====================

// Universal search
app.get('/api/search', async (req, res) => {
    const searchTerm = `%${req.query.q}%`;
    
    if (!req.query.q || req.query.q.trim() === '') {
        return res.json([]);
    }

    try {
        const allResults = [];
        
        // Search researchers
        try {
            const [researchers] = await promisePool.execute(
                `SELECT 'researcher' as type, researcher_id as id, full_name as name, 
                        email as details, academic_rank as description
                 FROM RESEARCHER 
                 WHERE full_name LIKE ? OR email LIKE ? 
                 LIMIT 3`,
                [searchTerm, searchTerm]
            );
            allResults.push(...researchers);
        } catch (err) {
            console.error('Error searching researchers:', err);
        }

        // Search projects
        try {
            const [projects] = await promisePool.execute(
                `SELECT 'project' as type, project_id as id, project_title as name, 
                        project_status as details, description
                 FROM RESEARCH_PROJECT 
                 WHERE project_title LIKE ? OR description LIKE ? 
                 LIMIT 3`,
                [searchTerm, searchTerm]
            );
            allResults.push(...projects);
        } catch (err) {
            console.error('Error searching projects:', err);
        }

        // Search papers
        try {
            const [papers] = await promisePool.execute(
                `SELECT 'paper' as type, output_id as id, title as name, 
                        manuscript_status as details, description
                 FROM RESEARCH_OUTPUT ro
                 JOIN PAPER p ON ro.output_id = p.paper_id
                 WHERE title LIKE ? OR description LIKE ? 
                 LIMIT 3`,
                [searchTerm, searchTerm]
            );
            allResults.push(...papers);
        } catch (err) {
            console.error('Error searching papers:', err);
        }

        // Search institutions
        try {
            const [institutions] = await promisePool.execute(
                `SELECT 'institution' as type, institution_id as id, name, 
                        location as details, description
                 FROM INSTITUTION 
                 WHERE name LIKE ? OR location LIKE ? 
                 LIMIT 3`,
                [searchTerm, searchTerm]
            );
            allResults.push(...institutions);
        } catch (err) {
            console.error('Error searching institutions:', err);
        }
        
        res.json(allResults.slice(0, 10));
    } catch (error) {
        console.error('Search error:', error);
        res.status(500).json({ error: 'Server error' });
    }
});

// ==================== HELPER ENDPOINTS ====================

// Get departments by institution
app.get('/api/departments', async (req, res) => {
    try {
        const { institution_id } = req.query;
        
        let query = 'SELECT * FROM DEPARTMENT';
        const params = [];
        
        if (institution_id) {
            query += ' WHERE institution_id = ?';
            params.push(institution_id);
        }
        
        query += ' ORDER BY name';
        
        const [rows] = await promisePool.execute(query, params);
        res.json(rows);
    } catch (error) {
        console.error('Error fetching departments:', error);
        res.status(500).json({ error: 'Server error' });
    }
});

// Get publication venues
app.get('/api/venues', async (req, res) => {
    try {
        const [rows] = await promisePool.execute(
            'SELECT * FROM PUBLICATION_VENUE ORDER BY name'
        );
        res.json(rows);
    } catch (error) {
        console.error('Error fetching venues:', error);
        res.status(500).json({ error: 'Server error' });
    }
});

// Add new publication venue
app.post('/api/venues', async (req, res) => {
    try {
        const { name, venue_type, publisher } = req.body;
        
        // Validate required fields
        if (!name) {
            return res.status(400).json({ 
                error: 'Venue name is required' 
            });
        }
        
        const [result] = await promisePool.execute(
            `INSERT INTO PUBLICATION_VENUE (name, venue_type, publisher) 
             VALUES (?, ?, ?)`,
            [name, venue_type || 'Journal', publisher || null]
        );
        
        res.status(201).json({ 
            success: true, 
            venue_id: result.insertId,
            message: 'Venue added successfully' 
        });
    } catch (error) {
        console.error('Error creating venue:', error);
        res.status(500).json({ error: 'Server error' });
    }
});

// ==================== HEALTH ENDPOINT ====================

app.get('/api/health', (req, res) => {
    res.json({ 
        status: 'OK', 
        timestamp: new Date().toISOString(),
        database: 'Connected',
        endpoints: [
            '/api/institutions',
            '/api/researchers',
            '/api/projects',
            '/api/papers',
            '/api/statistics/dashboard',
            '/api/search'
        ]
    });
});

// Default route
app.get('/', (req, res) => {
    res.sendFile(__dirname + '/public/index.html');
});

// Catch-all for undefined routes
app.use((req, res) => {
    res.status(404).json({ error: 'Endpoint not found' });
});

// Error handling middleware
app.use((err, req, res, next) => {
    console.error('Server error:', err);
    res.status(500).json({ error: 'Internal server error' });
});
// Add this route to see your CITATION table structure
app.get('/api/db-structure/citation', async (req, res) => {
    try {
        const [columns] = await promisePool.execute('DESCRIBE CITATION');
        res.json(columns);
    } catch (error) {
        console.error('Error fetching CITATION structure:', error);
        res.status(500).json({ error: error.message });
    }
});

// Add this route to see your GRANT table structure
app.get('/api/db-structure/grant', async (req, res) => {
    try {
        const [columns] = await promisePool.execute('DESCRIBE `GRANT`');
        res.json(columns);
    } catch (error) {
        console.error('Error fetching GRANT structure:', error);
        res.status(500).json({ error: error.message });
    }
});
// Add this right before the 404 handler in server.js
// ==================== DEBUG ENDPOINTS ====================
app.get('/api/debug/citation-structure', async (req, res) => {
    try {
        console.log('Fetching CITATION table structure...');
        const [columns] = await promisePool.execute('DESCRIBE CITATION');
        console.log('CITATION columns:', columns);
        res.json({
            table: 'CITATION',
            columns: columns
        });
    } catch (error) {
        console.error('Error fetching CITATION structure:', error.message);
        res.status(500).json({ 
            error: error.message,
            sqlState: error.sqlState,
            code: error.code 
        });
    }
});

app.get('/api/debug/grant-structure', async (req, res) => {
    try {
        console.log('Fetching GRANT table structure...');
        const [columns] = await promisePool.execute('DESCRIBE `GRANT`');
        console.log('GRANT columns:', columns);
        res.json({
            table: 'GRANT',
            columns: columns
        });
    } catch (error) {
        console.error('Error fetching GRANT structure:', error.message);
        res.status(500).json({ 
            error: error.message,
            sqlState: error.sqlState,
            code: error.code 
        });
    }
});

app.get('/api/debug/tables', async (req, res) => {
    try {
        const [tables] = await promisePool.execute('SHOW TABLES');
        res.json({
            tables: tables.map(t => Object.values(t)[0])
        });
    } catch (error) {
        console.error('Error fetching tables:', error);
        res.status(500).json({ error: error.message });
    }
});
// Add this near the end of server.js, before app.listen()
app.get('/api/debug/routes', (req, res) => {
    const routes = [];
    app._router.stack.forEach((middleware) => {
        if (middleware.route) {
            routes.push({
                path: middleware.route.path,
                methods: Object.keys(middleware.route.methods)
            });
        } else if (middleware.name === 'router') {
            middleware.handle.stack.forEach((handler) => {
                if (handler.route) {
                    routes.push({
                        path: handler.route.path,
                        methods: Object.keys(handler.route.methods)
                    });
                }
            });
        }
    });
    res.json(routes);
});
// Start the server
app.listen(PORT, () => {
    console.log(`Research Database Server running on http://localhost:${PORT}`);
    console.log(`API endpoints available at http://localhost:${PORT}/api/`);
    console.log(`Health check: http://localhost:${PORT}/api/health`);
    console.log('\nKey API Endpoints:');
    console.log('- GET /api/institutions - List all institutions');
    console.log('- POST /api/institutions - Add new institution');
    console.log('- PUT /api/institutions/:id - Update institution');
    console.log('- DELETE /api/institutions/:id - Delete institution');
    console.log('- GET /api/researchers - List all researchers');
    console.log('- POST /api/researchers - Add new researcher');
    console.log('- PUT /api/researchers/:id - Update researcher');
    console.log('- DELETE /api/researchers/:id - Delete researcher');
    console.log('- GET /api/projects - List all projects');
    console.log('- POST /api/projects - Add new project');
    console.log('- PUT /api/projects/:id - Update project');
    console.log('- DELETE /api/projects/:id - Delete project');
    console.log('- GET /api/papers - List all papers');
    console.log('- POST /api/papers - Add new paper');
    console.log('- PUT /api/papers/:id - Update paper');
    console.log('- DELETE /api/papers/:id - Delete paper');
    console.log('- POST /api/citations - Add new citation');
    console.log('- POST /api/grants - Add new grant/funding');
    console.log('- GET /api/search?q=query - Universal search');
    console.log('- POST /api/import/:entity - Import data from CSV/Excel');
    console.log('- GET /api/export/:entity - Export data to CSV/JSON');
});