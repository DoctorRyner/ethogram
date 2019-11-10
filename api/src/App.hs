module App where

import           API
import qualified Config
import           Data.Generics.Internal.VL.Lens
import           DB.Hasql
import           DB.Migration
import qualified Hasql.Pool                     as Pool
import           Network.Wai
import           Network.Wai.Handler.Warp       as Warp
import           Network.Wai.Logger             (withStdoutLogger)
import           Network.Wai.Middleware.Cors
import           Servant
import           Types

corsWithContentType :: Middleware
corsWithContentType = cors $ const $ Just $ simpleCorsResourcePolicy
    { corsRequestHeaders = ["Content-Type"]
    , corsMethods        = "PUT" : simpleMethods
    }

mkApp :: State -> Application
mkApp state = corsWithContentType $ serve api $ hoistServer api (nt state) server

runApp :: IO ()
runApp = withStdoutLogger $ \appLogger -> do
    putStrLn "Backend = http://localhost:3000/swagger-ui"

    config <- Config.load

    let dbSettings = convertSettings $ config ^. #psql

    initDB dbSettings

    pool   <- Pool.acquire
        ( config ^. #psql . #poolSize
        , config ^. #psql . #poolConnectionTimeoutInSec
        , convertSettings $ config ^. #psql
        )

    let settings = setPort 3000
                 $ setLogger appLogger
                   defaultSettings

        defaultState = mkState config pool
        app = mkApp defaultState

    runSettings settings app
