# Pinc0de
Two-factor authentication service.

## Setup
Clone current repository and move to directory.

Install:

1. Ruby
2. Gems 'rubygems', 'bundler'
3. Gemfile ```bundle update```
3. Redis

Launch:

1. Start Redis (port: 6379)
2. Start application ```rackup```

## Operations

### Create
```ruby
POST '/v1/pins/', 
     app_key: $app_key, 
     id: $id, 
     message: $message, 
     phone: $phone, 
     attempts: $attempts, 
     expire: $expire, # seconds
     sender: $sender_params
```

### Check
```ruby
GET '/v1/pins/$id/check', app_key: $app_key, code: $code
```

## Responses
if code is valid server return the status ```200```, else response will be ```403```.

## Setup sender

Follow instructions: https://github.com/IlyaDonskikh/pincode/wiki/Setup-SMS-sending.

## Tests

```bundle exec rake```

## Bonuces

Add this [service](https://github.com/IlyaDonskikh/pincode_account) if you want more power to control.
Also i was started a cloud service and you can try this code in production mode here: http://www.pinc0de.com/. 

## License

Pinc0de is released under the [MIT License](http://www.opensource.org/licenses/MIT).
