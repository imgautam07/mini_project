use surrealdb::{engine::remote::ws::Client, engine::remote::ws::Ws, opt::auth::Root, Surreal};

// 3.12.1.104
pub async fn init_db() -> surrealdb::Result<Surreal<Client>> {
    let db = Surreal::new::<Ws>("3.12.1.104:8000").await?;

    db.signin(Root {
        username: "root",
        password: "root",
    })
    .await?;
    db.use_ns("test").use_db("test").await?;

    Ok(db)
}
