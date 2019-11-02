{-# OPTIONS_GHC -F -pgmF=record-dot-preprocessor #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Route.Users where

import           Data.Aeson
--import qualified Data.ByteString.Lazy.Char8 as BSL
--import           Data.Maybe
import           Data.Swagger
import           DB
import           Miso.SPA     ()
--import           Miso.String  (MisoString)
import           Servant
import           Shared.Types
import           Types
import Data.Text (Text, pack)

instance ToRow User
instance ToSchema User
instance FromRow User

get_ :: AppM [User]
get_ = ask >>= \state -> db state.pool $ \conn -> do
    users :: [User] <- query_ conn "SELECT * from users"
    pure users
--    case fromJSON users of
--        Success a -> pure [a]
--        Error e   -> error e

post_ :: User -> AppM Text
post_ user = ask >>= \state -> db state.pool $ \conn -> do
    execute conn "insert into users values (?)" $ Only $ encode user
    pure user.username

handler :: AppM [User]
      :<|> (User -> AppM Text)
handler = get_ :<|> post_

type Type = "users" :> Get '[JSON] [User]
       :<|> "users" :> ReqBody '[JSON] User :> Post '[JSON] Text
