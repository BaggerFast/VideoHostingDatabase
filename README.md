# VideoHosting database
![MicrosoftSQLServer](https://img.shields.io/badge/Microsoft%20SQL%20Server-CC2927?style=for-the-badge&logo=microsoft%20sql%20server&logoColor=white)  
Coursework for university - I implemented a database similar to YouTube.

# Tables scheme
[<img src="Assets/Scheme_v2.png" width="832" height="528.5" alt="Tables scheme"/>](Assets/Scheme_v2.png)

# QUICK START
1) Connect to database via [docker-compose](docker-compose.yml)
```
docker-compose -up
```
2) Use scripts in this order
   - [TAGS](VideoHosting/TAGS)
   - [ACCESS_LEVELS](VideoHosting/ACCESS_LEVELS)
   - [AGE_RESTRICTIONS](VideoHosting/AGE_RESTRICTIONS) 
   - [USERS](VideoHosting/USERS)
   - [VIDEOS](VideoHosting/VIDEOS) 
   - [FK_VIDEO_TAGS](VideoHosting/_FK_VIDEO_TAGS)
   - [VIEW](VideoHosting/VIEWS)
   - [COMMENTS](VideoHosting/COMMENTS)
   - [SUBSCRIPTIONS](VideoHosting/SUBSCRIPTIONS)
   - [REACTIONS](VideoHosting/REACTIONS)
   - [PLAYLISTS](VideoHosting/PLAYLISTS)
   - [FK_VIDEO_PLAYLISTS](VideoHosting/_FK_VIDEO_PLAYLISTS)