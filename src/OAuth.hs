{-
  OAuth for twitterAPI
-}
{-# LANGUAGE OverloadedStrings #-}

module OAuth (
  oauth,
  credential
) where

import System.Directory (getCurrentDirectory)
import Data.ByteString.Char8 as B
import Control.Applicative
import Control.Monad
import Web.Authenticate.OAuth as OAuth
import qualified Data.Aeson as JSON


data OAuthProps = OAuthProps
  { consumerKey :: String
  , consumerSecret :: String
  , accessToken :: String
  , accessSecret :: String } deriving (Show)

instance JSON.FromJSON OAuthProps where
     parseJSON (JSON.Object v) = OAuthProps <$>
                            v JSON..: "consumerKey" <*>
                            v JSON..: "consumerSecret" <*>
                            v JSON..: "accessToken" <*>
                            v JSON..: "accessSecret"
     parseJSON _ = mzero

secrets :: IO OAuthProps
secrets = do
  currentDir <- getCurrentDirectory
  filestream <- B.readFile $ currentDir ++ "/../secrets/oauth.json"
  maybe (fail "failed to read") return $ JSON.decodeStrict filestream

oauth :: IO OAuth.OAuth
oauth = do
  key <- liftM consumerKey secrets
  secret <- liftM consumerSecret secrets
  return OAuth.newOAuth
    { OAuth.oauthServerName = "twitter"
    , OAuth.oauthRequestUri = "https://twitter.com/oauth/request_token"
    , OAuth.oauthAccessTokenUri = "https://api.twitter.com/oauth/access_token"
    , OAuth.oauthAuthorizeUri = "https://api.twitter.com/oauth/authorize"
    , OAuth.oauthSignatureMethod = OAuth.HMACSHA1
    , OAuth.oauthConsumerKey = B.pack key
    , OAuth.oauthConsumerSecret = B.pack secret
    , OAuth.oauthVersion = OAuth.OAuth10a
    }

credential :: IO OAuth.Credential
credential = do
  token <- liftM accessToken secrets
  secret <- liftM accessSecret secrets
  return $ newCredential (B.pack token) (B.pack secret)

