require "spec_helper"

describe BetterS3 do
  subject { described_class.new }
  let(:remote_file_name) { "somefile" }
  let(:s3_client) { mock_s3_client }

  before do
    allow(Aws::S3::Client).to receive(:new).and_return s3_client
  end

  describe "#get" do
    before do
      allow(s3_client).to receive(:get_object)
      allow(File).to receive(:read).and_return remote_file_contents
    end

    let(:remote_file_contents) {
      { "foo" => "bar" }
    }

    it "downloads a copy of the remote file to the local file system" do
      expect(s3_client).
        to receive(:get_object).
        with({
               bucket: BetterS3.configuration.bucket.to_s,
               key:    remote_file_name,
             },
             target: "#{BetterS3.configuration.tmp_dir_path}/#{remote_file_name}")

      subject.get remote_file_name
    end

    it "returns the contents of the file" do
      expect(subject.get(remote_file_name)).to eq remote_file_contents
    end
  end

  describe "#put" do
    let(:obj) { { "hi" => "toyou" } }
    it "uploads the object to s3" do
      expect(s3_client).to receive(:put_object).with(bucket: BetterS3.configuration.bucket.to_s,
                                                     key:    remote_file_name,
                                                     body:   obj.to_json)

      subject.put remote_file_name, obj.to_json
    end
  end

  describe "#delete_local_file_copy" do
    it "checks to see if the file exists locally" do
      expect(File).
        to receive(:exist?).
        with("#{BetterS3.configuration.tmp_dir_path}/#{remote_file_name}").
        and_return false

      subject.delete_local_file_copy remote_file_name
    end

    context "when the file exists locally" do
      it "deletes the file from the local file system" do
        allow(File).to receive(:exist?).and_return true
        expect(File).to receive(:delete).with("#{BetterS3.configuration.tmp_dir_path}/#{remote_file_name}")

        subject.delete_local_file_copy remote_file_name
      end
    end
  end
end
