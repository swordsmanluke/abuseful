require 'rspec'
require 'thread'
require './lib/peach.rb'

describe 'parallel each/map' do
  context '#peach' do
    before { @q = Queue.new }
    let(:val) { 1..10 }
    subject(:peached) { val.peach {|i| sleep(0.3 * Random.rand); @q.push i }.then { q_to_a(@q) }}

    it "is out of order - 'cause of the threading" do
      expect(peached).not_to eq(peached.sort)
    end

    it "put everything in our queue" do
      expect(peached.size).to eq val.size
    end
  end

  context "#pmap" do
    let(:val) { 1..10 }
    subject(:pmapped) { val.pmap {|i| sleep(0.1 * Random.rand); i*2 } }

    it "is out of order - 'cause of the threading" do
      expect(pmapped).not_to eq(pmapped.sort)
    end

    it "updates the values" do
      expect(pmapped.sum).to eq val.sum * 2
    end
  end
end
