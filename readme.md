# setting
update config.py first.

# trainingAWS.py
> This script use aws reko & polly : 
> - `index_faces`
> - `list_faces`
> - `search_faces_by_image`
> - `delete_faces`

- reko
    - help      : `python trainingAWS.py`
    - add       : `python trainingAWS.py add {imgPath} {imgName}`
    - list      : `python trainingAWS.py list`
    - search    : `python trainingAWS.py search {imgPath}` 
    - del       : `python trainingAWS.py del {faceId}`
        - {faceId} : Get this string from 'add', 'list', 'search'
- polly
    - playsound : `python trainingAWS.py playsound 'hello'`