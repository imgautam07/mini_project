use serde::{Deserialize, Serialize};

#[derive(Debug, FromForm, Serialize, Deserialize, Clone)]
#[serde(crate = "rocket::serde")]
pub struct ChatMessage {
    pub room: String,
    pub username: String,
    pub message: String,
}
