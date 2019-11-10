module App where

import           Miso.SPA    hiding (View, node, text)
import           Miso.Styled hiding (name)
import           Types
import           Update
import           View

app :: JSM (App Model Event)
app = do
    currentURI <- getCurrentURI
    pure $ App
        { initialAction   = Init
        , model           = defaultModel { uri = currentURI }
        , Miso.SPA.update = flip Update.update
        , Miso.SPA.view   = toUnstyled . View.view
        , events          = defaultEvents
        , subs            = [ uriSub HandleURI ]
        , mountPoint      = Nothing
        }

runAppCustom :: Bool -> IO ()
runAppCustom isDebugMode = do
    putStrLn "Frontend = http://localhost:8000"
    (if isDebugMode then debug else run) 8000 $ startApp =<< app

runApp :: IO ()
runApp = runAppCustom False

debugApp :: IO ()
debugApp = runAppCustom True
