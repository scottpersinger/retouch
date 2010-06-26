class Photo < ActiveRecord::Base
  belongs_to :customer

  before_destroy :delete_s3

  def s3_key
     "#{self.id}.#{self.file_name}"
  end

  def photo_url
    "https://s3.amazonaws.com/#{bucket}/#{s3_key}"
  end

  def store_file(file, content_type, file_name)
    self.file_name = file_name
    s3_upload(file, content_type, s3_key)
  end

  private
    def delete_s3
      s3_connect

      AWS::S3::S3Object.delete(self.s3_key, self.bucket)
    end

    def s3_opts
      @s3_opts ||= YAML.load(File.open(File.join(RAILS_ROOT, "config/amazon_s3.yml")))[RAILS_ENV]
    end

    def bucket
      s3_opts['bucket']
    end

    def s3_connect
       AWS::S3::Base.establish_connection!({:access_key_id => s3_opts['access_key_id'],
           :secret_access_key => s3_opts['secret_access_key']})
    end

    def s3_upload(file, content_type, asset_key)
      s3_connect

      # Ensure the bucket exists
      begin
        AWS::S3::Bucket.find(@s3_opts['bucket'])
      rescue
        AWS::S3::Bucket.create(@s3_opts['bucket'])
      end

      # Upload the file
      AWS::S3::S3Object.store(
        asset_key,
        file,
        @s3_opts['bucket'],
        {:access => :public_read,
         :ttl => 1.month,
         :content_type => content_type})
    end


end
