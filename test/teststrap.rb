require 'rubygems'
require 'riot'
require 'riot_notifier'

require 'retryable_record'

Riot.reporter = RiotNotifier

class FakeRecord
  include RetryableRecord

  attr_accessor :counter

  def initialize
    @counter = Hash.new(0)
  end

  def reload
    @counter[:reload] += 1
    self
  end

  def save
    @counter[:save] += 1
    true
  end

  def concurrent_modification!
    raise ActiveRecord::StaleObjectError
  end
end
