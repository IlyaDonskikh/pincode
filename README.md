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

## Getting started
*Note: Response format - JSON.*

### Create
```POST '/v1/create', id: $token```

### Check
```POST '/v1/check', id: $token, code: $code```

if code is valid server return the status ```200```, else response will be ```403```.

## Tests

```bundle exec rake```
