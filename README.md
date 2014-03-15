This is a crawler impledmented by haskell.

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
