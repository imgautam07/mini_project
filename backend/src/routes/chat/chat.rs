use super::models::ChatMessage;
use rocket::response::stream::{Event, EventStream};
use rocket::tokio::sync::broadcast::{error::RecvError, Sender};
use rocket::{form::Form, State};
use tokio::select;

#[post("/message", data = "<form_data>")]
pub fn post(form_data: Form<ChatMessage>, ws: &State<Sender<ChatMessage>>) {
    let _res = ws.send(form_data.into_inner());
}

#[get("/events")]
pub async fn events(ws: &State<Sender<ChatMessage>>) -> EventStream![] {
    let mut rx = ws.subscribe();

    EventStream! {
        loop {

            let msg = select!{
                msg = rx.recv()  => match msg{
                    Ok(msg)=> msg,
                    Err (RecvError::Closed) => break,
                    Err (RecvError::Lagged(_)) => continue,
                },
            };

            yield Event::json(&msg);
        }
    }
}
