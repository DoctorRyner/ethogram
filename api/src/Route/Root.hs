module Route.Root where

import           Servant
import           Types

type Type = Get '[JSON] NoContent

handler :: AppM NoContent
handler = pure NoContent
