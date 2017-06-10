function [predictedLabels,score]= signPredict(hog,isClassifier,Classifier)
    hog=reshape(hog,1,[]);
    [predictedLabels,score]=predict(isClassifier, hog);
    if predictedLabels == '1'
        [predictedLabels,pscore]= predict(Classifier, hog);
        score=max(pscore)*max(score);
        return
    end
    score=max(score);
end