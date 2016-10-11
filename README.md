# better_s3
An idiomatic pattern for working with s3 in Ruby

[![CircleCI](https://circleci.com/gh/Referly/better_s3.svg?style=svg)](https://circleci.com/gh/Referly/better_s3)

## Get the contents of a remote file

```ruby
require "better_s3"
s3 = BetterS3.new
s3.get "some-filename.txt"
 => "filescontentshere"
```

## Delete local copy of remote file

When downloading files from s3 there are benefits associated with storing a copy locally (most notably it enables
retry during download). As such BetterS3 stores a copy of files you get locally. If you want to delete one ...

```ruby
require "better_s3"
s3 = BetterS3.new
s3.delete_local_file_copy "some-filename.txt"
```

## Put an arbitrary String to a remote file

```ruby
require "better_s3"
s3 = BetterS3.new
content = { foo: "bar" }.to_json
s3.put content, "filename.ext"
```

## Configuration

To configure BetterS3 use the configuration block pattern

```ruby
require "better_s3"
BetterS3.configure do |config|
    # The name of the S3 bucket you plan to interact with
    config.bucket = "your-bucket-name"
    
    # The local path you want to use for temporary file
    # storage
    config.tmp_dir_path = "../tmp"
    
    # If you want to hardcode which region of SQS should be used then you can set this option. It is recommended
    # to use the environment variable ENV["AWS_REGION"] instead
    config.region = "us-west-2"
    
    # for aws_access_key_id and aws_secret_access_key you can set them in this fashion, but it is strongly
    # recommended that you just use the environment variables instead: ENV["AWS_ACCESS_KEY_ID"], 
    # ENV["AWS_SECRET_ACCESS_KEY"]
end
```