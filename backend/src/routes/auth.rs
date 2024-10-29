use bcrypt::{hash, verify, DEFAULT_COST};
use chrono::Utc;
use rocket::http::Status;
use rocket::serde::json::Json;
use rocket::{post, State};
use surrealdb::engine::remote::ws::Client;
use surrealdb::Surreal;

use crate::auth;
use crate::models::{AuthResponse, LoginRequest, SignupRequest, User};

#[post("/signup", data = "<signup_data>")]
pub async fn signup(
    db: &State<Surreal<Client>>,
    signup_data: Json<SignupRequest>,
) -> Result<Json<AuthResponse>, Status> {
    let form_data = signup_data.into_inner();
    let mail = form_data.email.clone();
    let password = form_data.password.clone();

    let existing_user: Option<User> = db
        .query("SELECT * FROM user WHERE email = $email")
        .bind(("email", form_data.email))
        .await
        .map_err(|_| Status::InternalServerError)?
        .take(0)
        .map_err(|_| Status::InternalServerError)?;

    if existing_user.is_some() {
        return Err(Status::Conflict);
    }

    // Hash password
    let hashed_password =
        hash(password.as_bytes(), DEFAULT_COST).map_err(|_| Status::InternalServerError)?;

    if let Err(e) = db
        .create::<Option<User>>("person")
        .content(User {
            id: None,
            email: mail.clone(),
            password: hashed_password,
            created_at: Utc::now(),
        })
        .await
    {
        // Log the error if creation fails
        eprintln!("Failed to create user: {:?}", e);
    }
    let token = auth::create_token(&mail).map_err(|_| Status::InternalServerError)?;

    Ok(Json(AuthResponse { token }))
}

#[post("/login", data = "<login_data>")]
pub async fn login(
    db: &State<Surreal<Client>>,
    login_data: Json<LoginRequest>,
) -> Result<Json<AuthResponse>, Status> {
    let form_data = login_data.into_inner();

    // Find user by email
    let user: Option<User> = db
        .query("SELECT * FROM user WHERE email = $email")
        .bind(("email", form_data.email))
        .await
        .map_err(|_| Status::InternalServerError)?
        .take(0)
        .map_err(|_| Status::InternalServerError)?;

    let user = user.ok_or(Status::Unauthorized)?;

    // Verify password
    let password_matches = verify(form_data.password.as_bytes(), &user.password)
        .map_err(|_| Status::InternalServerError)?;

    if !password_matches {
        return Err(Status::Unauthorized);
    }

    // Generate JWT token
    let token = auth::create_token(&user.id.unwrap().to_string())
        .map_err(|_| Status::InternalServerError)?;

    Ok(Json(AuthResponse { token }))
}
