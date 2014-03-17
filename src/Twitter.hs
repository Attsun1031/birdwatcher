{-
  Twitter API
-}
{-# LANGUAGE OverloadedStrings #-}

module Twitter (
  usersShow,
  UsersShow (..)
) where

import Control.Applicative
import Control.Monad
import Web.Authenticate.OAuth as OAuth
import qualified Data.Aeson as JSON
import Network.HTTP.Conduit
import Network.HTTP.Types
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

endPoint :: String -> String
endPoint x = "https://api.twitter.com/1.1/" ++ x ++ ".json"

fetch :: OAuth.OAuth -> OAuth.Credential -> Method -> String -> SimpleQuery -> IO UsersShow
fetch oa cred mth apiName query = withManager $ \man -> do
  req <- parseUrl (endPoint apiName)
  req' <- signOAuth oa cred (req { method = mth, queryString = renderSimpleQuery True query })
  res <- httpLbs req' man
  maybe (fail "JSON decoding error") return $ JSON.decode (responseBody res)

usersShow :: SimpleQuery -> IO UsersShow
usersShow query = do
  oa <- oauth
  cred <- credential
  fetch oa cred methodGet "users/show" query

{-
main :: IO ()
main = withSocketsDo $ do
  secrets' <- secrets
  let cred = newCredential (B.pack $ accessToken secrets') (B.pack $ accessSecret secrets')
  oa <- oauth
  result <- usersShow (createOAuth (B.pack $ consumerKey secrets') (B.pack $ consumerSecret secrets')) cred [("screen_name", "__Attsun__")]
  print result
  -}
