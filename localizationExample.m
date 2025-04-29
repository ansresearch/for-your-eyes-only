%% Load data
% MODIFY THIS PATH
datasetPath = "path/to/the/dataset/root/Sin/Dataset/mask1_instance1.mat";
dataset = load(datasetPath);


%% Parameters
modelN = 5;
antennaN = 8;
% This parameter allows to reduce the dataset in order use the same number
% of frame for each position
framesPerPosN = 450;


%% Preprocessing of data
datasetType = ["clear","masked","unmasked"];

for ddDataset = datasetType
    inputData = dataset.csi.(ddDataset);
    outputData = dataset.positions.(ddDataset);

    % Preprocessing of the data
    [inputData,outputData] = ...
        preconditionDataset(inputData, outputData, framesPerPosN);
    
    featuresN = size(inputData{1}, 1);

    tic;
    fprintf("Dataset: %s\n", ddDataset);
    for aaAntenna = 1:antennaN
        inputTraining = reshape((inputData{1}(:,aaAntenna,:)), featuresN, 1, 1, []);
        inputTesting = reshape((inputData{2}(:,aaAntenna,:)), featuresN, 1, 1, []);

        outputTraining = outputData{1}';
        outputTesting = outputData{2}';

        % Some tmp variable to store resulting accuracy of any single model
        tmpAccuracy = [];

        for mmModel = 1:modelN
            % Create layers
            layers = [
                imageInputLayer([featuresN,1], "Name", "input", "Normalization", "none")
                flattenLayer("Name", "flatten")
                fullyConnectedLayer(8, "Name", "fc")
                softmaxLayer("Name", "softmax")
            ];

            % Set network options
            netOptions = trainingOptions('adam', Metrics = "accuracy", Shuffle='every-epoch',...
                MiniBatchSize=5, MaxEpochs=15, Verbose=false, InitialLearnRate=0.001, ...
                ObjectiveMetricName="accuracy", Plots="none");

            % Training
            net = trainnet(inputTraining, outputTraining, layers, "crossentropy", netOptions);

            % Testing
            predictionsTesting = predict(net, inputTesting);

            % Restuls
            [~,predictionsTesting] = max(predictionsTesting, [], 2);
            [~,decodedOutputTesting] = max(outputTesting, [], 2);
            tmpAccuracy = [tmpAccuracy, ...
                mean(predictionsTesting == decodedOutputTesting) * 100];
        end
        fprintf("[%s] Antenna %d: mean accuracy %.2f\n", ...
            ddDataset, aaAntenna, mean(tmpAccuracy));
    end
    toc;
    fprintf("\n");
end