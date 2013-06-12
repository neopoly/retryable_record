require 'active_record'
require 'active_record/base'

# Retries an operation on an ActiveRecord until no StaleObjectError is being raised.
#
# == Example
#
#   class User < ActiveRecord::Base
#     include RetryableRecord
#   end
#
#   user = User.first
#
#   user.retryable do
#     user.username = "foo"
#     user.save!
#   end
#
module RetryableRecord
  # Retryable operations on an ActiveRecord +record+.
  #
  # == Example
  #
  #   RetryableRecord.retry(user) do
  #     user.username = "foo"
  #     user.save!
  #   end
  #
  def retry(record, opts = {})
    attempts = opts[:attempts]
    begin
      yield
    rescue ActiveRecord::StaleObjectError
      unless attempts.nil?
        raise unless attempts > 0
        attempts -= 1
      end
      record.reload
      retry
    end
  end
  module_function :retry

  # Retries operations on an ActiveRecord.
  def retryable(opts = {}, &block)
    RetryableRecord.retry(self, opts, &block)
  end
end
