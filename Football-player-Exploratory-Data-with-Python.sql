
select *
from MiniProject.dbo.cleaned_players$
order by 3 Desc;

--The goals is find taget team wants to buy!

--show percentage goals scored vs goals conceded

select first_name,second_name,goals_scored,goals_conceded,minutes,assists,(cast(goals_scored/(goals_scored+goals_conceded)*100 as decimal(10,2))) as percentage_goals_scored , element_type
from MiniProject.dbo.cleaned_players$
where goals_conceded > 0 and goals_scored > 0 and element_type = 'FWD'
order by 7 Desc;

--show percentage opportunity to shooting goals vs Games

select first_name,second_name,(goals_scored+goals_conceded) as opportunity_to_shooting,minutes,ROUND((minutes/90),0) as Games_played 
	,Round((goals_scored+goals_conceded)/(Round((minutes/90),0)),0) as opportunity_to_shooting_per_game,element_type
from MiniProject.dbo.cleaned_players$
where minutes > 0 and (goals_scored+goals_conceded) > 0 and element_type = 'FWD' and (minutes/90) >= 1
order by 7 Desc

--show percentage opportunity to goals per games

select first_name,second_name,goals_scored,minutes,element_type ,ROUND((minutes/90),0) as Games_played 
	,Cast(goals_scored/(Round((minutes/90),0))as decimal(10,2)) as goals_per_game
from MiniProject.dbo.cleaned_players$
where minutes > 0 and (goals_scored+goals_conceded) > 0 and element_type = 'FWD' and (minutes/90) >= 1
order by 7 Desc

--looking at table element type vs Goals and Assists

select SUM(goals_scored) as Total_goals , SUM(assists) as Total_assists , element_type
from MiniProject.dbo.cleaned_players$
--where goals_scored > 0 and assists > 0
Group by element_type
--order by 3

select element_type,count(element_type) as Players
from MiniProject.dbo.cleaned_players$
group by element_type

--select first_name,second_name,goals_scored,assists,minutes,element_type
--from MiniProject.dbo.cleaned_players$
--where element_type = 'MID' and goals_scored > 0 and assists > 0
--order by 3 Desc ,4 Desc

--Show percentage assists vs Games

select first_name, second_name ,assists,minutes,ROUND((minutes/90),0) as Games , cast(assists/(minutes/90)as decimal(10,2)) as Assists_per_games, element_type
from MiniProject.dbo.cleaned_players$
where (minutes/90) > 0 and element_type = 'MID'
order by 6 Desc

--Show percentage cleansheet vs Games

select first_name, second_name ,clean_sheets,minutes,ROUND((minutes/90),0) as Games , cast((clean_sheets/(minutes/90)*100)as decimal(10,2)) as Cleansheet_per_games, element_type
from MiniProject.dbo.cleaned_players$
where minutes > 0 and element_type = 'DEF'
order by 6 Desc

-- Show Top players and inexpensive cost

-- FWD requirement : good goals per game and good cost

select first_name,second_name,goals_scored,minutes,element_type ,ROUND((minutes/90),0) as Games_played 
	,Cast(goals_scored/(Round((minutes/90),0))as decimal(10,2)) as goals_per_game, now_cost
from MiniProject.dbo.cleaned_players$
where minutes > 0 and (goals_scored+goals_conceded) > 0 and element_type = 'FWD' and (minutes/90) >= 1 and now_cost <= 50
order by 7 Desc

-- MID requirement : good assists per game and good cost

select first_name, second_name ,assists,minutes,ROUND((minutes/90),0) as Games , cast(assists/(minutes/90)as decimal(10,2)) as Assists_per_games, element_type,now_cost
from MiniProject.dbo.cleaned_players$
where (minutes/90) > 0 and element_type = 'MID' and now_cost <= 45
order by 6 Desc

-- DEF requirement : good cleansheet per game and good cost

select first_name, second_name ,clean_sheets,minutes,ROUND((minutes/90),0) as Games , cast((clean_sheets/(minutes/90)*100)as decimal(10,2)) as Cleansheet_per_games, element_type,now_cost
from MiniProject.dbo.cleaned_players$
where minutes > 0 and element_type = 'DEF' and now_cost <= 40
order by 6 Desc

--temp table for TopPlayer

Drop Table if exists TopPlayer

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

select *
from TopPlayer
order by 7 Desc

-- Create Viwe for Top player and good cost (FWD)

Drop view if exists FWD
Create View FWD as
select first_name,second_name,goals_scored,minutes,element_type ,ROUND((minutes/90),0) as Games_played 
	,Cast(goals_scored/(Round((minutes/90),0))as decimal(10,2)) as goals_per_game, now_cost
from MiniProject.dbo.cleaned_players$
where minutes > 0 and (goals_scored+goals_conceded) > 0 and element_type = 'FWD' and (minutes/90) >= 1 and now_cost <= 50
--order by 7 Desc

-- Create Viwe for Top player and good cost (MID)

Drop view if exists MID
Create View MID as
select first_name, second_name ,assists,minutes,ROUND((minutes/90),0) as Games , cast(assists/(minutes/90)as decimal(10,2)) as Assists_per_games, element_type,now_cost
from MiniProject.dbo.cleaned_players$
where (minutes/90) > 0 and element_type = 'MID' and now_cost <= 45
--order by 6 Desc

-- Create Viwe for Top player and good cost (DEF)

Drop view if exists DEF
Create View DEF as
select first_name, second_name ,clean_sheets,minutes,ROUND((minutes/90),0) as Games , cast((clean_sheets/(minutes/90)*100)as decimal(10,2)) as Cleansheet_per_games, element_type,now_cost
from MiniProject.dbo.cleaned_players$
where minutes > 0 and element_type = 'DEF' and now_cost <= 40
--order by 6 Desc
