Birdwatcher is a twitter library for Haskell.

## requirements
### OAuth
Birdwatcher read json file at the following path to get information about oauth.

```
$APP_HOME/secrets/oauth.json
```

As you can see, you have to set environment variable `APP_HOME`.

```
$ export APP_HOME="/this/is/my/root"
```

And oauth.json must have followin key-value pairs.

```
{
  "consumerKey": "consumer key",
  "consumerSecret": "consumer secret",
  "accessToken": "access token",
  "accessSecret": "access secret"
}
```

## how to use
see <https://github.com/Attsun1031/birdwatcher/blob/master/test/TwitterSpec.hs>.
