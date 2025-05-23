use bcrypt::{hash, verify, DEFAULT_COST};
use chrono::Utc;
use rocket::http::Status;
use rocket::serde::json::Json;
use rocket::{post, State};
use surrealdb::engine::remote::ws::Client;
use surrealdb::Surreal;

use crate::auth;
use crate::models::{
    AuthResponse, CustomResponse, LoginRequest, ProfileUpdateRequest, SignupRequest, User, UserInfo,
};

use super::protected::AuthenticatedUser;

#[post("/signup", data = "<signup_data>")]
pub async fn signup(
    db: &State<Surreal<Client>>,
    signup_data: Json<SignupRequest>,
) -> Result<Json<AuthResponse>, Status> {
    let form_data = signup_data.into_inner();
    let mail = form_data.email.clone();
    let password = form_data.password.clone();

    let existing_user: Option<User> = db
        .query("SELECT * FROM users WHERE email = $email")
        .bind(("email", form_data.email))
        .await
        .map_err(|_| Status::InternalServerError)?
        .take(0)
        .map_err(|_| Status::InternalServerError)?;

    if existing_user.is_some() {
        return Err(Status::Conflict);
    }

    let hashed_password =
        hash(password.as_bytes(), DEFAULT_COST).map_err(|_| Status::InternalServerError)?;

    let user_id;

    match db
        .create::<Option<User>>("users")
        .content(User {
            id: None,
            email: mail.clone(),
            password: hashed_password,
            created_at: Utc::now(),
        })
        .await
    {
        Ok(Some(user)) => {
            user_id = user.id.unwrap().to_string();
            println!("User created with ID: {:?}", user_id);
        }
        Ok(None) => {
            eprintln!("No user created, unexpected result");
            user_id = String::from("");
        }
        Err(e) => {
            eprintln!("Failed to create user: {:?}", e);
            user_id = String::from("");
        }
    }

    if user_id.is_empty() {
        return Err(Status::InternalServerError);
    }

    let token = auth::create_token(&user_id).map_err(|_| Status::InternalServerError)?;

    Ok(Json(AuthResponse { token }))
}

#[post("/login", data = "<login_data>")]
pub async fn login(
    db: &State<Surreal<Client>>,
    login_data: Json<LoginRequest>,
) -> Result<Json<AuthResponse>, Status> {
    let form_data = login_data.into_inner();

    let user: Option<User> = db
        .query("SELECT * FROM users WHERE email = $email")
        .bind(("email", form_data.email))
        .await
        .map_err(|_| Status::InternalServerError)?
        .take(0)
        .map_err(|_| Status::InternalServerError)?;

    let user = user.ok_or(Status::Unauthorized)?;

    let password_matches = verify(form_data.password.as_bytes(), &user.password)
        .map_err(|_| Status::InternalServerError)?;

    if !password_matches {
        return Err(Status::Unauthorized);
    }

    let token = auth::create_token(&user.id.unwrap().to_string())
        .map_err(|_| Status::InternalServerError)?;

    Ok(Json(AuthResponse { token }))
}

#[post("/update_profile", data = "<profile_data>")]
pub async fn update_profile(
    user: AuthenticatedUser,
    db: &State<Surreal<Client>>,
    profile_data: Json<ProfileUpdateRequest>,
) -> Result<Json<CustomResponse>, Status> {
    let profile = profile_data.into_inner();
    let uid: String = String::from(user.user_id);

    // First, check if the user profile exists
    let existing_profile: Option<UserInfo> = db
        .query("SELECT * FROM type::thing('user_profile', $id)")
        .bind(("id", uid.clone()))
        .await
        .map_err(|e| {
            println!("Database Query Error: {}", e);
            Status::InternalServerError
        })?
        .take(0)
        .map_err(|_| Status::NotFound)?;

    // If profile doesn't exist, perform an insert
    if existing_profile.is_none() {
        let idd: String = String::from(uid.clone());

        db.query(
            "CREATE type::thing('user_profile', $id) CONTENT {
                id: $id,
                name: $name,
                professions: $professions,
                experience: $experience,
                technologies: $technologies,
                friends: []
            }",
        )
        .bind(("id", idd))
        .bind(("name", profile.name))
        .bind(("professions", profile.professions))
        .bind(("experience", profile.experience))
        .bind(("technologies", profile.technologies))
        .await
        .map_err(|e| {
            println!("Database Insert Error: {}", e);
            Status::InternalServerError
        })?;

        return Ok(Json(CustomResponse {
            message: String::from("User profile created"),
            status_code: Status::Created,
        }));
    }

    db.query(
        "UPDATE type::thing('user_profile', $id) SET  {
            name: $name,
            professions: $professions,
            experience: $experience,
            technologies: $technologies,
        }",
    )
    .bind(("id", uid))
    .bind(("name", profile.name))
    .bind(("professions", profile.professions))
    .bind(("experience", profile.experience))
    .bind(("technologies", profile.technologies))
    .await
    .map_err(|e| {
        println!("Database Insert Error: {}", e);
        Status::InternalServerError
    })?;

    return Ok(Json(CustomResponse {
        message: String::from("User profile created"),
        status_code: Status::Created,
    }));
}

#[get("/get_profile")]
pub async fn get_profile(
    user: AuthenticatedUser,
    db: &State<Surreal<Client>>,
) -> Result<Json<UserInfo>, Status> {
    let user_id: String = user.user_id;

    let profile: Option<UserInfo> = db.select(("user_profile", user_id)).await.map_err(|e| {
        println!("Database Fetch Error: {}", e);
        Status::InternalServerError
    })?;

    profile.map(Json).ok_or(Status::NotFound)
}

#[get("/user_by_id/<user_id>")]
pub async fn user_by_id(
    _user: AuthenticatedUser,
    db: &State<Surreal<Client>>,
    user_id: &str,
) -> Result<Json<UserInfo>, Status> {
    let profile: Option<UserInfo> = db.select(("user_profile", user_id)).await.map_err(|e| {
        println!("Database Fetch Error: {}", e);
        Status::InternalServerError
    })?;

    profile.map(Json).ok_or(Status::NotFound)
}

#[put("/add_friend/<user_id>")]
pub async fn add_friend(
    user: AuthenticatedUser,
    db: &State<Surreal<Client>>,
    user_id: &str,
) -> Result<Json<CustomResponse>, Status> {
    let idd: String = user.user_id.clone();
    let friend_id = String::from(user_id);

    db.query("UPDATE type::thing('user_profile', $id) SET  friends += $friendId")
        .bind(("id", idd))
        .bind(("friendId", friend_id))
        .await
        .map_err(|e| {
            println!("Database Insert Error: {}", e);
            Status::InternalServerError
        })?;

    Ok(Json(CustomResponse {
        message: String::from("Friend Added"),
        status_code: Status::Ok,
    }))
}
