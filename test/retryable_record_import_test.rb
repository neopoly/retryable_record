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

    it "saves and does not retry" do
      assert_equal 0, record.counter[:reload]
      assert_equal 1, record.counter[:save]
    end
  end

  describe :RetryableRecord_with_attempts do
    let(:retries) { 5 }

    it "retries `attempts` times, before re-raising" do
      begin
        RetryableRecord(record, :attempts => 1) do
          record.concurrent_modification!
          record.save!
        end
        assert false
      rescue ActiveRecord::StaleObjectError
        assert_equal 1, record.counter[:reload]
        assert_equal 0, record.counter[:save]
      end
    end
  end
end
