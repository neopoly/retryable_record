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
        assert_equal 0, record.counter[:reload]
        assert_equal 1, record.counter[:save]
      end
    end

    describe "with retry once" do
      let(:retries) { 5 }

      it "saves and reloads 5 times" do
        assert_equal 5, record.counter[:reload]
        assert_equal 1, record.counter[:save]
      end
    end

    it "does not rescue other errors" do
      assert_raises RuntimeError do
        record.retryable do
          raise "foo"
        end
      end

      assert_equal 0, record.counter[:reload]
      assert_equal 1, record.counter[:save]
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
      assert_equal 0, record.counter[:reload]
      assert_equal 1, record.counter[:save]
    end
  end
end
