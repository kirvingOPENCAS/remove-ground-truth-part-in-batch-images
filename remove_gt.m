clc;
clear;
cd('/home/feixuan/hhx/fast-rcnn/data/rm_gt_jpg');

root_listing_pic=dir('/media/TOSHIBA EXT/ILSVRC2015 (2)/Data/VID/val');
root_listing_ann=dir('/media/TOSHIBA EXT/ILSVRC2015 (2)/Annotations/VID/val');

num_videos=numel(root_listing_pic)-2;
num_videos_ann=numel(root_listing_ann)-2;

if(num_videos~=num_videos_ann)
    print('the number of videos is not equal to the number of video annotations!');
    exit;
end

% for i=1:num_videos
for i=2:8
    
video_name=root_listing_pic(i+2).name;
ann_name=root_listing_ann(i+2).name;

str_pic='/media/TOSHIBA EXT/ILSVRC2015 (2)/Data/VID/val';
str_ann='/media/TOSHIBA EXT/ILSVRC2015 (2)/Annotations/VID/val';

full_video_name=fullfile(str_pic,video_name);
full_ann_name=fullfile(str_ann,ann_name);

% listing1=dir('/media/TOSHIBA EXT/ILSVRC2015 (2)/Data/VID/val/ILSVRC2015_val_00000003');
% listing2=dir('/media/TOSHIBA EXT/ILSVRC2015 (2)/Annotations/VID/val/ILSVRC2015_val_00000003');
listing1=dir(full_video_name);
listing2=dir(full_ann_name);

num_pic=numel(listing1)-2;
num_xml=numel(listing2)-2;

if(num_pic~=num_xml)
    print('error');
    exit;
end

name_folder_save_remove_gt_pics=strcat('rm_gt_',video_name);
mkdir('/media/TOSHIBA EXT/ILSVRC2015 (2)/Data/VID/val_remove_gt',name_folder_save_remove_gt_pics);
folder_save_pics=fullfile('/media/TOSHIBA EXT/ILSVRC2015 (2)/Data/VID/val_remove_gt',name_folder_save_remove_gt_pics);
cd(folder_save_pics);

for i=1:num_pic
%     if(i==100)
%         1;
%     end
    pic_name=listing1(i+2).name;
    xml_name=listing2(i+2).name;
    
    str1=fullfile('/media/TOSHIBA EXT/ILSVRC2015 (2)/Data/VID/val',video_name);
    str2=fullfile('/media/TOSHIBA EXT/ILSVRC2015 (2)/Annotations/VID/val',ann_name);
    
    pic_full_name=fullfile(str1,pic_name);
    xml_full_name=fullfile(str2,xml_name);
    
img=imread(pic_full_name);
xml_file=xml_read(xml_full_name);

%有的图像不存在object！不存在则直接保存图图
if_exist_object=isfield(xml_file,'object');
if (if_exist_object==1)
num_gt_box=numel(xml_file.object);
for i=1:num_gt_box
    temp(i,1)=xml_file.object(i).bndbox.xmax;
    temp(clc);
clear;
cd('/home/feixuan/hhx/fast-rcnn/data/rm_gt_jpg');

root_listing_pic=dir('/media/TOSHIBA EXT/ILSVRC2015 (2)/Data/VID/val');
root_listing_ann=dir('/media/TOSHIBA EXT/ILSVRC2015 (2)/Annotations/VID/val');

temp(i,1)=xml_file.object(i).bndbox.xmax;
temp(i,2)=xml_file.object(i).bndbox.xmin;
    if(temp(i,2)==0)
        temp(i,2)=1;
    end
    temp(i,3)=xml_file.object(i).bndbox.ymax;
    temp(i,4)=xml_file.object(i).bndbox.ymin;
    if(temp(i,4)==0)
        temp(i,4)=1;
    end
end

for i=1:num_gt_box
    img(temp(i,4):temp(i,3),temp(i,2):temp(i,1),:)=0;
end
clear temp;

end 
% imshow(img);
trans_pic_name=strcat('rm_gt_',pic_name);
imwrite(img,trans_pic_name);
% set(gcf, 'Renderer', 'ZBuffer')
% save(trans_pic_name,'img');
clear img,xml_file;
end
end