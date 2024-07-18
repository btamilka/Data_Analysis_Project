# The following querries are from the "The Most Streamed Spotify Songs 2024"
# First cleaned using Excel Power Query
#=======================================================================================
# Create table in the tsql schema by importing csv file (power_query)
# This is achieved through the Table Data Import Wizard
#=======================================================================================
# View all records in the table tsql.power_query
select * from tsql.power_query;
#===========================================================================================

# Check for nulls in each column using conditional expressions
# Alias each column
SELECT
    SUM(CASE WHEN Album_Name IS NULL THEN 1 ELSE 0 END) AS Album_Name_Null_Count,
    SUM(CASE WHEN Artist IS NULL THEN 1 ELSE 0 END) AS Artist_Null_Count,
    SUM(CASE WHEN Spotify_Streams IS NULL THEN 1 ELSE 0 END) AS Spotify_Streams_Null_Count,
    SUM(CASE WHEN Track_Score IS NULL THEN 1 ELSE 0 END) AS Track_Score_Null_Count,
    SUM(CASE WHEN Spotify_Streams2 IS NULL THEN 1 ELSE 0 END) AS Spotify_Streams2_Null_Count,
    SUM(CASE WHEN Spotify_Playlist_Reach IS NULL THEN 1 ELSE 0 END) AS Spotify_Playlist_Reach_Null_Count,
    SUM(CASE WHEN Spotify_Playlist_Count IS NULL THEN 1 ELSE 0 END) AS Spotify_Playlist_Count_Null_Count,
    SUM(CASE WHEN Spotify_Popularity IS NULL THEN 1 ELSE 0 END) AS Spotify_Popularity_Null_Count,
    SUM(CASE WHEN YouTube_Likes IS NULL THEN 1 ELSE 0 END) AS YouTube_Likes_Null_Count,
    SUM(CASE WHEN YouTube_Playlist_Reach IS NULL THEN 1 ELSE 0 END) AS YouTube_Playlist_Reach_Null_Count,
    SUM(CASE WHEN YouTube_Views IS NULL THEN 1 ELSE 0 END) AS YouTube_Views_Null_Count,
    SUM(CASE WHEN TikTok_Likes IS NULL THEN 1 ELSE 0 END) AS TikTok_Likes_Null_Count,
    SUM(CASE WHEN TikTok_Posts IS NULL THEN 1 ELSE 0 END) AS TikTok_Posts_Null_Count,
    SUM(CASE WHEN TikTok_Views IS NULL THEN 1 ELSE 0 END) AS TikTok_Views_Null_Count,
    SUM(CASE WHEN Apple_Music_Playlist_Count IS NULL THEN 1 ELSE 0 END) AS Apple_Music_Playlist_Count_Null_Count,
    SUM(CASE WHEN DeezerPlaylistCountS IS NULL THEN 1 ELSE 0 END) AS DeezerPlaylistCountS_Null_Count,
    SUM(CASE WHEN Deezer_Playlist_Count IS NULL THEN 1 ELSE 0 END) AS Deezer_Playlist_Count_Null_Count,
    SUM(CASE WHEN Deezer_Playlist_Reach IS NULL THEN 1 ELSE 0 END) AS Deezer_Playlist_Reach_Null_Count,
    SUM(CASE WHEN SiriusXM_Spins IS NULL THEN 1 ELSE 0 END) AS SiriusXM_Spins_Null_Count,
    SUM(CASE WHEN Amazon_Playlist_Count IS NULL THEN 1 ELSE 0 END) AS Amazon_Playlist_Count_Null_Count,
    SUM(CASE WHEN Pandora_Streams IS NULL THEN 1 ELSE 0 END) AS Pandora_Streams_Null_Count,
    SUM(CASE WHEN Pandora_Track_Stations IS NULL THEN 1 ELSE 0 END) AS Pandora_Track_Stations_Null_Count,
    SUM(CASE WHEN Soundcloud_Streams IS NULL THEN 1 ELSE 0 END) AS Soundcloud_Streams_Null_Count,
    SUM(CASE WHEN Soundcloud_Streams2 IS NULL THEN 1 ELSE 0 END) AS Soundcloud_Streams2_Null_Count,
    SUM(CASE WHEN Explicit_Track IS NULL THEN 1 ELSE 0 END) AS Explicit_Track_Null_Count,
    SUM(CASE WHEN Date_released IS NULL THEN 1 ELSE 0 END) AS Date_released_Null_Count
