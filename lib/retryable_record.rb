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
  def retry(record)
    yield
  rescue ActiveRecord::StaleObjectError
    record.reload
    retry
  end
  module_function :retry

  # Retries operations on an ActiveRecord.
  def retryable(&block)
    RetryableRecord.retry(self, &block)
  end
end
