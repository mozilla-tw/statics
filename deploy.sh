#!/bin/bash 

firebase use $PREVIEW 
firebase deploy --only hosting

sleep 10

firebase use $PROD 
firebase deploy --only hosting
