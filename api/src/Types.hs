module Types where

import           Config
import           Control.Monad.Trans.Reader
import           GHC.Generics
import           Hasql.Pool
import           Servant

data State = State
    { config :: Config
    , pool   :: Pool
    } deriving Generic

mkState :: Config -> Pool -> State
mkState = State

type AppM = ReaderT State Handler

nt :: State -> AppM a -> Handler a
nt s x = runReaderT x s
