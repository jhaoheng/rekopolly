# SYNOPSIS

This doc is aws cli command operation.
It is diff use `boto`(a python package)
Please enhance `aws/*****.manager` to extend function 

# CLI : rekognition

## info 
- 目前 support region : 美國東部 (維吉尼亞北部)、美國西部 (奧勒岡)、歐洲 (愛爾蘭)、AWS GovCloud (US) 和 AWS 亞太區域 (東京) 
- 支援相片格式 : png, jpg
- 支援影片格式 : 支援最大 15 MB 的影像檔案，若是影像位元組陣列，則最大 5 MB。建議使用 VGA (640x480) 以上的解析度
- 可信度分數 : 可信度分數介於 0 至 100 之間，用來表示特定預測結果的正確機率。
- 一個影像可以分辨 100 張臉孔

## 情境

- 物件和場景偵測 : DetectLabels API 
- 臉部分析 : DetectFaces API 
- 臉部特徵點 : DetectFaces API
- 臉部比較 : CompareFaces 
- 臉部辨識 : SearchFaces, SearchFacesByImage 
- 人臉集合 : CreateCollection
- 人臉集合刪除 : DeleteCollection
- 人臉集合中新增 : IndexFaces 
- 人臉集合中刪除 : DeleteFaces
- 人臉集合中搜尋一張臉孔 : 影像 (SearchFaceByImage)或一個 FaceId (SearchFaces) 在其中搜尋臉孔 

## collection
- add collection : `aws rekognition create-collection --collection-id {string} `
- list collection : `aws rekognition list-collections`
- del collection : `aws rekognition delete-collection --collection-id "tech"`

## operation face
- index(add) face to collection : 
    - `aws rekognition index-faces --collection-id "johan" --image '{"S3Object":{"Bucket":"orbweb-rekognition","Name":"cook2.png"}}' --external-image-id "cook"`
- list face of collection : `aws rekognition list-faces --collection-id "johan" `
- search-faces-by-image : 
    - `aws rekognition search-faces-by-image --collection-id "johan" --image '{Bytes":}'`
    - `aws rekognition search-faces-by-image --collection-id "johan" --image '{"S3Object":{"Bucket":"orbweb-rekognition","Name":"wh2.jpg"}}' --face-match-threshold 90`
- delete face : `aws rekognition delete-faces --collection-id "johan" --face-ids "a9ca542f-c4c4-47fa-b774-7e8c176e204b"`

## compare face

```
aws rekognition compare-faces \
--source-image '{"S3Object":{"Bucket":"bucket-name","Name":"source.jpg"}}' \
--target-image '{"S3Object":{"Bucket":"bucket-name","Name":"target.jpg"}}' \
--region us-east-1
```


