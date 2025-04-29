function [csi,positions] = preconditionDataset(csi, positions, framesPerPosN)

    % Keep only valid subcarriers
    validSub = 1:256;
    validSub([1:7,128:130,251:256]) = [];

    loopN = numel(csi);
    posN = size(positions{1}, 1);
    
    % Preprocess both training and testing
    for llLoop = 1:loopN
        % Remove useless subcarrier and keep only required frames
        csi{llLoop} = csi{llLoop}(validSub,:,:);
        
        % Get the mean of any 5 consecutive subcarriers
        csi{llLoop} = ...
            mean(reshape(csi{llLoop}, 5, [], size(csi{llLoop}, 2), size(csi{llLoop}, 3)), 1);

        % Delete first dimension
        featuresN = size(csi{llLoop}, 2);
        antennaN = size(csi{llLoop}, 3);
        csiN = size(csi{llLoop}, 4);
        csi{llLoop} = reshape(csi{llLoop}, featuresN, antennaN, csiN);

        % Get zscore
        csi{llLoop} = normalize(abs(csi{llLoop}), "zscore");
    end

    % Remove surplus of frames
    validIndx = cell(loopN, 1);
    if (~isempty(framesPerPosN))
        for llLoop = 1:loopN       
            for ppPos = 1:posN
                posFrames = find(positions{llLoop}(ppPos,:) == 1);
                validIndx{llLoop} = [validIndx{llLoop},posFrames(1:framesPerPosN)];                
            end
            csi{llLoop} = csi{llLoop}(:,:,validIndx{llLoop});
            positions{llLoop} = positions{llLoop}(:,validIndx{llLoop});
        end
    end
end

