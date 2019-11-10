module API where

import           Control.Monad.Trans.Class (lift)
import           Servant
import           Servant.Swagger
import           Servant.Swagger.UI
import           Types

import qualified Route.Root
import qualified Route.Users

type Routes = Route.Root.Type
         :<|> Route.Users.Type

server :: ServerT API AppM
server = serverDocs
    :<|> Route.Root.handler
    :<|> Route.Users.handler

type AppDocs = SwaggerSchemaUI "swagger-ui" "swagger.json"

type API = AppDocs :<|> Routes

api :: Proxy API
api = Proxy

serverDocs :: ServerT AppDocs AppM
serverDocs = hoistServer (Proxy :: Proxy AppDocs) lift $ swaggerSchemaUIServer (toSwagger (Proxy :: Proxy Routes))
