module DB.Hasql where

import           Config
import           Control.Monad.IO.Class         (MonadIO, liftIO)
import           Control.Monad.Trans.Reader
import           Data.Generics.Internal.VL.Lens
import           Hasql.Connection
import           Hasql.Pool                     (UsageError, use)
import           Hasql.Session
import           Types

convertSettings :: PostgreSQLConfig -> Settings
convertSettings psql =
    settings "localhost" 5432 (psql ^. #username) (psql ^. #password) (psql ^. #dbname)

errOrUnpack :: MonadIO m => m a -> m (Maybe a) -> m a
errOrUnpack err handler = handler >>= \case
    Just val -> pure val
    Nothing  -> err

db :: Session a -> AppM (Either UsageError a)
db query = ask >>= \state ->
    liftIO $ use (state ^. #pool) query
