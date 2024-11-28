use aws_config::meta::region::RegionProviderChain;
use aws_sdk_s3::config::Region;
use aws_sdk_s3::Client as S3Client;
use aws_sdk_s3::primitives::ByteStream;
use rocket::{
    http::Status, 
    data::Data, 
    http::ContentType,
    serde::json::Json
};
use std::path::Path;
use uuid::Uuid;

pub struct ImageUploadConfig {
    pub bucket_name: String,
    pub region: String,
}

pub async fn upload_image(
    data: Data<'_>, 
    content_type: &ContentType,
    config: &ImageUploadConfig
) -> Result<String, Status> {
    if !content_type.is_jpeg() && !content_type.is_png() && !content_type.is_gif() {
        return Err(Status::UnsupportedMediaType);
    }

    let file_extension = match content_type {
        &ContentType::JPEG => "jpg",
        &ContentType::PNG => "png",
        &ContentType::GIF => "gif",
        _ => return Err(Status::UnsupportedMediaType),
    };
    let filename = format!(
        "{}.{}", 
        Uuid::new_v4(), 
        file_extension
    );

    let file_bytes = data.peek_complete()
        .map_err(|_| Status::InternalServerError)?
        .to_vec();

    let region_provider = RegionProviderChain::first_try(Region::new(config.region.clone()))
        .or_default_provider();
    let shared_config = aws_config::load_from_env().await;
    let client = S3Client::new(&shared_config);

    let upload_result = client
        .put_object()
        .bucket(&config.bucket_name)
        .key(&filename)
        .body(ByteStream::from(file_bytes))
        .content_type(content_type.to_string())
        .send()
        .await
        .map_err(|e| {
            println!("S3 Upload Error: {:?}", e);
            Status::InternalServerError
        })?;

    let image_url = format!(
        "https://{}.s3.{}.amazonaws.com/{}",
        config.bucket_name, 
        config.region, 
        filename
    );

    Ok(image_url)
}

#[post("/upload", data = "<image_data>")]
pub async fn upload_image_route(
    image_data: Data<'_>,
    content_type: &ContentType,
) -> Result<Json<serde_json::Value>, Status> {
    let config = ImageUploadConfig {
        bucket_name: std::env::var("AWS_S3_BUCKET")
            .expect("AWS_S3_BUCKET must be set"),
        region: std::env::var("AWS_REGION")
            .unwrap_or_else(|_| "us-east-1".to_string()),
    };

    let image_url = upload_image(image_data, content_type, &config)
        .await?;

    Ok(Json(serde_json::json!({
        "url": image_url,
        "message": "Image uploaded successfully"
    })))
}