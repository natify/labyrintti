require 'spec_helper'

RSpec.describe ::Labyrintti::Base do
  let(:options) {
    {
      key: 'value'
    }
  }
  let(:gateway_options) {
    {
      service: 'TestService',
      class:   'flash'
    }
  }
  let(:default_options) {
    {
      user:     'user',
      password: 'password'
    }
  }
  let(:client) { described_class.new('user', 'password') }
  let(:success) { true }
  let(:body) { '' }
  let(:response) { double('response', success?: success, body: body) }

  subject { client }

  context '#faraday_options' do
    subject { super().faraday_options }
    it { is_expected.to eq({
                             url:     'http://gw.labyrintti.com:28080',
                             headers: { accept: 'text/plain', user_agent: 'Labyrintti Ruby Client v0.0.1' }
                           }) }
  end

  context '#connection' do
    subject { super().connection }
    it { is_expected.to be_kind_of(::Faraday::Connection) }
  end

  context '#service_url' do
    context 'with secure' do
      subject { described_class.new('user', 'password', { secure: true }).service_url }
      it { is_expected.to eq('https://gw.labyrintti.com:28443') }
    end
    context 'without secure' do
      subject { super().service_url }
      it { is_expected.to eq('http://gw.labyrintti.com:28080') }
    end
  end


  context '#make_api_call' do
    let(:client) { described_class.new('user', 'password', gateway_options) }
    subject { client.make_api_call(options) }

    before :each do
      stub_request(:post, "http://gw.labyrintti.com:28080/sendsms").
        to_return(:status => 200, :body => "", :headers => {})
    end

    it 'should merge default and service options' do
      expect(options).to receive(:merge!).with(default_options)
      expect(options).to receive(:merge!).with(gateway_options)

      subject
    end
    it 'should clean empty values' do
      old_gateway_options = gateway_options.dup
      gateway_options.merge!({ foo: '', bar: '' })
      params = options.merge(default_options).merge(old_gateway_options)
      expect(client.connection).to receive(:post).with('/sendsms', params).and_return(response)
      subject
    end
    it 'should call post request' do
      params = options.merge(default_options).merge(gateway_options)
      expect(client.connection).to receive(:post).with('/sendsms', params).and_return(response)
      subject
    end
    it 'should call #process_response' do
      expect(client.connection).to receive(:post).and_return(response)
      expect(client).to receive(:process_response).with(response)
      subject
    end
    it { is_expected.to eq({ok: true}) }

  end
  context '#process_response' do
    subject { super().process_response(response) }
    context 'success' do
      it { is_expected.to be_truthy }
    end
    context 'failed' do
      let(:success) { false }
      let(:body) { 'some error' }
      it 'should call #parse_error' do
        expect(client).to receive(:parse_error).with(body)
        subject
      end
    end
  end
  context '#parse_error' do
    subject { super().parse_error(response.body) }
    let(:success) { false }
    context 'known error' do
      let(:body) { '12345 ERROR 2 1 message failed: Too short phone number' }
      it { is_expected.to eq([{
        number: '12345',
        error_code: '2',
        message_count: '1',
        description: 'message failed: Too short phone number'
      }]) }
    end
    context 'unknown error' do
      let(:body) { 'some error' }
      it { is_expected.to eq([{
        error: body
      }]) }

    end

  end
end
