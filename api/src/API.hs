{-# OPTIONS_GHC -F -pgmF=record-dot-preprocessor #-}

module API where

import Config
import           Control.Monad.Trans.Class (lift)
import           Cors
import           DB.Config
import           DB.Init
import           Log.Sentry                as Sentry
import           Network.Wai
import           Network.Wai.Handler.Warp  as Warp
import           Network.Wai.Logger        (withStdoutLogger)
import           Servant
import           Servant.Swagger
import           Servant.Swagger.UI
import           Types

import           Route.Root

type Routes = Route.Root.Type

server :: ServerT API AppM
server = serverDocs :<|> Route.Root.handler

api :: Proxy API
api = Proxy

type AppDocs = SwaggerSchemaUI "swagger-ui" "swagger.json"

serverDocs :: ServerT AppDocs AppM
serverDocs = hoistServer (Proxy :: Proxy AppDocs) lift $ swaggerSchemaUIServer (toSwagger (Proxy :: Proxy Routes))

type API = AppDocs :<|> Routes

app :: State -> Application
app state = corsWithContentType $ serve api $ hoistServer api (nt state) server

runApp :: IO ()
runApp = withStdoutLogger $ \appLogger -> do
    putStrLn "Backend = http://localhost:3000/swagger-ui"
    config <- Config.load
    pool   <- initConnectionPool $ settings config.psql
    initDB $ settings config.psql

    let settings = setPort 3000
                 $ setOnException (Sentry.sentryOnException config.sentry)
                 $ setLogger appLogger
                   defaultSettings
        defaultState = mkState pool config
    runSettings settings $ app defaultState
