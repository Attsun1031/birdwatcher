module UtilsSpec where
import Test.Hspec
import Web.Birdwatcher.Utils

main :: IO ()
main = hspec spec

spec :: Spec
spec = do
  describe "snake2camel" $ do
    it "convert snake case string to camel case" $ do
      snake2camel "snake_case" `shouldBe` "snakeCase"
    it "no modification for already camel case string" $ do
      snake2camel "camelCase" `shouldBe` "camelCase"
    it "empty string" $ do
      snake2camel "" `shouldBe` ""
