#!/bin/bash

apt install unzip

mkdir ~/data
cd ~/data
wget http://host.robots.ox.ac.uk/pascal/VOC/voc2012/VOCtrainval_11-May-2012.tar
tar -xvf VOCtrainval_11-May-2012.tar

wget https://www.dropbox.com/s/oeu149j8qtbs1x0/SegmentationClassAug.zip
unzip SegmentationClassAug.zip

cd ~
mkdir models
cd models
wget http://download.tensorflow.org/models/resnet_v2_101_2017_04_14.tar.gz
tar -zxvf resnet_v2_101_2017_04_14.tar.gz

export DATA_DIR='~/data'
export IMAGE_DATA_DIR='VOCdevkit/VOC2012/JPEGIamges/'
export LABEL_DATA_DIR='SegmentationClassAug/'
export PRE_TRAINED_MODEL='~/models/resnet_v2_101.ckpt'

