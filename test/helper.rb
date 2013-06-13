require 'rubygems'

require 'minitest/autorun'

require 'retryable_record'

require 'support/fake_record'

class Spec < Minitest::Spec
  # Assert internal counter of the fake +record+.
  #
  # The following counters must be provided:
  # * +:reloads+
  # * +:saves+
  #
  # == Example
  #
  #   assert_record :reloads => 2, :saves => 1
  #
  def assert_record(counter={})
    raise ":reloads missing" unless counter.key?(:reloads)
    raise ":saves missing" unless counter.key?(:saves)

    assert_equal counter[:reloads], record.count_reloads, "unexpected record reloads"
    assert_equal counter[:saves], record.count_saves, "unexpected record saves"
  end
end
