{-
  main runner of crawler
-}

import System.Exit

main = do
  code <- doCrawl ""
  exitWith code


doCrawl :: String -> IO ExitCode
doCrawl _ = return ExitSuccess
