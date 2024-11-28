use rocket::http::Status;
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

impl Post {
   pub fn new(
       user_id: String, 
       title: String, 
       content: String, 
       tags: Option<Vec<String>>, 
       image: Option<String>
   ) -> Self {
       Post {
           id: None,
           user_id,
           title,
           content,
           tags,
           image,
           created_at: Some(chrono::Utc::now().to_rfc3339()),
           likes_count: Some(0),
           comments_count: Some(0),
       }
   }
}