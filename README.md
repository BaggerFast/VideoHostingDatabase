# VideoHosting database
![MicrosoftSQLServer](https://img.shields.io/badge/Microsoft%20SQL%20Server-CC2927?style=for-the-badge&logo=microsoft%20sql%20server&logoColor=white)  
Coursework for university - I implemented a database similar to YouTube.

# Tables scheme
[<img src="Assets/Scheme_v2.png" width="832" height="528.5" alt="Tables scheme"/>](Assets/Scheme.png)

# QUICK START
1) Connect to database via docker
```
docker-compose -up
```
2) Use scripts in this order
   - TAGS
   - ACCESS_LEVELS 
   - AGE_RESTRICTIONS 
   - USERS 
   - VIDEOS 
   - FK_VIDEO_TAGS 
   - VIEW 
   - COMMENTS 
   - SUBSCRIPTIONS 
   - REACTIONS 
   - PLAYLISTS 
   - FK_VIDEO_PLAYLISTS