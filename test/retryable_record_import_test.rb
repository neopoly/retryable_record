require 'helper'
require 'retryable_record/import'

class RetryableRecordImportTest < Spec
  let(:retries) { 0 }
  let(:record) { FakeRecord.new(retries) }

  describe :RetryableRecord do
    before do
      RetryableRecord(record) do
        record.concurrent_modification!
        record.save!
      end
    end

    let(:retries) { 0 }

    it "saves and does not retry/reload" do
      assert_record :reloads => 0, :saves => 1
    end
  end

  describe :RetryableRecord_with_attempts do
    let(:retries) { 2 }

    it "retries `attempts` times, before re-raising" do
      assert_raises ActiveRecord::StaleObjectError do
        RetryableRecord(record, :attempts => 1) do
          record.concurrent_modification!
          record.save!
        end
      end

      assert_record :reloads => 1, :saves => 0
    end
  end
end
