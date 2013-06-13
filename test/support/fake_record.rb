class FakeRecord
  include RetryableRecord

  def initialize(retries_left = 0)
    @counter = Hash.new(0)
    @counter[:retries_left] = retries_left
  end

  def reload
    counter[:reloads] += 1
    self
  end

  def save!
    counter[:saves] += 1
  end

  def count_saves
    counter[:saves]
  end

  def count_reloads
    counter[:reloads]
  end

  def concurrent_modification!
    if retries_left?
      counter[:retries_left] -= 1
      raise ActiveRecord::StaleObjectError.new self, :save
    end
  end

  private

  attr_reader :counter

  def retries_left?
    counter[:retries_left] > 0
  end
end
