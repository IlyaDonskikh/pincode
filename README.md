# Pin
Pin service.

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
     api_key: $app_key, 
     id: id, 
     message: $message, 
     phone: $phone, 
     attempts: $attempts, 
     expire: $expire, 
     sender_api_key: $sender_api_key
```

### Check
```ruby
POST '/v1/pins/$id/check', app_key: $app_key, code: $code
```

## Responses
if code is valid server return the status ```200```, else response will be ```403```.

## Tests

```bundle exec rake```
