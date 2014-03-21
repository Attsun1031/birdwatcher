{-
  Twitter users/show API
-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Web.Birdwatcher.UserTimeline (
  userTimeline,
  UserTimeline (..)
) where

import GHC.Generics
import qualified Data.Aeson as JSON
import Data.Aeson.Types
import Network.HTTP.Types
import Web.Birdwatcher.Base


data UserTimeline = UserTimeline
  { id :: Int
  , text :: String
  , retweetCount :: Int
  , favoriteCount :: Int
  } deriving (Show, Eq, Generic)

instance JSON.FromJSON UserTimeline where
  parseJSON = JSON.genericParseJSON options

userTimeline :: SimpleQuery -> IO [UserTimeline]
userTimeline = callTwitterAPI "statuses/user_timeline" methodGet

