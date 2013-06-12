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
  # == Example using attempts
  #
  #   require 'retryable_record/import'
  #
  #   RetryableRecord(user, :attempts => 3) do
  #     user.username = "foo"
  #     user.save!
  #   end
  #
  # See RetryableRecord#retry
  def RetryableRecord(record, opts = {}, &block)
    RetryableRecord.retry(record, opts, &block)
  end
end
