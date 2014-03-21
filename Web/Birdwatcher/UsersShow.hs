{-
  Twitter users/show API
-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Web.Birdwatcher.UsersShow (
  usersShow,
  UsersShow (..)
) where

import GHC.Generics
import qualified Data.Aeson as JSON
import Data.Aeson.Types
import Network.HTTP.Types
import Web.Birdwatcher.Base


data UsersShow = UsersShow
  { name :: String
  , screenName :: String
  , id :: Int
  } deriving (Show, Eq, Generic)

instance JSON.FromJSON UsersShow where
  parseJSON = JSON.genericParseJSON options

usersShow :: SimpleQuery -> IO UsersShow
usersShow = callTwitterAPI "users/show" methodGet

