This is a crawler impledmented by haskell.

## requirements
### OAuth
you have to set following values as environment variables.

```
$ export APP_HOME="/this/is/my/root"
```

## create dev env

```
cabal sandbox init
cabal install --enable-tests --only-dependencies
cabal configure --enable-tests
```

## build and test

```
cabal build && cabal test
```
