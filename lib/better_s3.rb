require "aws-sdk"
require_relative "better_s3/configuration"
require_relative "better_s3/version"
class BetterS3
  class << self
    # Allows the user to set configuration options
    #  by yielding the configuration block
    #
    # @param opts [Hash] an optional hash of options, supported options are `reset: true`
    # @param block [Block] an optional configuration block
    # @return [Configuration] the current configuration object
    def configure(opts = {}, &_block)
      @configuration = nil if opts.key?(:reset) && opts[:reset]
      yield(configuration) if block_given?

      configuration.configure_aws
      configuration
    end

    # Returns the singleton class's configuration object
    #
    # @return [Configuration] the current configuration object
    def configuration
      @configuration ||= Configuration.new
    end

    def configured?
      !@configuration.nil?
    end

    def logger
      LincolnLogger.logger
    end
  end

  attr_accessor :s3, :_payload_body, :file_copied
  def s3
    @s3 ||= Aws::S3::Client.new
  end

  # Returns the body of the payload, retrieved from S3
  #
  # @param remote_file_name [String] the s3 bucket key
  # @return [String] the payload body from S3
  def get(remote_file_name)
    copy_file_from_s3 remote_file_name unless file_copied
    @_payload_body ||= File.read(full_file_path(remote_file_name))
  end

  # Puts a Ruby hash to s3 as a file
  #
  # @param remote_file_name [String] the s3 bucket object key where the file should be put
  # @param str [String] the string to be pushed to s3
  def put(remote_file_name, str)
    push_object_to_s3 str, remote_file_name
  end

  # Attempts to delete the local copy of the file, if it exists
  #
  # @param remote_file_name [String] the name of the file in the s3 bucket (the s3 object key)
  def delete_local_file_copy(remote_file_name)
    File.delete(full_file_path(remote_file_name)) if File.exist?(full_file_path(remote_file_name))
  end

  private

  # Puts a Ruby hash to s3 as a file
  #
  # @param hsh [String] the content to be put into s3 (it really should be JSON)
  # @param remote_file_name [String] the s3 bucket object key where the file should be put
  def push_object_to_s3(hsh, remote_file_name)
    s3.put_object(bucket: BetterS3.configuration.bucket.to_s,
                  key:    remote_file_name.to_s,
                  body:   hsh)
  end

  def copy_file_from_s3(remote_file_name)
    s3.get_object({ bucket: BetterS3.configuration.bucket.to_s, key: remote_file_name.to_s },
                  target: full_file_path(remote_file_name))
    @file_copied = true
  end

  # Returns the path on the server where the s3 file is downloaded locally
  #
  # @param remote_file_name [String] the name of the file in the s3 bucket (the s3 object key)
  # @return [String] the complete path to location of the temporary local copy of the file
  def full_file_path(remote_file_name)
    "#{BetterS3.configuration.tmp_dir_path}/#{remote_file_name}"
  end
end
