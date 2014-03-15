{-# LANGUAGE OverloadedStrings #-}

module TwitterSpec where
import Test.Hspec
import Twitter
import Web.Authenticate.OAuth as OAuth

main :: IO ()
main = hspec spec

spec :: Spec
spec = do
  describe "Prelude.head" $ do
    it "returns the first element of list" $ do
      Prelude.head [1..20] `shouldBe` (1 :: Int)

  describe "Twitter.usersShow" $ do
    it "return some response" $ do
      oauth <- return (createOAuth "key" "secret")
      cred <- return (newCredential "token" "secret")
      usersShow oauth cred [("screen_name", "__Attsun__")] `shouldReturn` UsersShow { lang = "ja" }
