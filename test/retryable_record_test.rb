require 'teststrap'

context "FakeRecord" do
  setup do
    FakeRecord.new
  end

  asserts("that block return value") do
    topic.retryable { :return_value }
  end.equals(:return_value)

  asserts("that other errors") do
    topic.retryable do
      raise "other error"
    end
  end.raises(RuntimeError, "other error")

  context "saves without retries" do
    hookup do
      topic.retryable do
        topic.save
      end
    end

    asserts("save counter") { topic.counter[:save] }.equals(1)
    asserts("reload counter") { topic.counter[:reload] }.equals(0)
  end

  context "saves with 1 retry" do
    hookup do
      topic.retryable do
        i = 0
        topic.retryable do
          if i == 0
            i += 1
            topic.concurrent_modification!
          end

          topic.save
        end
      end
    end

    asserts("save counter") { topic.counter[:save] }.equals(1)
    asserts("reload counter") { topic.counter[:reload] }.equals(1)
  end
end
