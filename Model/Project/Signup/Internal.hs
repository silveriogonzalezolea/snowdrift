module Model.Project.Signup.Internal where

import Prelude (Show, Read, Eq, Enum, Bounded)

import Data.Text (Text)
import Database.Persist.TH

-- We define helper 'Enum' types, so we could derive the 'Enum' (and
-- 'Bound') instances.  This allows us to write [minBound .. maxBound]
-- instead of enumerating the constructors by hand, which is
-- error-prone.  We still have to enumerate the value constructors by
-- hand in the pretty-printing functions, but the difference is that
-- now '-Wall' will report the missing cases.

data ProjectSignupCategoryEnum = CreativeWriting
                               | Education
                               | Games
                               | HardwareDesign
                               | Journalism
                               | Music
                               | Research
                               | Software
                               | Video
                               | VisualArt
                               deriving (Eq, Show, Read, Enum, Bounded)
derivePersistField "ProjectSignupCategoryEnum"

data ProjectSignupCategory = ProjectSignupCategory ProjectSignupCategoryEnum
                           | OtherProjectSignupCategory Text
                           deriving (Eq, Show, Read)
derivePersistField "ProjectSignupCategory"

data ProjectSignupLegalStatusEnum = Unincorporated
                                  | BenefitCorp
                                  | NonProfitCoop
                                  | ForProfitCoop
                                  deriving (Eq, Show, Read, Enum, Bounded)
derivePersistField "ProjectSignupLegalStatusEnum"

data ProjectSignupLegalStatus = ProjectSignupLegalStatus ProjectSignupLegalStatusEnum
                              | OtherProjectSignupLegalStatus Text
                              deriving (Eq, Show, Read)
derivePersistField "ProjectSignupLegalStatus"
