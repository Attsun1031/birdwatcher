{-
  Utilities
-}
module Utils (
  snake2camel,
  camel2snake
) where
import Data.Char

snake2camel = foldr convert []
  where convert '_' (w:acc) = (toUpper w):acc
        convert x acc = x:acc

camel2snake = foldr convert []
  where convert x acc = if (isUpper x)
                          then '_':(toLower x):acc
                          else x:acc
