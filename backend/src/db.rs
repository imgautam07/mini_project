use surrealdb::{engine::remote::ws::Client, engine::remote::ws::Ws, opt::auth::Root, Surreal};

pub async fn init_db() -> surrealdb::Result<Surreal<Client>> {
    let db = Surreal::new::<Ws>("127.0.0.1:8000").await?;

    db.signin(Root {
        username: "root",
        password: "root",
    })
    .await?;
    db.use_ns("test").use_db("test").await?;

    let some_queries = db
        .query(
            "
        RETURN 9; 
        RETURN 10; 
        SELECT * FROM { is: 'Nice database' };
    ",
        )
        .await?;
    dbg!(some_queries);
    Ok(db)
}
