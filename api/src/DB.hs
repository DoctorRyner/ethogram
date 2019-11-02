{-# LANGUAGE TypeSynonymInstances #-}
{-# OPTIONS_GHC -Wno-orphans #-}

module DB
    ( module DB
    , module Control.Monad.Trans.Reader
    , module Data.Pool
    , module Database.PostgreSQL.Simple
    ) where

import           Control.Monad.IO.Class
import           Control.Monad.Trans.Reader
import           Data.ByteString.Char8              as BS
import           Data.Pool
import           Database.PostgreSQL.Simple
import           Database.PostgreSQL.Simple.ToField
import           Miso.String                        as MS

instance ToField MisoString where
    toField = Escape . BS.pack . MS.unpack
    {-# INLINE toField #-}

db :: MonadIO m => Pool a -> (a -> IO b) -> m b
db pool = liftIO . withResource pool
