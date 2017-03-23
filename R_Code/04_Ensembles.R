setwd("~/Dropbox/Kaggle/predictions")
#eleastic <- read.csv('en_TEST_pred.csv')
#ridge    <- read.csv('ridge_TEST_pred.csv')
#gbm_h2o  <- read.csv('gmb_predictions.csv')
#xgb      <- read.csv('xgb.csv')
#ranger   <- read.csv('ranger_TEST_pred.csv')
#xgb       <- read.csv('xgb.csv')
#xgb_up    <- read.csv('xgbover.csv')
#xgb_down  <- read.csv('xgbunder.csv')
#listing_ids <- dplyr::select(xgb, listing_id)

setwd("~/Dropbox/Kaggle/predictions/Validation_Set")
#ridge_up    <- read.csv('ridge_pred_down.csv')
#ridge_down  <- read.csv('ridge_pred_up.csv')
#gbm_h2o     <- read.csv('gbm_preds.csv')
xgb_up      <- read.csv('xgbover.csv')
xgb_down    <- read.csv('xgbunder.csv')
xgb         <- read.csv('valxgbpreds.csv')
#ranger_up   <- read.csv('ranger_pred_up.csv')
#ranger_down <- read.csv('ranger_pred_down.csv')
#listing_ids <- dplyr::select(ridge_up, listing_id)

ridge_up_mat     <- as.matrix(dplyr::select(ridge_up, high, medium, low, -listing_id))
ridge_down_mat   <- as.matrix(dplyr::select(ridge_down, high, medium, low, -listing_id))
gbm_h2o_mat      <- as.matrix(dplyr::select(gbm_h2o, high, medium, low, -listing_id))
xgb_up_mat       <- as.matrix(dplyr::select(xgb_up, high, medium, low, -listing_id))
xgb_down_mat     <- as.matrix(dplyr::select(xgb_down, high, medium, low, -listing_id))
xgb_mat          <- as.matrix(dplyr::select(xgb, high, medium, low, -listing_id))
ranger_up_mat    <- as.matrix(dplyr::select(ranger_up, high, medium, low, -listing_id))
ranger_down_mat  <- as.matrix(dplyr::select(ranger_down, high, medium, low, -listing_id))

# eleastic = 0.2 | ridge = 0.2 | gbm_h2o = 0.1 | ranger = 0.1 | XGB = 0.4
  orig_weighting <- (xgb_mat*0.0) + (xgb_up_mat*0.0) + (xgb_down_mat*1.0) 
  
  weighting <- orig_weighting
  
  weighting <- apply(weighting,1,which.max)
  weighting[weighting==1] = 'high'
  weighting[weighting==2] = 'medium'
  weighting[weighting==3] = 'low'
  
  tab <- table(weighting, y_test)
  tab
  sum(diag(tab))/sum(tab)

submission <- cbind(orig_weighting, listing_ids)
write.csv(submission, 'submission.csv', row.names=FALSE)
