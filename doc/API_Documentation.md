# 📚 ResearchNet-X API Documentation

## 📋 Table of Contents
- [Overview](#overview)
- [Authentication](#authentication-api)
- [Institutions](#institutions-api)
- [Researchers](#researchers-api)
- [Projects](#projects-api)
- [Publications](#publications-api)
- [Grants & Citations](#grants--citations-api)
- [Statistics & Analytics](#statistics--analytics-api)
- [Search](#search-api)
- [Import/Export](#importexport-api)
- [Utilities](#utilities-api)
- [Error Handling](#error-handling)
- [Rate Limiting](#rate-limiting)
- [Response Formats](#response-formats)

## 📖 Overview

ResearchNet-X provides a RESTful API for managing academic research data. All API endpoints return JSON responses and require proper authentication via JWT tokens.

### Base URL
```
http://localhost:3000/api
```

### Authentication Headers
```http
Authorization: Bearer <your-jwt-token>
Content-Type: application/json
```

## 🔐 Authentication API

### Register New User
**POST** `/api/auth/register`

Creates a new user account.

#### Request Body
```json
{
  "username": "john.doe",
  "email": "john.doe@example.com",
  "password": "SecurePass123!",
  "full_name": "John Doe"
}
```

#### Response
```json
{
  "success": true,
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "user_id": 25,
    "username": "john.doe",
    "email": "john.doe@example.com",
    "full_name": "John Doe",
    "role": "user"
  }
}
```

---

### User Login
**POST** `/api/auth/login`

Authenticates a user and returns a JWT token.

#### Request Body
```json
{
  "username": "john.doe",
  "password": "SecurePass123!"
}
```

#### Response
```json
{
  "success": true,
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "user_id": 25,
    "username": "john.doe",
    "email": "john.doe@example.com",
    "full_name": "John Doe",
    "role": "user"
  }
}
```

---

### Get Current User Profile
**GET** `/api/auth/me`

Returns the profile of the currently authenticated user.

#### Response
```json
{
  "user_id": 25,
  "username": "john.doe",
  "email": "john.doe@example.com",
  "full_name": "John Doe",
  "role": "user",
  "created_at": "2024-01-15T10:30:00Z"
}
```

## 🏛️ Institutions API

### List All Institutions
**GET** `/api/institutions`

Retrieves all institutions with optional filtering.

#### Query Parameters
| Parameter | Type | Description |
|-----------|------|-------------|
| `type` | string | Filter by institution type |
| `search` | string | Search in name/location |

#### Example Request
```http
GET /api/institutions?type=Public+University&search=Lahore
```

#### Response
```json
[
  {
    "institution_id": 1,
    "name": "University of the Punjab",
    "location": "Lahore, Punjab",
    "type": "Public University",
    "website_url": "https://pu.edu.pk",
    "established_date": "1882-10-14"
  },
  {
    "institution_id": 5,
    "name": "University of Engineering and Technology, Lahore",
    "location": "Lahore, Punjab",
    "type": "Public University",
    "website_url": "https://uet.edu.pk",
    "established_date": "1921-10-31"
  }
]
```

---

### Get Single Institution
**GET** `/api/institutions/{id}`

Retrieves detailed information about a specific institution.

#### Path Parameters
| Parameter | Type | Description |
|-----------|------|-------------|
| `id` | integer | Institution ID |

#### Response
```json
{
  "institution_id": 1,
  "name": "University of the Punjab",
  "location": "Lahore, Punjab",
  "type": "Public University",
  "website_url": "https://pu.edu.pk",
  "established_date": "1882-10-14",
  "department_count": 4,
  "researcher_count": 15,
  "departments": "Computer Science, Physics, Mathematics, Chemistry",
  "project_count": 3,
  "paper_count": 8
}
```

---

### Create New Institution
**POST** `/api/institutions`

Creates a new institution with optional departments.

#### Request Body
```json
{
  "name": "New University Islamabad",
  "location": "Islamabad, Pakistan",
  "type": "Private University",
  "established_date": "2020-01-01",
  "website_url": "https://newuniversity.edu.pk",
  "departments": [
    {
      "name": "Department of Artificial Intelligence"
    },
    {
      "name": "Department of Data Science"
    }
  ]
}
```

#### Response
```json
{
  "success": true,
  "institution_id": 25,
  "message": "Institution created successfully with 2 departments"
}
```

---

### Update Institution
**PUT** `/api/institutions/{id}`

Updates an existing institution.

#### Request Body
```json
{
  "name": "Updated University Name",
  "location": "Updated Location",
  "type": "Updated Type",
  "established_date": "2000-01-01",
  "website_url": "https://updated.edu.pk",
  "departments": [
    {
      "department_id": 1,
      "name": "Updated Department Name"
    }
  ]
}
```

#### Response
```json
{
  "success": true,
  "message": "Institution updated successfully"
}
```

---

### Delete Institution
**DELETE** `/api/institutions/{id}`

Deletes an institution and all related data (cascade delete).

#### Response
```json
{
  "success": true,
  "message": "Institution deleted successfully (4 departments and all related data removed)"
}
```

## 👨‍🔬 Researchers API

### List All Researchers
**GET** `/api/researchers`

Retrieves all researchers with their current institution and department.

#### Response
```json
[
  {
    "researcher_id": 1,
    "full_name": "Dr. Muhammad Ali",
    "email": "m.ali@pu.edu.pk",
    "orcid_id": "0000-0001-2345-6789",
    "profile_url": "https://pu.edu.pk/faculty/mali",
    "academic_rank": "Professor",
    "institution_name": "University of the Punjab",
    "department_name": "Department of Computer Science"
  }
]
```

---

### Get Researcher Details
**GET** `/api/researchers/{id}`

Retrieves detailed information about a specific researcher.

#### Response
```json
{
  "researcher_id": 1,
  "full_name": "Dr. Muhammad Ali",
  "email": "m.ali@pu.edu.pk",
  "orcid_id": "0000-0001-2345-6789",
  "profile_url": "https://pu.edu.pk/faculty/mali",
  "academic_rank": "Professor",
  "current_institution": "University of the Punjab",
  "current_department": "Department of Computer Science",
  "publication_count": 15,
  "project_count": 8,
  "citation_count": 124,
  "research_areas": "Artificial Intelligence, Machine Learning",
  "h_index": 12
}
```

---

### Advanced Researcher Search
**GET** `/api/researchers/advanced-search`

Advanced search with multiple criteria.

#### Query Parameters
| Parameter | Type | Description |
|-----------|------|-------------|
| `institution_id` | integer | Filter by institution |
| `research_area` | string | Filter by research area |
| `min_citations` | integer | Minimum citations |
| `min_h_index` | integer | Minimum h-index |

#### Example Request
```http
GET /api/researchers/advanced-search?institution_id=1&research_area=AI&min_citations=50
```

#### Response
```json
[
  {
    "researcher_id": 1,
    "full_name": "Dr. Muhammad Ali",
    "email": "m.ali@pu.edu.pk",
    "academic_rank": "Professor",
    "institution_name": "University of the Punjab",
    "publication_count": 15,
    "citation_count": 124
  }
]
```

---

### Create New Researcher
**POST** `/api/researchers`

Creates a new researcher profile.

#### Request Body
```json
{
  "full_name": "Dr. New Researcher",
  "email": "new.researcher@uni.edu.pk",
  "academic_rank": "Assistant Professor",
  "orcid_id": "0000-0000-0000-0001",
  "google_scholar_id": "https://scholar.google.com/citations?user=abc123",
  "institution_id": 1,
  "department_id": 1,
  "research_areas": "Artificial Intelligence, Machine Learning, Deep Learning"
}
```

#### Response
```json
{
  "success": true,
  "researcher_id": 21,
  "message": "Researcher created successfully"
}
```

---

### Update Researcher
**PUT** `/api/researchers/{id}`

Updates an existing researcher profile.

#### Request Body
```json
{
  "full_name": "Updated Name",
  "email": "updated@edu.pk",
  "academic_rank": "Associate Professor",
  "orcid_id": "0000-0000-0000-0002",
  "google_scholar_id": "https://scholar.google.com/updated",
  "institution_id": 2,
  "department_id": 5,
  "research_areas": "Updated Research Area"
}
```

#### Response
```json
{
  "success": true,
  "message": "Researcher updated successfully"
}
```

---

### Delete Researcher
**DELETE** `/api/researchers/{id}`

Deletes a researcher and all related data.

#### Response
```json
{
  "success": true,
  "message": "Researcher deleted successfully (all related data removed)"
}
```

## 📋 Projects API

### List All Projects
**GET** `/api/projects`

Retrieves all research projects with team and output information.

#### Response
```json
[
  {
    "project_id": 1,
    "project_title": "AI for Healthcare Diagnosis in Pakistan",
    "description": "Developing AI tools for disease diagnosis in under-resourced hospitals",
    "start_date": "2023-01-01",
    "end_date": "2025-12-31",
    "project_status": "Active",
    "department_id": 1,
    "department_name": "Department of Computer Science",
    "institution_name": "University of the Punjab",
    "team_size": 3,
    "outputs_count": 2,
    "team_members": "Dr. Muhammad Ali, Dr. Ayesha Khan, Engr. Sara Malik"
  }
]
```

---

### Get Project Details
**GET** `/api/projects/{id}`

Retrieves detailed information about a specific project.

#### Response
```json
{
  "project_id": 1,
  "project_title": "AI for Healthcare Diagnosis in Pakistan",
  "description": "Developing AI tools for disease diagnosis in under-resourced hospitals",
  "start_date": "2023-01-01",
  "end_date": "2025-12-31",
  "project_status": "Active",
  "department_id": 1,
  "department_name": "Department of Computer Science",
  "institution_name": "University of the Punjab",
  "team_members": [
    {
      "researcher_id": 1,
      "full_name": "Dr. Muhammad Ali",
      "role_in_project": "Principal Investigator"
    },
    {
      "researcher_id": 2,
      "full_name": "Dr. Ayesha Khan",
      "role_in_project": "Co-Investigator"
    }
  ],
  "outputs": [
    {
      "output_id": 1,
      "title": "Deep Learning for Medical Diagnosis in Low-Resource Settings",
      "description": "A novel CNN model for detecting tuberculosis from chest X-rays"
    }
  ],
  "grants": [
    {
      "grant_id": 1,
      "grant_title": "HEC National Research Program for Universities",
      "funding_agency": "Higher Education Commission (HEC)",
      "allocation_amount": 2500000.00,
      "start_date": "2023-01-01",
      "end_date": "2025-12-31"
    }
  ],
  "funding_amount": 2500000.00
}
```

---

### Create New Project
**POST** `/api/projects`

Creates a new research project.

#### Request Body
```json
{
  "project_title": "New AI Research Project",
  "description": "Research on advanced AI algorithms",
  "start_date": "2024-01-01",
  "end_date": "2025-12-31",
  "project_status": "Active",
  "department_id": 1,
  "team_members": [1, 2, 3]
}
```

#### Response
```json
{
  "success": true,
  "project_id": 21,
  "message": "Project created successfully"
}
```

---

### Update Project
**PUT** `/api/projects/{id}`

Updates an existing project.

#### Request Body
```json
{
  "project_title": "Updated Project Title",
  "description": "Updated project description",
  "start_date": "2024-02-01",
  "end_date": "2026-01-31",
  "project_status": "Active",
  "department_id": 2,
  "team_members": [1, 4, 5]
}
```

#### Response
```json
{
  "success": true,
  "message": "Project updated successfully"
}
```

---

### Delete Project
**DELETE** `/api/projects/{id}`

Deletes a project and its related data.

#### Response
```json
{
  "success": true,
  "message": "Project deleted successfully"
}
```

## 📄 Publications API

### List All Papers
**GET** `/api/papers`

Retrieves all research papers.

#### Response
```json
[
  {
    "output_id": 1,
    "title": "Deep Learning for Medical Diagnosis in Low-Resource Settings",
    "description": "A novel CNN model for detecting tuberculosis from chest X-rays in Pakistani hospitals",
    "created_date": "2024-05-15",
    "visibility_status": "Public",
    "abstract": "This paper presents a novel Convolutional Neural Network (CNN) architecture...",
    "publication_date": "2024-06-10",
    "manuscript_status": "Published",
    "doi": "10.1234/pjs.2024.001",
    "venue_name": "Pakistan Journal of Science",
    "venue_type": "journal",
    "publisher": "Pakistan Academy of Sciences",
    "citation_count": 8,
    "authors": "Dr. Muhammad Ali, Dr. Ayesha Khan, Engr. Sara Malik"
  }
]
```

---

### Get Paper Details
**GET** `/api/papers/{id}`

Retrieves detailed information about a specific paper.

#### Response
```json
{
  "output_id": 1,
  "title": "Deep Learning for Medical Diagnosis in Low-Resource Settings",
  "description": "A novel CNN model for detecting tuberculosis from chest X-rays in Pakistani hospitals",
  "created_date": "2024-05-15",
  "visibility_status": "Public",
  "abstract": "This paper presents a novel Convolutional Neural Network (CNN) architecture...",
  "publication_date": "2024-06-10",
  "manuscript_status": "Published",
  "doi": "10.1234/pjs.2024.001",
  "venue_name": "Pakistan Journal of Science",
  "venue_type": "journal",
  "publisher": "Pakistan Academy of Sciences",
  "authors": [
    {
      "researcher_id": 1,
      "full_name": "Dr. Muhammad Ali",
      "role_name": "First Author"
    },
    {
      "researcher_id": 2,
      "full_name": "Dr. Ayesha Khan",
      "role_name": "Co-author"
    }
  ],
  "citation_count": 8,
  "keywords": ["machine learning", "artificial intelligence", "healthcare"]
}
```

---

### Create New Paper
**POST** `/api/papers`

Creates a new research paper.

#### Request Body
```json
{
  "title": "New Research Paper on Quantum Computing",
  "abstract": "Abstract text for the new paper",
  "publication_date": "2024-12-01",
  "manuscript_status": "Submitted",
  "doi": "10.1234/new.2024.001",
  "venue_id": 1,
  "authors": [1, 2, 3],
  "keywords": "quantum computing, machine learning, ai"
}
```

#### Response
```json
{
  "success": true,
  "output_id": 21,
  "message": "Paper created successfully"
}
```

---

### Update Paper
**PUT** `/api/papers/{id}`

Updates an existing paper.

#### Request Body
```json
{
  "title": "Updated Paper Title",
  "abstract": "Updated abstract text",
  "publication_date": "2024-12-15",
  "manuscript_status": "Accepted",
  "doi": "10.1234/updated.2024.001",
  "venue_id": 2,
  "authors": [1, 4, 5],
  "keywords": "updated, keywords, list"
}
```

#### Response
```json
{
  "success": true,
  "message": "Paper updated successfully"
}
```

---

### Delete Paper
**DELETE** `/api/papers/{id}`

Deletes a paper and all related data.

#### Response
```json
{
  "success": true,
  "message": "Paper deleted successfully (all related data removed)"
}
```

## 💰 Grants & Citations API

### Create New Citation
**POST** `/api/citations`

Creates a citation relationship between papers.

#### Request Body
```json
{
  "citing_paper_id": 1,
  "cited_paper_id": 2,
  "citation_date": "2024-12-01"
}
```

#### Response
```json
{
  "success": true,
  "citation_id": 31,
  "message": "Citation added successfully"
}
```

---

### Create New Grant
**POST** `/api/grants`

Creates a new research grant.

#### Request Body
```json
{
  "grant_title": "Advanced AI Research Grant 2024",
  "funding_agency": "Higher Education Commission (HEC)",
  "grant_number": "HEC-AI-2024-001",
  "start_date": "2024-01-01",
  "end_date": "2026-12-31",
  "total_amount": 10000000.00,
  "grant_status": "Active",
  "project_ids": [1, 2, 3],
  "allocation_amount": 3333333.33
}
```

#### Response
```json
{
  "success": true,
  "grant_id": 21,
  "message": "Grant added successfully"
}
```

## 📊 Statistics & Analytics API

### Dashboard Statistics
**GET** `/api/statistics/dashboard`

Returns high-level statistics for the dashboard.

#### Response
```json
{
  "total_institutions": 24,
  "total_researchers": 20,
  "total_projects": 20,
  "total_papers": 20,
  "total_citations": 30,
  "active_funding": 15000000.00
}
```

---

### Publications Per Year
**GET** `/api/statistics/publications-per-year`

Returns publication count grouped by year.

#### Response
```json
[
  {
    "year": 2023,
    "count": 8
  },
  {
    "year": 2024,
    "count": 12
  }
]
```

---

### Project Completion Status
**GET** `/api/statistics/project-completion`

Returns project count grouped by status.

#### Response
```json
[
  {
    "project_status": "Active",
    "count": 15
  },
  {
    "project_status": "Completed",
    "count": 5
  }
]
```

---

### Top Researchers
**GET** `/api/statistics/top-researchers`

Returns top 10 researchers by citation count.

#### Response
```json
[
  {
    "researcher_id": 1,
    "full_name": "Dr. Muhammad Ali",
    "citation_count": 124,
    "paper_count": 15,
    "current_institution": "University of the Punjab"
  },
  {
    "researcher_id": 2,
    "full_name": "Dr. Ayesha Khan",
    "citation_count": 89,
    "paper_count": 12,
    "current_institution": "University of the Punjab"
  }
]
```

## 🔍 Search API

### Universal Search
**GET** `/api/search`

Searches across all entities.

#### Query Parameters
| Parameter | Type | Description |
|-----------|------|-------------|
| `q` | string | Search query |

#### Example Request
```http
GET /api/search?q=Artificial+Intelligence
```

#### Response
```json
[
  {
    "type": "researcher",
    "id": 1,
    "name": "Dr. Muhammad Ali",
    "details": "m.ali@pu.edu.pk",
    "description": "Professor"
  },
  {
    "type": "project",
    "id": 1,
    "name": "AI for Healthcare Diagnosis in Pakistan",
    "details": "Active",
    "description": "Developing AI tools for disease diagnosis..."
  },
  {
    "type": "paper",
    "id": 1,
    "name": "Deep Learning for Medical Diagnosis in Low-Resource Settings",
    "details": "Published",
    "description": "A novel CNN model for detecting tuberculosis..."
  }
]
```

## 📥📤 Import/Export API

### Import Data
**POST** `/api/import/{entity}`

Imports data from CSV/Excel file.

#### Path Parameters
| Parameter | Type | Description |
|-----------|------|-------------|
| `entity` | string | Entity type (institutions, researchers, etc.) |

#### Form Data
- `file`: CSV/Excel file

#### Response
```json
{
  "success": true,
  "message": "Import for institutions received. File saved at: uploads/file-123456789.csv",
  "entity": "institutions",
  "file": {
    "fieldname": "file",
    "originalname": "institutions.csv",
    "encoding": "7bit",
    "mimetype": "text/csv",
    "size": 12345
  }
}
```

---

### Export Data
**GET** `/api/export/{entity}`

Exports data to CSV or JSON format.

#### Path Parameters
| Parameter | Type | Description |
|-----------|------|-------------|
| `entity` | string | Entity type (institutions, researchers, etc.) |

#### Query Parameters
| Parameter | Type | Description |
|-----------|------|-------------|
| `format` | string | Export format (csv, json) |

#### Example Request
```http
GET /api/export/researchers?format=csv
```

#### Response
CSV file download or JSON response based on format.

## 🛠️ Utilities API

### Get Departments by Institution
**GET** `/api/departments`

Returns departments, optionally filtered by institution.

#### Query Parameters
| Parameter | Type | Description |
|-----------|------|-------------|
| `institution_id` | integer | Filter by institution |

#### Response
```json
[
  {
    "department_id": 1,
    "name": "Department of Computer Science",
    "institution_id": 1
  },
  {
    "department_id": 2,
    "name": "Department of Physics",
    "institution_id": 1
  }
]
```

---

### Get Publication Venues
**GET** `/api/venues`

Returns all publication venues.

#### Response
```json
[
  {
    "venue_id": 1,
    "name": "Pakistan Journal of Science",
    "venue_type": "journal",
    "publisher": "Pakistan Academy of Sciences",
    "open_access_flag": true,
    "issn": "0030-9876",
    "website_url": "https://pjs.org.pk"
  }
]
```

---

### Create Publication Venue
**POST** `/api/venues`

Creates a new publication venue.

#### Request Body
```json
{
  "name": "Journal of New Science",
  "venue_type": "journal",
  "publisher": "New Publisher"
}
```

#### Response
```json
{
  "success": true,
  "venue_id": 21,
  "message": "Venue added successfully"
}
```

---

### System Health Check
**GET** `/api/health`

Returns system status and available endpoints.

#### Response
```json
{
  "status": "OK",
  "timestamp": "2024-12-15T10:30:00Z",
  "database": "Connected",
  "endpoints": [
    "/api/institutions",
    "/api/researchers",
    "/api/projects",
    "/api/papers",
    "/api/statistics/dashboard",
    "/api/search"
  ]
}
```

## ⚠️ Error Handling

### Error Response Format
```json
{
  "error": "Error message description",
  "message": "Detailed error message",
  "code": "ERROR_CODE_IF_APPLICABLE"
}
```

### Common Error Codes

| Status Code | Error | Description |
|------------|-------|-------------|
| 400 | Bad Request | Invalid request parameters |
| 401 | Unauthorized | Missing or invalid authentication |
| 403 | Forbidden | Insufficient permissions |
| 404 | Not Found | Resource not found |
| 409 | Conflict | Duplicate entry (e.g., duplicate grant number) |
| 422 | Unprocessable Entity | Validation failed |
| 500 | Internal Server Error | Server-side error |

### Example Error Responses

#### 400 - Bad Request
```json
{
  "error": "Missing required fields",
  "message": "Project title, start date, status, and department are required fields"
}
```

#### 401 - Unauthorized
```json
{
  "error": "Authentication required",
  "message": "No authentication token provided"
}
```

#### 404 - Not Found
```json
{
  "error": "Researcher not found",
  "message": "Researcher with ID 999 does not exist"
}
```

#### 409 - Conflict
```json
{
  "error": "Duplicate grant number",
  "message": "Grant number \"HEC-NRPU-2023-001\" already exists",
  "existing_grant": {
    "grant_id": 1,
    "grant_title": "Existing Grant Title"
  }
}
```

## 🚦 Rate Limiting

Currently, the API does not implement strict rate limiting for development purposes. In production, consider implementing:

- **100 requests per minute** per IP address
- **1000 requests per hour** per user
- **10,000 requests per day** per API key

## 📦 Response Formats

### Pagination
For endpoints returning large datasets, pagination will be implemented with:

```json
{
  "data": [...],
  "pagination": {
    "page": 1,
    "per_page": 20,
    "total": 150,
    "total_pages": 8
  }
}
```

### Filtering & Sorting
Most list endpoints support filtering and sorting via query parameters:

```http
GET /api/researchers?sort=citation_count&order=desc&limit=10
```

### Field Selection
Support for selecting specific fields (to be implemented):

```http
GET /api/researchers/1?fields=full_name,email,citation_count
```

## 🔗 Related Resources

- [Database Schema Documentation](schema.sql)
- [Sample Data Reference](sample_data.sql)
- [Frontend Integration Guide](FRONTEND_INTEGRATION.md)
- [Deployment Guide](DEPLOYMENT.md)

## 📝 Changelog

### Version 1.0.0 (Current)
- Initial API release with complete CRUD operations
- Authentication and authorization system
- Comprehensive search functionality
- Import/export capabilities
- Advanced analytics endpoints

### Planned Enhancements
- GraphQL API endpoint
- WebSocket support for real-time updates
- API versioning (v2)
- OAuth2 integration
- Rate limiting and API key management

---

**Last Updated:** January 27, 2026  
**API Version:** 1.0.0  
**Base URL:** `http://localhost:3000/api`  
**Contact:** [Your Contact Information]  
**License:** MIT