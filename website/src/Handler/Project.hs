module Handler.Project (getSnowdriftProjectR) where

import Import

import Crowdmatch
import Handler.Pledge (pledgeDeleteForm, pledgeForm)
import Handler.TH
import MarkupInstances ()

-- | For MVP, there is one, hard-coded project: Snowdrift
getSnowdriftProjectR :: Handler Html
getSnowdriftProjectR = do
    muid <- fmap entityKey <$> maybeAuth
    (mpatron, project) <-
        runDB $ (,) <$> traverse fetchPatron muid <*> fetchProject
    (pledgeNoCSRF, _) <- generateFormPost (renderDivs pledgeForm)
    deletePledgeWidget <-
        maybe (pure "") (const genDeleteWidget) (patronPledgeSince =<< mpatron)
    $(widgetSass "page/snowdrift-project" "Snowdrift.coop Project")
  where
    genDeleteWidget = fst <$> generateFormPost pledgeDeleteForm
