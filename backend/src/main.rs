#[macro_use]
extern crate rocket;

use std::net::{IpAddr, Ipv4Addr};

use rocket::fs::{relative, FileServer};
use rocket::tokio::sync::broadcast::channel;
use rocket::{launch, routes};
use routes::chat::models::ChatMessage;

mod auth;
mod db;
mod models;
mod routes;
// 3.12.1.104

#[launch]
async fn rocket() -> _ {
    print!("Process Started");
    let db = db::init_db().await.expect("Database initialization failed");

    rocket::build()
        .configure(rocket::Config {
            address: IpAddr::V4(Ipv4Addr::new(0, 0, 0, 0)),
            port: 9001,
            ..rocket::Config::default()
        })
        .manage(db)
        .manage(channel::<ChatMessage>(1024).0)
        .mount(
            "/api",
            routes![
                routes::auth::signup,
                routes::auth::login,
                routes::protected::protected_route,
                routes::auth::update_profile,
                routes::auth::get_profile,
                routes::auth::user_by_id,
                routes::auth::add_friend,
                routes::posts::posts::create_post,
                routes::posts::posts::get_posts,
                routes::posts::posts::delete_post,
                routes::posts::posts::your_posts,
                routes::posts::posts::posts_by_uid,
                routes::projects::projects::create_project,
                routes::projects::projects::get_projects,
                routes::projects::projects::your_projects,
                routes::projects::projects::update_project,
                routes::projects::projects::delete_project,
            ],
        )
        .mount(
            "/api/chat",
            routes![routes::chat::chat::post, routes::chat::chat::events,],
        )
        .mount("/", FileServer::from(relative!("static")))
}
