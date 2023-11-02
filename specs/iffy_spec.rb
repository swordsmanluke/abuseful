require 'rspec'
require './lib/iffy.rb'

describe 'Iffy code' do
  let(:val) { "some val" }
  let(:stuff_done) { [] }
  or_calls = 0
  let(:do_block) { Proc.new {|c| stuff_done << c } }

  subject { val.do { do_block.call _1 }.or { or_calls += 1 } }

  before do
    or_calls = 0
  end

  context 'when not nil' do
    it 'calls do block' do
      subject
      expect(stuff_done.first).to eq val
    end

    it 'does not call or block' do
      subject
      expect(or_calls).to eq 0
    end
  end

  context 'when nil' do
    let(:val) { nil }
    it 'does not call do block' do
      subject
      expect(stuff_done).to be_empty
    end

    it 'calls or block' do
      subject
      expect(or_calls).to eq 1
    end
  end

end
