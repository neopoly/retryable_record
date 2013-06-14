require 'helper'

class RetryableRecordTest < Spec
  let(:retries) { 0 }
  let(:record) { FakeRecord.new(retries) }

  describe :retry do
    describe "without retries" do
      let(:retries) { 0 }

      it "saves and does not retry" do
        RetryableRecord.retry(record) do
          record.concurrent_modification!
          record.save!
        end

        assert_record :reloads => 0, :saves => 1
      end
    end

    describe "with retry once" do
      let(:retries) { 5 }

      it "saves and reloads 5 times" do
        RetryableRecord.retry(record) do
          record.concurrent_modification!
          record.save!
        end

        assert_record :reloads => 5, :saves => 1
      end
    end

    describe "with option" do
      describe :attempts do
        let(:retries) { 2 }
        let(:attempts) { retries - 1 }

        it "retries `attempts` times, before re-raising" do
          assert_raises ActiveRecord::StaleObjectError do
            RetryableRecord.retry(record, :attempts => attempts) do
              record.concurrent_modification!
              record.save!
            end
          end

          assert_record :reloads => attempts, :saves => 0
        end
      end
    end

    it "does not rescue other errors" do
      assert_raises RuntimeError do
        RetryableRecord.retry(record) do
          raise "foo"
        end
      end

      assert_record :reloads => 0, :saves => 0
    end
  end

  # TODO de-duplicate with RetryableRecord() delegation test
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
        actual[:return] = record.retryable(expected[:options]) {}
      end

      assert_equal expected[:record], actual[:record]
      assert_equal expected[:options], actual[:options]
      assert_equal expected[:return], actual[:return]
    end
  end
end
