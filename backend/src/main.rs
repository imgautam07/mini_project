#[macro_use]
extern crate rocket;

use std::net::{IpAddr, Ipv4Addr};

use rocket::{launch, routes};

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
        .mount(
            "/api",
            routes![
                routes::auth::signup,
                routes::auth::login,
                routes::protected::protected_route,
                routes::auth::update_profile,
                routes::auth::get_profile,
                routes::posts::posts::create_post,
                routes::posts::posts::get_posts,
                routes::posts::posts::delete_post,
            ],
        )
}
