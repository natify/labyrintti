# Labyrintti

Labirintti SMS Gateway HTTP Interface wrapper

## Installation

Add this line to your application's Gemfile:

    gem 'labyrintti'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install labyrintti

## Usage

```ruby
client = ::Labyrintti::SMS.new('user', 'password')
res = client.send_text(from: 'Alex', to: '123456789', text: 'Hello world!')
if res[:ok]
  puts "Message was sent successfully!"
else
  res[:errors].each do |error|
    puts "Was an error #{error.inspect}"
  end
end
```

For secure connection:

```ruby
client = ::Labyrintti::SMS.new('user', 'password', {secure: true})
```

## Contributing

1. Fork it ( https://github.com/dotpromo/labyrintti/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
