module DB.Simple
    ( module DB.Simple
    , module DB.Hasql
    , module Hasql.Encoders
    , module Hasql.Session
    , module Hasql.Statement
    , Text
    ) where

import           Data.ByteString (ByteString)
import           Data.Text
import           DB.Hasql
import qualified Hasql.Decoders  as D
import           Hasql.Encoders
import           Hasql.Session
import           Hasql.Statement
import           Types

exec' :: ByteString -> a -> Params a -> Session ()
exec' sqlCode val encoder = statement val $ Statement sqlCode encoder D.noResult True

exec :: ByteString -> a -> Params a -> AppM ()
exec sqlCode val encoder = either (fail . show) pure =<< db (exec' sqlCode val encoder)

exec_ :: ByteString -> AppM ()
exec_ sqlCode = exec sqlCode () noParams
