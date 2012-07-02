require 'rubygems'

require 'minitest/unit'
require 'minitest/autorun'

require 'retryable_record'

class Spec < MiniTest::Spec
  class << self
    alias :context :describe
    alias :test :it
    alias :setup :before
    alias :teardown :after
  end
end

class FakeRecord
  include RetryableRecord

  attr_accessor :counter

  def initialize(retries_left = 0)
    @counter = Hash.new(0)
    @counter[:retries_left] = retries_left
  end

  def reload
    @counter[:reload] += 1
    self
  end

  def save!
    @counter[:save] += 1
  end

  def retries_left?
    @counter[:retries_left] > 0
  end

  def concurrent_modification!
    if retries_left?
      @counter[:retries_left] -= 1
      raise ActiveRecord::StaleObjectError.new self, :save
    end
  end
end
