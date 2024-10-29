use rocket::{launch, routes};

mod auth;
mod db;
mod models;
mod routes;

#[launch]
async fn rocket() -> _ {
    let db = db::init_db().await.expect("Database initialization failed");

    rocket::build()
        .configure(rocket::Config {
            port: 9000,
            ..rocket::Config::default()
        })
        .manage(db)
        .mount(
            "/api",
            routes![
                routes::auth::signup,
                routes::auth::login,
                routes::protected::protected_route
            ],
        )
}
