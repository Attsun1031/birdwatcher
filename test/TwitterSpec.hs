{-# LANGUAGE OverloadedStrings #-}

module TwitterSpec where
import Test.Hspec
import Twitter

main :: IO ()
main = hspec spec

spec :: Spec
spec = do
  describe "Prelude.head" $ do
    it "returns the first element of list" $ do
      Prelude.head [1..20] `shouldBe` (1 :: Int)

  describe "Twitter.usersShow" $ do
    it "return some response" $ do
      usersShow [("screen_name", "__Attsun__")] `shouldReturn` UsersShow { lang = "ja" }
