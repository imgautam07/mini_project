use std::net::{IpAddr, Ipv4Addr};

use rocket::{launch, routes};

mod auth;
mod db;
mod models;
mod routes;

#[launch]
async fn rocket() -> _ {
    print!("Process Started");
    let db = db::init_db().await.expect("Database initialization failed");

    rocket::build()
        .configure(rocket::Config {
            address: IpAddr::V4(Ipv4Addr::new(0, 0, 0, 0)),
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
