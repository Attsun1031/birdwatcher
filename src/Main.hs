{-
  main runner of crawler
-}

import System.Exit

main :: IO ()
main = do
  code <- doCrawl ""
  exitWith code


doCrawl :: String -> IO ExitCode
doCrawl _ = return ExitSuccess
