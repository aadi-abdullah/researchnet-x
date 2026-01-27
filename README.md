# 🔬 ResearchNet-X: Academic Research Database Management System

![Database Schema](https://img.shields.io/badge/Database-MySQL-blue)
![Backend-Node.js](https://img.shields.io/badge/Backend-Node.js-green)
![Frontend-HTML/CSS/JS](https://img.shields.io/badge/Frontend-HTML/CSS/JS-purple)
![License-MIT](https://img.shields.io/badge/License-MIT-yellow)
![Version-1.0](https://img.shields.io/badge/Version-1.0-orange)

## 📋 Table of Contents
- [✨ Overview](#-overview)
- [🎯 Key Features](#-key-features)
- [🏗️ System Architecture](#️-system-architecture)
- [🗄️ Database Schema](#️-database-schema)
- [⚙️ Installation Guide](#️-installation-guide)
- [🚀 Quick Start](#-quick-start)
- [📊 API Documentation](#-api-documentation)
- [🔍 Sample Queries](#-sample-queries)
- [🛠️ Project Structure](#️-project-structure)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)

## ✨ Overview

**ResearchNet-X** is a comprehensive, full-stack database management system designed to centralize and analyze academic research data across Pakistani universities. This system provides a robust platform for tracking researchers, publications, projects, grants, and collaborations with advanced analytics capabilities.

### 🎯 Project Goals
- ✅ **Centralized Research Repository**: Aggregate data from 24+ Pakistani universities
- ✅ **Impact Tracking**: Monitor citation networks and research impact metrics
- ✅ **Collaboration Facilitation**: Enable cross-institutional researcher networking
- ✅ **Funding Management**: Track grant allocations and project budgets
- ✅ **Trend Analysis**: Identify emerging research areas and hotspots

## 🎯 Key Features

### 🏛️ Institutional Management
- 📚 **24+ Universities**: Complete database of Pakistani higher education institutions
- 🏢 **Department Hierarchy**: Multi-level academic department structure
- 👥 **Researcher Profiles**: Comprehensive academic profiles with ORCID integration
- 📈 **Performance Metrics**: Institution-wise research output analytics

### 📊 Research Output Tracking
- 📄 **Publication Management**: Complete paper metadata with DOI tracking
- 🔗 **Citation Network Analysis**: Real-time citation mapping and impact calculation
- 📈 **Impact Metrics**: H-index, citation counts, trending scores
- 🔖 **Keyword Classification**: Automated topic modeling and categorization

### 💰 Funding & Grant Management
- 💸 **Multi-source Funding**: HEC, PSF, World Bank, EU, and international grants
- 📋 **Project Allocation**: Detailed grant-to-project allocation tracking
- 💰 **Budget Analytics**: Funding distribution analysis across institutions
- 📊 **ROI Calculation**: Research output per funding unit metrics

### 🤝 Collaboration Tools
- 👨‍🔬 **Researcher Networks**: Cross-institutional collaboration mapping
- 🤝 **Co-authorship Analysis**: Publication collaboration patterns
- 👥 **Team Management**: Project team composition and role tracking
- 📚 **Supervision Tracking**: Advisor-student relationship mapping

### 📈 Advanced Analytics
- 📊 **Trend Detection**: Citation growth rate and trending score calculation
- 📈 **Performance Benchmarking**: Institution and researcher ranking
- 📋 **Custom Reporting**: SQL-based analytical query support
- 🎯 **Predictive Insights**: Emerging research area identification

## 🏗️ System Architecture

### Tech Stack
```
┌─────────────────────────────────────────────────────┐
│                    Frontend Layer                    │
│  HTML5 + CSS3 + JavaScript + Bootstrap 5 + Chart.js │
├─────────────────────────────────────────────────────┤
│                    API Layer                         │
│  Node.js + Express.js + REST API + JWT Authentication│
├─────────────────────────────────────────────────────┤
│                    Database Layer                    │
│  MySQL 8.0 + Advanced Indexing + Referential Integrity│
└─────────────────────────────────────────────────────┘
```

### 🏗️ Database Design Principles
1. **Normalization**: 3NF compliance with minimal redundancy
2. **Referential Integrity**: Cascading updates and deletes
3. **Performance Optimization**: Strategic indexing on frequently queried columns
4. **Data Consistency**: Comprehensive foreign key constraints
5. **Scalability**: Support for large-scale academic data

## 🗄️ Database Schema

### 📊 Core Entities (24 Tables)

#### 1. **Institutional Structure**
```sql
INSTITUTION (institution_id, name, location, type, website_url, established_date)
│
└── DEPARTMENT (department_id, name, institution_id)  -- 20+ departments
```

#### 2. **Research Personnel**
```sql
RESEARCHER (researcher_id, full_name, email, orcid_id, profile_url, academic_rank)
│
├── EMPLOYMENT (researcher_id, department_id, position_title, employment_type)
└── RESEARCH_AREA_MAPPING (researcher_id, research_area_id, primary_flag)
```

#### 3. **Research Areas** (Hierarchical)
```sql
RESEARCH_AREA (research_area_id, area_name, description, parent_area_id)
├── Computer Science → Artificial Intelligence → Machine Learning
├── Engineering → Electrical Engineering → Renewable Energy
├── Medical Sciences → Medicine → Surgery → Public Health
└── Natural Sciences → Physics → Chemistry → Mathematics
```

#### 4. **Projects & Funding**
```sql
RESEARCH_PROJECT (project_id, title, description, status, dates, department_id)
│
├── PROJECT_MEMBER (project_id, researcher_id, role_in_project)
├── PROJECT_GRANT (project_id, grant_id, allocation_amount)
└── `GRANT` (grant_id, title, funding_agency, amount, status, grant_number)
```

#### 5. **Research Output**
```sql
RESEARCH_OUTPUT (output_id, title, description, created_date, visibility_status)
│
├── PAPER (paper_id, abstract, publication_date, manuscript_status, doi, venue_id)
├── DATASET (dataset_id, repository_url, access_type, license_type)
└── PUBLICATION_VENUE (venue_id, name, type, publisher, open_access_flag)
```

#### 6. **Collaboration Network**
```sql
COLLABORATION (researcher_id, paper_id, author_role_id, author_order)
│
├── CITATION (citing_output_id, cited_output_id, citation_date)
├── PEER_REVIEW (paper_id, reviewer_id, comments, recommendation)
└── PAPER_KEYWORD (paper_id, keyword_id)
```

#### 7. **Analytical Components**
```sql
TREND_INDICATOR (paper_id, calculated_date, citation_growth_rate, trending_score)
├── AUTHOR_ROLE (role_name)  -- 15+ academic roles
└── KEYWORD (keyword_text, keyword_type)  -- 30+ research keywords
```

### 🔗 Key Relationships
```
Institutions (24) → Departments (20) → Researchers (20)
      ↓                   ↓                  ↓
    Projects (20) → Project Members → Research Outputs (20)
      ↓                   ↓                  ↓
    Grants (20) → Funding Allocation → Papers (20) + Datasets (20)
                                         ↓          ↓
                                   Citations (30) + Keywords (40+)
                                         ↓
                                   Trend Indicators (27)
```
## 🖼️ Screenshots

### 📊 Dashboard View
<img width="1266" height="849" alt="dashboard" src="https://github.com/user-attachments/assets/08ed6522-ff00-40d2-affd-28e5181a2f13" />

*Main dashboard showing key statistics and recent research activities across institutions*

### 🏛️ Institution Management
<img width="1264" height="858" alt="institutions" src="https://github.com/user-attachments/assets/2a8112b4-b364-4119-a525-f193b720d258" />

*Comprehensive view of registered institutions with detailed metrics and department hierarchy*

### 👨‍🔬 Researcher Management
<img width="1266" height="851" alt="researchers" src="https://github.com/user-attachments/assets/74340a43-c499-4ed3-9776-8ba5ca1b5e54" />

*Detailed researcher profiles showing publications, citations, and collaboration networks*

### 📋 Project Management
<img width="1264" height="851" alt="projects" src="https://github.com/user-attachments/assets/c09c9bda-3e98-410f-acfd-3f495b52dfc9" />

*Project tracking interface with team assignments, milestones, and funding allocation*

### 📄 Publication Management
<img width="1265" height="849" alt="publications" src="https://github.com/user-attachments/assets/ae6a7d58-1bbf-4ce1-99d0-4b1d6139b8ea" />

*Publication tracking interface with categorization, citation counts, and impact metrics*

### 📈 Analytics Dashboard
<img width="1279" height="859" alt="analytics" src="https://github.com/user-attachments/assets/c04b0473-0d16-4944-9b95-cc0578273015" />

*Interactive charts showing research trends, citation impact, and trending topics*

## ⚙️ Installation Guide

### 📋 Prerequisites

#### 1. **System Requirements**
- Node.js 16+ 🟢
- MySQL 8.0+ 🐬
- npm 8+ 📦
- Git 🐙
- 4GB RAM minimum 💾
- 2GB free disk space 💽

#### 2. **Install MySQL**
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install mysql-server
sudo systemctl start mysql
sudo systemctl enable mysql

# macOS
brew install mysql
brew services start mysql

# Windows
# Download from https://dev.mysql.com/downloads/installer/
# Install MySQL Server 8.0+
```

#### 3. **Clone Repository**
```bash
git clone https://github.com/aadi-abdullah/researchnet-x.git
cd researchnet-x
```

### 🛠️ Backend Setup

#### 1. **Install Dependencies**
```bash
npm install
```

This installs:
- `express`: Web framework
- `mysql2`: MySQL database driver
- `bcryptjs`: Password hashing
- `jsonwebtoken`: Authentication
- `cors`: Cross-origin resource sharing
- `multer`: File upload handling

#### 2. **Configure Environment**
Create `.env` file in project root:
```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=Aadi950  # Your MySQL password
DB_NAME=research_db
JWT_SECRET=research-net-x-super-secret-key-2024-change-this
PORT=3000
NODE_ENV=development
```

#### 3. **Initialize Database**
```bash
# Option 1: Use the setup script
npm run setup-db

# Option 2: Manual setup
mysql -u root -p
# Then run:
# CREATE DATABASE research_db;
# USE research_db;
# SOURCE schema.sql;
# SOURCE sample_data.sql;
```

The database setup includes:
- ✅ 24 institutions with complete metadata
- ✅ 20 academic departments
- ✅ 20 researcher profiles with ORCIDs
- ✅ 20 active research projects
- ✅ 20 grants from international funding agencies
- ✅ 20 research papers with DOIs
- ✅ 20 datasets with access controls
- ✅ 30+ citations and peer reviews
- ✅ 40+ keyword associations
- ✅ 27 trend indicators

### 🚀 Running the Application

#### 1. **Start MySQL Service**
```bash
# Linux
sudo systemctl start mysql

# macOS
mysql.server start

# Windows
# Start MySQL from Services or use XAMPP/WAMP
```

#### 2. **Start Backend Server**
```bash
# Development mode with auto-reload
npm run dev

# Production mode
npm start
```

#### 3. **Verify Installation**
- 🌐 **API Server**: `http://localhost:3000`
- 📊 **Health Check**: `http://localhost:3000/api/health`
- 🔍 **API Documentation**: Available at server startup
- 🐬 **Database**: Connect via MySQL Workbench on port 3306

## 📊 API Documentation

### 🔐 Authentication Endpoints

| Method | Endpoint | Description | Required Fields |
|--------|----------|-------------|-----------------|
| `POST` | `/api/auth/register` | Register new user | `username`, `email`, `password` |
| `POST` | `/api/auth/login` | User login | `username`, `password` |
| `GET` | `/api/auth/me` | Get current user profile | `Authorization: Bearer <token>` |

### 🏛️ Institution Management

| Method | Endpoint | Description | Sample Response |
|--------|----------|-------------|-----------------|
| `GET` | `/api/institutions` | List all institutions | `[{id, name, location, type, ...}]` |
| `GET` | `/api/institutions/:id` | Get institution details | `{institution details + stats}` |
| `POST` | `/api/institutions` | Add new institution | `{success: true, institution_id: X}` |
| `PUT` | `/api/institutions/:id` | Update institution | `{success: true, message: "Updated"}` |
| `DELETE` | `/api/institutions/:id` | Delete institution | `{success: true, message: "Deleted"}` |

### 👨‍🔬 Researcher Management

| Method | Endpoint | Description | Query Parameters |
|--------|----------|-------------|------------------|
| `GET` | `/api/researchers` | List all researchers | `none` |
| `GET` | `/api/researchers/:id` | Get researcher profile | `none` |
| `GET` | `/api/researchers/advanced-search` | Advanced search | `institution_id`, `research_area`, `min_citations` |
| `POST` | `/api/researchers` | Add researcher | `full_name`, `email`, `academic_rank` |
| `PUT` | `/api/researchers/:id` | Update researcher | `researcher data` |
| `DELETE` | `/api/researchers/:id` | Delete researcher | `none` |

### 📚 Publication Management

| Method | Endpoint | Description | Request Body |
|--------|----------|-------------|--------------|
| `GET` | `/api/papers` | List all papers | `none` |
| `GET` | `/api/papers/:id` | Get paper details | `none` |
| `POST` | `/api/papers` | Add new paper | `title`, `abstract`, `authors[]`, `keywords` |
| `PUT` | `/api/papers/:id` | Update paper | `paper data` |
| `DELETE` | `/api/papers/:id` | Delete paper | `none` |

### 💰 Grant & Funding

| Method | Endpoint | Description | Validation Rules |
|--------|----------|-------------|------------------|
| `POST` | `/api/grants` | Add new grant | Unique grant number validation |
| `POST` | `/api/citations` | Add citation | Duplicate citation prevention |

### 📊 Analytics & Reports

| Method | Endpoint | Description | Data Returned |
|--------|----------|-------------|---------------|
| `GET` | `/api/statistics/dashboard` | Dashboard stats | `total_institutions`, `total_researchers`, etc. |
| `GET` | `/api/statistics/top-researchers` | Top 10 researchers | `researchers with citation counts` |
| `GET` | `/api/statistics/publications-per-year` | Yearly publications | `{year, count}` pairs |
| `GET` | `/api/statistics/project-completion` | Project status | `{status, count}` pairs |

### 🔍 Search & Discovery

| Method | Endpoint | Description | Search Types |
|--------|----------|-------------|--------------|
| `GET` | `/api/search` | Universal search | Researchers, Projects, Papers, Institutions |
| `GET` | `/api/departments` | Get departments | Filter by `institution_id` |
| `GET` | `/api/venues` | Publication venues | Journal and conference listings |

## 🔍 Sample Queries

### 1. **Top 10 Researchers by Citations**
```sql
SELECT 
    r.full_name,
    COUNT(DISTINCT cit.citation_id) as total_citations,
    COUNT(DISTINCT col.paper_id) as publications,
    i.name as institution
FROM RESEARCHER r
JOIN COLLABORATION col ON r.researcher_id = col.researcher_id
JOIN PAPER p ON col.paper_id = p.paper_id
LEFT JOIN CITATION cit ON p.paper_id = cit.cited_output_id
LEFT JOIN EMPLOYMENT e ON r.researcher_id = e.researcher_id
LEFT JOIN DEPARTMENT d ON e.department_id = d.department_id
LEFT JOIN INSTITUTION i ON d.institution_id = i.institution_id
WHERE (e.end_date IS NULL OR e.end_date > CURDATE())
GROUP BY r.researcher_id
ORDER BY total_citations DESC
LIMIT 10;
```

### 2. **Institution Research Productivity**
```sql
SELECT 
    i.name as institution,
    COUNT(DISTINCT rp.project_id) as total_projects,
    COUNT(DISTINCT ro.output_id) as total_outputs,
    COALESCE(SUM(g.grant_amount), 0) as total_funding,
    COUNT(DISTINCT e.researcher_id) as active_researchers
FROM INSTITUTION i
LEFT JOIN DEPARTMENT d ON i.institution_id = d.institution_id
LEFT JOIN RESEARCH_PROJECT rp ON d.department_id = rp.department_id
LEFT JOIN PROJECT_OUTPUT po ON rp.project_id = po.project_id
LEFT JOIN RESEARCH_OUTPUT ro ON po.output_id = ro.output_id
LEFT JOIN PROJECT_GRANT pg ON rp.project_id = pg.project_id
LEFT JOIN `GRANT` g ON pg.grant_id = g.grant_id
LEFT JOIN EMPLOYMENT e ON d.department_id = e.department_id
    AND (e.end_date IS NULL OR e.end_date > CURDATE())
GROUP BY i.institution_id
ORDER BY total_outputs DESC;
```

### 3. **Collaboration Network Analysis**
```sql
SELECT 
    r1.full_name as researcher1,
    r2.full_name as researcher2,
    COUNT(DISTINCT c1.paper_id) as coauthored_papers,
    GROUP_CONCAT(DISTINCT i1.name SEPARATOR '; ') as institutions
FROM COLLABORATION c1
JOIN COLLABORATION c2 ON c1.paper_id = c2.paper_id
JOIN RESEARCHER r1 ON c1.researcher_id = r1.researcher_id
JOIN RESEARCHER r2 ON c2.researcher_id = r2.researcher_id
JOIN EMPLOYMENT e1 ON r1.researcher_id = e1.researcher_id
JOIN EMPLOYMENT e2 ON r2.researcher_id = e2.researcher_id
JOIN DEPARTMENT d1 ON e1.department_id = d1.department_id
JOIN DEPARTMENT d2 ON e2.department_id = d2.department_id
JOIN INSTITUTION i1 ON d1.institution_id = i1.institution_id
JOIN INSTITUTION i2 ON d2.institution_id = i2.institution_id
WHERE c1.researcher_id < c2.researcher_id
    AND (e1.end_date IS NULL OR e1.end_date > CURDATE())
    AND (e2.end_date IS NULL OR e2.end_date > CURDATE())
GROUP BY r1.researcher_id, r2.researcher_id
HAVING coauthored_papers >= 2
ORDER BY coauthored_papers DESC
LIMIT 15;
```

### 4. **Funding Efficiency Analysis**
```sql
SELECT 
    g.funding_agency,
    COUNT(DISTINCT g.grant_id) as total_grants,
    SUM(g.grant_amount) as total_funding,
    COUNT(DISTINCT po.output_id) as outputs_produced,
    ROUND(SUM(g.grant_amount) / NULLIF(COUNT(DISTINCT po.output_id), 0), 2) as cost_per_output,
    ROUND(AVG(ti.trending_score), 2) as avg_impact_score
FROM `GRANT` g
LEFT JOIN PROJECT_GRANT pg ON g.grant_id = pg.grant_id
LEFT JOIN PROJECT_OUTPUT po ON pg.project_id = po.project_id
LEFT JOIN RESEARCH_OUTPUT ro ON po.output_id = ro.output_id
LEFT JOIN PAPER p ON ro.output_id = p.paper_id
LEFT JOIN TREND_INDICATOR ti ON p.paper_id = ti.paper_id
    AND ti.calculated_date = (SELECT MAX(calculated_date) FROM TREND_INDICATOR)
WHERE g.grant_status = 'Active'
GROUP BY g.funding_agency
HAVING outputs_produced > 0
ORDER BY avg_impact_score DESC;
```

### 5. **Emerging Research Topics**
```sql
SELECT 
    k.keyword_text,
    COUNT(DISTINCT pk.paper_id) as total_papers,
    COUNT(DISTINCT CASE 
        WHEN p.publication_date >= DATE_SUB(CURDATE(), INTERVAL 2 YEAR) 
        THEN pk.paper_id 
    END) as recent_papers,
    ROUND(AVG(ti.citation_growth_rate), 3) as avg_growth_rate,
    ROUND(AVG(ti.trending_score), 2) as avg_trending_score
FROM KEYWORD k
JOIN PAPER_KEYWORD pk ON k.keyword_id = pk.keyword_id
JOIN PAPER p ON pk.paper_id = p.paper_id
JOIN TREND_INDICATOR ti ON p.paper_id = ti.paper_id
WHERE ti.calculated_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
GROUP BY k.keyword_id
HAVING recent_papers >= 3
    AND avg_growth_rate > 0.15
    AND avg_trending_score > 7.0
ORDER BY avg_growth_rate DESC, avg_trending_score DESC
LIMIT 10;
```

## 🛠️ Project Structure

```
researchnet-x/
├── 📁 server/
│   ├── 📄 server.js                 # Main Express server
│   ├── 📄 package.json              # Dependencies
│   ├── 📄 .env                      # Environment variables
│   └── 📁 public/                   # Frontend static files
│       └── 📄 index.html            # Main dashboard
├── 📁 database/
│   ├── 📄 schema.sql               # Complete database schema (24 tables)
│   ├── 📄 sample_data.sql          # Pre-populated sample data
│   └── 📄 triggers.sql             # Advanced analytical queries
├── 📁 docs/
│   ├── 📄 API_Documentation.md     # Detailed API docs
│   ├── 📄 Database_Schema.pdf      # ER Diagram
│   └── 📁 screenshots/             # Application screenshots
│       ├── 📄 dashboard.png
│       ├── 📄 institution.png
│       ├── 📄 researchers.png
│       ├── 📄 projects.png
│       ├── 📄 publications.png
│       └── 📄 analytics.png
├── 📄 LICENSE                      # MIT License
├── 📄 README.md                    # This documentation
└── 📄 .gitignore                   # Git ignore file
```

### 📊 Database Statistics
- **24** Institutions (Universities)
- **20** Academic Departments
- **20** Active Researchers
- **20** Research Projects
- **20** Funding Grants
- **20** Research Papers
- **20** Datasets
- **30+** Citations
- **40+** Keyword Associations
- **27** Trend Indicators
- **15** Author Roles
- **30** Research Keywords

## 🤝 Contributing

We welcome contributions! Please follow these steps:

### 1. **Fork the Repository**
```bash
git clone https://github.com/aadi-abdullah/researchnet-x.git
cd researchnet-x
git checkout -b feature/your-feature-name
```

### 2. **Development Guidelines**
- Follow existing code style and naming conventions
- Add comments for complex logic
- Update documentation for new features
- Write meaningful commit messages

### 3. **Pull Request Process**
1. Ensure all tests pass
2. Update the README.md if needed
3. Document your changes
4. Submit pull request with detailed description

### 📋 Code Standards
- ✅ Use meaningful variable names
- ✅ Add error handling for all database operations
- ✅ Validate user input
- ✅ Follow REST API conventions
- ✅ Include proper logging

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### 📝 MIT License Summary
- ✅ **Commercial use**: Allowed
- ✅ **Modification**: Allowed
- ✅ **Distribution**: Allowed
- ✅ **Private use**: Allowed
- ✅ **Sublicensing**: Allowed
- ⚠️ **Liability**: No liability
- ⚠️ **Warranty**: No warranty

## 🙏 Acknowledgments

- **Data Sources**: Higher Education Commission (HEC) Pakistan
- **Universities**: All 24 participating Pakistani universities
- **Funding Agencies**: HEC, PSF, World Bank, EU, and others
- **Open Source**: MySQL, Node.js, Express.js communities
- **Contributors**: Project development team and testers

## 📞 Support & Contact

For support, questions, or contributions:
- **GitHub Issues**: [Create an issue](https://github.com/aadi-abdullah/researchnet-x/issues)
- **Email**: [Project maintainer email]
- **Documentation**: Check `/docs` folder for detailed guides

---

<div align="center">

### 🚀 **Ready to Transform Research Management?**

[![Star](https://img.shields.io/github/stars/aadi-abdullah/researchnet-x?style=social)](https://github.com/aadi-abdullah/researchnet-x/stargazers)
[![Fork](https://img.shields.io/github/forks/aadi-abdullah/researchnet-x?style=social)](https://github.com/aadi-abdullah/researchnet-x/network/members)
[![Issues](https://img.shields.io/github/issues/aadi-abdullah/researchnet-x)](https://github.com/aadi-abdullah/researchnet-x/issues)

**"Empowering Research Through Data-Driven Insights"**

**Developed with ❤️ for the Academic Research Community**

</div>

---

### 🔄 Quick Reference Commands

```bash
# Start MySQL (Linux)
sudo systemctl start mysql

# Start MySQL (macOS)
mysql.server start

# Initialize database
mysql -u root -p < schema.sql
mysql -u root -p research_db < sample_data.sql

# Start server
npm install
npm run dev

# Access application
http://localhost:3000
```

### 📚 Learning Resources
- [MySQL Documentation](https://dev.mysql.com/doc/)
- [Express.js Guide](https://expressjs.com/)
- [REST API Best Practices](https://restfulapi.net/)
- [Database Design Principles](https://www.databasestar.com/database-design/)

---

**Note**: This project is for educational and research purposes. Ensure compliance with data privacy regulations when deploying with real institutional data.
