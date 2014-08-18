require 'spec_helper'

RSpec.describe ::Labyrintti::SMS do
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

  context '#send_text' do
    it 'should failed if broken params' do
      expect { client.send_text({}) }.to raise_error('text is required param')
    end
    it 'should call #make_api_call' do
      expect(client).to receive(:make_api_call).with({
        'source-name' => 'foobar',
        'dests' => 'foowidget',
        'text' => 'Hello world!'
      })
      client.send_text(from: 'foobar', to: 'foowidget', text: 'Hello world!')
    end
    it 'should call #make_api_call properly if multiple from' do
      expect(client).to receive(:make_api_call).with({
        'source-name' => 'foobar',
        'dests' => 'foowidget,barwidget',
        'text' => 'Hello world!'
      })
      client.send_text(from: 'foobar', to: ['foowidget', 'barwidget'], text: 'Hello world!')
    end
  end

end
