module Route.Users where

import           Data.Aeson
import           Data.Generics.Internal.VL.Lens
import           DB.Simple
import           DB.SimpleResult
import           Miso.String
import           Servant
import           Shared.Types
import           Types

type Type = "users" :> Get '[JSON] [User]
       :<|> "users" :> ReqBody '[JSON] User :> Post '[JSON] MisoString

get_ :: AppM [User]
get_ = mapM resToJson =<< query "select * from users" jsonListD

post_ :: User -> AppM MisoString
post_ user = do
    exec "insert into users values ($1)" (toJSON user) jsonSingleE
    pure $ user ^. #name

handler :: AppM [User]
      :<|> (User -> AppM MisoString)
handler = get_ :<|> post_
