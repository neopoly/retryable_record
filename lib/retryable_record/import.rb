require 'retryable_record'

module Kernel
  # Retryable operations on an ActiveRecord +record+.
  #
  # == Example
  #
  #   require 'retryable_record/import'
  #
  #   RetryableRecord(user) do
  #     user.username = "foo"
  #     user.save!
  #   end
  #
  # See RetryableRecord#retry
  def RetryableRecord(record, &block)
    RetryableRecord.retry(record, &block)
  end
end
