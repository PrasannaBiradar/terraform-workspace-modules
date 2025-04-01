provider "aws" {
    region = "us-east-1"
}

resource "aws_s3_bucket" "my_s3_bucket" {
    bucket = var.bucket_name 
}

resource "aws_s3_bucket_public_access_block" "s3_block_public_aceess" {
    bucket = aws_s3_bucket.my_s3_bucket.id

    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true    

    depends_on = [ aws_s3_bucket.my_s3_bucket ]
}

/*
resource "aws_s3_bucket_object" "s3_file_add" {
    bucket = aws_s3_bucket.my_s3_bucket.id
    key    = var.destination_path
    source = var.source_path 
    depends_on = [ aws_s3_bucket.my_s3_bucket , aws_s3_bucket_public_access_block.s3_block_public_aceess ]
}
*/

