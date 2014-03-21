{-
  Twitter API
-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Web.Birdwatcher.Base (
  options,
  callTwitterAPI
) where

import Web.Authenticate.OAuth as OAuth
import qualified Data.Aeson as JSON
import Data.Aeson.Types
import Network.HTTP.Conduit
import Network.HTTP.Types (SimpleQuery, Method, renderSimpleQuery)
import Web.Birdwatcher.OAuth
import Web.Birdwatcher.Utils


options :: Options
options = Options
  { fieldLabelModifier = camel2snake
  , constructorTagModifier = constructorTagModifier defaultOptions
  , allNullaryToStringTag = allNullaryToStringTag defaultOptions
  , omitNothingFields = omitNothingFields defaultOptions
  , sumEncoding = sumEncoding defaultOptions
  }

endPoint :: String -> String
endPoint x = "https://api.twitter.com/1.1/" ++ x ++ ".json"

fetch :: (JSON.FromJSON t) => OAuth.OAuth -> OAuth.Credential -> Method -> String -> SimpleQuery -> IO t
fetch oa cred mth u query = withManager $ \man -> do
  req <- parseUrl u
  req' <- signOAuth oa cred (req { method = mth, queryString = renderSimpleQuery True query })
  res <- httpLbs req' man
  either (\s -> fail s) return $ JSON.eitherDecode (responseBody res)

callTwitterAPI :: (JSON.FromJSON t) => String -> Method -> SimpleQuery -> IO t
callTwitterAPI apiName m query = do
  oa <- oauth
  cred <- credential
  fetch oa cred m (endPoint apiName) query

{-
main :: IO ()
main = withSocketsDo $ do
  --result <- usersShow (createOAuth (B.pack $ consumerKey secrets') (B.pack $ consumerSecret secrets')) cred [("screen_name", "__Attsun__")]
  result <- userTimeline [("screen_name", "__Attsun__")]
  print result
  -}
