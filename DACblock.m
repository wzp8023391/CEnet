function LayerGraph = DACblock(LayerGraph, InputLayerName, convSize)
% create DAC block, based on CEnet
% This code was written by Mr zhipan Wang, if you have any question, Please
% contact me,Email:1044625113@qq.com,@BeiJing,China Remote Sensing
% Application Center,2019-6-24

% input: 14*14*512 in original paper
% output: 14*14*512 in original paper

% InputLayerName:layer name to connect!
% convSize: The author of CEnet suggest use 512, you can modify the conv
% kernel size to save GPU memory, but the accuracy may descend!


% DAC 卷积块1
conv_1_name = 'DACblock_conv1';
DAC1 = convolution2dLayer(3,convSize,...  % 原始滤波器个数推荐512个,1*1卷积
    'Stride',[1 1],...
    'Padding','same',...
    'BiasL2Factor',0,...
    'Name',conv_1_name);
LayerGraph = addLayers(LayerGraph, DAC1);


% DAC 卷积块2
conv_2_1_name = 'DACblock_conv2_1';
conv_2_2_name = 'DACblock_conv2_2';
convLayer_2 = convolution2dLayer(1,convSize,...
    'Stride',[1 1],...
    'DilationFactor',3,...
    'Padding','same',...
    'BiasL2Factor',0,...
    'Name',conv_2_1_name);

convLayer_3 = convolution2dLayer(3,convSize,...
    'Stride',[1 1],...
    'DilationFactor',1,...
    'Padding','same',...
    'BiasL2Factor',0,...
    'Name',conv_2_2_name);
DAC2 = [convLayer_3; convLayer_2];
LayerGraph = addLayers(LayerGraph, DAC2);


% DAC 卷积块3
conv_3_1_name = 'DACblock_conv3_1';
conv_3_2_name = 'DACblock_conv3_2';
conv_3_3_name = 'DACblock_conv3_3';
convLayer_4 = convolution2dLayer(1,convSize,...
    'Stride',[1 1],...
    'DilationFactor',1,...
    'Padding','same',...
    'BiasL2Factor',0,...
    'Name',conv_3_1_name);

convLayer_5 = convolution2dLayer(3,convSize,...
    'Stride',[1 1],...
    'DilationFactor',3,...
    'Padding','same',...
    'BiasL2Factor',0,...
    'Name',conv_3_2_name);

convLayer_6 = convolution2dLayer(3,convSize,...
    'Stride',[1 1],...
    'DilationFactor',1,...
    'Padding','same',...
    'BiasL2Factor',0,...
    'Name',conv_3_3_name);

DAC3 = [convLayer_6; convLayer_5; convLayer_4];
LayerGraph = addLayers(LayerGraph, DAC3);


% DAC 卷积块4
conv_4_1_name = 'DACblock_conv4_1';
conv_4_2_name = 'DACblock_conv4_2';
conv_4_3_name = 'DACblock_conv4_3';
conv_4_4_name = 'DACblock_conv4_4';

convLayer_7 = convolution2dLayer(1,convSize,...
    'Stride',[1 1],...
    'DilationFactor',1,...
    'Padding','same',...
    'BiasL2Factor',0,...
    'Name',conv_4_1_name);

convLayer_8 = convolution2dLayer(3,convSize,...
    'Stride',[1 1],...
    'DilationFactor',5,...
    'Padding','same',...
    'BiasL2Factor',0,...
    'Name',conv_4_2_name);

convLayer_9 = convolution2dLayer(3,convSize,...
    'Stride',[1 1],...
    'DilationFactor',3,...
    'Padding','same',...
    'BiasL2Factor',0,...
    'Name',conv_4_3_name);

convLayer_10 = convolution2dLayer(3,convSize,...
    'Stride',[1 1],...
    'DilationFactor',1,...
    'Padding','same',...
    'BiasL2Factor',0,...
    'Name',conv_4_4_name);

DAC4 = [convLayer_10; convLayer_9; convLayer_8; convLayer_7];
LayerGraph = addLayers(LayerGraph, DAC4);


% 完成连接
LayerGraph = connectLayers(LayerGraph, InputLayerName, conv_1_name);
LayerGraph = connectLayers(LayerGraph, InputLayerName, conv_2_2_name);
LayerGraph = connectLayers(LayerGraph, InputLayerName, conv_3_3_name);
LayerGraph = connectLayers(LayerGraph, InputLayerName, conv_4_4_name);


% 特征融合
add = additionLayer(5,'Name', 'DAC_add');
LayerGraph = addLayers(LayerGraph, add);

LayerGraph = connectLayers(LayerGraph, conv_1_name, 'DAC_add/in1');
LayerGraph = connectLayers(LayerGraph, conv_2_1_name, 'DAC_add/in2');
LayerGraph = connectLayers(LayerGraph, InputLayerName, 'DAC_add/in3');
LayerGraph = connectLayers(LayerGraph, conv_3_1_name, 'DAC_add/in4');
LayerGraph = connectLayers(LayerGraph, conv_4_1_name, 'DAC_add/in5');


end

