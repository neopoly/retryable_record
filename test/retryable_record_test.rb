require 'helper'

class RetryableRecordTest < Spec
  let(:retries) { 0 }
  let(:record) { FakeRecord.new(retries) }

  setup do
    record.retryable do
      record.concurrent_modification!
      record.save!
    end
  end

  context :retryable do
    context "without retry" do
      let(:retries) { 0 }

      test "saves and does not retry" do
        assert_equal 0, record.counter[:reload]
        assert_equal 1, record.counter[:save]
      end
    end

    context "with retry once" do
      let(:retries) { 5 }

      test "saves and reloads 5 times" do
        assert_equal 5, record.counter[:reload]
        assert_equal 1, record.counter[:save]
      end
    end

    test "does not rescue other errors" do
      assert_raises RuntimeError do
        record.retryable do
          raise "foo"
        end
      end

      assert_equal 0, record.counter[:reload]
      assert_equal 1, record.counter[:save]
    end
  end
end
