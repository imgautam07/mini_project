use serde::{Deserialize, Serialize};
use surrealdb::sql::Thing;

#[derive(Debug, Serialize, Deserialize)]
pub struct CreatePostRequest {
    pub title: String,
    pub content: String,
    pub tags: Option<Vec<String>>,
    pub image: Option<String>, // Base64 encoded image or URL
}


#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct Post {
   pub id: Option<Thing>,
   pub user_id: String,
   pub title: String,
   pub content: String,
   pub tags: Option<Vec<String>>,
   pub image: Option<String>,
   pub created_at: Option<String>,
   pub likes_count: Option<u32>,
   pub comments_count: Option<u32>,
}