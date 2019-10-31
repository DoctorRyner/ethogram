module DB
    ( module DB
    , module Control.Monad.Trans.Reader
    , module Data.Pool
    , module Database.PostgreSQL.Simple
    ) where

import           Control.Monad.IO.Class
import           Control.Monad.Trans.Reader
import           Data.Pool
import           Database.PostgreSQL.Simple

db :: MonadIO m => Pool a -> (a -> IO b) -> m b
db pool = liftIO . withResource pool
