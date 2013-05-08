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
end
