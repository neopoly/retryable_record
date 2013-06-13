require 'helper'

class RetryableRecordTest < Spec
  let(:retries) { 0 }
  let(:record) { FakeRecord.new(retries) }

  describe :retry do
    before do
      RetryableRecord.retry(record) do
        record.concurrent_modification!
        record.save!
      end
    end

    describe "without retry" do
      let(:retries) { 0 }

      it "saves and does not retry" do
        assert_record :reloads => 0, :saves => 1
      end
    end

    describe "with retry once" do
      let(:retries) { 5 }

      it "saves and reloads 5 times" do
        assert_record :reloads => 5, :saves => 1
      end
    end

    it "does not rescue other errors" do
      assert_raises RuntimeError do
        record.retryable do
          raise "foo"
        end
      end

      assert_record :reloads => 0, :saves => 1
    end
  end

  describe :retryable do
    before do
      record.retryable do
        record.concurrent_modification!
        record.save!
      end
    end

    let(:retries) { 0 }

    it "saves and does not retry" do
      assert_record :reloads => 0, :saves => 1
    end
  end

  describe :retryable_with_attempts do
    let(:retries) { 2 }

    it "retries `attempts` times, before re-raising" do
      assert_raises ActiveRecord::StaleObjectError do
        record.retryable(:attempts => 1) do
          record.concurrent_modification!
          record.save!
        end
      end

      assert_record :reloads => 1, :saves => 0
    end
  end
end
