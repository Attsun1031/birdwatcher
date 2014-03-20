{-
  Twitter API
-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Twitter (
  usersShow,
  UsersShow (..),
  userTimeline,
  UserTimeline (..)
) where

import GHC.Generics
import Web.Authenticate.OAuth as OAuth
import qualified Data.Aeson as JSON
import Data.Aeson.Types
import Network.HTTP.Conduit
import Network.HTTP.Types (SimpleQuery, Method, renderSimpleQuery, methodGet)
import OAuth
import Utils


options :: Options
options = Options
  { fieldLabelModifier = camel2snake
  , constructorTagModifier = constructorTagModifier defaultOptions
  , allNullaryToStringTag = allNullaryToStringTag defaultOptions
  , omitNothingFields = omitNothingFields defaultOptions
  , sumEncoding = sumEncoding defaultOptions
  }

data UsersShow = UsersShow
  { name :: String
  , screenName :: String
  , id :: Int
  } deriving (Show, Eq, Generic)

instance JSON.FromJSON UsersShow where
  parseJSON = JSON.genericParseJSON options

data UserTimeline = UserTimeline
  { text :: String
  , retweetCount :: Int
  --, statusId :: Int
  } deriving (Show, Eq, Generic)

instance JSON.FromJSON UserTimeline where
  parseJSON = JSON.genericParseJSON options

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

usersShow :: SimpleQuery -> IO UsersShow
usersShow = callTwitterAPI "users/show" methodGet

userTimeline :: SimpleQuery -> IO [UserTimeline]
userTimeline = callTwitterAPI "statuses/user_timeline" methodGet

{-
main :: IO ()
main = withSocketsDo $ do
  --result <- usersShow (createOAuth (B.pack $ consumerKey secrets') (B.pack $ consumerSecret secrets')) cred [("screen_name", "__Attsun__")]
  result <- userTimeline [("screen_name", "__Attsun__")]
  print result
  -}
