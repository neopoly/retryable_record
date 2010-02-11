require 'active_record'
require 'active_record/base'

# Retries an operation on an ActiveRecord until no StaleObjectError is being raised.
#
# @example
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
# @yield Operation that should be retried on failure ActiveRecord::StaleObjectError.
module RetryableRecord
  def retryable(&block)
    yield
  rescue ActiveRecord::StaleObjectError
    reload
    retry
  end
end
