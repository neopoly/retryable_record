require 'helper'
require 'retryable_record/import'

class RetryableRecordImportTest < Spec
  # TODO de-duplicate with RetryableRecord#retryable delegation test
  describe :retryable do
    let(:record) { Class.new(FakeRecord) { include RetryableRecord }.new }
    let(:expected) do
      {
        :record   => record,
        :options  => { :attempts => 1 },
        :return   => :return
      }
    end
    let(:actual) { {} }

    it "delegates to RetryableRecord.retry" do
      method = proc do |record, options|
        actual[:record]   = record
        actual[:options]  = options
        expected[:return]
      end

      RetryableRecord.stub :retry, method do
        actual[:return] = RetryableRecord(record, expected[:options]) {}
      end

      assert_equal expected[:record], actual[:record]
      assert_equal expected[:options], actual[:options]
      assert_equal expected[:return], actual[:return]
    end
  end
end
