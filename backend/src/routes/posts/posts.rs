use rocket::{http::Status, serde::json::Json, State};
use surrealdb::{engine::remote::ws::Client, Surreal};

use crate::{models::CustomResponse, routes::protected::AuthenticatedUser};

use super::models::{CreatePostRequest, Post};

#[post("/create_post", data = "<post_data>")]
pub async fn create_post(
    user: AuthenticatedUser,
    db: &State<Surreal<Client>>,
    post_data: Json<CreatePostRequest>,
) -> Result<Json<CustomResponse>, Status> {
    let post = post_data.into_inner();
    let user_id: String = user.user_id;

    db.query(
        "CREATE post SET 
            user_id = $user_id, 
            title = $title, 
            content = $content, 
            tags = $tags, 
            image = $image,
            likes_count = 0,
            comments_count = 0,
            created_at = time::now()",
    )
    .bind(("user_id", user_id))
    .bind(("title", post.title))
    .bind(("content", post.content))
    .bind(("tags", post.tags.unwrap_or_default()))
    .bind(("image", post.image))
    .await
    .map_err(|e| {
        println!("Create Post Error: {}", e);
        Status::InternalServerError
    })?;

    Ok(Json(CustomResponse {
        message: String::from("Post created successfully"),
        status_code: Status::Ok,
    }))
}

#[get("/get_posts?<page>&<limit>")]
pub async fn get_posts(
    _user: AuthenticatedUser,
    db: &State<Surreal<Client>>,
    page: Option<usize>,
    limit: Option<usize>,
) -> Result<Json<Vec<Post>>, Status> {
    let page = page.unwrap_or(1);
    let limit = limit.unwrap_or(10);
    let offset = (page - 1) * limit;

    let posts: Vec<Post> = db
        .query(
            "SELECT * FROM post 
            ORDER BY created_at DESC 
            LIMIT $limit 
            START $offset",
        )
        .bind(("limit", limit))
        .bind(("offset", offset))
        .await
        .map_err(|e| {
            println!("Fetch Posts Error: {}", e);
            Status::InternalServerError
        })?
        .take(0)
        .map_err(|e| {
            println!("Fetch Posts Error: {}", e);
            Status::InternalServerError
        })?;

    Ok(Json(posts))
}

#[get("/your_posts?<page>&<limit>")]
pub async fn your_posts(
    user: AuthenticatedUser,
    db: &State<Surreal<Client>>,
    page: Option<usize>,
    limit: Option<usize>,
) -> Result<Json<Vec<Post>>, Status> {
    let user_id: String = user.user_id;
    let page = page.unwrap_or(1);
    let limit = limit.unwrap_or(10);
    let offset = (page - 1) * limit;

    let posts: Vec<Post> = db
        .query(
            "SELECT * FROM post 
            where user_id = $uid
            ORDER BY created_at DESC 
            LIMIT $limit 
            START $offset",
        )
        .bind(("limit", limit))
        .bind(("offset", offset))
        .bind(("uid", user_id))
        .await
        .map_err(|e| {
            println!("Fetch Posts Error: {}", e);
            Status::InternalServerError
        })?
        .take(0)
        .map_err(|e| {
            println!("Fetch Posts Error: {}", e);
            Status::InternalServerError
        })?;

    Ok(Json(posts))
}

#[get("/posts_by_uid/<user_id>?<page>&<limit>")]
pub async fn posts_by_uid(
    _user: AuthenticatedUser,
    db: &State<Surreal<Client>>,
    page: Option<usize>,
    limit: Option<usize>,
    user_id: Option<&str>,
) -> Result<Json<Vec<Post>>, Status> {
    let page = page.unwrap_or(1);
    let limit = limit.unwrap_or(10);
    let offset = (page - 1) * limit;
    let u = user_id.unwrap().to_string();

    let posts: Vec<Post> = db
        .query(
            "SELECT * FROM post 
            where user_id = $uid
            ORDER BY created_at DESC 
            LIMIT $limit 
            START $offset",
        )
        .bind(("limit", limit))
        .bind(("offset", offset))
        .bind(("uid", u))
        .await
        .map_err(|e| {
            println!("Fetch Posts Error: {}", e);
            Status::InternalServerError
        })?
        .take(0)
        .map_err(|e| {
            println!("Fetch Posts Error: {}", e);
            Status::InternalServerError
        })?;

    Ok(Json(posts))
}

#[delete("/delete_post/<post_id>")]
pub async fn delete_post(
    user: AuthenticatedUser,
    db: &State<Surreal<Client>>,
    post_id: &str,
) -> Result<Json<CustomResponse>, Status> {
    let full_post_id = format!("post:{}", post_id);

    let _p: Option<Post> = db.delete(("post", post_id)).await.map_err(|e| {
        println!("Post Verification Error: {}", e);
        Status::InternalServerError
    })?;

    // Ok(Json(CustomResponse {
    //     message: String::from("Post deleted successfully"),
    //     status_code: Status::Ok,
    // }));

    let post: Option<Post> = db
        .query("SELECT * FROM post WHERE id = $post_id AND user_id = $user_id")
        .bind(("post_id", full_post_id))
        .bind(("user_id", user.user_id))
        .await
        .map_err(|e| {
            println!("Post Verification Error: {}", e);
            Status::InternalServerError
        })?
        .take(0)
        .map_err(|e| {
            println!("Post Verification Error: {}", e);
            Status::InternalServerError
        })?;

    if post.is_none() {
        println!("No post with {}", post_id);

        return Err(Status::Forbidden);
    }

    let full_post_id = format!("post:{}", post_id);

    db.query("DELETE post WHERE id = $post_id")
        .bind(("post_id", full_post_id))
        .await
        .map_err(|e| {
            println!("Delete Post Error: {}", e);
            Status::InternalServerError
        })?;

    Ok(Json(CustomResponse {
        message: String::from("Post deleted successfully"),
        status_code: Status::Ok,
    }))
}
