#[macro_use]
extern crate rocket;

#[get("/")]
fn hello() -> &'static str {
    "Hello, world!"
}

#[get("/api")]

fn api() -> &'static str {
    "This is our API test endpoint"
}

#[launch]
fn rocket() -> _ {
    rocket::build().mount("/", routes![hello, api])
}
