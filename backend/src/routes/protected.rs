use rocket::get;
use rocket::http::Status;
use rocket::request::{FromRequest, Outcome, Request};
use rocket::serde::json::Json;
use crate::auth;

pub struct AuthenticatedUser {
    pub user_id: String,
}

#[rocket::async_trait]
impl<'r> FromRequest<'r> for AuthenticatedUser {
    type Error = ();

    async fn from_request(request: &'r Request<'_>) -> Outcome<Self, Self::Error> {
        let token = request.headers().get_one("Authorization");

        match token {
            Some(token) if token.starts_with("Bearer ") => {
                let token = token.split_at(7).1;
                match auth::verify_token(token) {
                    Ok(claims) => Outcome::Success(AuthenticatedUser {
                        user_id: claims.sub,
                    }),
                    Err(_) => Outcome::Error((Status::Unauthorized, ())),
                }
            }
            _ => Outcome::Error((Status::Unauthorized, ())),
        }
    }
}

#[get("/protected")]
pub async fn protected_route(user: AuthenticatedUser) -> Json<String> {
    Json(format!("Hello, user {}!", user.user_id))
}
