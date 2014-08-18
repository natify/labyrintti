require 'spec_helper'

RSpec.describe ::Labyrintti do
  subject { described_class }

  before :each do
    described_class.reset!
  end

  context '#reset!' do
    describe '#user_agent' do
      subject { super().user_agent }
      it { is_expected.to eq("Labyrintti Ruby Client v#{::Labyrintti::VERSION}") }
    end

    %w(user password).each do |key|
      describe "##{key}" do
        subject { super().__send__(key.to_sym) }
        it { is_expected.to be_nil }
      end
    end
    describe '#logger' do
      subject { super().logger }
      it { is_expected.to be_kind_of(::Logger) }
    end
  end

  context '#setup' do
    context 'single call' do
      it 'should set user_agent' do
        subject.setup do |c|
          c.user_agent = 'Test1245'
        end
        expect(subject.user_agent).to eq('Test1245')
      end

      it 'should set logger' do
        newlogger = ::Logger.new(STDERR)
        subject.setup do |c|
          c.logger = newlogger
        end
        expect(subject.logger).to eq(newlogger)
      end

      %w(user password).each do |key|
        it "should set #{key}" do
          subject.setup do |c|
            c.__send__("#{key}=", 'FooBar')
          end
          expect(subject.__send__(key.to_sym)).to eq('FooBar')
        end
      end
    end

    context 'double call' do
      it 'should not accept running setup more then once' do
        subject.setup do |c|
          c.user = 'user1'
        end
        subject.setup do |c|
          c.user = 'user2'
        end
        expect(subject.user).to eq('user1')
      end
    end
  end
end