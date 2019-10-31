{-# OPTIONS_GHC -F -pgmF=record-dot-preprocessor #-}

module Update where

import           Miso.SPA
import           Types
import Miso.Http as Http

update :: Model -> Event -> Effect Event Model
update model = \case
    NoEvent -> pure model

    HandleURI uri -> pure model { uri = uri }
    ChangeURI uri -> model `withJS_` pushURI uri

    Init -> batchEff model $ map pure [ ReqLocale ]

    ReqLocale -> withJS model $ ResLocale <$> Http.send get { Http.url = "/locale/ru.json" }
    ResLocale resp -> fromResp resp model $ \locale -> model { locale = locale } 