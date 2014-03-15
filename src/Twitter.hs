{-
  Twitter API
-}
{-# LANGUAGE OverloadedStrings #-}

module Twitter (
  usersShow,
  UsersShow (..),
  createOAuth
) where

import Data.ByteString.Char8 as B
import Control.Applicative
import Control.Monad
import Web.Authenticate.OAuth as OAuth
import qualified Data.Aeson as JSON
import Network.HTTP.Conduit
import Network.HTTP.Types
import Network (withSocketsDo)


data UsersShow = UsersShow
  { lang :: String } deriving (Show, Eq)

instance JSON.FromJSON UsersShow where
     parseJSON (JSON.Object v) = UsersShow <$>
                            v JSON..: "lang"
     parseJSON _ = mzero

data OAuthInfo = OAuthInfo
  { consumerKey :: String
  , consumerSecret :: String
  , accessToken :: String
  , accessSecret :: String } deriving (Show)

instance JSON.FromJSON OAuthInfo where
     parseJSON (JSON.Object v) = OAuthInfo <$>
                            v JSON..: "consumerKey" <*>
                            v JSON..: "consumerSecret" <*>
                            v JSON..: "accessToken" <*>
                            v JSON..: "accessSecret"
     parseJSON _ = mzero

secrets :: IO OAuthInfo
secrets = do
  filestream <- B.readFile "../secrets/oauth.json"
  maybe (fail "failed to read") return $ JSON.decodeStrict filestream

oauth :: IO OAuth.OAuth
oauth = do
  oaInfo <- secrets
  return OAuth.newOAuth
    { OAuth.oauthServerName = "twitter"
    , OAuth.oauthRequestUri = "https://twitter.com/oauth/request_token"
    , OAuth.oauthAccessTokenUri = "https://api.twitter.com/oauth/access_token"
    , OAuth.oauthAuthorizeUri = "https://api.twitter.com/oauth/authorize"
    , OAuth.oauthSignatureMethod = OAuth.HMACSHA1
    , OAuth.oauthConsumerKey = B.pack $ consumerKey oaInfo
    , OAuth.oauthConsumerSecret = B.pack $ consumerSecret oaInfo
    , OAuth.oauthVersion = OAuth.OAuth10a
    }

createOAuth :: ByteString -> ByteString -> OAuth.OAuth
createOAuth key secret = OAuth.newOAuth
    { OAuth.oauthServerName = "twitter"
    , OAuth.oauthRequestUri = "https://twitter.com/oauth/request_token"
    , OAuth.oauthAccessTokenUri = "https://api.twitter.com/oauth/access_token"
    , OAuth.oauthAuthorizeUri = "https://api.twitter.com/oauth/authorize"
    , OAuth.oauthSignatureMethod = OAuth.HMACSHA1
    , OAuth.oauthConsumerKey = key
    , OAuth.oauthConsumerSecret = secret
    , OAuth.oauthVersion = OAuth.OAuth10a
    }

endPoint :: String -> String
endPoint x = "https://api.twitter.com/1.1/" ++ x ++ ".json"

fetch :: Method -> OAuth.OAuth -> Credential -> String -> SimpleQuery -> IO UsersShow
fetch mth oauth cred apiName query = withManager $ \man -> do
  req <- parseUrl (endPoint apiName)
  req' <- signOAuth oauth cred (req { method = mth, queryString = renderSimpleQuery True query })
  res <- httpLbs req' man
  maybe (fail "JSON decoding error") return $ JSON.decode (responseBody res)

usersShow :: OAuth.OAuth -> Credential -> SimpleQuery -> IO UsersShow
usersShow oauth cred query = fetch methodGet oauth cred "users/show" query

main :: IO ()
main = withSocketsDo $ do
  secrets' <- secrets
  let cred = newCredential (B.pack $ accessToken secrets') (B.pack $ accessSecret secrets')
  oa <- oauth
  result <- usersShow (createOAuth (B.pack $ consumerKey secrets') (B.pack $ consumerSecret secrets')) cred [("screen_name", "__Attsun__")]
  print result
