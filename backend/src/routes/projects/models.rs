use serde::{Deserialize, Serialize};
use surrealdb::sql::Thing;

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct Project {
    pub project_id: Option<Thing>,
    pub user_ids: Vec<String>,
    pub title: String,
    pub description: String,
    pub image: Option<String>,
    pub start_date: Option<String>,
    pub end_date: Option<String>,
    pub status: String,
    pub priority: i32,
}

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct CreateProjectRequest {
    pub user_ids: Option<Vec<String>>,
    pub title: String,
    pub description: String,
    pub image: Option<String>,
    pub start_date: Option<String>,
    pub end_date: Option<String>,
    pub status: String,
    pub priority: i32,
}