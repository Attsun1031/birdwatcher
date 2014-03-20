{-
  Twitter API
-}
{-# LANGUAGE OverloadedStrings #-}

module Twitter (
  usersShow,
  UsersShow (..),
  userTimeline,
  UserTimeline (..)
) where

import Control.Applicative
import Control.Monad
import Web.Authenticate.OAuth as OAuth
import qualified Data.Aeson as JSON
import Network.HTTP.Conduit
import Network.HTTP.Types (SimpleQuery, Method, renderSimpleQuery, methodGet)
import OAuth


data UsersShow = UsersShow
  { name :: String
  , screen_name :: String
  , id :: Int
  } deriving (Show, Eq)

instance JSON.FromJSON UsersShow where
     parseJSON (JSON.Object v) = UsersShow <$>
                            v JSON..: "name" <*>
                            v JSON..: "screen_name" <*>
                            v JSON..: "id"
     parseJSON _ = mzero

data UserTimeline = UserTimeline
  { text :: String
  , retweet_count :: Int
  } deriving (Show, Eq)

instance JSON.FromJSON UserTimeline where
     parseJSON (JSON.Object v) = UserTimeline <$>
                            v JSON..: "text" <*>
                            v JSON..: "retweet_count"
     parseJSON _ = mzero

endPoint :: String -> String
endPoint x = "https://api.twitter.com/1.1/" ++ x ++ ".json"

fetch :: (JSON.FromJSON t) => OAuth.OAuth -> OAuth.Credential -> Method -> String -> SimpleQuery -> IO t
fetch oa cred mth url query = withManager $ \man -> do
  req <- parseUrl url
  req' <- signOAuth oa cred (req { method = mth, queryString = renderSimpleQuery True query })
  res <- httpLbs req' man
  maybe (fail "JSON decoding error") return $ JSON.decode (responseBody res)

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
