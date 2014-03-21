{-# LANGUAGE OverloadedStrings #-}

module TwitterSpec where
import Test.Hspec
import Web.Birdwatcher.UsersShow
import Web.Birdwatcher.UserTimeline
import Data.ByteString.Char8 as B

main :: IO ()
main = hspec spec

spec :: Spec
spec = do
  describe "usersShow" $ do
    it "users/show API result" $ do
      expect <- return $ UsersShow  252464840 "あつん" "__Attsun__"
      usersShow [("user_id", "252464840")] `shouldReturn` expect

  describe "userTimeline" $ do
    it "statuses/userTimeline API result" $ do
      let maxId = 446511275204296705
          message = "このイラスト、なんでみんな片目が吹っ飛んでるんだろう。｜国が違うとこんなに違う。各国別擬音の違い http://t.co/g53WQ4V6h6 @karapaiaさんから"
      expect <- return $ [UserTimeline maxId message 0 1]
      userTimeline [("screen_name", "__Attsun__"), ("count", "1"), ("max_id", B.pack $ show maxId)] `shouldReturn` expect
