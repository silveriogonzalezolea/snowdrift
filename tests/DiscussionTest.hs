{-# LANGUAGE OverloadedStrings #-}
module DiscussionTest
    ( discussionSpecs
    ) where

import TestImport
import qualified Data.Map as M
import qualified Text.XML as XML
import qualified Text.HTML.DOM as HTML

import Database.Esqueleto hiding (get)

import Data.Text as T

import Control.Monad

discussionSpecs :: Spec
discussionSpecs =
    ydescribe "discussion" $ do
        yit "loads the discussion page" $ do
            login

            get $ DiscussWikiR "snowdrift" "about"
            statusIs 200

        yit "posts some new comments" $ do
            login

            get $ NewDiscussWikiR "snowdrift" "about"

            statusIs 200
            
            let postComment stmts = do 
                [ form ] <- htmlQuery "form"

                let getAttrs = XML.elementAttributes . XML.documentRoot . HTML.parseLBS
                    Just action = M.lookup "action" $ getAttrs form

                request $ do
                    addNonce
                    setMethod "POST"
                    setUrl action
                    addPostParam "mode" "post"
                    stmts

                statusIs 303


            postComment $ do
                byLabel "Comment" "Thread 1 - root message"
            

            forM_ [1..10] $ \ i -> do
                [ Value (Just comment_id) ] <- runDB $ select $ from $ \ comment -> return (max_ $ comment ^. CommentId)

                get $ ReplyCommentR "snowdrift" "about" comment_id

                statusIs 200
            
                postComment $ do
                    byLabel "Reply" $ T.pack $ "Thread 1 - reply " ++ show i
                

                
