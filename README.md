# Football-player-Exploratory-Data-with-Python
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
order by 7 Desc
```
