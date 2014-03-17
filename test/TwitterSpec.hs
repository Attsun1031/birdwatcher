{-# LANGUAGE OverloadedStrings #-}

module TwitterSpec where
import Test.Hspec
import Twitter

main :: IO ()
main = hspec spec

spec :: Spec
spec = do
  describe "Twitter.usersShow" $ do
    it "users/show API result" $ do
      expect <- return $ UsersShow { name = "あつん", screen_name = "__Attsun__", Twitter.id = 252464840 }
      usersShow [("user_id", "252464840")] `shouldReturn` expect
