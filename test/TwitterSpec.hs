{-# LANGUAGE OverloadedStrings #-}

module TwitterSpec where
import Test.Hspec
import Web.Birdwatcher.UsersShow

main :: IO ()
main = hspec spec

spec :: Spec
spec = do
  describe "Twitter.usersShow" $ do
    it "users/show API result" $ do
      expect <- return $ UsersShow "あつん" "__Attsun__" 252464840
      usersShow [("user_id", "252464840")] `shouldReturn` expect
