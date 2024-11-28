use rocket::{http::Status, serde::json::Json, State};
use surrealdb::{engine::remote::ws::Client, Surreal};

use crate::{models::CustomResponse, routes::protected::AuthenticatedUser};

use super::models::{CreateProjectRequest, Project};

#[post("/create_project", data = "<project_data>")]
pub async fn create_project(
    user: AuthenticatedUser,
    db: &State<Surreal<Client>>,
    project_data: Json<CreateProjectRequest>,
) -> Result<Json<CustomResponse>, Status> {
    let project = project_data.into_inner();
    let user_id: String = user.user_id;

    let mut user_ids = project.user_ids.unwrap_or_default();
    if !user_ids.contains(&user_id) {
        user_ids.push(user_id.clone());
    }

    let _result: Option<Project> = db
        .query(
            "CREATE project SET 
                user_ids = $user_ids, 
                title = $title, 
                description = $description, 
                image = $image,
                start_date = $start_date,
                end_date = $end_date,
                status = $status,
                priority = $priority",
        )
        .bind(("user_ids", user_ids))
        .bind(("title", project.title))
        .bind(("description", project.description))
        .bind(("image", project.image))
        .bind(("start_date", project.start_date))
        .bind(("end_date", project.end_date))
        .bind(("status", project.status))
        .bind(("priority", project.priority))
        .await
        .map_err(|e| {
            println!("Create Project Error: {}", e);
            Status::InternalServerError
        })?
        .take(0)
        .map_err(|e| {
            println!("Create Project Error: {}", e);
            Status::InternalServerError
        })?;

    Ok(Json(CustomResponse {
        message: String::from("Project created successfully"),
        status_code: Status::Ok,
    }))
}

#[get("/get_projects?<page>&<limit>")]
pub async fn get_projects(
    _user: AuthenticatedUser,
    db: &State<Surreal<Client>>,
    page: Option<usize>,
    limit: Option<usize>,
) -> Result<Json<Vec<Project>>, Status> {
    let page = page.unwrap_or(1);
    let limit = limit.unwrap_or(10);
    let offset = (page - 1) * limit;

    let projects: Vec<Project> = db
        .query(
            "SELECT * FROM project 
            ORDER BY start_date DESC 
            LIMIT $limit 
            START $offset",
        )
        .bind(("limit", limit))
        .bind(("offset", offset))
        .await
        .map_err(|e| {
            println!("Fetch Projects Error: {}", e);
            Status::InternalServerError
        })?
        .take(0)
        .map_err(|e| {
            println!("Fetch Projects Error: {}", e);
            Status::InternalServerError
        })?;

    Ok(Json(projects))
}

#[get("/your_projects?<page>&<limit>")]
pub async fn your_projects(
    user: AuthenticatedUser,
    db: &State<Surreal<Client>>,
    page: Option<usize>,
    limit: Option<usize>,
) -> Result<Json<Vec<Project>>, Status> {
    let user_id: String = user.user_id;
    let page = page.unwrap_or(1);
    let limit = limit.unwrap_or(10);
    let offset = (page - 1) * limit;

    let projects: Vec<Project> = db
        .query(
            "SELECT * FROM project 
            WHERE $uid IN user_ids
            ORDER BY start_date DESC 
            LIMIT $limit 
            START $offset",
        )
        .bind(("limit", limit))
        .bind(("offset", offset))
        .bind(("uid", user_id))
        .await
        .map_err(|e| {
            println!("Fetch Projects Error: {}", e);
            Status::InternalServerError
        })?
        .take(0)
        .map_err(|e| {
            println!("Fetch Projects Error: {}", e);
            Status::InternalServerError
        })?;

    Ok(Json(projects))
}

#[put("/update_project/<project_id>", data = "<project_data>")]
pub async fn update_project(
    user: AuthenticatedUser,
    db: &State<Surreal<Client>>,
    project_id: &str,
    project_data: Json<CreateProjectRequest>,
) -> Result<Json<CustomResponse>, Status> {
    let project = project_data.into_inner();
    let user_id: String = user.user_id.clone();
    let full_project_id = format!("project:{}", project_id);

    let existing_project: Option<Project> = db
        .query("SELECT * FROM project WHERE id = $project_id AND $user_id IN user_ids")
        .bind(("project_id", full_project_id))
        .bind(("user_id", user_id.clone()))
        .await
        .map_err(|e| {
            println!("Project Verification Error: {}", e);
            Status::InternalServerError
        })?
        .take(0)
        .map_err(|e| {
            println!("Project Verification Error: {}", e);
            Status::InternalServerError
        })?;

    if existing_project.is_none() {
        return Err(Status::Forbidden);
    }

    let mut user_ids = project.user_ids.unwrap_or_default();
    if !user_ids.contains(&user_id) {
        user_ids.push(user_id.clone());
    }
    let full_project_i = format!("project:{}", project_id);

    db.query(
        "UPDATE project SET 
            user_ids = $user_ids, 
            title = $title, 
            description = $description, 
            image = $image,
            start_date = $start_date,
            end_date = $end_date,
            status = $status,
            priority = $priority 
        WHERE id = $project_id",
    )
    .bind(("project_id", full_project_i))
    .bind(("user_ids", user_ids))
    .bind(("title", project.title))
    .bind(("description", project.description))
    .bind(("image", project.image))
    .bind(("start_date", project.start_date))
    .bind(("end_date", project.end_date))
    .bind(("status", project.status))
    .bind(("priority", project.priority))
    .await
    .map_err(|e| {
        println!("Update Project Error: {}", e);
        Status::InternalServerError
    })?;

    Ok(Json(CustomResponse {
        message: String::from("Project updated successfully"),
        status_code: Status::Ok,
    }))
}

#[delete("/delete_project/<project_id>")]
pub async fn delete_project(
    user: AuthenticatedUser,
    db: &State<Surreal<Client>>,
    project_id: &str,
) -> Result<Json<CustomResponse>, Status> {
    let user_id: String = user.user_id;
    let full_project_id = format!("project:{}", project_id);

    let existing_project: Option<Project> = db
        .query("SELECT * FROM project WHERE id = $project_id AND $user_id IN user_ids")
        .bind(("project_id", full_project_id))
        .bind(("user_id", user_id))
        .await
        .map_err(|e| {
            println!("Project Verification Error: {}", e);
            Status::InternalServerError
        })?
        .take(0)
        .map_err(|e| {
            println!("Project Verification Error: {}", e);
            Status::InternalServerError
        })?;

    if existing_project.is_none() {
        return Err(Status::Forbidden);
    }

    let full_project_i = format!("project:{}", project_id);

    db.query("DELETE project WHERE id = $project_id")
        .bind(("project_id", full_project_i))
        .await
        .map_err(|e| {
            println!("Delete Project Error: {}", e);
            Status::InternalServerError
        })?;

    Ok(Json(CustomResponse {
        message: String::from("Project deleted successfully"),
        status_code: Status::Ok,
    }))
}