FROM tsql.power_query;
#========================================
# No column has null; 0 returned for all columns
#====================================================

# Extract all records that are related to albums released after 31/12/2009 and write this to CSV file
SELECT 
	Album_Name, Artist, Spotify_Streams, Track_Score,
	Spotify_Streams2, Spotify_Playlist_Reach, Spotify_Playlist_Count,
	Spotify_Popularity, YouTube_Likes, YouTube_Playlist_Reach,
	YouTube_Views, TikTok_Likes, TikTok_Posts, TikTok_Views,
	Apple_Music_Playlist_Count, DeezerPlaylistCountS, Deezer_Playlist_Count, Deezer_Playlist_Reach,
	SiriusXM_Spins, Amazon_Playlist_Count, Pandora_Streams, Pandora_Track_Stations,
	Soundcloud_Streams, Soundcloud_Streams2, Explicit_Track, Date_released
FROM 
	tsql.power_query
WHERE 
	Date_released >= '20100101';
#=====================================================
# 502 records returned
#=====================================================

### Find 10 artists with the most likes on Youtuebe and Titok. Limit this to artists with records after 31/12/2009
 SELECT 
    Artist, 
    SUM(TikTok_Likes) AS Total_TikTok_Likes, 
    SUM(YouTube_Likes) AS Total_YouTube_Likes
FROM tsql.power_query
WHERE Date_released >= '2010-01-01'
GROUP BY Artist
ORDER BY 
    SUM(TikTok_Likes) DESC, 
    SUM(YouTube_Likes) DESC
LIMIT 10;
#===================================================
#Billie Eilish, Drake, etc.alter
#===================================================

# Find artis whose youtube likes are more than their Tiktok likes.
# Limit this to albums realesed after 31/12/2019
SELECT Album_Name, Artist, TikTok_Likes, YouTube_Likes
FROM tsql.power_query
WHERE YouTube_Likes >
	(SELECT AVG(TikTok_Likes) FROM tsql.power_query)
    AND Date_released >= '2020-01-01';
#=================================================
# There is no artist with Youtube likes greater than the average of Tiktok likes
#=====================================================

# Show a list of artists and their Spotify streams 
#where Spotify popularity is above the average Spotify popularity across all records.
SELECT Artist, Spotify_Streams2, Spotify_Popularity 
FROM  tsql.power_query
WHERE Spotify_Popularity > (SELECT AVG(Spotify_Popularity) 
FROM tsql.power_query);
#======================================
#295 records returned
#=======================================

# STRING MANIPULATION: Find artists with albusm that have love in any part of the title
SELECT Album_Name AS Albums_with_Love, Artist 
FROM tsql.power_query
WHERE Album_Name LIKE '%love%';
#=====================================
# 14 records returned
#===================================

# SELF JOINS
# Select prepare a list of artists with the same Explicit Tracks. Include their names, album names, and spotify popularity.
# Explicit tracks is categorical (0/1)
SELECT
	a.Album_Name AS Album_Name1, b.Album_Name AS Album_Name2, 
    a.Artist AS Artist1,  b.Artist AS Artist2,
    a.Spotify_Popularity AS Spotify_Popularity1, 
    b.Spotify_Popularity AS Spotify_Popularity2, 
    a.Explicit_Track AS Explicit_Track1,
    b.Explicit_Track AS Explicit_Track2
FROM 
	tsql.power_query a, tsql.power_query b
WHERE a.Artist = b.Artist
AND a.Explicit_Track = b.Explicit_Track
ORDER BY a.Explicit_Track;
