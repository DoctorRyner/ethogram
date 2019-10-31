{-# OPTIONS_GHC -F -pgmF=record-dot-preprocessor #-}

module Types where

import           Config
import           Control.Monad.Trans.Reader
import           Data.Pool
import           Database.PostgreSQL.Simple
import           Servant

data State = State
    { pool   :: Pool Connection
    , config :: Config
    }

mkState :: Pool Connection -> Config -> State
mkState pool config = State
    { pool = pool
    , config = config
    }

type AppM = ReaderT State Handler

nt :: State -> AppM a -> Handler a
nt s x = runReaderT x s
