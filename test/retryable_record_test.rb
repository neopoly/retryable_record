require 'teststrap'

context "retryable_record" do
  setup do
    false
  end

  asserts "i'm a failure :(" do
    topic
  end
end
