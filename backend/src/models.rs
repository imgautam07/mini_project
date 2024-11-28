use rocket::http::Status;
use serde::{Deserialize, Serialize};
use surrealdb::sql::Thing;

#[derive(Debug, Serialize, Deserialize)]
pub struct User {
    pub id: Option<Thing>,
    pub email: String,
    pub password: String, // Stored as bcrypt hash
    pub created_at: chrono::DateTime<chrono::Utc>,
}
#[derive(Debug, Serialize, Deserialize)]
pub struct UserInfo {
    pub id: Option<Thing>,
    name: String,
    professions: Vec<String>,
    experience: String,
    technologies: Vec<String>,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct SignupRequest {
    pub email: String,
    pub password: String,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct ProfileUpdateRequest {
    pub name: String,
    pub professions: Vec<String>,
    pub experience: String,
    pub technologies: Vec<String>,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct LoginRequest {
    pub email: String,
    pub password: String,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct AuthResponse {
    pub token: String,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct  CustomResponse{
    pub message : String,
    pub status_code : Status,
}