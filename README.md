# Football-player-Exploratory-Data-with-Python
![image](https://github.com/setthawat121/Webscaping-IMDB/assets/96307668/5b710c8f-0050-4a8b-8168-08df25d1d254)
<br />Data form : Vaastav Anand (vaastav)
## Exploratory Data Analysis
- Show percentage goals scored vs goals conceded :
```
select first_name,second_name,goals_scored,goals_conceded,minutes,assists,
      (cast(goals_scored/(goals_scored+goals_conceded)*100 as decimal(10,2))) as percentage_goals_scored , element_type
from MiniProject.dbo.cleaned_players$
where goals_conceded > 0 and goals_scored > 0 and element_type = 'FWD'
order by 7 Desc;
```
![image](https://github.com/setthawat121/Football-player-Exploratory-Data-with-Python/assets/96307668/c84cfd0c-08e9-4158-aa55-e3d1656313da)
<br />
<br />

- Show percentage opportunity to shooting goals vs Games :
```
select first_name,second_name,(goals_scored+goals_conceded) as opportunity_to_shooting,minutes,ROUND((minutes/90),0) as Games_played,
      Round((goals_scored+goals_conceded)/(Round((minutes/90),0)),0) as Opportunity_to_shooting_per_game,element_type
from MiniProject.dbo.cleaned_players$
where minutes > 0 and (goals_scored+goals_conceded) > 0 and element_type = 'FWD' and (minutes/90) >= 1
order by 6 Desc
```
![image](https://github.com/setthawat121/Python-and-REST-APIs/assets/96307668/be4453b0-db69-4e9c-b04a-a3215dc1ea13)
<br />
<br />

- Show percentage opportunity to goals per games :
```
select first_name,second_name,goals_scored,minutes,element_type ,ROUND((minutes/90),0) as Games_played 
	,Cast(goals_scored/(Round((minutes/90),0))as decimal(10,2)) as goals_per_game
from MiniProject.dbo.cleaned_players$
where minutes > 0 and (goals_scored+goals_conceded) > 0 and element_type = 'FWD' and (minutes/90) >= 1
order by 7 Desc
```
![image](https://github.com/setthawat121/Python-and-REST-APIs/assets/96307668/6e93088b-d003-4ebb-9b19-2e4616afc330)
<br />
<br />

- Looking at table element type vs Goals and Assists :
```
select SUM(goals_scored) as Total_goals , SUM(assists) as Total_assists , element_type
from MiniProject.dbo.cleaned_players$
Group by element_type
```
![image](https://github.com/setthawat121/Python-and-REST-APIs/assets/96307668/3a39692d-2e5b-4e3b-9981-907d359a3e76)
<br />
<br />

- Show percentage assists vs Games :
```
select first_name, second_name ,assists,minutes,ROUND((minutes/90),0) as Games , 
      cast(assists/(minutes/90)as decimal(10,2)) as Assists_per_games, element_type
from MiniProject.dbo.cleaned_players$
where (minutes/90) > 0 and element_type = 'MID'
order by 6 Desc
```
![image](https://github.com/setthawat121/Python-and-REST-APIs/assets/96307668/e1a4c308-b074-40f2-86b3-f7e12cf5356d)
<br />
<br />

- Show percentage cleansheet vs Games :
```
select first_name, second_name ,clean_sheets,minutes,ROUND((minutes/90),0) as Games , 
      cast((clean_sheets/(minutes/90)*100)as decimal(10,2)) as Cleansheet_per_games, element_type
from MiniProject.dbo.cleaned_players$
where minutes > 0 and element_type = 'DEF'
order by 6 Desc
```
![image](https://github.com/setthawat121/Python-and-REST-APIs/assets/96307668/7ba80471-857f-4c6b-830e-aaf90349b8c4)
<br />
<br />

## Show Top players and inexpensive cost
- FWD requirement : good goals per game and good cost :
```
select first_name,second_name,goals_scored,minutes,element_type ,ROUND((minutes/90),0) as Games_played 
	,Cast(goals_scored/(Round((minutes/90),0))as decimal(10,2)) as goals_per_game, now_cost
from MiniProject.dbo.cleaned_players$
where minutes > 0 and (goals_scored+goals_conceded) > 0 and element_type = 'FWD' and (minutes/90) >= 1 and now_cost <= 50
order by 7 Desc
```
![image](https://github.com/setthawat121/Python-and-REST-APIs/assets/96307668/e009f024-8bf2-49a9-ada8-f6001589a292)
<br />
<br />

- MID requirement : good assists per game and good cost :
```
select first_name, second_name ,assists,minutes,ROUND((minutes/90),0) as Games ,
      cast(assists/(minutes/90)as decimal(10,2)) as Assists_per_games, element_type,now_cost
from MiniProject.dbo.cleaned_players$
where (minutes/90) > 0 and element_type = 'MID' and now_cost <= 45
order by 6 Desc
```
![image](https://github.com/setthawat121/Python-and-REST-APIs/assets/96307668/874b32b5-7094-4f89-bff6-2c5e8c7d8bd3)
<br />
<br />

- DEF requirement : good cleansheet per game and good cost :
```
select first_name, second_name ,clean_sheets,minutes,ROUND((minutes/90),0) as Games ,
      cast((clean_sheets/(minutes/90)*100)as decimal(10,2)) as Cleansheet_per_games, element_type,now_cost
from MiniProject.dbo.cleaned_players$
where minutes > 0 and element_type = 'DEF' and now_cost <= 40
order by 6 Desc
```
![image](https://github.com/setthawat121/Python-and-REST-APIs/assets/96307668/c00fe9e4-f82f-4292-909d-e5f1f7d70290)
<br />
<br />

##Temp table for TopPlayer
- Create table for Top player :
```
create table TopPlayer (
FirstName nvarchar(50),
LastName nvarchar(50),
GoalsScored numeric,
GoalsConceded numeric,
Assists numeric,
Games numeric,
PercentageScored float,
ElementType nvarchar(50)
)

Insert into TopPlayer 
select first_name,second_name,goals_scored,goals_conceded,assists,(minutes/90) as Games,(cast(goals_scored/(goals_scored+goals_conceded)*100 as decimal(10,2))) as PercentageScored , element_type
from MiniProject.dbo.cleaned_players$
where goals_conceded > 0 and goals_scored > 0 and element_type = 'FWD'
order by 7 Desc;
```
<br />
<br />

- Create Viwe for Top player and good cost :
```
Drop view if exists FWD
Create View FWD as
select first_name,second_name,goals_scored,minutes,element_type ,ROUND((minutes/90),0) as Games_played 
	,Cast(goals_scored/(Round((minutes/90),0))as decimal(10,2)) as goals_per_game, now_cost
from MiniProject.dbo.cleaned_players$
where minutes > 0 and (goals_scored+goals_conceded) > 0 and element_type = 'FWD' and (minutes/90) >= 1 and now_cost <= 50

-- Create Viwe for Top player and good cost (MID)

Drop view if exists MID
Create View MID as
select first_name, second_name ,assists,minutes,ROUND((minutes/90),0) as Games , cast(assists/(minutes/90)as decimal(10,2)) as Assists_per_games, element_type,now_cost
from MiniProject.dbo.cleaned_players$
where (minutes/90) > 0 and element_type = 'MID' and now_cost <= 45

-- Create Viwe for Top player and good cost (DEF)

Drop view if exists DEF
Create View DEF as
select first_name, second_name ,clean_sheets,minutes,ROUND((minutes/90),0) as Games , cast((clean_sheets/(minutes/90)*100)as decimal(10,2)) as Cleansheet_per_games, element_type,now_cost
from MiniProject.dbo.cleaned_players$
where minutes > 0 and element_type = 'DEF' and now_cost <= 40
```
